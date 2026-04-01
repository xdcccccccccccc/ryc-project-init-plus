#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="${1:-$(cd "$SCRIPT_DIR/.." && pwd)}"
TARGET_DIR="$HOME/.claude/skills"

mkdir -p "$TARGET_DIR"

for dir in \
  ryc-project-workflow-router \
  ryc-project-init \
  ryc-project-developer \
  ryc-project-reviewer \
  ryc-project-planner \
  shared
do
  rm -rf "$TARGET_DIR/$dir"
  ln -s "$REPO_ROOT/skills/$dir" "$TARGET_DIR/$dir"
done

echo "Claude Code install complete:"
echo "  skills linked into $TARGET_DIR"
echo "Restart Claude Code, then try /ryc-project-init or /ryc-project-workflow-router"
