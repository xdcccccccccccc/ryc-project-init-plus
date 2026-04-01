#!/usr/bin/env bash
set -euo pipefail

TARGET_LINK="$HOME/.agents/skills/ryc-project-init-plus"

rm -rf "$TARGET_LINK"

echo "Codex uninstall complete:"
echo "  removed $TARGET_LINK"
