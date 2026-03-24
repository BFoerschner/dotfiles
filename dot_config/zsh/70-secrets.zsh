# Source platform helper for SECRETS_RAMDIR (silently skip if not installed)
source secrets-platform 2>/dev/null || return

# Claude Code token (decrypted by unlock-secrets)
_secrets_token_file="$SECRETS_RAMDIR/.claude-token"
if [[ -r "$_secrets_token_file" ]]; then
    export CLAUDE_CODE_OAUTH_TOKEN
    CLAUDE_CODE_OAUTH_TOKEN="$(<"$_secrets_token_file")"
fi

# Shell wrappers so unlock/lock affect the current shell
unlock-secrets() {
    command unlock-secrets "$@" || return $?
    if [[ -r "$_secrets_token_file" ]]; then
        export CLAUDE_CODE_OAUTH_TOKEN
        CLAUDE_CODE_OAUTH_TOKEN="$(<"$_secrets_token_file")"
    fi
    # Register this session now that RAMDIR exists
    if [[ -n "${SSH_CONNECTION:-}" && -d "$SECRETS_RAMDIR" ]]; then
        echo "$_MY_PID" >> "$SECRETS_RAMDIR/.sessions"
    fi
}
lock-secrets() {
    command lock-secrets "$@"
    unset CLAUDE_CODE_OAUTH_TOKEN
}

# Auto-unlock/lock secrets for SSH sessions
if [[ -n "${SSH_CONNECTION:-}" ]]; then
    _MY_PID=$$
    # Auto-unlock if not already unlocked
    if [[ ! -d "$SECRETS_RAMDIR" ]]; then
        unlock-secrets 2>/dev/null || true
    fi
    if [[ -d "$SECRETS_RAMDIR" ]]; then
        echo "$_MY_PID" >> "$SECRETS_RAMDIR/.sessions"
    fi
    trap '
        if [[ -f "$SECRETS_RAMDIR/.sessions" ]]; then
            grep -v "^${_MY_PID}$" "$SECRETS_RAMDIR/.sessions" > "$SECRETS_RAMDIR/.sessions.tmp" 2>/dev/null && mv "$SECRETS_RAMDIR/.sessions.tmp" "$SECRETS_RAMDIR/.sessions" || true
            if [[ ! -s "$SECRETS_RAMDIR/.sessions" ]]; then
                lock-secrets 2>/dev/null
            fi
        fi
        unset CLAUDE_CODE_OAUTH_TOKEN
    ' EXIT
fi
