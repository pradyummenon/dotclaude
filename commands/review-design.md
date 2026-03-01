Review a system or API design document from an engineering architecture perspective. Uses the design-reviewer agent at ~/.claude/agents/design-reviewer.md.

Arguments: $ARGUMENTS (file path, or figma URL for UI design review)

1. If Figma URL: use Figma MCP tools to inspect file structure, components, styles
2. If file path: read the design document
3. Detect target stack and load relevant skills:
   - API design: ~/.claude/skills/api-design.md
   - Performance: ~/.claude/rules/performance.md
   - Security: ~/.claude/rules/security.md
4. Multi-dimensional review: architecture, API design, security, performance, testability
5. Output: categorized findings with severity (CRITICAL/HIGH/MEDIUM/LOW/INFO)