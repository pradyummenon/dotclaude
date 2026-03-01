Review a Product Requirements Document for completeness and quality. Spawn the PRD reviewer agent at ~/.claude/agents/prd-reviewer.md.

Arguments: $ARGUMENTS (file path or "clipboard" to read from recent paste)

1. Load skill: ~/.claude/skills/prd-writing.md (for structure expectations)
2. Read the PRD document from the provided path
3. Produce a structured review:
   - Completeness check (are all PRD sections present?)
   - User stories well-formed? (As a... I want... So that...)
   - Acceptance criteria testable and specific?
   - Success metrics measurable?
   - Scope clearly bounded?
   - Severity-rated findings (CRITICAL/HIGH/MEDIUM/LOW)
4. Output: review report with actionable recommendations in table format