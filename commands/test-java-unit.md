Generate or run Java unit tests for specified class(es). Follow the java-unit-test skill at ~/.claude/skills/java-unit-test.md.

Arguments: $ARGUMENTS (class name, --run, or --coverage)

1. Load skill: ~/.claude/skills/java-unit-test.md
2. If class name provided: analyze the class — public methods, dependencies, edge cases — and generate a test file following JUnit 5 + Mockito + AssertJ patterns
3. If --run: execute all existing unit tests with `./gradlew test` or `mvn test`
4. If --coverage: run with coverage report
5. Ensure generated tests actually pass before presenting them