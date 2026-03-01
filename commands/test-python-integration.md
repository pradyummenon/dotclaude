Generate or run Python integration tests for specified module(s) or endpoints. Follow the python-integration-test skill at ~/.claude/skills/python-integration-test.md.

Arguments: $ARGUMENTS (module name, endpoint, --run, or --coverage)

1. Load skill: ~/.claude/skills/python-integration-test.md
2. If target provided: analyze and generate integration tests using testcontainers + httpx patterns
3. If --run: execute integration tests with `pytest tests/integration/ -v`
4. If --coverage: run with `pytest tests/integration/ -v --cov=src/`
5. Use testcontainers for databases, respx for external API mocking