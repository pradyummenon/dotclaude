Create Jira tickets from raw descriptions. Spawn the Jira ticket creator agent at ~/.claude/agents/jira-ticket-creator.md.

Arguments: $ARGUMENTS (description text, or --from=file.md for batch)

1. Parse the input into discrete tickets
2. For each ticket, generate:
   - Summary (concise, action-oriented, <100 chars)
   - Description (acceptance criteria, technical notes)
   - Issue Type (Story/Task/Bug)
   - Priority (suggested)
   - Labels (auto-suggested from content)
3. Present all tickets in a table for review BEFORE creating
4. On confirmation, create tickets via Atlassian MCP
5. Output: list of created ticket IDs with Jira links