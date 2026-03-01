# skill: product requirements document

## template structure

### 1. overview
- **feature name**: clear, descriptive name
- **owner**: product owner / PM
- **status**: draft / in review / approved
- **target release**: date or sprint

### 2. problem statement
- what user problem are we solving?
- evidence: user feedback, data, support tickets, analytics
- who is affected? (user persona)
- what happens if we don't solve this?

### 3. user stories
format: "as a [persona], i want [goal] so that [benefit]"

each story includes:
- **acceptance criteria** (testable, specific)
- **priority**: P0 (must), P1 (should), P2 (nice to have)
- **estimated complexity**: S / M / L / XL

### 4. scope

#### in scope
- explicit list of what this feature covers

#### out of scope
- explicit list of what this feature does NOT cover
- why it's excluded (defer to future, separate initiative, not needed)

### 5. success metrics
- primary KPI: what tells us this worked?
- secondary KPIs: supporting indicators
- guardrail metrics: what should NOT get worse?
- measurement method: how will we track these?
- target values: specific numbers, not "improvement"

### 6. user flows
- happy path flow (diagram or numbered steps)
- key alternate paths
- error states and messaging

### 7. design requirements
- wireframes or mockups (link to Figma)
- accessibility requirements (WCAG AA)
- responsive behavior

### 8. technical constraints
- platform/browser support
- performance requirements
- data privacy requirements (PII handling, consent)
- integration requirements

### 9. dependencies
- engineering dependencies (APIs, services, libraries)
- design dependencies (design system updates)
- cross-team dependencies

### 10. timeline
- phases with milestones
- key deadlines
- risks to timeline

### 11. open questions
- unresolved decisions with recommended approach
