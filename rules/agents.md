# agent delegation rules

## when to spawn subagents
- code review across >3 files — use code-reviewer agent
- writing docs >500 words — use doc-writer agent
- creating >3 Jira tickets — use jira-ticket-creator agent
- reviewing TRD/PRD — use respective reviewer agent

## agent output standards
- every agent must produce structured output (not free-form prose)
- severity levels: CRITICAL, HIGH, MEDIUM, LOW, INFO
- every finding must include: location, issue, recommendation
- agents reference relevant skills for language-specific context
