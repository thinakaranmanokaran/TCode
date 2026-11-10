#!/bin/bash
# Installable packaging (thin wrapper over package.sh) with direct
# deb/rpm sub-formats for Linux.
#
#   bash application/scripts/package-installable.sh --version 2.1.7
#   bash application/scripts/package-installable.sh --version 2.1.7 --format deb
#   bash application/scripts/package-installable.sh --version 2.1.7 --format rpm
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
  echo "  --version V     Version (default: meson version)."
  echo "  -b --builddir D Build dir."
  echo "  --distdir DIR   Output dir (default: application/dist)."
  echo "  --format [tar|deb|rpm]  Linux sub-format (default: tar=FHS archive;"
  echo "                        deb/rpm built when the tools exist)."
  echo "  --nobuild       Reuse staging."
  echo "  -h --help       This help."
  echo
}

main() {
  local version="" builddir="" distdir="" format="tar" nobuild=false
  while [[ $# -gt 0 ]]; do
    case $1 in
      -h|--help) show_help; exit 0 ;;
      --version|-v) version="$2"; shift 2 ;;
      -b|--builddir) builddir="$2"; shift 2 ;;
      --distdir) distdir="$2"; shift 2 ;;
      --format) format="$2"; shift 2 ;;
      --nobuild) nobuild=true; shift ;;
      *) echo "Unknown option: $1" >&2; exit 1 ;;
    esac
  done

  local platform arch
  platform="$(get_platform_name)"
  arch="$(get_platform_arch)"
  version="${version:-$(get_project_version)}"
  distdir="${distdir:-$app_root/dist}"
  builddir="${builddir:-application/build}"

  if [[ "$format" == "deb" || "$format" == "rpm" ]]; then
    [[ "$platform" == "linux" ]] || { echo "deb/rpm only supported on Linux." >&2; exit 1; }
    # Build installable staging if requested (stages under application/build)
    if [[ "$nobuild" == false ]]; then
      bash "${app_root}/scripts/build.sh" --installable --mode release -b "build"
      builddir="application/build"
    fi
    local install_root="$builddir/install"
    local usr_local="$install_root/usr/local"
    [[ -e "$usr_local/bin/tcode" ]] || usr_local="$install_root"

    if [[ "$format" == "deb" ]]; then
      command -v dpkg-deb >/dev/null 2>&1 || { echo "dpkg-deb not found." >&2; exit 1; }
      # Debian architecture names differ from uname -m.
      local deb_arch
      case "$arch" in
        x86_64) deb_arch=amd64 ;;
        aarch64) deb_arch=arm64 ;;
        i686|i386) deb_arch=i386 ;;
        armv7l) deb_arch=armhf ;;
        *) deb_arch="$arch" ;;
      esac
      local deb_root="$builddir/deb-root"
      rm -rf "$deb_root"
      mkdir -p "$deb_root/usr/local"
      cp -a "$usr_local"/. "$deb_root/usr/local"/

      mkdir -p "$deb_root/DEBIAN"
      # Debian control (from template; @VERSION@ / @ARCH@ substituted)
      sed -e "s/@VERSION@/$version/g" -e "s/@ARCH@/$deb_arch/g" \
        "${app_root}/resources/linux/debian/control.in" > "$deb_root/DEBIAN/control"
      sed "s/@VERSION@/$version/g" "${app_root}/resources/linux/debian/conffiles.in" > "$deb_root/DEBIAN/conffiles" 2>/dev/null || true
      cat > "$deb_root/DEBIAN/postinst" <<'EOF'
#!/bin/sh
set -e
# Register desktop entry cache / icons / man pages
if command -v update-desktop-database >/dev/null 2>&1; then
  update-desktop-database /usr/local/share/applications || true
fi
if command -v gtk-update-icon-cache >/dev/null 2>&1; then
  gtk-update-icon-cache -f -t /usr/local/share/icons/hicolor || true
fi
exit 0
EOF
      cat > "$deb_root/DEBIAN/postrm" <<'EOF'
#!/bin/sh
set -e
# Purge caches (best effort)
if command -v update-desktop-database >/dev/null 2>&1; then
  update-desktop-database /usr/local/share/applications || true
fi
exit 0
EOF
      chmod 755 "$deb_root/DEBIAN/postinst" "$deb_root/DEBIAN/postrm"

      mkdir -p "$distdir"
      local deb_file="$distdir/tcode_${version}_${deb_arch}.deb"
      dpkg-deb --build --root-owner-group "$deb_root" "$deb_file"
      echo "Debian package -> $deb_file"
      return 0
    fi

    if [[ "$format" == "rpm" ]]; then
      command -v rpmbuild >/dev/null 2>&1 || { echo "rpmbuild not found." >&2; exit 1; }
      local spec="${app_root}/resources/linux/tcode.spec.in"
      mkdir -p "$builddir/rpmbuild/SOURCES" "$builddir/rpmbuild/BUILD" "$builddir/rpmbuild/BUILDROOT"
      tar -czf "$builddir/rpmbuild/SOURCES/tcode-$version.tar.gz" -C "$builddir/install" usr/local 2>/dev/null \
        || tar -czf "$builddir/rpmbuild/SOURCES/tcode-$version.tar.gz" -C "$builddir/install" .
      mkdir -p "$distdir"
      # Write spec with version substituted
      sed "s/@VERSION@/$version/g" "$spec" > "$builddir/rpmbuild/tcode.spec"
      rpmbuild --define "_topdir $builddir/rpmbuild" -bb "$builddir/rpmbuild/tcode.spec"
      cp "$builddir/rpmbuild/RPMS/"*/*.rpm "$distdir/" 2>/dev/null || true
      echo "RPM in $distdir"
      return 0
    fi
  fi

  # Default: full installable via package.sh
  local args=(--only-installable --version "$version")
  [[ -n "$distdir" ]] && args+=(--distdir "$distdir")
  [[ -n "$builddir" ]] && args+=(--builddir "$builddir")
  [[ "$nobuild" == true ]] && args+=(--nobuild)
  exec bash "${app_root}/scripts/package.sh" "${args[@]}"
}

main "$@"
