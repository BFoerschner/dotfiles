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

# Phase 1: load completion definitions + fzf-tab (must be before compinit)
zinit wait"0a" lucid for \
  blockf \
    zsh-users/zsh-completions \
  Aloxaf/fzf-tab

# Phase 2: init compinit once, then syntax highlighting + autosuggestions
zinit wait"0b" lucid for \
  atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting \
  atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions

# Phase 3: OMZ snippets (after completion system is ready)
zinit wait"0c" lucid for \
  OMZL::git.zsh \
  OMZP::git \
  OMZP::git-commit \
  OMZP::gitignore \
  OMZP::sudo \
  OMZP::brew \
  OMZP::extract \
  OMZP::command-not-found \
  OMZP::ansible

# Phase 3b: OMZ plugins with completion files (load plugin + completion separately)
zinit wait"0c" lucid for \
  OMZP::terraform \
  OMZP::docker-compose \
  OMZP::mvn
zinit wait"0c" lucid as"completion" for \
  OMZP::terraform/_terraform \
  OMZP::docker-compose/_docker-compose

# Load archlinux plugin only on Linux
[[ "$OSTYPE" == linux* ]] && zinit wait"0c" lucid for OMZP::archlinux
