#!/usr/bin/env bash
# AppImage builder (Linux).
#
# Works with either staging layout produced by build.sh:
#   - portable  (prefix "/"   -> <destdir>/tcode + data/)
#   - installable (prefix "/usr/local" -> <destdir>/usr/local/bin/tcode)
#
#   bash application/scripts/package-appimage.sh --version 2.1.7 -b build
#   bash application/scripts/package-appimage.sh --nobuild --distdir application/dist
set -e

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "${script_dir}/../.." && pwd)"
app_root="${repo_root}/application"

cd "${repo_root}"

if [ ! -e "${app_root}/src/api/api.h" ]; then
  echo "Could not find the T Code source tree at ${app_root}."
  exit 1
fi

source "${app_root}/scripts/common.sh"

ARCH="$(get_platform_arch)"
BUILD_DIR="application/build"
DIST_DIR=""
VERSION=""
NOBUILD=false
PORTABLE=true

show_help(){
  echo
  echo "Usage: $0 <OPTIONS>"
  echo
  echo "Available options:"
  echo
  echo "-h --help                 Show this help and exits."
  echo "-b --builddir DIRNAME     Build directory (default: application/build)."
  echo "   --distdir DIR          Output directory (default: repo root)."
  echo "   --debug                Debug this script."
  echo "-n --nobuild              Skip building; reuse the existing build directory."
  echo "-v --version VERSION      Version used in the artifact name."
  echo "   --installable          Build the installable (FHS) layout instead of portable."
  echo
}

while [[ $# -gt 0 ]]; do
  case $1 in
    -h|--help)
      show_help
      exit 0
      ;;
    -b|--builddir)
      BUILD_DIR="$2"
      shift 2
      ;;
    --distdir)
      DIST_DIR="$2"
      shift 2
      ;;
    --debug)
      set -x
      shift
      ;;
    -n|--nobuild)
      NOBUILD=true
      shift
      ;;
    -v|--version)
      VERSION="$2"
      shift 2
      ;;
    --installable)
      PORTABLE=false
      shift
      ;;
    *)
      echo "Unknown option: $1" >&2
      exit 1
      ;;
  esac
done

# Build directories live inside the application folder unless an
# explicit absolute path is given.
case "${BUILD_DIR}" in
  application/*|/*|[A-Za-z]:*) ;;
  *) BUILD_DIR="application/${BUILD_DIR}" ;;
esac

VERSION="${VERSION:-$(get_project_version)}"
DIST_DIR="${DIST_DIR:-$repo_root}"
mkdir -p "$DIST_DIR"

setup_appimagetool() {
  if [ ! -e appimagetool ]; then
    if ! wget -O appimagetool \
      "https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-${ARCH}.AppImage"; then
      echo "Could not download appimagetool for arch '${ARCH}'." >&2
      exit 1
    else
      chmod 0755 appimagetool
    fi
  fi
}

stage_appdir() {
  local appdir="TCode.AppDir"

  if [[ "$NOBUILD" != true && ! -f "$BUILD_DIR/build.ninja" ]]; then
    local layout="--portable"
    [[ "$PORTABLE" != true ]] && layout="--installable"
    bash application/scripts/build.sh "$layout" --forcefallback --mode release -b "${BUILD_DIR#application/}"
  fi

  rm -rf "$appdir"
  echo "Staging AppDir..."
  DESTDIR="$(realpath "$appdir")" meson install -C "$BUILD_DIR" \
    --no-rebuild --skip-subprojects=freetype2,lua,pcre2

  # The payload root is DESTDIR + install prefix.
  local root=""
  for candidate in "$appdir/usr/local" "$appdir/usr" "$appdir"; do
    if [[ -e "$candidate/bin/tcode" || -e "$candidate/tcode" ]]; then
      root="$candidate"
      break
    fi
  done
  if [[ -z "$root" ]]; then
    echo "Could not locate the staged tcode payload under $appdir." >&2
    exit 1
  fi

  mkdir -p "$appdir/usr/bin" "$appdir/usr/share"
  if [[ -e "$root/bin/tcode" ]]; then
    mv "$root/bin/tcode" "$appdir/usr/bin/tcode"
  elif [[ -e "$root/tcode" ]]; then
    mv "$root/tcode" "$appdir/usr/bin/tcode"
  fi
  if [[ -d "$root/share/tcode" ]]; then
    mv "$root/share/tcode" "$appdir/usr/share/tcode"
  elif [[ -d "$root/data" ]]; then
    mv "$root/data" "$appdir/usr/share/tcode"
  fi

  # Drop prefix leftovers (usr/local, lib64, include, doc) so the AppDir
  # contains only the AppRun + usr/bin + usr/share payload.
  rm -rf "$appdir/usr/local" "$appdir/usr/lib64" "$appdir/lib64" "$appdir/include" "$appdir/doc"

  cp application/resources/icons/tcode.svg "$appdir/"
  cp application/resources/linux/dev.thinakaran.tcode.desktop "$appdir/"

  echo "Creating AppRun..."
  cat > "$appdir/AppRun" <<'EOF'
#!/bin/sh
CURRENTDIR="$(dirname "$(readlink -f "$0")")"
exec "$CURRENTDIR/usr/bin/tcode" "$@"
EOF
  chmod +x "$appdir/AppRun"
}

generate_appimage() {
  stage_appdir

  local out="$DIST_DIR/tcode-${VERSION}-${ARCH}-linux.AppImage"
  echo "Generating AppImage -> $out"
  ARCH="$ARCH" APPIMAGE_EXTRACT_AND_RUN=1 ./appimagetool TCode.AppDir "$out"
  rm -rf TCode.AppDir
}

setup_appimagetool
generate_appimage
