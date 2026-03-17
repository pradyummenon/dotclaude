Index or re-index the current codebase using the context-indexer agent
at .claude/agents/context-indexer.md.

Arguments: $ARGUMENTS (optional: "full" for complete re-index, default: incremental if context exists)

1. Verify the current directory is a git repository
2. If "full" is passed or no context graph exists at ~/.claude/context/<repo>-context.json:
   run full indexing via the context-indexer agent
3. If a context graph already exists and "full" was not passed:
   run incremental update (only changed files and new PRs)
4. Report results: files indexed, features detected, PRs mined, context graph path
