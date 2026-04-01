#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="${1:-$(cd "$SCRIPT_DIR/.." && pwd)}"
TARGET_DIR="$HOME/.agents/skills"
TARGET_LINK="$TARGET_DIR/ryc-project-init-plus"

mkdir -p "$TARGET_DIR"
rm -rf "$TARGET_LINK"
ln -s "$REPO_ROOT/skills" "$TARGET_LINK"

echo "Codex install complete:"
echo "  $TARGET_LINK -> $REPO_ROOT/skills"
