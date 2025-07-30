# Environment Variables
$env.GOPATH = ($env.HOME | path join ".local" "gopkg")
$env.EDITOR = "nvim"
$env.MANPAGER = "nvim +Man!"
$env.TERM = "xterm-256color"
$env.PATH = (
    $env.PATH | split row (char esep) | 
    prepend [
        "/usr/bin"
        "/usr/local/bin"
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
  hooks: {
    pre_prompt: [{ ||
      if (which direnv | is-empty) {
        return
      }

      direnv export json | from json | default {} | load-env
      if 'ENV_CONVERSIONS' in $env and 'PATH' in $env.ENV_CONVERSIONS {
        $env.PATH = do $env.ENV_CONVERSIONS.PATH.from_string $env.PATH
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

let carapace_completer = {|spans: list<string>|
    carapace $spans.0 nushell ...$spans
    | from json
    | if ($in | default [] | where value =~ '^-.*ERR$' | is-empty) { $in } else { null }
}

# This completer will use carapace by default
let external_completer = {|spans|
    let expanded_alias = scope aliases
    | where name == $spans.0
    | get -o 0.expansion

    let spans = if $expanded_alias != null {
        $spans
        | skip 1
        | prepend ($expanded_alias | split row ' ' | take 1)
    } else {
        $spans
    }

    match $spans.0 {
        # carapace completions are incorrect for nu
        nu => $fish_completer
        # fish completes commits and branch names in a nicer way
        git => $fish_completer
        # carapace doesn't have completions for asdf
        asdf => $fish_completer
        _ => $carapace_completer
    } | do $in $spans
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
    edit_mode: emacs
    shell_integration: { osc2: true, osc7: true, osc8: true, osc9_9: false, osc133: true, osc633: true, reset_application_mode: true }
    buffer_editor: "nvim",
    completions: {
      external: {
        enable: true
        max_results: 100
        completer: $external_completer
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
alias rg = rg --hidden --glob '!.git'
alias t = tmux new-session -A -s main
alias lg = lazygit  
alias ldo = lazydocker
alias find = fd

# Starship
mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")
