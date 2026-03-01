# customization

this setup is designed to be forked and adapted. here's how to make it yours.

## first steps after installing

1. **edit `rules/git-workflow.md`** — replace the placeholder git identities with your actual GitHub username and email
2. **edit `settings.json`** — remove MCP servers you don't use (sentry, figma), add ones you do
3. **delete skills you don't need** — if you don't write Java, remove `java-unit-test.md` and `java-integration-test.md`. if you don't use React, remove `react-patterns.md`
4. **delete agents/commands you don't need** — they are independent. removing one does not break others

## adding a new rule

rules are always-loaded constraints. keep them short (<25 lines).

create a new file in `rules/`:

```markdown
# accessibility rules

## requirements
- all images must have alt text
- all form inputs must have associated labels
- color must not be the sole means of conveying information
- minimum contrast ratio: 4.5:1 for normal text, 3:1 for large text
```

that's it. the rule will be loaded on every interaction automatically.

**checklist before adding a rule:**
- is it relevant to every interaction? (if not, it's a skill)
- is it under 25 lines? (if not, split into a short rule + detailed skill)
- is it a hard constraint? (if it's guidance, it's a skill)

## adding a new skill

skills are on-demand knowledge. they can be as detailed as needed.

create a new file in `skills/`:

```markdown
# go testing patterns

## table-driven tests
- use a slice of test cases with name, input, expected fields
- iterate with t.Run(tc.name, func(t *testing.T) {...})
- use t.Parallel() for independent test cases

## mocking
- define interfaces for external dependencies
- use gomock or testify/mock for implementation
- prefer interface satisfaction over struct embedding

## testcontainers
- use testcontainers-go for database/service integration tests
- use container request with WaitingFor strategies
- clean up containers with t.Cleanup()

## common pitfalls
- goroutine leaks in tests: use goleak
- time-dependent tests: inject clock interface
- flaky tests: avoid shared state, use t.TempDir()
```

skills are only loaded when an agent references them, so length doesn't impact every-interaction performance.

## adding a new agent

create `agents/your-agent.md` with four sections:

```markdown
# your agent name

## role
you are a [specific role] that [what you do].

## process
1. [first step — usually context gathering]
2. [second step — analysis or generation]
3. [third step — produce output]

## skill references
- load ~/.claude/skills/relevant-skill.md when [condition]
- load ~/.claude/skills/another-skill.md when [condition]

## output format
| column1 | column2 | column3 |
|---------|---------|---------|
produce structured output in this format.
```

then create a matching command in `commands/`:

```markdown
# /your-command

invoke the your-agent at ~/.claude/agents/your-agent.md

arguments:
- $ARGUMENTS: [what the user provides]

pass context about the current project and the user's request to the agent.
```

## adding a new hook

hooks are shell scripts triggered by lifecycle events.

1. create the script in `hooks/`:

```bash
#!/bin/bash
# your-hook.sh — description of what it does
set -euo pipefail

# your logic here

# exit 0 = continue (warn only)
# exit 1 = block the action
exit 0
```

2. register it in `settings.json`:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash(your-pattern*)",
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/your-hook.sh"
          }
        ]
      }
    ]
  }
}
```

**hook events:**
- `PreToolUse` — before a tool executes (can block with exit 1)
- `PostToolUse` — after a tool executes (for formatting, validation)
- `Stop` — when the session ends (for cleanup, auditing)

**matcher patterns:**
- `Bash(git push*)` — matches bash commands starting with "git push"
- `Write(*\\.py)` — matches writing Python files
- `Edit(*\\.ts) || Edit(*\\.tsx)` — matches editing TypeScript files

## adding a new language

to add support for a new language (e.g., Go, Rust):

1. create `skills/go-unit-test.md` with testing patterns for the language
2. update agents that do language detection (code-reviewer, pr-review, test-writer) to recognize the language's config files (e.g., `go.mod`)
3. optionally add a hook for auto-formatting (e.g., `gofmt`)
4. optionally add commands for test generation

the existing agents already have the detection logic — you just need to add the new language to their detection list and create the matching skill file.

## removing things

everything is independent. safe to delete:

- any single rule (other rules continue working)
- any single skill (agents that reference it will just not load it)
- any single agent (other agents and commands continue working)
- any single command (other commands continue working)
- any single hook (other hooks continue working)
- entire directories (e.g., remove all of `commands/` if you prefer invoking agents directly)

the only dependency to watch: if you remove a skill that an agent references, the agent will still work but won't have that domain knowledge available. this is by design — graceful degradation, not hard failure.

## tips

- **start by removing**, not adding. delete skills/agents for languages and frameworks you don't use. a smaller config loads faster and stays focused.
- **rules compound**. each rule you add costs tokens on every interaction. audit your rules quarterly — remove ones that aren't pulling their weight.
- **hooks should be fast**. they run synchronously. if a hook takes more than a few seconds, it disrupts the workflow. keep them under 5 seconds.
- **test your agents**. run each command on a real project and verify the output makes sense. tweak the process steps and output format based on what you see.
