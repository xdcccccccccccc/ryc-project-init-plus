#!/usr/bin/env bash
set -euo pipefail

TARGET_DIR="$HOME/.claude/skills"

for dir in \
  hyper-cast-off \
  ryc-project-workflow-router \
  ryc-project-init \
  ryc-project-developer \
  ryc-project-reviewer \
  ryc-project-planner \
  shared
do
  rm -rf "$TARGET_DIR/$dir"
done

echo "Claude Code uninstall complete:"
echo "  removed ryc-project-init-plus links from $TARGET_DIR"
