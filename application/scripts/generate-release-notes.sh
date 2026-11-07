#!/usr/bin/env bash

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "${script_dir}/../.." && pwd)"
app_root="${repo_root}/application"

cd "${repo_root}"

if [ ! -e "${app_root}/src/api/api.h" ]; then
  echo "Could not find the T Code source tree at ${app_root}."; exit 1
fi

show_help() {
  echo
  echo "Release notes generator for tcode releases."
  echo "USE IT AT YOUR OWN RISK!"
  echo
  echo "Usage: $0 <OPTIONS>"
  echo
  echo "Available options:"
  echo
  echo "--version    The current version used to generate release notes."
  echo "--debug      Debug this script."
  echo "--help       Show this message."
  echo
}

main() {
  local version
  local last_version

  while [[ $# -gt 0 ]]; do
    case $1 in
      --debug)
        set -x
        shift
        ;;
      --help)
        show_help
        exit 0
        ;;
      --version)
        version="$2"
        shift 2
        ;;
      *)
        echo "unknown option: $1" >&2
        exit 1
        ;;
    esac
  done

  if [[ -z "$version" ]]; then
    echo "error: a version must be provided"
    exit 1
  fi

  # use gh cli to get the last version
  read -r last_version < <(gh release list --exclude-pre-releases --limit 1 | awk 'BEGIN {FS="\t"}; {print $3}')
  if [[ -z "$last_version" ]]; then
    echo "error: cannot get last release git tag"
    exit 1
  fi

  export RELEASE_TAG="$version"
  export LAST_RELEASE_TAG="$last_version"
  envsubst '$RELEASE_TAG:$LAST_RELEASE_TAG' > release-notes.md < application/resources/release-notes.md
}

main "$@"
