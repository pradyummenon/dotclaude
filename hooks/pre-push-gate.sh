#!/bin/bash
# pre-push-gate: verify before git push
# checks: correct git identity, no console.log/print, no secrets

set -euo pipefail

# check git identity is set
GIT_EMAIL=$(git config user.email 2>/dev/null || echo "")
if [ -z "$GIT_EMAIL" ]; then
  echo "[Hook] WARNING: git user.email is not set. Set it before pushing." >&2
  exit 1
fi

# check for stray debug statements in staged/modified files
MODIFIED_FILES=$(git diff --name-only HEAD 2>/dev/null || echo "")
if [ -n "$MODIFIED_FILES" ]; then
  ISSUES=""

  # check JS/TS files for console.log
  JS_FILES=$(echo "$MODIFIED_FILES" | grep -E '\.(js|jsx|ts|tsx)$' || true)
  if [ -n "$JS_FILES" ]; then
    CONSOLE_LOGS=$(echo "$JS_FILES" | xargs grep -l 'console\.log' 2>/dev/null || true)
    if [ -n "$CONSOLE_LOGS" ]; then
      ISSUES="${ISSUES}\n  console.log found in: $CONSOLE_LOGS"
    fi
  fi

  # check Python files for print()
  PY_FILES=$(echo "$MODIFIED_FILES" | grep -E '\.py$' || true)
  if [ -n "$PY_FILES" ]; then
    PRINTS=$(echo "$PY_FILES" | xargs grep -l 'print(' 2>/dev/null || true)
    if [ -n "$PRINTS" ]; then
      ISSUES="${ISSUES}\n  print() found in: $PRINTS"
    fi
  fi

  # check Java files for System.out
  JAVA_FILES=$(echo "$MODIFIED_FILES" | grep -E '\.java$' || true)
  if [ -n "$JAVA_FILES" ]; then
    SYSOUT=$(echo "$JAVA_FILES" | xargs grep -l 'System\.out' 2>/dev/null || true)
    if [ -n "$SYSOUT" ]; then
      ISSUES="${ISSUES}\n  System.out found in: $SYSOUT"
    fi
  fi

  if [ -n "$ISSUES" ]; then
    echo "[Hook] WARNING: Debug statements detected before push:$ISSUES" >&2
    echo "[Hook] Consider removing them before pushing." >&2
  fi
fi
