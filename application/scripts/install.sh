#!/bin/bash
# Install T Code from a built staging tree or from a dist archive.
#
# Examples:
#   # Install the just-built installable layout (Linux)
#   bash application/scripts/install.sh --from-build
#   sudo bash application/scripts/install.sh --from-build --prefix /usr/local
#
#   # User install to ~/.local
#   bash application/scripts/install.sh --from-build --prefix ~/.local --no-desktop
#
#   # Install from tarball
#   bash application/scripts/install.sh --archive application/dist/tcode-*-linux-installable.tar.gz
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
  echo "  --from-build              Install from application/build*/install (or application/build/tcode)."
  echo "  --archive FILE            Install from a .tar.gz / .zip archive."
  echo "  --prefix DIR              Install prefix (default: /usr/local, or ~/.local with --user)."
  echo "  --user                    Install under ~/.local (default if not root)."
  echo "  --no-desktop              Skip desktop entry/icon/man install."
  echo "  -h --help                 This help."
  echo
}

main() {
  local from_build=false archive="" prefix="" user=false desktop=true
  while [[ $# -gt 0 ]]; do
    case $1 in
      -h|--help) show_help; exit 0 ;;
      --from-build) from_build=true; shift ;;
      --archive) archive="$2"; shift 2 ;;
      --prefix) prefix="$2"; shift 2 ;;
      --user) user=true; shift ;;
      --no-desktop) desktop=false; shift ;;
      *) echo "Unknown option: $1" >&2; exit 1 ;;
    esac
  done

  [[ "$from_build" == true || -n "$archive" ]] || { echo "Pick --from-build or --archive." >&2; exit 1; }
  [[ -n "$prefix" ]] || {
    if [[ "$user" == true || "${EUID:-0}" != "0" ]]; then
      prefix="$HOME/.local"
    else
      prefix="/usr/local"
    fi
  }

  echo "Installing to $prefix ..."

  local src=""
  if [[ "$from_build" == true ]]; then
    # Prefer installable staging, fall back to portable staging
    for d in application/build-*/install/usr/local application/build/install/usr/local \
             application/build-*/install application/build/install \
             application/build/tcode; do
      if [[ -e "$d/bin/tcode" || -e "$d/tcode" || -e "$d/tcode.exe" ]]; then
        src="$d"; break
      fi
    done
    [[ -n "$src" ]] || { echo "No build staging found (run build.sh first)." >&2; exit 1; }
    echo "Staging: $src"

    if [[ -e "$src/bin/tcode" ]]; then
      # FHS layout
      mkdir -p "$prefix/bin" "$prefix/share"
      install -m755 "$src/bin/tcode" "$prefix/bin/tcode"
      [[ -d "$src/share/tcode" ]] && cp -r "$src/share/tcode" "$prefix/share/tcode" || true
      [[ "$desktop" == true ]] && [[ -d "$src/share/applications" ]] && {
        mkdir -p "$prefix/share/applications"
        cp "$src/share/applications/"*.desktop "$prefix/share/applications/" || true
      }
      [[ "$desktop" == true ]] && [[ -d "$src/share/icons" ]] && {
        mkdir -p "$prefix/share/icons"
        cp -r "$src/share/icons/"* "$prefix/share/icons/" || true
      }
      [[ "$desktop" == true ]] && [[ -d "$src/share/man" ]] && {
        mkdir -p "$prefix/share/man"
        cp -r "$src/share/man/"* "$prefix/share/man/" || true
      }
      echo "Installed $prefix/bin/tcode"
    else
      # Portable payload: copy exe + data/ to $prefix/share/tcode + shim
      local exe="$src/tcode.exe"
      [[ -e "$exe" ]] || exe="$src/tcode"
      mkdir -p "$prefix/share/tcode" "$prefix/bin"
      cp "$exe" "$prefix/share/tcode/"
      [[ -d "$src/data" ]] && cp -r "$src/data" "$prefix/share/tcode/data" || true
      # Shim so `tcode` runs the payload (absolute path, same host)
      cat > "$prefix/bin/tcode" <<EOF
#!/bin/sh
exec "$prefix/share/tcode/$(basename "$exe")" "\$@"
EOF
      chmod 755 "$prefix/bin/tcode"
      echo "Installed portable payload into $prefix/share/tcode (shim: $prefix/bin/tcode)"
    fi
  else
    # Archive path
    local tmp
    tmp="$(mktemp -d)"
    case "$archive" in
      *.tar.gz|*.tgz) tar -xzf "$archive" -C "$tmp" ;;
      *.zip) unzip -q "$archive" -d "$tmp" ;;
      *) echo "Unsupported archive: $archive" >&2; exit 1 ;;
    esac
    echo "Extracted to $tmp"
    # Try FHS layout first, then portable payload
    if [[ -e "$tmp/usr/local/bin/tcode" ]]; then
      mkdir -p "$prefix/bin" "$prefix/share"
      install -m755 "$tmp/usr/local/bin/tcode" "$prefix/bin/tcode"
      [[ -d "$tmp/usr/local/share/tcode" ]] && cp -r "$tmp/usr/local/share/tcode" "$prefix/share/tcode" || true
    elif [[ -e "$tmp/tcode/tcode.exe" || -e "$tmp/tcode" ]]; then
      local payload="$tmp/tcode"
      mkdir -p "$prefix/share/tcode" "$prefix/bin"
      cp -r "$payload"/. "$prefix/share/tcode"/
    else
      echo "Unrecognized archive layout." >&2; exit 1
    fi
    rm -rf "$tmp"
    echo "Installed to $prefix"
  fi

  echo "Done. Run: tcode --help (or just: tcode)"
}

main "$@"
