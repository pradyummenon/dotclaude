Implement a feature following established codebase patterns
using the feature-builder agent at .claude/agents/feature-builder.md.

Arguments: $ARGUMENTS (feature description or Figma design URL)

1. Verify ~/.claude/context/<repo>-context.json exists (derive repo name from git remote).
   If not, tell the user to run /index-codebase first.
2. If a Figma URL is included, the agent will fetch the design via Figma MCP.
3. Pass the feature request to the feature-builder agent.
4. The agent will present an implementation plan — wait for user approval.
5. After approval: branch, implement, lint, test, build, create PR.
6. Present the PR link to the user.
