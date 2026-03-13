# Anti-Patterns & Pattern Selection Guide

## 5 Common Anti-Patterns

| Anti-Pattern | Symptoms | Fix |
|-------------|---------|-----|
| **God Object** | 500+ line file, 15+ fields, 30+ methods | Split by SRP; Facade if single entry point needed |
| **Spaghetti Code** | Maze control flow, circular dependencies | Mediator + layered architecture |
| **Golden Hammer** | Forcing same pattern everywhere | Problem-first. Match pattern to problem. YAGNI. |
| **Cargo Cult** | Patterns without understanding why | Articulate the problem first |
| **Premature Optimization** | Complex caching before bottleneck identified | Profile first, KISS |

## Pattern Decision Matrix

| Problem | First Choice | Alternative |
|---------|-------------|-------------|
| Multiple types, one interface | Factory Method | Abstract Factory (families) |
| Many optional params | Builder / Functional Options | — |
| Single shared resource | DI (preferred) | Singleton |
| Incompatible interface | Adapter | — |
| Add behavior dynamically | Decorator / Middleware | — |
| Control access to resource | Proxy | — |
| Tree/recursive structure | Composite | — |
| Notify many on change | Observer / Event Bus | — |
| Swap algorithms at runtime | Strategy | — |
| Queue / undo operations | Command | — |
| Complex state transitions | State | — |
| Read/write model split | CQRS | — |
| Multi-service transaction | Saga | 2PC (strong consistency) |
| Legacy migration | Strangler Fig | — |

## By Code Smell

| Code Smell | Suggested Pattern | Fix |
|-----------|------------------|-----|
| Giant switch on type | Factory Method or Strategy | — |
| Constructor with 5+ params | Builder / Functional Options | — |
| Same wrapper logic everywhere | Decorator / Middleware | — |
| Direct DB calls in business logic | Repository + DI | — |
| Cascading service failures | Circuit Breaker + Retry | — |
| God class doing everything | Split + Facade | — |
| Copy-paste across handlers | Template Method or Strategy | — |
| Tightly coupled components | Observer / Event Bus | — |
| Complex if/else on state | State pattern | — |
| Empty catch blocks | Result type / error boundary | Missing error handling pattern |
| Shared DB across services | Database per Service + events | Remove cross-service DB coupling |
| 500+ line component | Custom hooks + composition | Split by SRP |
| Copied logic 10+ places | Template Method / shared middleware | DRY |

## Go-Specific Pattern Idioms

| GoF Pattern | Go Idiom |
|-------------|----------|
| Singleton | `sync.Once` + DI (prefer DI) |
| Builder | Functional options: `NewX(opts ...Option)` |
| Decorator | `func(Handler) Handler` middleware |
| Observer | Channels (async), callbacks (sync) |
| Strategy | Function types: `type Sorter func([]int) []int` |
| Iterator | `for range` + custom iterators |
| Template Method | Interface + helper function |

## Pattern Combinations That Work

| Combination | Why |
|-------------|-----|
| Repository + DI | Testable data access |
| Strategy + Factory | Create correct algorithm by type |
| Circuit Breaker + Retry | Resilient with automatic recovery |
| CQRS + Event Sourcing | Events sync read/write models |
| Middleware + Chain of Resp | HTTP request pipeline |
| Strangler Fig + Facade | Legacy migration with routing |
| Bulkhead + Circuit Breaker | Defense in depth for resilience |
