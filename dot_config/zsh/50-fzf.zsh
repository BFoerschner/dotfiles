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

# Load FZF key bindings (cached)
if (( $+commands[fzf] )); then
  _cached_eval fzf fzf --zsh
fi
