# Claude Code token (decrypted by unlock-secrets)
_secrets_token_file="/dev/shm/.secrets-${UID}/.claude-token"
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
    if [[ -n "${SSH_CONNECTION:-}" && -d "$_SECRETS_RAMDIR" ]]; then
        echo "$_MY_PID" >> "$_SECRETS_RAMDIR/.sessions"
    fi
}
lock-secrets() {
    command lock-secrets "$@"
    unset CLAUDE_CODE_OAUTH_TOKEN
}

# Auto-unlock/lock secrets for SSH sessions
if [[ -n "${SSH_CONNECTION:-}" ]]; then
    _SECRETS_RAMDIR="/dev/shm/.secrets-${UID}"
    _MY_PID=$$
    # Auto-unlock if not already unlocked
    if [[ ! -d "$_SECRETS_RAMDIR" ]]; then
        unlock-secrets 2>/dev/null || true
    fi
    if [[ -d "$_SECRETS_RAMDIR" ]]; then
        echo "$_MY_PID" >> "$_SECRETS_RAMDIR/.sessions"
    fi
    trap '
        if [[ -f "$_SECRETS_RAMDIR/.sessions" ]]; then
            sed -i "/^${_MY_PID}$/d" "$_SECRETS_RAMDIR/.sessions" 2>/dev/null
            if [[ ! -s "$_SECRETS_RAMDIR/.sessions" ]]; then
                lock-secrets 2>/dev/null
            fi
        fi
        unset CLAUDE_CODE_OAUTH_TOKEN
    ' EXIT
fi
