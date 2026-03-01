Review a Technical Requirements Document for completeness, feasibility, and quality. Spawn the TRD reviewer agent at ~/.claude/agents/trd-reviewer.md.

Arguments: $ARGUMENTS (file path or "clipboard" to read from recent paste)

1. Load skill: ~/.claude/skills/trd-writing.md (for structure expectations)
2. Load skill: ~/.claude/skills/api-design.md (for API section review)
3. Read the TRD document from the provided path
4. Produce a structured review:
   - Completeness check (are all TRD sections present?)
   - Technical feasibility flags
   - Missing constraints or edge cases
   - Severity-rated findings (CRITICAL/HIGH/MEDIUM/LOW)
5. Output: review report with actionable recommendations in table format