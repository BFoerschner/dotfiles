# Generate and cache tool completions into fpath (lazy-loaded by compinit)
_comp_cache="$HOME/.cache/zsh-completions"
if [[ ! -d "$_comp_cache" || "${0}" -nt "$_comp_cache" ]]; then
  mkdir -p "$_comp_cache"
  # Each entry: completion-filename command [args...]
  typeset -A _comp_cmds=(
    [_rustup]="rustup completions zsh"
    [_cargo]="rustup completions zsh cargo"
    [_uv]="uv generate-shell-completion zsh"
    [_yq]="yq shell-completion zsh"
    [_just]="just --completions zsh"
    [_gh]="gh completion -s zsh"
    [_kubectl]="kubectl completion zsh"
    [_k9s]="k9s completion zsh"
    [_docker]="docker completion zsh"
    [_bat]="bat --completion zsh"
    [_fd]="fd --gen-completions zsh"
    [_delta]="delta --generate-completion zsh"
    [_rg]="rg --generate complete-zsh"
    [_procs]="procs --gen-completion-out zsh"
  )
  for comp cmd in "${(@kv)_comp_cmds}"; do
    bin=${cmd%% *}
    if (( $+commands[$bin] )); then
      ${(z)cmd} > "$_comp_cache/$comp" 2>/dev/null
    fi
  done
  # sops generates a broken completion (wrong function name), patch it
  if (( $+commands[sops] )); then
    sops completion zsh 2>/dev/null \
      | sed '/^$/d; s/_cli_zsh_autocomplete/_sops/g; /^compdef /d' \
      > "$_comp_cache/_sops"
  fi
  touch "$_comp_cache"
  # Invalidate zcompdump so compinit rescans fpath
  rm -f ~/.zcompdump(N) ~/.zcompdump.*(N)
fi
fpath=("$_comp_cache" $fpath)

# Completion Styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color "${realpath}"'
zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes

# Reduce completion system overhead
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.cache/.zcompcache
