# Anti-Patterns & Pattern Selection Guide

## 5 Common Anti-Patterns

### 1. God Object / Blob
- **Symptoms:** 500+ line file, 15+ fields, 30+ methods, imports half the project
- **Fix:** Split by Single Responsibility. Use Facade if single entry point needed.
- **Example:** `AppManager` doing auth+payments+email → UserService + PaymentService + NotificationService

### 2. Spaghetti Code
- **Symptoms:** Control flow is a maze, no clear structure, circular dependencies
- **Fix:** Mediator pattern + layered architecture, clear dependency direction

### 3. Golden Hammer
- **Symptoms:** Forcing same pattern everywhere ("everything is a Singleton")
- **Fix:** Problem-first approach. Match pattern to problem, not problem to pattern. YAGNI.

### 4. Cargo Cult Programming
- **Symptoms:** Implementing patterns without understanding why, copying blindly
- **Fix:** Always articulate the problem first. Pattern names are communication tools, not requirements.

### 5. Premature Optimization
- **Symptoms:** Complex caching/indexing before bottleneck identified
- **Fix:** KISS principle. Profile first, optimize proven hotspots. Simple code > clever code.

## Pattern Decision Matrix

### By Problem Category

| Problem | First Choice | Alternative |
|---------|-------------|-------------|
| **Object creation** | | |
| Multiple types, one interface | Factory Method | Abstract Factory (if families) |
| Many optional params | Builder / Functional Options | — |
| Single shared resource | DI (preferred) | Singleton (if truly global) |
| **Structure** | | |
| Incompatible interface | Adapter | — |
| Add behavior dynamically | Decorator / Middleware | — |
| Simplify complex API | Facade | — |
| Control access to resource | Proxy | — |
| Tree/recursive structure | Composite | — |
| **Communication** | | |
| Notify many on change | Observer / Event Bus | — |
| Swap algorithms at runtime | Strategy | — |
| Queue / undo operations | Command | — |
| Pipeline of handlers | Chain of Responsibility | Middleware |
| Complex state transitions | State | — |
| **Distributed** | | |
| Read/write model split | CQRS | — |
| Audit trail needed | Event Sourcing | — |
| Multi-service transaction | Saga | 2PC (if strong consistency) |
| Legacy migration | Strangler Fig | — |
| Cross-cutting infra | Sidecar / Middleware | — |

### By Code Smell

| Code Smell | Suggested Pattern |
|-----------|------------------|
| Giant switch on type | Factory Method or Strategy |
| Constructor with 5+ params | Builder / Functional Options |
| Same wrapper logic everywhere | Decorator / Middleware |
| Direct DB calls in business logic | Repository + DI |
| Cascading service failures | Circuit Breaker + Retry |
| God class doing everything | Split + Facade |
| Copy-paste across handlers | Template Method or Strategy |
| Tightly coupled components | Observer / Event Bus |
| Complex if/else on state | State pattern |

## Go-Specific Pattern Idioms

| GoF Pattern | Go Idiom |
|-------------|----------|
| Singleton | `sync.Once` + DI (prefer DI) |
| Builder | Functional options: `NewX(opts ...Option)` |
| Decorator | `func(Handler) Handler` middleware |
| Observer | Channels for async, callbacks for sync |
| Strategy | Function types: `type Sorter func([]int) []int` |
| Iterator | `for range` + custom iterators |
| Template Method | Interface + helper function |

## Pattern Combinations That Work

| Combination | Why |
|-------------|-----|
| Repository + DI | Testable data access (inject mock repo) |
| Strategy + Factory | Create correct algorithm by type |
| Circuit Breaker + Retry | Resilient with automatic recovery |
| CQRS + Event Sourcing | Events sync read/write models |
| Decorator + Composite | Recursive decorated structures |
| Middleware + Chain of Resp | HTTP request pipeline |
| Strangler Fig + Facade | Legacy migration with routing |

## 27-Pattern Quick Reference

| # | Pattern | Category | One-Line Intent |
|---|---------|----------|----------------|
| 1 | Factory Method | Creational | Delegate creation to subtypes |
| 2 | Abstract Factory | Creational | Create related object families |
| 3 | Builder | Creational | Step-by-step complex construction |
| 4 | Singleton | Creational | Single instance (prefer DI) |
| 5 | Prototype | Creational | Clone existing objects |
| 6 | Adapter | Structural | Translate incompatible interfaces |
| 7 | Decorator | Structural | Add behavior dynamically |
| 8 | Facade | Structural | Simplify complex subsystem |
| 9 | Proxy | Structural | Control access to object |
| 10 | Composite | Structural | Treat tree uniformly |
| 11 | Bridge | Structural | Separate abstraction from implementation |
| 12 | Observer | Behavioral | Notify dependents on change |
| 13 | Strategy | Behavioral | Swap algorithms at runtime |
| 14 | Command | Behavioral | Encapsulate request as object |
| 15 | Chain of Resp | Behavioral | Pass request along handler chain |
| 16 | State | Behavioral | Behavior changes with state |
| 17 | Template Method | Behavioral | Algorithm skeleton with variant steps |
| 18 | Repository | Modern | Abstract data access |
| 19 | Dependency Injection | Modern | Pass dependencies in |
| 20 | Middleware | Modern | Composable request pipeline |
| 21 | Circuit Breaker | Modern | Fail fast on downstream failure |
| 22 | Retry + Backoff | Modern | Recover from transient failures |
| 23 | CQRS | Distributed | Separate read/write models |
| 24 | Event Sourcing | Distributed | Append-only event log |
| 25 | Saga | Distributed | Distributed transactions |
| 26 | Strangler Fig | Distributed | Incremental migration |
| 27 | Sidecar | Distributed | Infrastructure helper process |
