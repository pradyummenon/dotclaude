#!/bin/bash
# pre-block-md-spam: warn before creating unnecessary .md files
# allows: README.md, CLAUDE.md, CHANGELOG.md, docs/, .claude/

FILE_PATH="${1:-}"

if [ -z "$FILE_PATH" ]; then
  exit 0
fi

BASENAME=$(basename "$FILE_PATH")
DIRNAME=$(dirname "$FILE_PATH")

# always allow these
case "$BASENAME" in
  README.md|CLAUDE.md|CHANGELOG.md|LICENSE.md|CONTRIBUTING.md|MEMORY.md)
    exit 0
    ;;
esac

# allow docs/ and .claude/ directories
case "$DIRNAME" in
  *docs*|*.claude*)
    exit 0
    ;;
esac

# warn for everything else
echo "[Hook] NOTE: Creating markdown file outside docs/ or .claude/: $FILE_PATH" >&2
echo "[Hook] Ensure this file is actually needed." >&2
