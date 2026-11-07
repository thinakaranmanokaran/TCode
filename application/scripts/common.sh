#!/bin/bash
# Common helpers for build/package scripts (bash, cross-platform MSYS/Lin/Mac).
# Provides platform/arch detection, version / checksum / archive helpers.

set -e

get_platform_name() {
  if [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
    echo "windows"
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "darwin"
  elif [[ "$OSTYPE" == "linux"* || "$OSTYPE" == "freebsd"* ]]; then
    echo "linux"
  else
    # Fallback for shells where OSTYPE is unset (e.g. meson runs)
    case "$(uname -s)" in
      MINGW*|MSYS*|CYGWIN*) echo "windows" ;;
      Darwin*) echo "darwin" ;;
      Linux*) echo "linux" ;;
      *) echo "UNSUPPORTED-OS" ;;
    esac
  fi
}

get_executable_extension() {
  if [[ "$(get_platform_name)" == "windows" ]]; then
    echo ".exe"
  else
    echo ""
  fi
}

get_platform_arch() {
  arch=${CROSS_ARCH:-$(uname -m)}
  if [[ $MSYSTEM != "" ]]; then
    case "$MSYSTEM" in
      MINGW64|UCRT64|CLANG64)
      arch=x86_64
      ;;
      MINGW32|CLANG32)
      arch=i686
      ;;
      CLANGARM64)
      arch=aarch64
      ;;
    esac
  fi
  [[ $arch == "arm64" ]] && arch="aarch64"
  echo "$arch"
}

get_platform_tuple() {
  platform="$(get_platform_name)"
  arch="$(get_platform_arch)"
  echo "$arch-$platform"
}

get_default_build_dir() {
  platform="${1:-$(get_platform_name)}"
  arch="${2:-$(get_platform_arch)}"
  echo "build-$arch-$platform"
}

# Project version (meson.project_version in root meson.build). Stable
# without git suffix; pass an override via env TCODE_VERSION if set.
get_project_version() {
  if [[ -n "${TCODE_VERSION:-}" ]]; then
    echo "$TCODE_VERSION"
    return
  fi
  local root
  root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
  if [[ -f "$root/meson.build" ]]; then
    grep -oP "(?<=version : ')[^']+" "$root/meson.build" | head -1
  else
    echo "0.0.0"
  fi
}

# Absolute path to the distribution output directory.
get_dist_dir() {
  echo "$1/application/dist"
}

# sha256 checksum of a file (cross-platform).
get_sha256() {
  local f="$1"
  if command -v sha256sum >/dev/null 2>&1; then
    sha256sum "$f" | awk '{print $1}'
  elif command -v shasum >/dev/null 2>&1; then
    shasum -a 256 "$f" | awk '{print $1}'
  elif command -v certutil >/dev/null 2>&1; then
    certutil -hashfile "$f" SHA256 | sed -n '2p' | tr -d ' \r'
  else
    echo "no sha256 tool found" >&2
    echo "SKIP"
  fi
}

# Write checksums for every file in a directory into "$dir/SHA256SUMS".
write_checksums() {
  local dir="$1"
  {
    if command -v sha256sum >/dev/null 2>&1; then
      (cd "$dir" && sha256sum * 2>/dev/null || true)
    elif command -v shasum >/dev/null 2>&1; then
      (cd "$dir" && shasum -a 256 * 2>/dev/null || true)
    elif command -v certutil >/dev/null 2>&1; then
      for f in "$dir"/*; do
        [[ -f "$f" ]] && echo "$(certutil -hashfile "$f" SHA256 | sed -n '2p' | tr -d ' \r')  $(basename "$f")"
      done
    fi
  } > "$dir/SHA256SUMS"
  # SHA256SUMS / manifest.json should not checksum themselves
  grep -v -E "SHA256SUMS|manifest\.json" "$dir/SHA256SUMS" > "$dir/.SHA256SUMS.tmp" 2>/dev/null || true
  mv "$dir/.SHA256SUMS.tmp" "$dir/SHA256SUMS"
}

# Create an archive. Usage: make_archive <archive> <srcdir-parent> <dirname...>
# Uses zip on Windows, tar.gz elsewhere (portable shims for MSYS).
# For .zip: prefer `zip`, then `7z`, then python zipfile, then powershell,
# then tar (gzip) as a last resort renamed to .zip (still real zip via python).
make_archive() {
  local archive="$1"
  local parent="$2"
  shift 2
  if [[ "$archive" == *.zip ]]; then
    if command -v zip >/dev/null 2>&1; then
      (cd "$parent" && zip -r "$archive" "$@")
    elif command -v 7z >/dev/null 2>&1; then
      (cd "$parent" && 7z a -mx=9 "$archive" "$@")
    elif command -v python3 >/dev/null 2>&1 || command -v python >/dev/null 2>&1; then
      local py
      py="$(command -v python3 || command -v python)"
      # Resolve MSYS paths to pass to Python (use cygpath if available)
      if command -v cygpath >/dev/null 2>&1; then
        local win_archive win_parent
        win_archive="$(cygpath -w "$(realpath -m "$archive")")"
        win_parent="$(cygpath -w "$(realpath -m "$parent")")"
        # "$@" are relative dir names; pass parent + files to python
        (cd "$parent" && "$py" -c "
import zipfile, sys, os
archive = r'''$win_archive'''
parent = r'''$win_parent'''
files = sys.argv[1:]
out = zipfile.ZipFile(archive, 'w', zipfile.ZIP_DEFLATED)
for f in files:
    full = os.path.join(parent, f)
    for root, dirs, filenames in os.walk(full):
        for name in filenames:
            p = os.path.join(root, name)
            arc = os.path.relpath(p, parent)
            out.write(p, arc)
        # keep empty dirs (e.g. user/)
        for d in dirs:
            dp = os.path.join(root, d)
            arc = os.path.relpath(dp, parent) + '/'
            out.writestr(arc, '')
out.close()
print(f'zip -> {archive}')
" "$@")
      else
        (cd "$parent" && "$py" -c "
import zipfile, sys, os
archive = sys.argv[1]
files = sys.argv[2:]
out = zipfile.ZipFile(archive, 'w', zipfile.ZIP_DEFLATED)
for f in files:
    for root, dirs, filenames in os.walk(f):
        for name in filenames:
            p = os.path.join(root, name)
            out.write(p, p)
        for d in dirs:
            dp = os.path.join(root, d)
            out.writestr(dp + '/', '')
out.close()
print(f'zip -> {archive}')
" "$archive" "$@")
      fi
    elif command -v powershell.exe >/dev/null 2>&1; then
      local win_archive win_parent
      win_archive="$(cygpath -w "$archive" 2>/dev/null || echo "$archive")"
      powershell.exe -Command "Compress-Archive -Path '$@' -DestinationPath '$win_archive' -Force" || {
        (cd "$parent" && tar -czf "$archive" "$@")
      }
    else
      (cd "$parent" && tar -czf "$archive" "$@")
    fi
  else
    (cd "$parent" && tar -czf "$archive" "$@")
  fi
}

if [[ $(get_platform_name) == "UNSUPPORTED-OS" ]]; then
  echo "Error: unknown OS type: \"$OSTYPE\"" >&2
  exit 1
fi
