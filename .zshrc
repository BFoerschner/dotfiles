# don't load zshrc if non interactive shell
if [ -z "$PS1" ]; then
  return
fi

if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
  # give me homebrew installed gnu unix tools in path
  if type brew &>/dev/null; then
    HOMEBREW_PREFIX=$(brew --prefix)
    for d in "${HOMEBREW_PREFIX}"/opt/*/libexec/gnubin; do export PATH=$d:$PATH; done 
  fi
  export PATH="$HOME/go/bin:$PATH"
  export PATH="$HOME/.cargo/bin:$PATH"
  export PATH="$HOME/.local/bin:$PATH"
  export EDITOR=nvim
  export MANPAGER='nvim +Man!'

  # Set the directory we want to store zinit and plugins
  ZINIT_HOME="$HOME"/.local/share/zinit/zinit.git

  # Download Zinit, if it's not there yet
  if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname "$ZINIT_HOME")"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
  fi

  # Source/Load zinit
  source "${ZINIT_HOME}/zinit.zsh"

  zinit light zsh-users/zsh-completions
  zinit light zsh-users/zsh-syntax-highlighting
  zinit light zsh-users/zsh-autosuggestions
  zinit light Aloxaf/fzf-tab
  zinit light birdhackor/zsh-eza-ls-plugin
  autoload -Uz compinit && compinit

  # --- Initialize Zsh Completion System ---
  autoload -Uz compinit
  compinit

  # --- Core OMZ Lib and Handy Plugins (still useful) ---
  zinit snippet OMZL::git.zsh

  # Git aliases & helpers
  zinit snippet OMZP::git
  zinit snippet OMZP::git-commit
  zinit snippet OMZP::gitignore

  # Quality-of-life helpers
  zinit snippet OMZP::sudo
  zinit snippet OMZP::archlinux
  zinit snippet OMZP::brew
  zinit snippet OMZP::extract
  zinit snippet OMZP::command-not-found
  zinit snippet OMZP::ansible

  # Docker (includes docker compose, services, etc.)
  if command -v docker &>/dev/null; then
    source <(docker completion zsh)
  fi

  # AWS CLI completions
  if command -v aws_completer &>/dev/null; then
    complete -C "$(command -v aws_completer)" aws
  fi

  # kubectl completions
  if command -v kubectl &>/dev/null; then
    source <(kubectl completion zsh)
  fi

  # kubectx completions
  if command -v kubectx &>/dev/null; then
    source <(kubectx completion zsh)
  fi

  # kubens completions
  if command -v kubens &>/dev/null; then
    source <(kubens completion zsh)
  fi

  # --- Terraform Completion ---
  if command -v terraform &>/dev/null; then
    autoload -U +X bashcompinit && bashcompinit
    complete -o nospace -C "$(which terraform)" terraform
  fi

  # reload snippets every new shell
  zinit cdreplay -q

  # This enables Zsh to understand commands like docker run -it ubuntu. However, by enabling this, this also makes 
  # Zsh complete docker run -u<tab> with docker run -uapprox which is not valid. The users have to put the space or 
  # the equal sign themselves before trying to complete.
  zstyle ':completion:*:*:docker:*' option-stacking yes
  zstyle ':completion:*:*:docker-*:*' option-stacking yes

  # Completion styling
  zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
  zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
  zstyle ':completion:*' menu no
  zstyle ':fzf-tab:complete:cd:*' fzf-preview "ls --color $realpath"

  # History
  export HISTSIZE=5000
  export HISTFILE=~/.zsh_history
  export SAVEHIST=$HISTSIZE
  export HISTDUP=erase
  setopt appendhistory
  setopt sharehistory
  setopt hist_ignore_space
  setopt hist_ignore_all_dups
  setopt hist_save_no_dups 
  setopt hist_ignore_dups
  setopt hist_find_no_dups

  alias gig='gi $(gi list &>/dev/null | tr "," "\n" | fzf)'
  alias ..='cd ..'
  alias rg="rg --hidden --glob '!.git'"

  export FZF_DEFAULT_COMMAND='fd --type f --color=never'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND="fd --type d --color=never"
  export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --color=bg+:#293739,bg:#1B1D1E,border:#808080,spinner:#E6DB74,hl:#7E8E91,fg:#F8F8F2,header:#7E8E91,info:#A6E22E,pointer:#A6E22E,marker:#F92672,fg+:#F8F8F2,prompt:#F92672,hl+:#F92672"
  export FZF_CTRL_T_OPTS="
    --walker-skip .git,node_modules,target
    --preview 'bat -n --color=always {}'
    --tmux 80%
    --bind 'ctrl-/:change-preview-window(down|hidden|)'"
  export FZF_ALT_C_OPTS="
    --walker-skip .git,node_modules,target
    --tmux 80%
    --preview 'tree -C {}'"

  # Shell integrations
  eval "$(oh-my-posh init zsh --config "$HOME"/.config/ohmyposh/zen.toml)"
  eval "$(fzf --zsh)"
fi
