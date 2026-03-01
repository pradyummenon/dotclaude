# security rules

## secrets management
- NEVER hardcode API keys, tokens, passwords, or DSNs in source code
- NEVER commit .env files — always .gitignore them
- use environment variables or secret managers (AWS Secrets Manager, Vault)
- if a secret is accidentally committed, rotate it immediately — git history preserves it
- provide .env.example with placeholder values

## dependencies
- pin dependency versions (no floating ^, ~, or *)
- review changelogs before major version bumps
- never install packages from untrusted registries

## input validation
- validate all external inputs at system boundaries (CLI args, API params, user input)
- use parameterized queries — never string-interpolate into SQL/Cypher/GraphQL
- sanitize user input before rendering in HTML (XSS prevention)
