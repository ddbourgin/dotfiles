#!/usr/bin/env bash
set -euo pipefail

dry_run=false
if [[ $# -gt 1 || ( $# -eq 1 && "$1" != "--dry-run" ) ]]; then
  echo "Usage: $0 [--dry-run]" >&2
  exit 2
fi
if [[ $# -eq 1 ]]; then
  dry_run=true
fi

local_dir="${DOTFILES_OPENCODE_LOCAL_DIR:-${XDG_CONFIG_HOME:-$HOME/.config}/opencode/.local}"
cache="${XDG_CACHE_HOME:-$HOME/.cache}/dotfiles/autoresearch"

run() {
  if "$dry_run"; then
    printf 'Would run:'
    printf ' %s' "$@"
    printf '\n'
  else
    "$@"
  fi
}

available() {
  if command -v "$1" >/dev/null 2>&1; then
    return 0
  fi
  echo "Skipping $2: $1 is not installed." >&2
  "$dry_run"
}

if available npx "skills"; then
  run env DISABLE_TELEMETRY=1 npx --yes skills add addyosmani/clarity -g -a opencode -y
  if [[ -f "$local_dir/skills.local" ]]; then
    while IFS= read -r line || [[ -n "$line" ]]; do
      read -r -a fields <<< "$line"
      [[ ${#fields[@]} -eq 0 || "${fields[0]}" == \#* ]] && continue
      if [[ ${#fields[@]} -ne 1 && ( ${#fields[@]} -ne 3 || "${fields[1]}" != "--skill" ) ]]; then
        echo "Invalid skills.local entry: expected SOURCE [--skill NAME]." >&2
        exit 1
      fi
      run env DISABLE_TELEMETRY=1 npx --yes skills add "${fields[@]}" -g -a opencode -y
    done < "$local_dir/skills.local"
  fi
fi

if available git "autoresearch"; then
  if "$dry_run"; then
    run git clone --branch v2.3.0 --single-branch https://github.com/uditgoenka/autoresearch.git "$cache"
    run git -C "$cache" fetch --no-tags origin refs/tags/v2.3.0:refs/tags/v2.3.0
    run git -C "$cache" checkout --detach v2.3.0
    run bash "$cache/scripts/install.sh" --opencode --global
  else
    if [[ ! -e "$cache" ]]; then
      mkdir -p "$(dirname "$cache")"
      git clone --branch v2.3.0 --single-branch https://github.com/uditgoenka/autoresearch.git "$cache"
    fi
    if [[ ! -d "$cache/.git" ]] || [[ "$(git -C "$cache" remote get-url origin)" != "https://github.com/uditgoenka/autoresearch.git" ]]; then
      echo "Autoresearch cache is not the expected repository: $cache" >&2
      exit 1
    fi
    if [[ -n "$(git -C "$cache" status --porcelain)" ]]; then
      echo "Autoresearch cache has local changes: $cache" >&2
      exit 1
    fi
    git -C "$cache" fetch --no-tags origin refs/tags/v2.3.0:refs/tags/v2.3.0
    git -C "$cache" checkout --detach v2.3.0
    bash "$cache/scripts/install.sh" --opencode --global
  fi
fi

if available rtk "RTK integration"; then
  run rtk init -g --opencode
fi
if available herdr "Herdr integration"; then
  run herdr integration install opencode
fi
if [[ -f "$local_dir/opencode-extras.local.sh" ]]; then
  run bash "$local_dir/opencode-extras.local.sh"
fi
