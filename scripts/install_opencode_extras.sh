#!/usr/bin/env bash
set -euo pipefail

# Public components installed in this order:
components=(
  clarity       # Skill: addyosmani/clarity
  autoresearch  # Skill and commands: uditgoenka/autoresearch default branch
  rtk           # RTK OpenCode plugin
  herdr         # Herdr OpenCode integration
)
# Superpowers is loaded from opencode.jsonc, not installed by this script.

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

install_clarity() {
  if available npx "skills"; then
    run env DISABLE_TELEMETRY=1 npx --yes skills add addyosmani/clarity -g -a opencode -y
  fi
}

install_autoresearch() {
  if available git "autoresearch"; then
    if "$dry_run"; then
      run git clone https://github.com/uditgoenka/autoresearch.git "$cache"
      run git -C "$cache" fetch origin '+refs/heads/*:refs/remotes/origin/*'
      run git -C "$cache" remote set-head origin --auto
      echo "Would switch to the origin default branch if needed."
      run git -C "$cache" merge --ff-only origin/HEAD
      run bash "$cache/scripts/install.sh" --opencode --global
    else
      if [[ ! -e "$cache" ]]; then
        mkdir -p "$(dirname "$cache")"
        git clone https://github.com/uditgoenka/autoresearch.git "$cache"
      fi
      if [[ ! -d "$cache/.git" ]] || [[ "$(git -C "$cache" remote get-url origin)" != "https://github.com/uditgoenka/autoresearch.git" ]]; then
        echo "Autoresearch cache is not the expected repository: $cache" >&2
        exit 1
      fi
      if [[ -n "$(git -C "$cache" status --porcelain)" ]]; then
        echo "Autoresearch cache has local changes: $cache" >&2
        exit 1
      fi
      # Older caches were cloned at a tag and may not track any branch.
      git -C "$cache" fetch origin '+refs/heads/*:refs/remotes/origin/*'
      git -C "$cache" remote set-head origin --auto
      default_ref="$(git -C "$cache" symbolic-ref --short refs/remotes/origin/HEAD)"
      default_branch="${default_ref#origin/}"
      if ! git -C "$cache" merge-base --is-ancestor HEAD "$default_ref"; then
        echo "Autoresearch cache has commits outside the default branch: $cache" >&2
        exit 1
      fi
      current_branch="$(git -C "$cache" symbolic-ref --short -q HEAD || true)"
      if [[ "$current_branch" != "$default_branch" ]]; then
        if git -C "$cache" show-ref --verify --quiet "refs/heads/$default_branch"; then
          if ! git -C "$cache" merge-base --is-ancestor "$default_branch" "$default_ref"; then
            echo "Autoresearch default branch cannot be fast-forwarded: $cache" >&2
            exit 1
          fi
          git -C "$cache" checkout "$default_branch"
        else
          git -C "$cache" checkout -b "$default_branch" --no-track "$default_ref"
        fi
      fi
      git -C "$cache" merge --ff-only "$default_ref"
      bash "$cache/scripts/install.sh" --opencode --global
    fi
  fi
}

install_rtk() {
  if available rtk "RTK integration"; then
    run rtk init -g --opencode
  fi
}

install_herdr() {
  if available herdr "Herdr integration"; then
    run herdr integration install opencode
  fi
}

for component in "${components[@]}"; do
  case "$component" in
    clarity) echo "==> Installing Clarity (skill)"; install_clarity ;;
    autoresearch) echo "==> Installing Autoresearch (skill and commands)"; install_autoresearch ;;
    rtk) echo "==> Installing RTK (OpenCode plugin)"; install_rtk ;;
    herdr) echo "==> Installing Herdr (OpenCode integration)"; install_herdr ;;
    *) echo "Unknown component: $component" >&2; exit 1 ;;
  esac
done

if [[ -f "$local_dir/skills.local" ]] && available npx "local skills"; then
  while IFS= read -r line || [[ -n "$line" ]]; do
    read -r -a fields <<< "$line"
    [[ ${#fields[@]} -eq 0 || "${fields[0]}" == \#* ]] && continue
    if [[ ${#fields[@]} -ne 1 && ( ${#fields[@]} -ne 3 || "${fields[1]}" != "--skill" ) ]]; then
      echo "Invalid skills.local entry: expected SOURCE [--skill NAME]." >&2
      exit 1
    fi
    echo "==> Installing local skill: ${fields[0]}"
    run env DISABLE_TELEMETRY=1 npx --yes skills add "${fields[@]}" -g -a opencode -y
  done < "$local_dir/skills.local"
fi
if [[ -f "$local_dir/opencode-extras.local.sh" ]]; then
  run bash "$local_dir/opencode-extras.local.sh"
fi
