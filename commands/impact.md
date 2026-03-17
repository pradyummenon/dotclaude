Assess the feasibility and impact of a feature or change request
using the impact-analyzer agent at .claude/agents/impact-analyzer.md.

Arguments: $ARGUMENTS (the feature or change description in natural language)

1. Verify ~/.claude/context/<repo>-context.json exists (derive repo name from git remote).
   If not, tell the user to run /index-codebase first.
2. Pass the feature description to the impact-analyzer agent.
3. Present the assessment with effort estimates, risks, and recommended approach.
