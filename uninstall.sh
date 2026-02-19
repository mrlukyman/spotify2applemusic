#!/usr/bin/env bash
set -euo pipefail

RUNNER_APP_PATH="${RUNNER_APP_PATH:-$HOME/Applications/SpotifyShortcutRunner.app}"
FINICKY_CONFIG_PATH="${FINICKY_CONFIG_PATH:-$HOME/.finicky.js}"

if [[ -d "$RUNNER_APP_PATH" ]]; then
  rm -rf "$RUNNER_APP_PATH"
  echo "Removed: $RUNNER_APP_PATH"
else
  echo "Runner app not found: $RUNNER_APP_PATH"
fi

if [[ -f "$FINICKY_CONFIG_PATH" ]] && rg -q "spotify2applemusic generated config" "$FINICKY_CONFIG_PATH"; then
  rm -f "$FINICKY_CONFIG_PATH"
  echo "Removed generated Finicky config: $FINICKY_CONFIG_PATH"
else
  echo "Left Finicky config untouched: $FINICKY_CONFIG_PATH"
fi

echo "Uninstall complete."
