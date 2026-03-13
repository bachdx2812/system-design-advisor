---
name: code-pattern-reviewer
description: Review code for design pattern usage, anti-pattern violations, and improvement opportunities. Use when user wants code reviewed for patterns, asks "is this good design?", "what pattern should I use here?", or "review my code structure". Auto-scans project files and identifies pattern opportunities with severity ratings.
version: 1.0.0
user-invocable: true
allowed-tools: Read, Grep, Glob, Bash
---

# Code Pattern Reviewer

Review project code for design pattern usage, anti-patterns, and improvement opportunities.

**Context awareness:** If prior skill output is visible in conversation (design plan, advisor recommendations), reference it when presenting findings — connect your review to prior advice.

## Auto-Scan Process

1. **Discover project structure** — scan for source files, identify language and framework
2. **Find pattern violations** — search for known anti-pattern signatures (God Objects, Spaghetti, Golden Hammer, etc.)
3. **Identify improvement opportunities** — find repeated conditional logic, tight coupling, large classes/files
4. **Load relevant references** — pull from `references/` based on findings

### Anti-Pattern Detection Signals

| Signal | Grep Target | Anti-Pattern |
|--------|------------|--------------|
| Files >200 lines | File size scan | God Object |
| Repeated switch/if on type | `switch.*type`, `if.*instanceof` | Missing polymorphism → Factory/Strategy |
| Direct `new` in business logic | `new ` in service files | Missing Factory/DI |
| Deep nesting >4 levels | Indentation analysis | Spaghetti → Chain of Responsibility |
| Shared mutable state | Global variables, singletons everywhere | Golden Hammer (Singleton) |
| Scattered error handling | `try/catch` without pattern | Missing Chain of Responsibility |
| Tight service coupling | Direct imports across bounded contexts | Missing Facade/Mediator |
| Circular imports | Dependency analysis | Circular dependency → Mediator/DI |
| Empty catch blocks | `catch.*\{\s*\}` | Missing error handling pattern |
| Shared DB across services | Cross-service DB imports | Missing Database per Service |

## Reference Routing

Load references based on findings:

| Finding | Reference |
|---------|-----------|
| Object creation issues | [creational-patterns.md](references/creational-patterns.md) |
| Structural coupling | [structural-patterns.md](references/structural-patterns.md) |
| Behavioral complexity | [behavioral-patterns.md](references/behavioral-patterns.md) |
| Distributed system issues | [distributed-patterns.md](references/distributed-patterns.md) |
| Anti-patterns detected | [anti-patterns-and-selection.md](references/anti-patterns-and-selection.md) |
| Modern idiom improvements | [modern-patterns.md](references/modern-patterns.md) |

## Output Format

```
## Code Pattern Review: [Project/File]

### Findings

| # | Severity | Anti-Pattern / Issue | Location | Pattern Suggestion |
|---|----------|---------------------|----------|--------------------|
| 1 | Critical  | God Object (450 lines, 20+ methods) | `src/services/AppService.ts:1` | Split → Facade + focused services |
| 2 | High      | Repeated type switch | `src/factory/createWidget.ts:34` | Factory Method |
| 3 | Medium    | Direct `new` in handler | `src/handlers/order.ts:12` | Dependency Injection |
| 4 | Low       | Missing error boundary | `src/api/routes.ts` | Chain of Responsibility |

### Positive Patterns Found
- [List well-applied patterns]

### Top 3 Recommended Refactors
1. **[Pattern]** at `[location]` — [one-line rationale]
2. ...
3. ...

### Effort Estimate
| Refactor | Estimated Effort | Impact |
|----------|-----------------|--------|
| ... | Low/Med/High | Low/Med/High |
```

Severity levels: **Critical** (blocks scalability/maintainability), **High** (significant tech debt), **Medium** (code smell), **Low** (style/minor improvement).

## Follow-up Bridges
After presenting findings, offer: "Want me to explain any of these patterns in detail? (`/design-patterns-advisor`) Or generate an implementation plan for a specific refactor? (`/pattern-implementation-guide`)"
