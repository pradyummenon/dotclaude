#!/bin/bash
# post-edit-format: auto-format files after edit/write
# usage: post-edit-format.sh <file_path> <lang>
# lang: js (prettier) or py (black/ruff)

FILE_PATH="${1:-}"
LANG="${2:-}"

if [ -z "$FILE_PATH" ] || [ ! -f "$FILE_PATH" ]; then
  exit 0
fi

case "$LANG" in
  js)
    # format with prettier if available
    if command -v npx &>/dev/null && [ -f "$(dirname "$FILE_PATH")/node_modules/.bin/prettier" ] 2>/dev/null; then
      npx prettier --write "$FILE_PATH" 2>/dev/null || true
    elif command -v prettier &>/dev/null; then
      prettier --write "$FILE_PATH" 2>/dev/null || true
    fi
    ;;
  py)
    # format with ruff if available, fallback to black
    if command -v ruff &>/dev/null; then
      ruff format "$FILE_PATH" 2>/dev/null || true
    elif command -v black &>/dev/null; then
      black "$FILE_PATH" 2>/dev/null || true
    fi
    ;;
esac
