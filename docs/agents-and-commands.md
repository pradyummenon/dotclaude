# agents and commands

## how the agent system works

agents are autonomous subprocesses that handle complex, multi-step tasks. they are defined in markdown files that specify a role, process, skill references, and output format.

commands are thin entry points that parse user input and delegate to agents. the intelligence lives in the agent definition, not the command.

```
user types /pr-review
  -> commands/pr-review.md parses input
  -> delegates to agents/pr-review.md
  -> agent detects project language
  -> agent loads matching skills
  -> agent produces structured review
```

## anatomy of an agent

every agent definition follows the same structure:

### 1. role definition

```markdown
you are a code reviewer specializing in [language] projects.
```

this sets the agent's identity and expertise. it determines how the agent approaches problems and what it prioritizes.

### 2. process steps

```markdown
1. detect project language from config files
2. load relevant skills
3. analyze each modified file
4. produce structured findings
```

the process is explicit and ordered. agents follow steps sequentially, which makes their behavior predictable and debuggable.

### 3. skill references

```markdown
reference skills:
- ~/.claude/skills/python-unit-test.md (if python)
- ~/.claude/skills/java-unit-test.md (if java)
- ~/.claude/skills/typescript-strict.md (if typescript)
```

skills are loaded conditionally based on the detected context. this is the key mechanism for keeping agents language-agnostic while still producing language-specific output.

### 4. output format

```markdown
output format:
| severity | file:line | issue | recommendation |
```

every agent produces structured, tabular output. this is non-negotiable — it ensures consistency across different agents, different languages, and different sessions.

## the language detection pattern

the most reused pattern across agents is automatic language detection:

```
read project root for:
  - package.json -> JavaScript/TypeScript
  - tsconfig.json -> TypeScript
  - pom.xml -> Java
  - build.gradle -> Java
  - pyproject.toml -> Python
  - requirements.txt -> Python
  - go.mod -> Go
```

once the language is detected, the agent loads the corresponding skills. this means:
- one agent definition works for multiple languages
- adding a new language requires only adding a new skill file
- the agent automatically adapts to whatever project it's pointed at

## the structured output pattern

all agents produce output using severity-rated findings:

**severity levels:**
- `CRITICAL` — security vulnerability, data loss risk, production-breaking bug
- `HIGH` — significant bug, performance issue, architectural violation
- `MEDIUM` — code quality issue, missing test coverage, style violation
- `LOW` — minor improvement, naming suggestion, documentation gap
- `INFO` — observation, context, positive feedback

**mandatory fields:**
- severity level
- file:line reference (clickable in most editors)
- issue description (what's wrong)
- recommendation (what to do instead)

this consistency means you can scan reviews quickly — skip to CRITICAL/HIGH when time-pressured, review MEDIUM/LOW when thorough.

## agent catalog

### review agents

| agent | reviews | loads skills for |
|-------|---------|-----------------|
| `code-reviewer.md` | code quality, patterns, anti-patterns | detected language |
| `pr-review.md` | PRs: breaking changes, architecture, SOLID | detected language |
| `design-reviewer.md` | system/API design documents | api-design, detected language |
| `design-review.md` | Figma designs: implementability, accessibility | (none — visual review) |
| `prd-reviewer.md` | PRDs: completeness, user stories, metrics | prd-writing |
| `trd-reviewer.md` | TRDs: feasibility, requirements, data model | trd-writing |
| `refactor-agent.md` | dead code, unused deps, orphan files | refactor-clean |

### generation agents

| agent | generates | loads skills for |
|-------|-----------|-----------------|
| `doc-writer.md` | README, concept docs, ADRs | (project context) |
| `diagram-gen.md` | mermaid diagrams (architecture, sequence, class) | (project context) |
| `test-writer.md` | unit/integration tests | detected language |
| `jira-ticket-creator.md` | structured Jira tickets | (user input) |

## command catalog

commands map 1:1 to agents (with a few exceptions where multiple commands use the same agent with different parameters):

| command | agent | typical use |
|---------|-------|-------------|
| `/pr-review` | pr-review.md | before merging a PR |
| `/doc-write` | doc-writer.md | after completing a feature |
| `/diagram` | diagram-gen.md | when architecture changes |
| `/design-review` | design-review.md | reviewing Figma mockups |
| `/review-design` | design-reviewer.md | reviewing design docs |
| `/review-prd` | prd-reviewer.md | before engineering starts |
| `/review-trd` | trd-reviewer.md | before implementation starts |
| `/review-enterprise-python` | code-reviewer.md | deep Python audit |
| `/create-jira-tickets` | jira-ticket-creator.md | sprint planning |
| `/refactor-clean` | refactor-agent.md | periodic codebase cleanup |
| `/test-python-unit` | test-writer.md | writing Python unit tests |
| `/test-python-integration` | test-writer.md | writing Python integration tests |
| `/test-java-unit` | test-writer.md | writing Java unit tests |
| `/test-java-integration` | test-writer.md | writing Java integration tests |

## adding a new agent

to add a new agent:

1. create `agents/your-agent.md` following the structure above (role, process, skill refs, output format)
2. create `commands/your-command.md` as a thin wrapper that delegates to the agent
3. if the agent needs domain knowledge, create `skills/your-domain.md`
4. if the agent should be auto-invoked, add a delegation rule to `rules/agents.md`

the key principle: keep the command thin and the agent rich. commands parse input; agents contain intelligence.
