#!/bin/bash
# install.sh — install dotclaude configuration to ~/.claude/
set -euo pipefail

DOTCLAUDE_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET_DIR="${HOME}/.claude"
BACKUP_DIR="${TARGET_DIR}/backups/dotclaude-$(date +%Y%m%d-%H%M%S)"

DIRS=(rules skills agents commands hooks)

mkdir -p "$TARGET_DIR"

# backup existing dirs
echo "backing up existing config to $BACKUP_DIR"
mkdir -p "$BACKUP_DIR"
for dir in "${DIRS[@]}"; do
  if [ -d "$TARGET_DIR/$dir" ]; then
    cp -r "$TARGET_DIR/$dir" "$BACKUP_DIR/$dir"
  fi
done

# copy config directories
for dir in "${DIRS[@]}"; do
  echo "installing $dir/"
  rm -rf "$TARGET_DIR/$dir"
  cp -r "$DOTCLAUDE_DIR/$dir" "$TARGET_DIR/$dir"
done

# make hooks executable
chmod +x "$TARGET_DIR/hooks/"*.sh

# copy settings template if no settings.json exists
if [ ! -f "$TARGET_DIR/settings.json" ]; then
  echo "creating settings.json from template"
  cp "$DOTCLAUDE_DIR/settings.example.json" "$TARGET_DIR/settings.json"
  echo "  -> edit ~/.claude/settings.json to configure MCP servers and paths"
else
  echo "settings.json already exists, skipping (see settings.example.json for reference)"
fi

echo ""
echo "installation complete."
echo ""
echo "next steps:"
echo "  1. review ~/.claude/settings.json and update paths if needed"
echo "  2. set environment variables for MCP servers (SENTRY_ACCESS_TOKEN, FIGMA_API_KEY)"
echo "  3. customize rules/git-workflow.md with your git identity"
echo "  4. remove any skills/agents/commands you don't need"
