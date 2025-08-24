# Environment Variables
$env.XDG_CONFIG_HOME = ($env.HOME | path join ".config")
$env.XDG_CACHE_HOME = ($env.HOME | path join ".cache")
$env.XDG_DATA_HOME = ($env.HOME | path join ".local" "share")

# Paths
$env.GOPATH = ($env.HOME | path join ".local" "gopkg")
$env.JAVA_HOME = (bash -c "echo $(dirname $(dirname $(readlink -f $(which javac))))")
$env.EDITOR = "nvim"
$env.MANPAGER = "nvim +Man!"
$env.TERM = "xterm-256color"
$env.CARAPACE_MATCH = 1 # Disables case-sensitive matching
$env.LANG = "en_US.UTF-8"
$env.LANGUAGE = "en_US:en"
$env.LC_ALL = "en_US.UTF-8"
$env.TMUX_GIT_PROJECTS_DIRS = [
  ($env.HOME)/.local/share
  ($env.HOME)/host
] | str join ":"
$env.TMUX_AUTO_POPULATE_SESSIONS = 1
$env.PATH = (
    $env.PATH | split row (char esep) | 
    prepend [
        "/usr/bin"
        "/usr/local/bin"
        ($env.JAVA_HOME | path join "bin")
        ($env.HOME | path join ".local" "share" "fnm")
        ($env.HOME | path join ".local" "share" "go" "bin")
        ($env.GOPATH | path join "bin")
        ($env.HOME | path join ".local" "share" "lua" "bin")
        ($env.HOME | path join ".cargo" "bin")
        ($env.HOME | path join ".local" "bin")
    ] | uniq
)
if not (which fnm | is-empty) {
    ^fnm env --json | from json | load-env
    $env.PATH = $env.PATH | prepend ($env.FNM_MULTISHELL_PATH | path join (if $nu.os-info.name == 'windows' {''} else {'bin'}))
    $env.config.hooks.env_change.PWD = (
        $env.config.hooks.env_change.PWD? | append {
            condition: {|| ['.nvmrc' '.node-version', 'package.json'] | any {|el| $el | path exists}}
            code: {|| ^fnm use --install-if-missing}
        }
    )
}
$env.config = {
  show_banner: false
  shell_integration: {
    osc2: false
    osc7: false
    osc8: false
    osc9_9: false
    osc133: false
    osc633: false
    reset_application_mode: false
  }
  hooks: {
    pre_prompt: [{ ||
      if (which direnv | is-empty) {
        return
      }

      let result = (^direnv export json | complete)
      if $result.exit_code == 0 {
        $result.stdout | from json | default {} | load-env
        if 'ENV_CONVERSIONS' in $env and 'PATH' in $env.ENV_CONVERSIONS {
          $env.PATH = do $env.ENV_CONVERSIONS.PATH.from_string $env.PATH
        }
      }
    }]
  }
}

# Completions
let fish_completer = {|spans|
    fish --command $"complete '--do-complete=($spans | str replace --all "'" "\\'" | str join ' ')'"
    | from tsv --flexible --noheaders --no-infer
    | rename value description
    | update value {|row|
      let value = $row.value
      let need_quote = ['\' ',' '[' ']' '(' ')' ' ' '\t' "'" '"' "`"] | any {$in in $value}
      if ($need_quote and ($value | path exists)) {
        let expanded_path = if ($value starts-with ~) {$value | path expand --no-symlink} else {$value}
        $'"($expanded_path | str replace --all "\"" "\\\"")"'
      } else {$value}
    }
}

$env.config = {
    history: {
        max_size: 20000
        sync_on_enter: true
        file_format: "sqlite"
        isolation: false
    }
    show_banner: false
    # footer_mode: 25
    float_precision: 2
    use_ansi_coloring: true
    edit_mode: vi
    shell_integration: { osc2: true, osc7: true, osc8: true, osc9_9: false, osc133: true, osc633: true, reset_application_mode: true }
    buffer_editor: "nvim",
    completions: {
      external: {
        enable: true
        max_results: 100
        # completer: $external_completer
        completer: $fish_completer
      }
    }
    keybindings: [
        {
            name: fzf_file_search
            modifier: control
            keycode: char_t
            mode: [emacs vi_normal vi_insert]
            event: {
                send: executehostcommand
                cmd: "commandline edit --insert (
                        fd --hidden --type f --color=never 
                        | fzf 
                            --preview='bat --style=numbers --color=always {}' 
                            --bind='ctrl-/:change-preview-window(down|hidden|)' 
                        | str trim
                )"
            }
        }
        {
            name: fzf_directory_search
            modifier: alt
            keycode: char_c
            mode: [emacs vi_normal vi_insert]
            event: {
                send: executehostcommand
                cmd: "cd (
                        fd --hidden --type d --color=never 
                        | fzf --preview='tree -C {}' --bind='ctrl-/:change-preview-window(down|hidden|)' 
                        | str trim
                )"
            }
        }
        {
            name: fzf_history_search
            modifier: control
            keycode: char_r
            mode: [emacs vi_normal vi_insert]
            event: {
                send: executehostcommand
                cmd: "commandline edit --replace (
                        history | get command | reverse | uniq | to text
                        | fzf --height=40% --layout=reverse --border --prompt='History > ' --query=(commandline)
                        | str trim
                )"
            }
        }
    ]
}

# Aliases
alias .. = cd ..
alias ll = ls -la
alias rg = rg --hidden --glob '!.git'
alias t = tmux new-session -A -s main
alias lg = lazygit  
alias ldo = lazydocker
alias find = fd

source ~/.config/nushell/zoxide.nu
alias cd = __zoxide_z
alias cdi = __zoxide_zi
alias cda = zoxide add
alias cdr = zoxide remove

# preserve PATH with sudo
def --env sudo [...args] {
  ^sudo env $"PATH=($env.PATH | str join ':')" ...$args
}

$env.STARSHIP_SHELL = "nu"
$env.PROMPT_INDICATOR_VI_INSERT = ""
$env.PROMPT_INDICATOR_VI_NORMAL = "{} "
$env.PROMPT_MULTILINE_INDICATOR = " "
$env.TRANSIENT_PROMPT_COMMAND = {|| 
    let exit_code = if ($env.LAST_EXIT_CODE? | default 0) == 0 { 
        $"(ansi green_bold)❯(ansi reset)" 
    } else { 
        $"(ansi red_bold)❯(ansi reset)" 
    }
    $"($exit_code) "
}
# $env.TRANSIENT_PROMPT_COMMAND_RIGHT = ^starship module custom.git_dirty
$env.TRANSIENT_PROMPT_COMMAND_RIGHT = ""
$env.TRANSIENT_PROMPT_INDICATOR = ""
$env.TRANSIENT_PROMPT_INDICATOR_VI_NORMAL = ""
$env.TRANSIENT_PROMPT_INDICATOR_VI_INSERT = ""
$env.TRANSIENT_PROMPT_MULTILINE_INDICATOR = ""

# Starship
mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")
