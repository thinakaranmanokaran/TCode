#!/bin/bash
# Portable packaging only (thin wrapper over package.sh).
#   bash application/scripts/package-portable.sh --version 2.1.7
#   bash application/scripts/package-portable.sh --nobuild
set -e
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec bash "${script_dir}/package.sh" --only-portable "$@"
