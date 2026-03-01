Generate or run Python unit tests for specified module(s). Follow the python-unit-test skill at ~/.claude/skills/python-unit-test.md.

Arguments: $ARGUMENTS (module/class name, --run, or --coverage)

1. Load skill: ~/.claude/skills/python-unit-test.md
2. If module provided: analyze the module — public functions, dependencies, edge cases — and generate pytest test file with fixtures, parametrize, and async support
3. If --run: execute all unit tests with `pytest tests/unit/ -v`
4. If --coverage: run with `pytest tests/unit/ -v --cov=src/`
5. Ensure generated tests pass before presenting them