# Skip setup for non-interactive shells *unless explicitly forced
if [[ -z "$PS1" && -z "${ZSHRC_FORCE_LOAD:-}" ]]; then
  return
fi

# Environment Variables
export GOPATH="$HOME/.local/gopkg"
export EDITOR=nvim
export MANPAGER='nvim +Man!'
export TERM=xterm-256color
export HISTSIZE=5000
export HISTFILE=~/.zsh_history
export SAVEHIST=$HISTSIZE
export HISTDUP=erase

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

# History Options
setopt \
	appendhistory \
	sharehistory \
	hist_ignore_space \
	hist_ignore_all_dups \
	hist_save_no_dups \
	hist_ignore_dups \
	hist_find_no_dups

# Cache Homebrew prefix and paths (only if available and not Apple Terminal)
if [[ "$TERM_PROGRAM" != "Apple_Terminal" && -x "$(command -v brew)" ]]; then
  if [[ -z "$HOMEBREW_PREFIX" ]]; then
    export HOMEBREW_PREFIX=$(brew --prefix)
  fi
  # Only add existing GNU bin directories
  for d in "${HOMEBREW_PREFIX}"/opt/{coreutils,findutils,gnu-tar,gnu-sed,gawk,gnutls,gnu-indent,gnu-getopt}/libexec/gnubin; do
    [[ -d "$d" ]] && path=("$d" "${path[@]}")
  done
fi

# Zinit (lazy initialization with better error handling)
ZINIT_HOME="$HOME/.local/share/zinit/zinit.git"
if [[ ! -d "$ZINIT_HOME" ]]; then
  print -P "%F{blue}Installing Zinit...%f"
  mkdir -p "$(dirname "$ZINIT_HOME")"
  if git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"; then
    print -P "%F{green}Zinit installed successfully%f"
  else
    print -P "%F{red}Failed to install Zinit%f"
    return 1
  fi
fi
source "$ZINIT_HOME/zinit.zsh"

# Load plugins asynchronously with wait since these take way too long to load
zinit wait lucid for \
  atload"zicompinit; zicdreplay" blockf \
    zsh-users/zsh-completions \
  atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting \
  atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions \
  Aloxaf/fzf-tab \
  birdhackor/zsh-eza-ls-plugin

# Tmux xpanes
source "$HOME"/.local/pkg/tmux-xpanes/activate.sh
source "$HOME"/.local/pkg/tmux-xpanes/completion.zsh

# OMZ plugin snippets
zinit wait lucid for \
  OMZL::git.zsh \
  OMZP::git \
  OMZP::git-commit \
  OMZP::gitignore \
  OMZP::sudo \
  OMZP::archlinux \
  OMZP::brew \
  OMZP::extract \
  OMZP::command-not-found \
  OMZP::ansible

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
  --walker-skip .git,node_modules,target,.next,dist,build
  --preview='([[ -f {} ]] && (bat --style=numbers --color=always {} || cat {})) || ([[ -d {} ]] && (tree -C {} | head -200))'
  --tmux=80%
  --bind='ctrl-/:change-preview-window(down|hidden|)'"
export FZF_ALT_C_OPTS="
  --walker-skip .git,node_modules,target,.next,dist,build
  --tmux=80%
  --preview='tree -C {}'"

# Load FZF key bindings (Ctrl+T / Alt+C)
if command -v fzf > /dev/null 2>&1; then
  eval "$(fzf --zsh)"
fi

# Aliases
alias gig='gi $(gi list &>/dev/null | tr "," "\n" | fzf)'
alias ..='cd ..'
alias rg="rg --hidden --glob '!.git'"
alias t="tmux new-session -A -s main"
alias llm="llm"
alias lg="lazygit"

# Enhanced aliases (only add if tools are available)
if command -v eza > /dev/null 2>&1; then
  alias ls='eza --icons --git'
  alias ll='eza -l --icons --git'
  alias la='eza -la --icons --git'
  alias tree='eza --tree --icons'
fi

if command -v bat > /dev/null 2>&1; then
  alias cat='bat --paging=never'
fi

if command -v fd > /dev/null 2>&1; then
  alias find='fd'
fi

if command -v dust > /dev/null 2>&1; then
  alias du='dust'
fi

if command -v duf > /dev/null 2>&1; then
  alias df='duf'
fi

if command -v procs > /dev/null 2>&1; then
  alias ps='procs'
fi

if command -v fnm > /dev/null 2>&1; then
  eval "$(fnm env)"
fi

# Cache starship init for faster startup (even though starship already fast af)
if command -v starship > /dev/null 2>&1; then
  if [[ ! -f ~/.cache/starship-init.zsh || ~/.zshrc -nt ~/.cache/starship-init.zsh ]]; then
    mkdir -p ~/.cache
    starship init zsh > ~/.cache/starship-init.zsh
  fi
  source ~/.cache/starship-init.zsh
fi

# Load direnv synchronously (needed for proper functionality)
if command -v direnv > /dev/null 2>&1; then
  eval "$(direnv hook zsh)"
fi

if command -v fnm > /dev/null 2>&1; then
  eval "$(fnm env)"
fi

# Reduce completion system overhead
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.cache/.zcompcache

