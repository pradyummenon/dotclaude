# code hygiene rules

## forbidden in committed code
- `console.log()` — use a proper logger (winston, pino, log4j, python logging)
- `System.out.println()` — use SLF4J/Logback
- `print()` in Python — use logging module
- `debugger` statements
- `TODO` comments without a Jira ticket reference
- commented-out code blocks (delete, don't comment)

## no emojis
- no emojis in source code, comments, variable names, or string literals
- exception: user-facing copy where product spec requires it

## file hygiene
- no orphan files (unused imports, dead modules)
- remove generated files from version control (.class, __pycache__, node_modules)
- keep .gitignore comprehensive and up-to-date
