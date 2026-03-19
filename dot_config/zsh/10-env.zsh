# Environment Variables
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"

# Paths
export GOPATH="$HOME/.local/gopkg"
export EDITOR=nvim
export MANPAGER='nvim +Man!'
export TERM=xterm-256color
export HISTSIZE=5000
export HISTFILE=~/.zsh_history
export SAVEHIST=$HISTSIZE
export HISTDUP=erase

# History Options
setopt \
	appendhistory \
	sharehistory \
	hist_ignore_space \
	hist_ignore_all_dups \
	hist_save_no_dups \
	hist_ignore_dups \
	hist_find_no_dups
