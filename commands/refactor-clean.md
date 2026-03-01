Analyze the current codebase for dead code, unused dependencies, and orphan files. Follow the refactor-clean skill at ~/.claude/skills/refactor-clean.md.

1. Detect project language(s) from file extensions and config files (pom.xml, pyproject.toml, package.json)
2. Run Phase 1 (Analysis) — dead code detection, dependency audit, file audit
3. Present a Cleanup Report with categorized findings and confidence levels (HIGH/MEDIUM/LOW)
4. Ask for confirmation before Phase 2 (Execution)
5. Execute removals in batched commits, run tests between batches
6. Create PR with summary of what was removed and why

Use the refactor-agent at ~/.claude/agents/refactor-agent.md for execution.