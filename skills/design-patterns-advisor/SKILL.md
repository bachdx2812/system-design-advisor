---
name: design-patterns-advisor
description: Answer questions about design patterns — GoF (creational, structural, behavioral), modern patterns, distributed patterns, and anti-patterns. Use when user asks about Factory, Observer, Strategy, CQRS, Saga, Singleton, Decorator, or any software design pattern. Helps select the right pattern for a given problem and explains tradeoffs.
version: 1.0.0
user-invocable: true
---

# Design Patterns Advisor

Answer design pattern questions using distilled knowledge from GoF, modern, and distributed pattern references.

## Step 0: Clarify Context (before answering)

If context is missing, ask 1-3 questions using `AskUserQuestion` tool:

| Missing Context | Question to Ask |
|----------------|----------------|
| Language unknown | "What language/framework are you using?" |
| Problem vague | "What specific problem are you trying to solve?" |
| Scale unclear | "Is this a single service, microservices, or distributed system?" |
| Comparing options | "Do you have existing code this pattern needs to fit into?" |

**Skip if:** Question is conceptual ("explain Observer pattern") or context is sufficient.

## Step 1: Answer with Structure

1. **Pattern name + intent** (one sentence)
2. **When to use / when NOT to use**
3. **Trade-off table** when comparing patterns
4. **Mermaid diagram** — always generate a class or sequence diagram showing pattern structure

### Mermaid Diagram (Required)

Always generate a Mermaid diagram appropriate to the pattern:
- **Structural/Creational patterns** → class diagram showing relationships
- **Behavioral patterns** → sequence diagram showing interactions
- **Distributed patterns** → flowchart or sequence showing data/event flow

```
classDiagram
    class Creator {
        +factoryMethod() Product
    }
    Creator <|-- ConcreteCreator
    Creator --> Product
    Product <|-- ConcreteProduct
```

## Step 2: Follow-up

Offer: "Want me to generate an implementation plan for this pattern in your codebase?" (bridges to pattern-implementation-guide).

## Topic Routing

| Pattern Category | Reference |
|-----------------|-----------|
| Factory, Abstract Factory, Builder, Prototype, Singleton | [creational-patterns.md](references/creational-patterns.md) |
| Adapter, Bridge, Composite, Decorator, Facade, Flyweight, Proxy | [structural-patterns.md](references/structural-patterns.md) |
| Chain of Responsibility, Command, Iterator, Mediator, Memento, Observer, State, Strategy, Template Method, Visitor | [behavioral-patterns.md](references/behavioral-patterns.md) |
| Repository, CQRS, Event Sourcing, Outbox, Saga, Circuit Breaker | [distributed-patterns.md](references/distributed-patterns.md) |
| Functional patterns, DI, Options, Plugin | [modern-patterns.md](references/modern-patterns.md) |
| Anti-patterns (God Object, Spaghetti), pattern selection guide | [anti-patterns-and-selection.md](references/anti-patterns-and-selection.md) |

## Response Format

```
## [Pattern Name]

**Intent:** [One sentence]

**Trade-offs:**
| Option | Pros | Cons |
|--------|------|------|

**When to use:** [Scenarios]
**When NOT to use:** [Anti-patterns]

**Structure:**
[Mermaid diagram]
```
