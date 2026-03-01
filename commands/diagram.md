Create or update architecture diagrams using mermaid. Uses the diagram-gen agent at ~/.claude/agents/diagram-gen.md.

Arguments: $ARGUMENTS (optional: "architecture", "data-flow", "sequence", "class")

1. Analyze the current codebase structure
2. Based on argument:
   - "architecture" or no arg: high-level system context + component diagram
   - "data-flow": how data moves through the system
   - "sequence": key user flows or system interactions
   - "class": module/class relationship diagram showing patterns
3. Follow mermaid syntax, max 12-15 nodes, clear labels
4. Save to docs/diagrams/ as .md files with rendered description