# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Environment Variables
export XDG_CONFIG_HOME="$HOME/.config"
export PATH=/usr/bin:$PATH
export PATH=/usr/local/bin:$PATH
export PATH=$HOME/.local/share/fnm:$PATH
export PATH=$HOME/.local/share/go/bin:$PATH
export PATH=$GOPATH/bin:$PATH
export PATH=$HOME/.local/share/lua/bin:$PATH
export PATH=$HOME/.cargo/bin:$PATH
export PATH=$HOME/.local/bin:$PATH

eval "$(fnm env)"
eval "$(starship init bash)"
