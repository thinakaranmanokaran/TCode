#!/bin/bash
# Install build/runtime dependencies for T Code.
# For CI/documentation use. Do not run blindly on user machines.
# Prints commands (and attempts install where a package manager is found).
set -e

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${script_dir}/common.sh"

plat="$(get_platform_name)"

case "$plat" in
  windows)
    echo "Windows (MSYS2 UCRT64):"
    echo "  pacman -S mingw-w64-ucrt-x86_64-gcc mingw-w64-ucrt-x86_64-meson mingw-w64-ucrt-x86_64-ninja mingw-w64-ucrt-x86_64-cmake mingw-w64-ucrt-x86_64-pkg-config mingw-w64-ucrt-x86_64-SDL3 mingw-w64-ucrt-x86_64-pcre2 mingw-w64-ucrt-x86_64-freetype mingw-w64-ucrt-x86_64-lua"
    echo "  ...or use --forcefallback (Meson wraps download SDL3/Lua/PCRE2/FreeType)."
    echo "  For the InnoSetup installer, install InnoSetup 6 (ISCC.exe)."
    ;;
  linux)
    if command -v apt-get >/dev/null 2>&1; then
      sudo apt-get update
      sudo apt-get install -y meson ninja-build gcc pkg-config \
        libsdl3-dev libpcre2-dev libfreetype-dev lua5.4-dev \
        libx11-dev libwayland-dev cmake
    elif command -v dnf >/dev/null 2>&1; then
      sudo dnf install -y meson ninja-build gcc pkg-config SDL3-devel \
        pcre2-devel freetype-devel lua-devel cmake
    elif command -v pacman >/dev/null 2>&1; then
      sudo pacman -S --noconfirm meson ninja gcc pkgconf sdl3 pcre2 freetype2 lua cmake
    else
      echo "Install: meson ninja gcc pkg-config SDL3 PCRE2 FreeType Lua 5.4 cmake"
    fi
    echo "Optional packaging tools: dpkg-deb rpmbuild appimagetool"
    ;;
  darwin)
    echo "brew install meson ninja cmake"
    echo "SDL3/Pcre2/FreeType/Lua come via Meson wraps (--forcefallback) or brew:"
    echo "  brew install sdl3 pcre2 freetype lua"
    echo "Optional: brew install dmgbuild"
    ;;
  *) echo "Unknown platform: $plat" ;;
esac
