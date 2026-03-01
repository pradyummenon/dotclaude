# skill: refactor clean

## purpose
systematically identify and remove dead code, unused dependencies, orphan files, and stale artifacts from a codebase without breaking functionality.

## pre-conditions
- all tests pass before starting
- git working tree is clean (commit or stash changes)
- branch created: `refactor/cleanup-YYYY-MM-DD`

## phase 1: analysis (read-only)

### dead code detection
- Java: check for unused imports, unreachable methods, unused private fields
- Python: run `vulture` for dead code, `autoflake` for unused imports
- TypeScript/JS: check for unused exports, unused variables, dead branches

### dependency audit
- Java: `mvn dependency:analyze` or `gradle dependencies` — list unused declared dependencies
- Python: compare requirements.txt/pyproject.toml vs actual imports
- Node: `depcheck` for unused packages

### file audit
- find orphan files: modules not imported anywhere
- find stale markdown: docs referencing deleted features/APIs
- find duplicate logic: near-identical functions across modules

### output: cleanup report
- categorized list with confidence scores (HIGH/MEDIUM/LOW)
- HIGH = definitely dead (no references anywhere)
- MEDIUM = likely dead (only referenced in tests or comments)
- LOW = possibly dead (referenced but execution path unclear)

## phase 2: execution (with tests)
1. remove HIGH-confidence items first
2. run full test suite after each batch removal
3. commit each batch separately with descriptive message:
   `refactor(cleanup): remove unused PatientValidator class`
4. move to MEDIUM items only after HIGH batch passes
5. skip LOW items — flag for manual review

## phase 3: verification
1. full test suite passes
2. application starts and basic smoke test works
3. no new lint/type errors introduced
4. PR created with summary of what was removed and why

## anti-patterns (DO NOT)
- never remove code you're unsure about in the same PR as confirmed dead code
- never refactor logic while cleaning (separate concerns)
- never clean and add features in the same branch
- never remove @Deprecated methods without checking external consumers
