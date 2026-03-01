# testing rules

## before any deployment
- all existing tests must pass
- new code requires corresponding tests
- no skipped tests without a linked Jira ticket explaining why

## coverage expectations
- new modules: aim for >80% line coverage
- bug fixes: must include a regression test
- integration points: at least one happy-path + one error-path test

## test quality
- tests should be independent (no shared mutable state)
- use descriptive test names: `should_return_404_when_patient_not_found`
- mock external dependencies, don't mock the thing being tested
- test behavior, not implementation details
