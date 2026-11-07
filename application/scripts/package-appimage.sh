#!/usr/bin/env bash
# AppImage builder (Linux). Expects a portable-layout build (flat).
#   bash application/scripts/package-appimage.sh --version 2.1.7 -b build
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

ARCH="$(uname -m)"
BUILD_DIR="$(get_default_build_dir)"
VERSION=""

show_help(){
  echo
  echo "Usage: $0 <OPTIONS>"
  echo
  echo "Available options:"
  echo
  echo "-h --help                 Show this help and exits."
  echo "-b --builddir DIRNAME     Sets the name of the build directory."
  echo "                          Created under 'application/'."
  echo "                          Default: 'application/$(get_default_build_dir)'."
  echo "   --debug                Debug this script."
  echo "-n --nobuild              Skips the build step, use existing files."
  echo "-v --version VERSION      Specify a version, non whitespace separated string."
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

setup_appimagetool() {
  if [ ! -e appimagetool ]; then
    if ! wget -O appimagetool "https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-${ARCH}.AppImage" ; then
      echo "Could not download the appimagetool for the arch '${ARCH}'."
      exit 1
    else
      chmod 0755 appimagetool
    fi
  fi
}

generate_appimage() {
  if [[ "$NOBUILD" != true && ! -e $BUILD_DIR ]]; then
    application/scripts/build.sh --portable --forcefallback --mode release -b "${BUILD_DIR}"
  fi

  if [ -e TCode.AppDir ]; then
    rm -rf TCode.AppDir
  fi

  echo "Creating TCode.AppDir..."

  DESTDIR="$(realpath TCode.AppDir)" meson install -C ${BUILD_DIR} --no-rebuild --skip-subprojects=freetype2,lua,pcre2

  cp application/resources/icons/tcode.svg TCode.AppDir/
  cp application/resources/linux/dev.thinakaran.tcode.desktop TCode.AppDir/

  # https://github.com/lite-xl/lite-xl/issues/1912
  mkdir -p ./TCode.AppDir/usr/share/../bin
  # Handle both portable (flat) and installable (FHS) staging layouts
  if [[ -e ./TCode.AppDir/tcode ]]; then
    mv ./TCode.AppDir/tcode ./TCode.AppDir/usr/bin
  elif [[ -e ./TCode.AppDir/bin/tcode ]]; then
    mv ./TCode.AppDir/bin/tcode ./TCode.AppDir/usr/bin/tcode
    rm -rf ./TCode.AppDir/bin
  fi
  if [[ -e ./TCode.AppDir/data ]]; then
    mv ./TCode.AppDir/data ./TCode.AppDir/usr/share/tcode
  elif [[ -e ./TCode.AppDir/share/tcode ]]; then
    mkdir -p ./TCode.AppDir/usr/share
    mv ./TCode.AppDir/share/tcode ./TCode.AppDir/usr/share/tcode
    rm -rf ./TCode.AppDir/share
  fi
  rm -rf ./TCode.AppDir/lib64 ./TCode.AppDir/include

  echo "Creating AppRun..."
	cat >> TCode.AppDir/AppRun <<- 'EOF'
	#!/bin/sh
	CURRENTDIR="$(dirname "$(readlink -f "$0")")"
	exec "$CURRENTDIR/usr/bin/tcode" "$@"
	EOF
  chmod +x TCode.AppDir/AppRun

  echo "Generating AppImage..."
  local version=""
  if [ -n "$VERSION" ]; then
    version="-$VERSION"
  fi

  APPIMAGE_EXTRACT_AND_RUN=1 ./appimagetool TCode.AppDir TCode${version}-${ARCH}-linux.AppImage
  rm -rf TCode.AppDir
}

setup_appimagetool
generate_appimage
