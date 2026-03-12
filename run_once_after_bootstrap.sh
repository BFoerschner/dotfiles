#!/usr/bin/env bash
set -euo pipefail

MISE_BIN="${MISE_BIN:-$HOME/.local/bin/mise}"

if ! command -v mise &>/dev/null && [ ! -x "$MISE_BIN" ]; then
  echo "mise not found, installing..."
  curl -fsSL https://mise.jdx.dev/install.sh | bash
fi

if ! command -v mise &>/dev/null; then
  export PATH="$HOME/.local/bin:$PATH"
fi

echo "Installing mise tools..."
mise install --yes

echo "Running bootstrap task..."
mise run bootstrap
