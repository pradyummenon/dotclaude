Create a PR from the current changes on the active branch
using the pr-creator agent at .claude/agents/pr-creator.md.

Arguments: $ARGUMENTS (optional: additional context for the PR description)

1. Verify you are on a feat/ or fix/ branch (not main).
   If on main, stop and tell the user to create a branch first.
2. Verify there are uncommitted or unpushed changes (git status, git log origin..HEAD).
   If no changes, tell the user there's nothing to ship.
3. Run lint and tests. If either fails, report the issue and stop.
4. Pass the current changes to the pr-creator agent.
5. Present the PR link to the user.
