Review a Python codebase or PR against enterprise standards. Follow the enterprise-python-review skill at ~/.claude/skills/enterprise-python-review.md.

Arguments: $ARGUMENTS (file path, directory, or "diff" for current git diff)

1. Load skill: ~/.claude/skills/enterprise-python-review.md
2. If "diff" or no argument: review the current git diff against main
3. If path provided: review the specified file(s) or directory
4. Run all 10 review sections from the skill: error handling, type safety, async patterns, security, DI/architecture, logging, testing, config, performance, python best practices
5. Output: structured report with PASS/FAIL per section, file:line references, and concrete fixes