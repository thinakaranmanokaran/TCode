#!/usr/bin/env bash
# InnoSetup installer builder (Windows).
#   bash application/scripts/package-innosetup.sh --version 2.1.7 -b build
set -e

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "${script_dir}/../.." && pwd)"
app_root="${repo_root}/application"

cd "${repo_root}"

if [ ! -e "${app_root}/src/api/api.h" ]; then
  echo "Could not find the T Code source tree at ${app_root}."; exit 1
fi

source "${app_root}/scripts/common.sh"

show_help() {
  echo
  echo "Usage: $0 <OPTIONS>"
  echo
  echo "Available options:"
  echo
  echo "-b --builddir DIRNAME     Sets the name of the build directory."
  echo "                          Created under 'application/'."
  echo "                          Default: 'application/$(get_default_build_dir)'."
  echo "-v --version VERSION      Sets the version on the package name."
  echo "   --debug                Debug this script."
  echo
}

main() {
  local build_dir="build"
  local version arch arch_file
  local NOBUILD=false

  while [[ $# -gt 0 ]]; do
    case $1 in
      -h|--help)
        show_help
        exit 0
        ;;
      -b|--builddir)
        build_dir="$2"
        shift 2
        ;;
      -v|--version)
        version="$2"
        shift 2
        ;;
      -n|--nobuild)
        NOBUILD=true
        shift
        ;;
      --debug)
        set -x
        shift
        ;;
      *)
        echo "Unknown option: $1" >&2
        exit 1
        ;;
    esac
  done

  case "$MSYSTEM" in
    MINGW64|UCRT64|CLANG64)
    arch=x64compatible
    arch_file=x86_64
    ;;
    MINGW32|CLANG32)
    arch=x86compatible
    arch_file=i686
    ;;
    CLANGARM64)
    arch=arm64
    arch_file=aarch64
    ;;
    *)
    # Fallback for plain MSYS / Git Bash without MSYSTEM set
    if [[ "$(get_platform_name)" == "windows" ]]; then
      arch=x64compatible
      arch_file=x86_64
    else
      echo "error: unsupported MSYSTEM type: $MSYSTEM"
      exit 1
    fi
    ;;
  esac

  # Build directories live inside the application folder unless an
  # explicit absolute path is given.
  case "${build_dir}" in
    application/*|/*|[A-Za-z]:*) ;;
    *) build_dir="application/${build_dir}" ;;
  esac

  if [[ "$NOBUILD" != true && ! -e $build_dir ]]; then
    application/scripts/build.sh --installable --forcefallback --mode release -b "${build_dir}"
  fi

  version="${version:-$(get_project_version)}"
  local output="tcode-${version}-${arch_file}-windows-setup"

  "/c/Program Files (x86)/Inno Setup 6/ISCC.exe" -dARCH=$arch //F"${output}" "${build_dir}/application/scripts/innosetup.iss"
  pushd "${build_dir}/application/scripts"; mv tcode*.exe "${repo_root}"; popd
}

main "$@"
