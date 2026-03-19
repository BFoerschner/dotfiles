# Aliases
alias gig='gi $(gi list &>/dev/null | tr "," "\n" | fzf)'
alias ..='cd ..'
alias rg="rg --hidden --glob '!.git'"
alias t="tmux new-session -A -s main"
alias lg="lazygit"
alias ldo="lazydocker"

# Enhanced aliases — use $+commands[] (zsh hash lookup, no fork)
(( $+commands[eza] )) && {
  export EZA_COLORS="mp=1;34"  # ln: symlinks cyan; mp: mount points bold blue (no underline)
  alias ls='eza --git'
  alias ll='eza -l --git'
  alias la='eza -la --git'
  alias tree='eza --tree'
}
(( $+commands[bat] ))   && alias cat='bat --paging=never'
(( $+commands[fd] ))    && alias find='fd'
(( $+commands[dust] ))  && alias du='dust'
(( $+commands[duf] ))   && alias df='duf'
(( $+commands[procs] )) && alias ps='procs'
