Generate project documentation. Uses the doc-writer agent at ~/.claude/agents/doc-writer.md.

Arguments: $ARGUMENTS (optional: "readme", "concepts", "adr", or "all")

1. Analyze the current codebase structure, tech stack, and key modules
2. Based on argument:
   - "readme" or no arg: generate/update README.md
   - "concepts": generate docs/concepts/ deep-dive files for core concepts
   - "adr": generate a new architecture decision record in docs/architecture/
   - "all": generate README + concepts + architecture diagram
3. Follow the doc-writer agent's principles: concise, scannable, example-driven
4. Present generated docs for review before writing