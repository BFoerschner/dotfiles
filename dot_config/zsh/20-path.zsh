# Build PATH efficiently
typeset -U path  # Ensures unique entries
path=(
  /usr/bin
  /usr/local/bin
  $HOME/.local/share/fnm
  $HOME/.local/share/go/bin
  $GOPATH/bin
  $HOME/.local/share/lua/bin
  $HOME/.cargo/bin
  $HOME/.local/bin
  $path
)

# Cache Homebrew prefix and paths (only if available and not Apple Terminal)
if [[ "$TERM_PROGRAM" != "Apple_Terminal" ]]; then
  # Persist HOMEBREW_PREFIX across sessions
  if [[ -z "$HOMEBREW_PREFIX" ]]; then
    _brew_cache="$HOME/.cache/zsh-brew-prefix"
    if [[ ! -f "$_brew_cache" || "${0}" -nt "$_brew_cache" ]]; then
      if (( $+commands[brew] )); then
        mkdir -p "$HOME/.cache"
        brew --prefix > "$_brew_cache" 2>/dev/null
      fi
    fi
    [[ -f "$_brew_cache" ]] && export HOMEBREW_PREFIX=$(<"$_brew_cache")
  fi
  if [[ -n "$HOMEBREW_PREFIX" ]]; then
    # Only add existing GNU bin directories
    for d in "${HOMEBREW_PREFIX}"/opt/{coreutils,findutils,gnu-tar,gnu-sed,gawk,gnutls,gnu-indent,gnu-getopt}/libexec/gnubin; do
      [[ -d "$d" ]] && path=("$d" "${path[@]}")
    done
  fi
fi
