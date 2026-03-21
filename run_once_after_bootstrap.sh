#!/usr/bin/env bash
set -euo pipefail

MISE_BIN="${MISE_BIN:-$HOME/.local/bin/mise}"

if ! command -v mise &>/dev/null && [ ! -x "$MISE_BIN" ]; then
  echo "mise not found, installing..."
  install_script="$(mktemp)"
  curl -fsSL https://mise.jdx.dev/install.sh -o "$install_script"
  bash "$install_script"
  rm -f "$install_script"
fi

if ! command -v mise &>/dev/null; then
  export PATH="$HOME/.local/bin:$PATH"
fi

echo "Installing mise tools..."
mise install --yes

echo "Running bootstrap task..."
mise run bootstrap
