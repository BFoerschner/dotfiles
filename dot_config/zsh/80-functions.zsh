select_gist() {
    local selected_line
    selected_line=$(gh gist list --limit 100 | \
        tail -n +2 | \
        fzf --preview 'gh gist view $(echo {} | awk "{print \$1}") | bat --style=numbers --color=always' \
            --preview-window=right:60% \
            --header='Select a gist' \
            --with-nth='2' \
            --bind 'enter:accept')

    if [[ -n "$selected_line" ]]; then
        local content
        content=$(gh gist view "$(echo "$selected_line" | awk '{print $1}')")

        # If output is to terminal, add syntax highlighting
        if [[ -t 1 ]]; then
            echo "$content" | bat --style=numbers --color=always
        else
            echo "$content"
        fi
    fi
}
