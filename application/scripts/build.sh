#!/bin/bash
# Build T Code (production + portable/installable layouts).
#
# Examples:
#   bash application/scripts/build.sh --production --portable
#   bash application/scripts/build.sh --production --installable
#   bash application/scripts/build.sh --production --installable --prefix /usr/local
#   bash application/scripts/build.sh --portable -b build-x86_64-windows-portable
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
  echo "  -b --builddir DIRNAME         Sets the name of the build directory."
  echo "                                Created under 'application/'."
  echo "                                Default: 'application/$(get_default_build_dir)'."
  echo "     --debug                    Debug this script."
  echo "  -f --forcefallback            Force to build dependencies statically."
  echo "  -h --help                     Show this help and exit."
  echo "  -m --mode MODE                Build type (plain,debug,debugoptimized,release,minsize)."
  echo "                                Default: release."
  echo "  -p --prefix PREFIX            Install directory prefix. Default: '/' for"
  echo "                                portable, '/usr/local' for Linux installable."
  echo "  -B --bundle                   Create an App bundle (macOS only)."
  echo "  -A --addons [LIST]            Install extra plugins via lpm."
  echo "                                Bare flag = welcome; list = csv."
  echo "  -P --portable                 Portable build (flat relocatable layout)."
  echo "  -I --installable              Production installable build (FHS on Linux,"
  echo "                                .app bundle on macOS, InnoSetup payload on Windows)."
  echo "     --production               Production build: release + LTO + strip +"
  echo "                                hardening + no git suffix."
  echo "     --strip                     Strip binaries on install."
  echo "     --destdir DIR               Staging install dir inside the build dir."
  echo "                                Default: 'tcode' (portable) / 'install' (installable)."
  echo "  -r --reconfigure              Reuse the meson build directory."
  echo "  -O --pgo                      Profile-guided optimization (Windows: implied)."
  echo "  -L --lto [MODE]               Link-time optimization. MODE: [default],thin"
  echo "     --cross-platform PLATFORM  Cross compile for this platform."
  echo "     --cross-arch ARCH          Cross compile for this architecture."
  echo "     --cross-file CROSS_FILE    Cross compile with the given cross file."
  echo
}

main() {
  local platform="$(get_platform_name)"
  local arch="$(get_platform_arch)"
  local build_dir=""
  local plugins="-Dbundle_plugins="
  local prefix=""
  local build_type="release"
  local sdl3_version="${SDL3_VERSION:-3.2.8}"
  local pkg_config_path
  local cmake_build_type
  local force_fallback
  local bundle="-Dbundle=false"
  local portable="-Dportable=false"
  local layout="installable"
  local production=""
  local strip=""
  local destdir=""
  local pgo
  local lto
  local lto_mode
  local cross
  local cross_platform
  local cross_arch
  local cross_file
  local reconfigure
  local lpm_path
  local should_reconfigure

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
      -m|--mode)
        build_type="$2"
        shift 2
        ;;
      -r|--reconfigure)
        should_reconfigure=true
        shift
        ;;
      --debug)
        set -x
        shift
        ;;
      -f|--forcefallback)
        force_fallback="--wrap-mode=forcefallback"
        shift
        ;;
      -p|--prefix)
        prefix="$2"
        shift 2
        ;;
      -A|--addons)
        if [[ -n ${2:-} ]] && [[ $2 != -* ]]; then
          plugins="-Dbundle_plugins=$2"
          shift
        else
          plugins="-Dbundle_plugins=welcome"
        fi
        shift
        ;;
      -B|--bundle)
        if [[ "$platform" != "darwin" ]]; then
          echo "Warning: ignoring --bundle option, works only under macOS."
        else
          bundle="-Dbundle=true"
          layout="installable"
        fi
        shift
        ;;
      -P|--portable)
        portable="-Dportable=true"
        layout="portable"
        shift
        ;;
      -I|--installable)
        portable="-Dportable=false"
        layout="installable"
        if [[ "$platform" == "darwin" ]]; then
          bundle="-Dbundle=true"
        fi
        shift
        ;;
      --production)
        production="-Dproduction=true"
        build_type="release"
        strip="--strip"
        lto="-Db_lto=true"
        # Production builds are hermetic: static deps via Meson wraps + SDL3
        # built with CMake (needed on hosts without system SDL3).
        if [[ -z "$force_fallback" ]]; then
          force_fallback="--wrap-mode=forcefallback"
        fi
        shift
        ;;
      --strip)
        strip="--strip"
        shift
        ;;
      --destdir)
        destdir="$2"
        shift 2
        ;;
      -O|--pgo)
        pgo="-Db_pgo=generate"
        shift
        ;;
      -L|--lto)
        lto="-Db_lto=true"
        if [[ -n ${2:-} ]] && [[ $2 != -* ]]; then
          lto_mode="-Db_lto_mode=$2"
          shift
        fi
        shift
        ;;
      --cross-arch)
        cross="true"
        cross_arch="$2"
        shift 2
        ;;
      --cross-platform)
        cross="true"
        cross_platform="$2"
        shift 2
        ;;
      --cross-file)
        cross="true"
        cross_file="$2"
        shift 2
        ;;
      --)
        shift
        break
        ;;
      -*)
        echo "Error: unknown option: $1" >&2
        show_help
        exit 1
        ;;
      *)
        echo "Error: unexpected argument: $1" >&2
        show_help
        exit 1
        ;;
    esac
  done

  # macOS: bundle wins over portable (cannot be both)
  if [[ $platform == "darwin" && $bundle == "-Dbundle=true" && $portable == "-Dportable=true" ]]; then
    echo "Warning: \"bundle\" and \"portable\" specified; excluding portable package."
    portable="-Dportable=false"
    layout="installable"
  fi

  # Default prefix per layout/platform (explicit --prefix always wins)
  if [[ -z "$prefix" ]]; then
    if [[ "$layout" == "portable" ]]; then
      prefix="/"
    else
      case "$platform" in
        linux) prefix="/usr/local" ;;
        darwin) prefix="/" ;;
        windows) prefix="/" ;;
        *) prefix="/" ;;
      esac
    fi
  fi

  # Default destdir: keep legacy 'tcode' name for portable so CI's
  # `tar -C $build_dir tcode` keeps working.
  if [[ -z "$destdir" ]]; then
    if [[ "$platform" == "darwin" && $bundle == "-Dbundle=true" ]]; then
      destdir="T Code.app"
    elif [[ "$layout" == "portable" ]]; then
      destdir="tcode"
    else
      # Installable Linux FHS layout stages as `install/` (prefix-relative);
      # Windows installable stages as `tcode/` (InnoSetup payload).
      if [[ "$platform" == "windows" ]]; then
        destdir="tcode"
      else
        destdir="install"
      fi
    fi
  fi

  # --production implies --forcefallback (set above). CI passes it explicitly
  # too for hermetic release builds.

  # if CROSS_ARCH is used, it will be picked up
  cross="${cross:-$CROSS_ARCH}"
  if [[ -n "$cross" ]]; then
    if [[ -n "$cross_file" ]] && ([[ -z "$cross_arch" ]] || [[ -z "$cross_platform" ]]); then
      echo "Warning: --cross-platform or --cross-arch not set; guessing it from the filename."
      cross_file_name="${cross_file##*/}"
      cross_file_name="${cross_file_name%%.*}"
      if [[ -z "$cross_platform" ]]; then
        cross_platform="${cross_file_name%%-*}"
        echo "Warning: Guessing --cross-platform $cross_platform"
      fi
      if [[ -z "$cross_arch" ]]; then
        cross_arch="${cross_file_name#*-}"
        echo "Warning: Guessing --cross-arch $cross_arch"
      fi
    fi
    platform="${cross_platform:-$platform}"
    arch="${cross_arch:-$arch}"
    cross_file="--cross-file ${cross_file:-application/resources/cross/$platform-$arch.txt}"
    if [[ -z "${build_dir}" ]]; then
      build_dir="$(get_default_build_dir "$platform" "$arch")"
    fi
  elif [[ -z "${build_dir}" ]]; then
    build_dir="$(get_default_build_dir)"
  fi

  # Build directories live inside the application folder unless absolute.
  case "${build_dir}" in
    application/*|/*|[A-Za-z]:*) ;;
    *) build_dir="application/${build_dir}" ;;
  esac

  # arch and platform specific stuff
  if [[ "$platform" == "darwin" || "$platform" == "macos" ]]; then
    platform="darwin"
    macos_version_min="10.11"
    if [[ "$arch" == "aarch64" ]]; then
      macos_version_min="11.0"
    fi
    export MACOSX_DEPLOYMENT_TARGET="$macos_version_min"
    export MIN_SUPPORTED_MACOSX_DEPLOYMENT_TARGET="$macos_version_min"
    export CFLAGS="${CFLAGS:-}-mmacosx-version-min=$macos_version_min"
    export CXXFLAGS="${CXXFLAGS:-}-mmacosx-version-min=$macos_version_min"
    export LDFLAGS="${LDFLAGS:-}-mmacosx-version-min=$macos_version_min"
  fi

  if [[ $should_reconfigure == true ]] && [[ -d "${build_dir}" ]]; then
    reconfigure="--reconfigure"
  elif [[ -d "${build_dir}" ]]; then
    rm -rf "${build_dir}"
  fi

  mkdir -p "${build_dir}"
  if [[ -n "$force_fallback" ]]; then
    pushd "${build_dir}"
    if [[ ! -f "SDL3-$sdl3_version.tar.gz" ]]; then
      curl --insecure -L -o "SDL3-$sdl3_version.tar.gz" \
        "https://github.com/libsdl-org/SDL/releases/download/release-$sdl3_version/SDL3-$sdl3_version.tar.gz" || true
      # GitHub can return a 92-byte 504 HTML page; validate and fall back to libsdl.org
      if ! tar -tzf "SDL3-$sdl3_version.tar.gz" >/dev/null 2>&1; then
        echo "GitHub SDL3 download invalid; retrying from libsdl.org..."
        curl --insecure -L -o "SDL3-$sdl3_version.tar.gz" \
          "https://www.libsdl.org/release/SDL3-$sdl3_version.tar.gz"
      fi
    fi
    [[ ! -f "SDL3-$sdl3_version/CMakeLists.txt" ]] && tar -xzf "SDL3-$sdl3_version.tar.gz"
    case "$build_type" in
      "release"|"debug") cmake_build_type="$build_type";;
      "debugoptimized") cmake_build_type="RelWithDebInfo";;
      "minsize") cmake_build_type="MinSizeRel";;
      *) cmake_build_type="Release";;
    esac
    cmake -S "SDL3-$sdl3_version" -B "SDL3-$sdl3_version/build" -GNinja \
      -DCMAKE_OSX_DEPLOYMENT_TARGET="$MACOSX_DEPLOYMENT_TARGET" -DCMAKE_INTERPROCEDURAL_OPTIMIZATION=$([[ -n $lto ]] && echo ON || echo OFF) \
      -DCMAKE_BUILD_TYPE=$cmake_build_type -DCMAKE_INSTALL_LIBDIR=lib -DCMAKE_INSTALL_PREFIX="$(pwd -P)/prefix" \
      -DCMAKE_POSITION_INDEPENDENT_CODE=ON -DSDL_INSTALL=ON -DSDL_INSTALL_DOCS=OFF -DSDL_DEPS_SHARED=ON \
      -DSDL_DBUS=ON -DSDL_IBUS=ON -DSDL_AUDIO=OFF -DSDL_GPU=OFF -DSDL_RPATH=OFF -DSDL_PIPEWIRE=OFF \
      -DSDL_CAMERA=OFF -DSDL_JOYSTICK=OFF -DSDL_HAPTIC=OFF -DSDL_HIDAPI=OFF -DSDL_DIALOG=ON \
      -DSDL_POWER=OFF -DSDL_SENSOR=OFF -DSDL_VULKAN=OFF -DSDL_LIBUDEV=OFF -DSDL_SHARED=OFF -DSDL_STATIC=ON \
      -DSDL_X11=ON -DSDL_WAYLAND=ON -DSDL_TESTS=OFF -DSDL_EXAMPLES=OFF -DSDL_VENDOR_INFO=tcode
    cmake --build "SDL3-$sdl3_version/build" && cmake --install "SDL3-$sdl3_version/build"
    pkg_config_path="--pkg-config-path=$(pwd -P)/prefix/lib/pkgconfig"
    popd
  fi

  if [[ -n "$plugins" ]] && [[ -z "$(command -v lpm)" ]]; then
    mkdir -p "${build_dir}"
    lpm_path="$(pwd -P)/${build_dir}/lpm$(get_executable_extension)"
    if [[ ! -e "$lpm_path" ]]; then
      curl --insecure -L -o "$lpm_path" \
        "https://github.com/lite-xl/lite-xl-plugin-manager/releases/download/${LPM_VERSION:-latest}/lpm.$(get_platform_tuple)$(get_executable_extension)"
      chmod u+x "$lpm_path"
    fi
    export PATH="$(dirname "$lpm_path"):$PATH"
  fi

  echo "=== T Code build ($layout${production:+", production"}) ==="
  echo "platform: $platform  arch: $arch  buildtype: $build_type"
  echo "builddir: $build_dir  prefix: $prefix  destdir: $destdir"

  meson_args=(
    "${build_dir}"
    --buildtype "$build_type"
    --prefix "$prefix"
  )
  # $cross_file / $force_fallback / $bundle etc. are space-separated flag
  # strings (e.g. "--wrap-mode=forcefallback"); word-splitting is
  # intentional here, but $pkg_config_path must stay a single arg
  # because the build dir may contain spaces.
  meson_args+=($cross_file $force_fallback $bundle $portable $production $pgo $lto $lto_mode $plugins $reconfigure)
  if [[ -n "$pkg_config_path" ]]; then
    meson_args+=("$pkg_config_path")
  fi

  CFLAGS=$CFLAGS LDFLAGS=$LDFLAGS meson setup "${meson_args[@]}"

  meson compile -C "${build_dir}"

  if [[ $pgo != "" ]]; then
    cp -r "${app_root}/data" "${build_dir}/application/src"
    "${build_dir}/application/src/tcode"
    meson configure -Db_pgo=use "${build_dir}"
    meson compile -C "${build_dir}"
    rm -fr "${build_dir}/application/src/data"
  fi

  rm -rf "${build_dir}/${destdir}"
  meson install -C "${build_dir}" --destdir "$destdir" \
    --skip-subprojects=freetype2,lua,pcre2 --no-rebuild $strip

  echo "=== Done ($layout) ==="
  echo "Staged install: ${build_dir}/${destdir}"
}

main "$@"
