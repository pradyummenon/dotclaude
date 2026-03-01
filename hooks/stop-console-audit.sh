#!/bin/bash
# stop-console-audit: check for debug statements in recently modified files
# runs at the end of each Claude response

# get files modified in the last 10 minutes (approximation for "this session")
MODIFIED=$(find . -maxdepth 5 -name "*.ts" -o -name "*.tsx" -o -name "*.js" -o -name "*.jsx" -o -name "*.py" -o -name "*.java" 2>/dev/null | head -100)

if [ -z "$MODIFIED" ]; then
  exit 0
fi

ISSUES=""

# check for console.log in JS/TS
JS_HITS=$(echo "$MODIFIED" | grep -E '\.(js|jsx|ts|tsx)$' | xargs grep -l 'console\.log' 2>/dev/null || true)
if [ -n "$JS_HITS" ]; then
  ISSUES="${ISSUES}  console.log: $(echo "$JS_HITS" | wc -l | tr -d ' ') file(s)\n"
fi

# check for print() in Python
PY_HITS=$(echo "$MODIFIED" | grep -E '\.py$' | xargs grep -l 'print(' 2>/dev/null || true)
if [ -n "$PY_HITS" ]; then
  ISSUES="${ISSUES}  print(): $(echo "$PY_HITS" | wc -l | tr -d ' ') file(s)\n"
fi

# check for System.out in Java
JAVA_HITS=$(echo "$MODIFIED" | grep -E '\.java$' | xargs grep -l 'System\.out' 2>/dev/null || true)
if [ -n "$JAVA_HITS" ]; then
  ISSUES="${ISSUES}  System.out: $(echo "$JAVA_HITS" | wc -l | tr -d ' ') file(s)\n"
fi

if [ -n "$ISSUES" ]; then
  echo "[Hook] Debug statements found in workspace:" >&2
  echo -e "$ISSUES" >&2
fi
