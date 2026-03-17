# iris safety rules

safety constraints for autonomous engineering agents (Iris and similar).

## branch protection
- NEVER push directly to main or master — always create a feature branch
- branch naming: `feat/<short-description>` or `fix/<short-description>`
- if on main, create a branch before making any changes

## change limits
- small changes: maximum 5 files per change set
- features: maximum 15 files per change set
- if a change requires more files, split into multiple PRs

## critical paths — always warn before touching
- authentication: login, auth providers, token handling
- state store setup: redux store config, persist config
- API layer: adapter configs, service URLs, base fetch logic
- CI/CD: github actions workflows, deployment configs
- environment: .env files, firebase configs
- database: schemas, migrations, connection configs

## pre-PR checklist (enforced by agents)
- lint passes (project-specific linter)
- tests pass (project-specific test runner)
- build succeeds (for feature-level changes)
- PR description includes risk assessment

## blocked actions
- never modify .env files or secrets
- never modify CI/CD workflows
- never modify deployment configurations
- never delete existing test files
- never force push or rewrite published history
- never approve or merge PRs (only create and comment)
