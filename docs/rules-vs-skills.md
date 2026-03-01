# rules vs skills

this is the most important conceptual distinction in the entire setup.

## the core difference

**rules** are constraints that are always loaded. they tell the agent what it must or must not do.

**skills** are knowledge that is loaded on demand. they teach the agent how to do things well.

| | rules | skills |
|--|-------|--------|
| **loaded** | every interaction | on demand |
| **purpose** | constrain behavior | teach patterns |
| **length** | 10-25 lines | 50-160 lines |
| **tone** | imperative ("never", "always", "must") | instructive ("prefer", "use", "consider") |
| **cost** | consumes tokens always | consumes tokens only when relevant |
| **examples** | "no console.log", "conventional commits" | "how to write a pytest fixture", "REST API naming" |

## why the distinction matters

### context window budget

every rule consumes context window tokens on every interaction. if you have 7 rules averaging 18 lines each, that's ~126 lines loaded before the agent even sees your code.

skills, by contrast, are only loaded when an agent determines they are relevant. the enterprise Python review skill is 163 lines. if it were a rule, it would consume those 163 lines on every interaction — including when you're writing JavaScript, reviewing a design document, or generating diagrams.

the math is simple: rules have a per-interaction cost. skills have a per-use cost. put knowledge where its cost model matches its usage pattern.

### enforcement vs guidance

rules define hard boundaries. "no console.log in committed code" is not a suggestion. the pre-push hook enforces it. the code reviewer flags it. the session-end audit catches it.

skills define best practices. "prefer composition over inheritance" is guidance. there are cases where inheritance is the right choice. the skill teaches the pattern; the developer (or agent) decides when to apply it.

putting guidance in rules makes the agent overly rigid. putting constraints in skills makes them optional.

## how to decide: rule or skill?

ask these questions:

1. **does this apply to every interaction?** if yes, consider a rule. if it only applies to certain languages/frameworks/tasks, it's a skill.

2. **is it short enough?** rules should be <25 lines. if explaining the constraint requires detailed examples and patterns, the constraint goes in a rule and the explanation goes in a skill.

3. **is it a hard constraint or best practice?** hard constraints ("never commit secrets") are rules. best practices ("prefer cursor-based pagination") are skills.

4. **would violating it be caught automatically?** if a hook or automated check can catch violations, the rule is worth having because it creates defense-in-depth.

## examples

### this belongs in a rule

```markdown
# security rules
- NEVER hardcode API keys, tokens, passwords, or DSNs in source code
- NEVER commit .env files
- use environment variables or secret managers
```

short, universal, always relevant, hard constraint.

### this belongs in a skill

```markdown
# python unit testing
## fixture patterns
- use scope="function" for most fixtures (scope="session" + async = deadlocks)
- name fixtures after what they provide, not what they do
- prefer factory fixtures over static data
## parametrization
- use @pytest.mark.parametrize for input/output pairs
- group related parameters with pytest.param(id=...)
```

detailed, language-specific, only relevant when writing Python tests.

### this was a rule but should have been a skill

```markdown
## api design
- use plural nouns for resource collections (/users not /user)
- use HTTP methods correctly (GET=read, POST=create, PUT=full-replace, PATCH=partial)
- return 201 for successful creation with Location header
- use cursor-based pagination with ?cursor= parameter
- error responses: { "error": { "code": "NOT_FOUND", "message": "..." } }
```

this is 5 lines, but it's only relevant when designing or reviewing APIs. making it a rule wastes context on every non-API interaction. it belongs in `skills/api-design.md` where it can be loaded by the design reviewer agent when reviewing API endpoints.

## the agents bridge

agents are how rules and skills compose. an agent like `code-reviewer.md`:

1. inherits all rules (already in context)
2. detects project language (reads config files)
3. loads relevant skills (python skills for python, java skills for java)
4. applies both rules (constraints) and skills (knowledge) during review
5. produces structured output (consistent format across all reviews)

this means the same code reviewer agent enforces "no console.log" (rule) while also checking "uses pytest fixtures correctly" (skill) — but only when reviewing Python code.
