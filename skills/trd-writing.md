# skill: technical requirements document

## template structure

### 1. overview
- **title**: feature/system name
- **author**: who owns this document
- **status**: draft / in review / approved
- **last updated**: date

### 2. problem statement
- what problem are we solving?
- who experiences this problem?
- what is the impact of not solving it? (quantify if possible)

### 3. system context
- where does this fit in the overall architecture?
- what existing systems does it interact with?
- include a context diagram (mermaid)

### 4. requirements

#### functional requirements
- numbered list (FR-001, FR-002, etc.)
- each requirement: "the system shall..."
- include priority: MUST / SHOULD / COULD

#### non-functional requirements
- **latency**: p50, p95, p99 targets
- **throughput**: requests/sec or messages/sec
- **availability**: uptime SLA (99.9%, 99.99%)
- **scalability**: expected growth, peak load
- **security**: authentication, authorization, data classification
- **compliance**: HIPAA, GDPR, SOC2 (if applicable)

### 5. data model
- entity relationship diagram (mermaid)
- table/collection schemas with types
- indexes and constraints
- migration strategy from existing schema (if applicable)

### 6. API contracts
- endpoint definitions (method, path, request/response)
- error response format
- pagination strategy
- versioning approach
- authentication mechanism

### 7. technical design
- component diagram
- key algorithms or logic flows
- technology choices with rationale
- trade-offs considered

### 8. dependencies & risks
- external system dependencies
- team dependencies
- technical risks with mitigation strategies

### 9. migration & rollback
- deployment strategy (blue/green, canary, feature flag)
- data migration plan
- rollback procedure
- success criteria for rollout

### 10. open questions
- unresolved decisions with options and recommendation
