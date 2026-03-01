# design philosophy

## the problem

AI coding assistants are powerful but unpredictable. without guardrails, they produce inconsistent code — sometimes excellent, sometimes subtly wrong. the default behavior varies by session, by prompt, by context window state. you get different results on Tuesday than you got on Monday for the same kind of task.

the fix isn't better prompting. it's **configuration as code** — a persistent, version-controlled set of constraints and knowledge that shapes every interaction.

## constraint-based programming

the core idea behind this setup is constraint-based programming: instead of telling the agent what to do step by step, you define boundaries it must stay within and knowledge it can draw from.

this is fundamentally different from prompt engineering. prompt engineering is per-interaction. constraints are persistent. prompt engineering is "please use conventional commits." constraints are "conventional commits are the only format that will pass the pre-push hook."

### why constraints beat instructions

instructions are suggestions. constraints are enforced.

when you write a rule that says "no console.log in committed code," that rule is loaded into every interaction. the agent sees it before it writes code, while it writes code, and when it reviews code. and if it still slips through, the pre-push hook catches it.

this creates a defense-in-depth model:
1. **rules** prevent the problem (the agent knows not to use console.log)
2. **hooks** catch what rules miss (the pre-push gate scans for debug statements)
3. **agents** enforce during review (the code reviewer flags console.log as a finding)

three layers. same constraint. different enforcement points.

## the rules/skills/agents taxonomy

this is the most important design decision in the entire setup.

### rules: always loaded, always enforced

rules are short constraint files (10-25 lines each) that are loaded into the context window on every interaction. because they consume tokens every time, they must be concise. a rule should never explain _how_ to do something — only _what_ is required or forbidden.

good rule: "no console.log in committed code"
bad rule: "when writing JavaScript, avoid using console.log because it can leak sensitive information to the browser console. instead, use a structured logging library like winston or pino that supports log levels..."

the bad rule is a skill pretending to be a rule. it wastes tokens on every interaction, even when the user is writing Python.

### skills: loaded on demand

skills are detailed knowledge files (50-160 lines each) that teach patterns, conventions, and best practices for a specific domain. they are only loaded when an agent decides they are relevant — typically by detecting the project language from config files.

this is critical for context window management. the enterprise Python review skill is 163 lines. if it were loaded on every interaction, it would waste context on Java projects, React projects, documentation tasks. by keeping it as a skill, it only appears when a Python code review is requested.

### agents: compose rules + skills

agents are the glue. they have:
- a **role** ("you are a code reviewer")
- a **process** ("detect language, load matching skills, analyze each file, produce findings")
- an **output format** ("table with columns: severity, file:line, issue, recommendation")
- **references** to skills (loaded dynamically) and rules (already in context)

the language detection pattern is used across multiple agents: read `package.json`, `pom.xml`, `pyproject.toml`, or similar config files to determine the project language, then load the corresponding skills. this means the same agent definition works for Python, Java, and TypeScript projects without modification.

## hooks: automate what humans forget

four lifecycle hooks handle the tasks that should happen automatically:

1. **pre-push-gate.sh** — before every `git push`, verify git identity is set and scan for debug statements. this catches the most common mistake: pushing code with `console.log` or `print()` left in.

2. **post-edit-format.sh** — after every file write/edit, auto-format with prettier (JS/TS) or ruff/black (Python). this eliminates formatting debates entirely. the agent never needs to think about formatting because the hook handles it.

3. **pre-block-md-spam.sh** — before creating markdown files, warn if the file is outside `docs/` or `.claude/`. this prevents the common pattern where agents create unnecessary documentation files scattered across the project.

4. **stop-console-audit.sh** — at session end, scan the workspace for debug statements. this is the final safety net — even if the pre-push hook was bypassed or the code wasn't pushed yet.

## commands: thin entry points

commands are intentionally thin. they parse user input (which files to review, what format to generate) and delegate to agents. the intelligence lives in the agent definition, not the command.

this separation matters because:
- the same agent can be invoked programmatically (not just via slash command)
- agent definitions can be tested and reviewed independently
- commands can be added or removed without touching agent logic

## lessons learned

### context window budget is real

the most impactful optimization was moving detailed knowledge from rules to skills. early versions had rules that were 50-100 lines each. the total rule set consumed significant context on every interaction, leaving less room for actual code. splitting into short rules (constraints) and longer skills (knowledge) dramatically improved response quality.

### structured output is non-negotiable

early agent definitions produced free-form prose reviews. they were hard to scan, inconsistent between runs, and missed things. switching to structured output with mandatory fields (severity, file:line, issue, recommendation) made reviews dramatically more useful and consistent.

### defense-in-depth works

no single layer catches everything. the agent might write console.log despite the rule. the hook catches it before push. the session-end audit catches it if the code wasn't pushed yet. the code reviewer catches it in PR review. having the same constraint enforced at multiple points is what makes the system reliable.

### hooks must be non-blocking

early hook implementations would block the workflow on warnings. this was frustrating — you don't want to be interrupted every time you create a markdown file. the current hooks warn but don't block (exit 0 even when they find issues). only the identity check in pre-push-gate is a hard block (exit 1).

### less is more for rules

every rule consumes context window tokens on every interaction. adding a rule has a cost. the test for whether something should be a rule: "does this need to be enforced on every interaction, regardless of what the user is doing?" if the answer is no, it's a skill, not a rule.
