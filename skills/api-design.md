# skill: API design conventions

## URL naming
- use nouns, not verbs: `/patients` not `/getPatients`
- plural for collections: `/patients`, `/appointments`
- nested resources for relationships: `/patients/{id}/appointments`
- max 2 levels deep — beyond that, use query params or separate endpoints
- lowercase, hyphen-separated: `/lab-results` not `/labResults`

## HTTP methods
| method | purpose | idempotent | response |
|--------|---------|-----------|----------|
| GET | read | yes | 200 with data |
| POST | create | no | 201 with created resource |
| PUT | full replace | yes | 200 with updated resource |
| PATCH | partial update | yes | 200 with updated resource |
| DELETE | remove | yes | 204 no content |

## status codes
- **200**: success with body
- **201**: created (include Location header)
- **204**: success, no body (DELETE)
- **400**: bad request (validation errors)
- **401**: unauthenticated
- **403**: unauthorized (authenticated but not allowed)
- **404**: not found
- **409**: conflict (duplicate, version mismatch)
- **422**: unprocessable entity (valid syntax, invalid semantics)
- **429**: rate limited
- **500**: internal server error (never expose internals)

## pagination (cursor-based preferred)
```json
{
  "data": [...],
  "pagination": {
    "next_cursor": "eyJpZCI6MTAwfQ==",
    "has_more": true,
    "total_count": 1542
  }
}
```

## error response format
```json
{
  "error": {
    "code": "PATIENT_NOT_FOUND",
    "message": "Patient with ID 123 not found",
    "details": [
      { "field": "patient_id", "issue": "No patient exists with this ID" }
    ],
    "request_id": "req_abc123"
  }
}
```

## versioning
- URL path versioning: `/api/v1/patients` (simple, explicit)
- only bump version for breaking changes
- support previous version for minimum 6 months after deprecation notice

## request/response patterns
- use consistent field naming (snake_case for JSON)
- always include `id` in responses
- include `created_at` and `updated_at` timestamps
- never expose internal IDs (database auto-increments) — use UUIDs
- wrap responses: `{ "data": {...} }` for single, `{ "data": [...] }` for lists

## authentication
- bearer token in Authorization header: `Authorization: Bearer <token>`
- API keys in custom header for service-to-service: `X-API-Key: <key>`
- never pass credentials in URL query params
