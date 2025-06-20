# Skip setup for non-interactive shells *unless explicitly forced*
if [[ -z "$PS1" && -z "${ZSHRC_FORCE_LOAD:-}" ]]; then
  return
fi

# Environment Variables
export GOPATH="$HOME/.local/gopkg"
export PATH="/usr/bin/:$PATH"
export PATH="/usr/local/bin/:$PATH"
export PATH="$HOME/.local/share/fnm:$PATH"
export PATH="$HOME/.local/share/go/bin:$PATH"
export PATH="$GOPATH/bin:$PATH"
export PATH="$HOME/.local/share/lua/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export TERM=xterm-256color
export EDITOR=nvim
export MANPAGER='nvim +Man!'
export HISTSIZE=5000
export HISTFILE=~/.zsh_history
export SAVEHIST=$HISTSIZE
export HISTDUP=erase
eval "$(fnm env)"

# History Options
setopt \
	appendhistory \
	sharehistory \
	hist_ignore_space \
	hist_ignore_all_dups \
	hist_save_no_dups \
	hist_ignore_dups \
	hist_find_no_dups

# Homebrew
if [[ "$TERM_PROGRAM" != "Apple_Terminal" && -x "$(command -v brew)" ]]; then
  HOMEBREW_PREFIX=$(brew --prefix)
  for d in "${HOMEBREW_PREFIX}"/opt/*/libexec/gnubin; do
    export PATH="$d:$PATH"
  done
fi

# Zinit
ZINIT_HOME="$HOME/.local/share/zinit/zinit.git"
if [[ ! -d "$ZINIT_HOME" ]]; then
  mkdir -p "$(dirname "$ZINIT_HOME")"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "$ZINIT_HOME/zinit.zsh"

# Zinit Plugins
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit light birdhackor/zsh-eza-ls-plugin

# OMZ plugin snippets
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::git-commit
zinit snippet OMZP::gitignore
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
zinit snippet OMZP::brew
zinit snippet OMZP::extract
zinit snippet OMZP::command-not-found
zinit snippet OMZP::ansible

# Completion Initialization
autoload -Uz compinit
zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
if [[ ! -s "$zcompdump" || "$zcompdump" -ot "$ZDOTDIR/.zshrc" ]]; then
  compinit -i
else
  compinit -C
fi

# Completion Styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes

# FZF Configuration
export FZF_DEFAULT_OPTS='--color=bg+:#293739,bg:#1B1D1E,border:#808080,spinner:#E6DB74,hl:#7E8E91,fg:#F8F8F2,header:#7E8E91,info:#A6E22E,pointer:#A6E22E,marker:#F92672,fg+:#F8F8F2,prompt:#F92672,hl+:#F92672'
export FZF_DEFAULT_COMMAND="fd --hidden --type f --color=never"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --hidden --type d --color=never"
export FZF_CTRL_T_OPTS="
  --walker-skip .git,node_modules,target
  --preview='bat -n --color=always {}'
  --tmux=80%
  --bind='ctrl-/:change-preview-window(down|hidden|)'"
export FZF_ALT_C_OPTS="
  --walker-skip .git,node_modules,target
  --tmux=80%
  --preview='tree -C {}'"

# Aliases
alias gig='gi $(gi list &>/dev/null | tr "," "\n" | fzf)'
alias ..='cd ..'
alias rg="rg --hidden --glob '!.git'"
alias t="tmux new-session -A -s main"

# Prompt & fzf
eval "$(oh-my-posh init zsh --config "$HOME/.config/ohmyposh/zen.toml")"
eval "$(fzf --zsh)"

# Ensure everything from zinit is truly loaded
zinit cdreplay -q
eval "$(direnv hook zsh)"
