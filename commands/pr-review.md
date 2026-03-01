Review the current PR using the pr-review agent at ~/.claude/agents/pr-review.md. Diff all changes against the target branch (default: main).

1. Run `git diff main...HEAD` to get the full diff
2. Read the PR description if available
3. Detect language(s) and load relevant skills:
   - Java: ~/.claude/skills/java-unit-test.md, ~/.claude/skills/java-integration-test.md
   - Python: ~/.claude/skills/enterprise-python-review.md, ~/.claude/skills/python-unit-test.md
   - TypeScript: ~/.claude/skills/typescript-strict.md, ~/.claude/skills/react-patterns.md
4. Follow the exact review structure: implementation context, breaking changes, code quality & practices, architecture review, what's done well, summary
5. Use severity levels: CRITICAL, HIGH, MEDIUM, LOW, INFO
6. Reference ~/.claude/rules/security.md and ~/.claude/rules/performance.md for cross-cutting checks