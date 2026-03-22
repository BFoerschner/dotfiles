# fnm — lazy-load on first use of node/npm/npx/fnm
if (( $+commands[fnm] )); then
  _fnm_lazy_load() {
    unfunction node npm npx fnm 2>/dev/null
    eval "$(fnm env)"
    "$@"
  }
  node()  { _fnm_lazy_load node  "$@" }
  npm()   { _fnm_lazy_load npm   "$@" }
  npx()   { _fnm_lazy_load npx   "$@" }
  fnm()   { _fnm_lazy_load fnm   "$@" }
fi

# GPG Agent with SSH support (YubiKey)
if (( $+commands[gpgconf] )); then
  export GPG_TTY=$TTY
  if [[ -z "${SSH_CONNECTION:-}" ]]; then
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
    { gpgconf --launch gpg-agent && (( $+commands[yubikey-sync] )) && yubikey-sync -q } &!
  fi
fi

# Cache starship init for faster startup
if (( $+commands[starship] )); then
  _cached_eval starship starship init zsh
fi

# zoxide (cached) — replaces cd with smart directory jumping
if (( $+commands[zoxide] )); then
  _cached_eval zoxide zoxide init zsh --cmd cd
fi

# direnv (cached)
if (( $+commands[direnv] )); then
  _cached_eval direnv direnv hook zsh
fi
