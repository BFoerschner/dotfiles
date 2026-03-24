# Aliases
alias gig='gi $(gi list &>/dev/null | tr "," "\n" | fzf)'
alias mkdir='mkdir -p'
alias cp='cp -i'
alias mv='mv -i'
alias ...='cd ../..'
alias path='echo $PATH | tr ":" "\n"'

# Enhanced aliases — use $+commands[] (zsh hash lookup, no fork)
(( $+commands[lazydocker] )) && {
  alias ldo="lazydocker"
}

(( $+commands[rg] )) && {
  alias rg="rg --hidden --glob '!.git'"
}

(( $+commands[tmux] )) && {
  alias t="tmux new-session -A -s main"
}

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
