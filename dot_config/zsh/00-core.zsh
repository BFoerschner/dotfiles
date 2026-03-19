# Helper: cache an eval to disk, re-generate when any zsh config changes
# Usage: _cached_eval <cache-name> <command> [args...]
_cached_eval() {
  local name=$1; shift
  local cache="$HOME/.cache/zsh-eval-${name}.zsh"
  local stale=0
  if [[ ! -f "$cache" ]]; then
    stale=1
  else
    local f
    for f in ~/.zshrc "${XDG_CONFIG_HOME:-$HOME/.config}"/zsh/*.zsh; do
      if [[ "$f" -nt "$cache" ]]; then
        stale=1
        break
      fi
    done
  fi
  if (( stale )); then
    mkdir -p "$HOME/.cache"
    local tmp
    tmp=$(mktemp "$HOME/.cache/zsh-eval-${name}.XXXXXX")
    if "$@" > "$tmp" 2>/dev/null && [[ -s "$tmp" ]]; then
      mv "$tmp" "$cache"
    else
      rm -f "$tmp"
      [[ -f "$cache" ]] || return 1
    fi
  fi
  source "$cache"
}
