# Aliases
alias gig='gi $(gi list &>/dev/null | tr "," "\n" | fzf)'
alias ..='cd ..'
alias rg="rg --hidden --glob '!.git'"
alias t="tmux new-session -A -s main"
alias lg="lazygit"
alias ldo="lazydocker"

# Enhanced aliases — use $+commands[] (zsh hash lookup, no fork)
(( $+commands[eza] )) && {
  alias ls='eza --icons --git'
  alias ll='eza -l --icons --git'
  alias la='eza -la --icons --git'
  alias tree='eza --tree --icons'
}
(( $+commands[bat] ))   && alias cat='bat --paging=never'
(( $+commands[fd] ))    && alias find='fd'
(( $+commands[dust] ))  && alias du='dust'
(( $+commands[duf] ))   && alias df='duf'
(( $+commands[procs] )) && alias ps='procs'
