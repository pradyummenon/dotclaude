# coding style rules

## general
- prefer readability over cleverness
- functions should do one thing and be <40 lines
- classes should follow Single Responsibility Principle
- use meaningful variable names (no single-letter except loop counters)
- guard clauses over nested conditionals
- composition over inheritance
- program to interfaces, not implementations

## language-specific defaults
- Java: Google Java Style Guide, 4-space indent
- Python: PEP 8, Black formatter, 4-space indent
- TypeScript/JavaScript: Prettier defaults, 2-space indent
- React: functional components + hooks, no class components
