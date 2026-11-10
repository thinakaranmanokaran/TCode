#!/bin/bash
# Production packaging for T Code — builds BOTH installable + portable
# artifacts for the current platform into application/dist/.
#
# Examples:
#   bash application/scripts/package.sh --production
#   bash application/scripts/package.sh --only-portable
#   bash application/scripts/package.sh --only-installable
#   bash application/scripts/package.sh --nobuild --version 2.1.7
#
# Output (application/dist/):
#   Linux   : tcode-<ver>-<arch>-linux-portable.tar.gz
#             tcode-<ver>-<arch>-linux-installable.tar.gz  (FHS: bin/share)
#             tcode_<ver>_<arch>.deb ; tcode-<ver>-<arch>.rpm (if tools present)
#             tcode-<ver>-<arch>-linux.AppImage (if appimagetool present)
#   Windows : tcode-<ver>-<arch>-windows-portable.zip
#             tcode-<ver>-<arch>-windows-setup.exe (InnoSetup, if ISCC present)
#   macOS   : tcode-<ver>-<arch>-darwin-portable.tar.gz
#             tcode-<ver>-<arch>-darwin-bundle.tar.gz (+ DMG if dmgbuild present)
#   + SHA256SUMS + manifest.json
set -e

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "${script_dir}/../.." && pwd)"
app_root="${repo_root}/application"

cd "${repo_root}"
source "${app_root}/scripts/common.sh"

show_help() {
  echo
  echo "Usage: $0 <OPTIONS>"
  echo
  echo "  --version V            Version override (default: meson project version)."
  echo "  --ref REF              Release ref for filenames (default: version)."
  echo "  -b --builddir D        Build dir (default: application/build)."
  echo "  --distdir DIR          Output dir (default: application/dist)."
  echo "  --production           Production build (release+LTO+strip, no git suffix)."
  echo "  --only-portable        Only portable artifact."
  echo "  --only-installable     Only installable artifact(s)."
  echo "  --nobuild              Do not rebuild; package existing staging if present."
  echo "  -A --addons [LIST]     Pass-through to build.sh (bare = welcome)."
  echo "  -f --forcefallback     Pass-through to build.sh."
  echo "  --debug                set -x."
  echo "  -h --help              This help."
  echo
}

main() {
  local version ref distdir builddir="" nobuild=false only_portable=false only_installable=false production=false
  local platform arch addons forcefallback

  while [[ $# -gt 0 ]]; do
    case $1 in
      -h|--help) show_help; exit 0 ;;
      --version|-v) version="$2"; shift 2 ;;
      --ref) ref="$2"; shift 2 ;;
      -b|--builddir) builddir="$2"; shift 2 ;;
      --distdir) distdir="$2"; shift 2 ;;
      --production) production=true; shift ;;
      --only-portable) only_portable=true; only_installable=false; shift ;;
      --only-installable) only_installable=true; only_portable=false; shift ;;
      --nobuild) nobuild=true; shift ;;
      -A|--addons)
        if [[ -n ${2:-} ]] && [[ $2 != -* ]]; then addons="--addons $2"; shift; else addons="--addons"; fi
        shift ;;
      -f|--forcefallback) forcefallback="--forcefallback"; shift ;;
      --debug) set -x; shift ;;
      *) echo "Unknown option: $1" >&2; exit 1 ;;
    esac
  done

  platform="$(get_platform_name)"
  arch="$(get_platform_arch)"
  version="${version:-$(get_project_version)}"
  ref="${ref:-$version}"
  distdir="${distdir:-$app_root/dist}"
  mkdir -p "$distdir"

  # All builds stage under application/build (via `-b build` → application/build).
  # build.sh resolves a bare "build" to application/build; keep it simple.
  builddir="${builddir:-application/build}"

  echo "=== T Code $version ($platform/$arch) ==="
  echo "build dir: $builddir  dist dir: $distdir"

  # ---- Portable ----
  if [[ "$only_portable" == true || "$only_installable" == false ]]; then
    if [[ "$nobuild" != true ]]; then
      local build_args=(--portable --mode release)
      if [[ "$production" == true ]]; then build_args+=(--production --lto); fi
      if [[ -n "$addons" ]]; then build_args+=($addons); fi
      if [[ -n "$forcefallback" ]]; then build_args+=($forcefallback); fi
      bash "${app_root}/scripts/build.sh" "${build_args[@]}" -b "build"
    fi

    local p_stage="$builddir/tcode"
    if [[ ! -d "$p_stage" ]]; then
      echo "Portable staging not found: $p_stage" >&2
      echo "Run without --nobuild, or pass --builddir." >&2
      exit 1
    fi

    cp "${app_root}/resources/portable/README.txt" "$p_stage/README.txt" 2>/dev/null || true
    mkdir -p "$p_stage/user"

    local p_file
    if [[ "$platform" == "windows" ]]; then
      p_file="$distdir/tcode-$ref-$arch-windows-portable.zip"
      make_archive "$p_file" "$builddir" tcode
    else
      p_file="$distdir/tcode-$ref-$arch-$platform-portable.tar.gz"
      make_archive "$p_file" "$builddir" tcode
    fi
    echo "Portable -> $p_file"
  fi

  # ---- Installable ----
  if [[ "$only_installable" == true || "$only_portable" == false ]]; then
    if [[ "$nobuild" != true ]]; then
      local build_args=(--installable --mode release)
      if [[ "$production" == true ]]; then build_args+=(--production --lto); fi
      if [[ -n "$addons" ]]; then build_args+=($addons); fi
      if [[ -n "$forcefallback" ]]; then build_args+=($forcefallback); fi
      bash "${app_root}/scripts/build.sh" "${build_args[@]}" -b "build"
    fi

    if [[ "$platform" == "linux" ]]; then
      local i_stage="$builddir/install/usr/local"
      [[ -d "$builddir/install/usr" ]] || i_stage="$builddir/install"
      if [[ ! -e "$i_stage/bin/tcode" ]]; then
        echo "Installable staging not found: $i_stage/bin/tcode" >&2; exit 1
      fi
      cp "${app_root}/resources/installable/README.txt" "$i_stage/" 2>/dev/null || true

      local i_file="$distdir/tcode-$ref-$arch-linux-installable.tar.gz"
      echo "Installable (FHS) -> $i_file"
      local install_root="$builddir/install"
      (cd "$install_root" && tar -czf "$i_file" usr/local 2>/dev/null || tar -czf "$i_file" --sort=name --owner=0 --group=0 --numeric-owner -C "$install_root" usr/local)

      if command -v dpkg-deb >/dev/null 2>&1; then
        bash "${app_root}/scripts/package-installable.sh" --builddir "$builddir" --version "$ref" --format deb --distdir "$distdir" || echo "Warning: .deb build failed (skipped)"
      fi
      # RPM packaging is available on demand via
      #   package-installable.sh --format rpm
      # and is intentionally not part of the default artifact set.

    elif [[ "$platform" == "windows" ]]; then
      # InnoSetup payload is the `tcode/` staging under the build dir.
      local i_file="$distdir/tcode-$ref-$arch-windows-setup.exe"
      if [[ -x "/c/Program Files (x86)/Inno Setup 6/ISCC.exe" || -x "/c/Program Files/Inno Setup 6/ISCC.exe" ]] \
        || command -v iscc >/dev/null 2>&1; then
        bash "${app_root}/scripts/package-innosetup.sh" --version "$ref" -b "build" --distdir "$distdir" \
          || echo "Warning: InnoSetup build failed"
      else
        echo "ISCC.exe not found; skipping installer (portable zip is the Windows installable fallback)."
      fi
      local i_zip="$distdir/tcode-$ref-$arch-windows-installable.zip"
      [[ -d "$builddir/tcode" ]] && make_archive "$i_zip" "$builddir" tcode && echo "Installable (payload zip) -> $i_zip" || true

    elif [[ "$platform" == "darwin" ]]; then
      local i_stage="$builddir/T Code.app"
      [[ -d "$i_stage" ]] || i_stage="$builddir/install/T Code.app"
      local i_file="$distdir/tcode-$ref-$arch-darwin-bundle.tar.gz"
      if [[ -d "$i_stage" ]]; then
        (cd "$(dirname "$i_stage")" && tar -czf "$i_file" "T Code.app") && echo "Installable (bundle) -> $i_file"
      else
        echo "Bundle staging not found: $i_stage" >&2
      fi
      if command -v dmgbuild >/dev/null 2>&1; then
        dmgbuild -s "${app_root}/resources/macos/tcode-dmg.py" \
          -D "app_path=$i_stage" "T Code" "$distdir/tcode-$ref-universal-darwin.dmg" && echo "DMG -> $distdir/tcode-$ref-universal-darwin.dmg"
      fi
    fi
  fi

  # ---- Checksums + manifest ----
  write_checksums "$distdir"
  local m="$distdir/manifest.json"
  {
    echo "{"
    echo "  \"version\": \"$version\","
    echo "  \"ref\": \"$ref\","
    echo "  \"platform\": \"$platform\","
    echo "  \"arch\": \"$arch\","
    echo "  \"files\": ["
    local first=true
    for f in "$distdir"/tcode-*; do
      [[ -f "$f" ]] || continue
      [[ "$first" == true ]] && first=false || echo ","
      echo "    {\"file\": \"$(basename "$f")\", \"sha256\": \"$(get_sha256 "$f")\"}"
    done
    echo ""
    echo "  ]"
    echo "}"
  } > "$m"

  echo "=== Done. Artifacts in $distdir ==="
  ls -lh "$distdir"
}

main "$@"
