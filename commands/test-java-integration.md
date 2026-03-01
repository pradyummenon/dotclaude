Generate or run Java integration tests for specified class(es) or endpoints. Follow the java-integration-test skill at ~/.claude/skills/java-integration-test.md.

Arguments: $ARGUMENTS (class name, endpoint, --run, or --coverage)

1. Load skill: ~/.claude/skills/java-integration-test.md
2. If target provided: analyze the class/endpoint and generate integration tests using Spring Boot Test + Testcontainers + WireMock patterns
3. If --run: execute integration tests with `./gradlew integrationTest` or `mvn verify -Pintegration`
4. If --coverage: run with coverage report
5. Ensure tests use Testcontainers for databases and WireMock for external APIs