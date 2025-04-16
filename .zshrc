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
  ZINIT_HOME="${HOME}/.local/share/zinit/zinit.git"

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

  # Terraform autocomplete
    autoload -U +X bashcompinit && bashcompinit
    complete -o nospace -C "$(which terraform)" terraform

  zinit snippet OMZL::git.zsh
  zinit snippet OMZP::git
  zinit snippet OMZP::sudo
  zinit snippet OMZP::archlinux
  zinit snippet OMZP::aws
  zinit snippet OMZP::kubectl
  zinit snippet OMZP::kubectx
  zinit snippet OMZP::command-not-found
  zinit snippet OMZP::ansible
  zinit snippet OMZP::brew
  zinit snippet OMZP::docker/completions/_docker
  zinit snippet OMZP::docker-compose
  zinit snippet OMZP::extract
  zinit snippet OMZP::gitignore
  zinit snippet OMZP::git-commit


  # reload snippets every new shell
  zinit cdreplay -q

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

