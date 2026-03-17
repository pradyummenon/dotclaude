# backend conventions (org-level)

these are organization-wide backend engineering conventions.
repo-specific details come from the context graph, not this file.

## API design

- RESTful endpoints with consistent naming: `/resource`, `/resource/:id`
- use HTTP methods correctly: GET (read), POST (create), PUT (update), DELETE (remove)
- response format: consistent JSON envelope with data, error, and metadata fields
- pagination: cursor-based (never offset-based — offset breaks with concurrent writes)
- always version APIs: `/v1/resource`, `/v2/resource`

## authentication and authorization

- bearer token authentication for API calls
- tokens managed via auth providers (Firebase Auth, custom auth)
- never expose auth tokens in URLs, logs, or error messages
- role-based access control where applicable
- auth logic lives in middleware/interceptors, not in individual endpoints

## error handling

- structured error responses with error code, message, and details
- never expose stack traces or internal paths in API responses
- log errors with correlation IDs for traceability
- use structured logging (not console.log or print statements)
- categorize errors: client errors (4xx) vs server errors (5xx)

## data layer

- parameterized queries only — never string-interpolate into queries
- database access through a data layer (repository pattern or ORM)
- index frequently queried columns
- no N+1 queries — use JOINs, batch fetching, or DataLoader
- all list endpoints must be paginated

## configuration

- environment variables for all external configuration
- never hardcode API keys, tokens, or passwords
- provide .env.example with placeholder values
- abstract external service configs behind a config module
- feature flags for gradual rollout of new behavior

## deployment

- CI/CD via GitHub Actions (or equivalent)
- automated checks on every PR: lint, test, build
- staging environment for pre-production validation
- production deploys require passing CI and approval
- rollback plan for every deployment

## testing

- unit tests for business logic (services, utilities)
- integration tests for API endpoints
- mock external dependencies (databases, third-party APIs)
- test both happy paths and error paths
- new code requires corresponding tests

## service communication

- REST for synchronous operations
- WebSocket for real-time features (chat, live updates)
- event-driven where appropriate (message queues, pub/sub)
- retry logic with exponential backoff for external service calls
- circuit breaker pattern for unreliable dependencies
