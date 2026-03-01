# architecture

## system overview

the dotclaude configuration is a layered system where each layer has a specific responsibility and loading strategy.

```mermaid
graph TB
    subgraph "always loaded"
        R1[rules/coding-style.md]
        R2[rules/git-workflow.md]
        R3[rules/testing.md]
        R4[rules/security.md]
        R5[rules/performance.md]
        R6[rules/code-hygiene.md]
        R7[rules/agents.md]
    end

    subgraph "loaded on demand"
        S1[skills/python-*.md]
        S2[skills/java-*.md]
        S3[skills/react-patterns.md]
        S4[skills/typescript-strict.md]
        S5[skills/nextjs-patterns.md]
        S6[skills/api-design.md]
        S7[skills/enterprise-python-review.md]
        S8[skills/prd-writing.md]
        S9[skills/trd-writing.md]
        S10[skills/refactor-clean.md]
    end

    subgraph "user-invoked"
        C[commands/]
    end

    subgraph "autonomous"
        A[agents/]
    end

    subgraph "lifecycle"
        H1[hooks/pre-push-gate.sh]
        H2[hooks/post-edit-format.sh]
        H3[hooks/pre-block-md-spam.sh]
        H4[hooks/stop-console-audit.sh]
    end

    C -->|delegates to| A
    A -->|loads| S1
    A -->|loads| S2
    A -->|loads| S3
    A -->|constrained by| R1
    A -->|constrained by| R3
```

## loading strategy

### rules: always in context

rules are loaded into the system prompt for every interaction. this means:
- they consume context window tokens on every request
- they must be concise (10-25 lines each)
- total rule set: ~130 lines across 7 files
- they define what is required or forbidden, never how

### skills: demand-loaded by agents

skills are loaded when an agent determines they are relevant. the detection pattern:

```
agent receives task
  -> reads project config files (package.json, pom.xml, pyproject.toml)
  -> determines project language/framework
  -> loads matching skill files
  -> applies skill knowledge to the task
```

this means a Python project never wastes context on Java skills, and vice versa.

### agents: invoked by commands or delegation rules

agents are invoked in two ways:
1. **directly via commands**: user types `/pr-review`, command delegates to `agents/pr-review.md`
2. **via delegation rules**: `rules/agents.md` defines when to auto-delegate (e.g., "code review across >3 files -> use code-reviewer agent")

### hooks: triggered by lifecycle events

hooks are registered in `settings.json` and triggered automatically:

| event | trigger | hook |
|-------|---------|------|
| `PreToolUse` | before `git push` | `pre-push-gate.sh` |
| `PreToolUse` | before creating `.md` files | `pre-block-md-spam.sh` |
| `PostToolUse` | after writing/editing JS/TS/Python | `post-edit-format.sh` |
| `Stop` | session end | `stop-console-audit.sh` |

## data flow: code review example

```mermaid
sequenceDiagram
    participant U as user
    participant CMD as /pr-review
    participant AGT as agents/pr-review.md
    participant DET as language detection
    participant SKL as skills/*
    participant RUL as rules/*
    participant OUT as structured output

    U->>CMD: /pr-review
    CMD->>AGT: delegate with PR context
    AGT->>DET: read config files
    DET-->>AGT: python detected
    AGT->>SKL: load python-unit-test.md
    AGT->>SKL: load enterprise-python-review.md
    Note over AGT,RUL: rules already in context
    AGT->>AGT: analyze each file
    AGT->>OUT: produce findings table
    OUT-->>U: severity | file:line | issue | fix
```

## the structured output pattern

every agent produces output in a consistent format:

```
| severity | file:line | issue | recommendation |
|----------|-----------|-------|----------------|
| CRITICAL | auth.py:42 | SQL injection via string interpolation | use parameterized queries |
| HIGH | api.py:15 | no input validation on user_id | add pydantic model validation |
| MEDIUM | utils.py:88 | broad exception catch | catch specific exceptions |
```

severity levels: `CRITICAL`, `HIGH`, `MEDIUM`, `LOW`, `INFO`

this consistency means:
- output is scannable (you can skip LOW/INFO if pressed for time)
- findings are actionable (file:line takes you directly to the code)
- reviews are comparable (same format across different agents and languages)

## hook execution flow

```mermaid
graph LR
    subgraph "pre-push"
        A[git push] --> B{identity set?}
        B -->|no| C[BLOCK: exit 1]
        B -->|yes| D{debug statements?}
        D -->|yes| E[WARN: continue]
        D -->|no| F[PASS: continue]
    end

    subgraph "post-edit"
        G[file written] --> H{JS/TS?}
        H -->|yes| I[prettier --write]
        H -->|no| J{Python?}
        J -->|yes| K[ruff format / black]
        J -->|no| L[skip]
    end

    subgraph "session end"
        M[stop] --> N[scan workspace]
        N --> O{debug found?}
        O -->|yes| P[WARN to stderr]
        O -->|no| Q[silent pass]
    end
```

## file dependency map

```
commands/pr-review.md
  -> agents/pr-review.md
    -> skills/python-unit-test.md (if python)
    -> skills/java-unit-test.md (if java)
    -> skills/typescript-strict.md (if typescript)
    -> skills/enterprise-python-review.md (if python)

commands/doc-write.md
  -> agents/doc-writer.md
    -> (no skill dependencies, uses project context)

commands/test-python-unit.md
  -> agents/test-writer.md
    -> skills/python-unit-test.md

commands/review-enterprise-python.md
  -> agents/code-reviewer.md
    -> skills/enterprise-python-review.md
```
