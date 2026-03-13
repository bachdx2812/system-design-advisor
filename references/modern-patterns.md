# Modern Application Patterns

## Overview
Production-level patterns addressing real-world challenges: testability, failure resilience, cross-cutting concerns.

## Repository
- **Intent:** Abstract data access behind interface — decouple business logic from DB
- **Solution:** Interface with `Find/Create/Update/Delete` → implementations (Postgres, Mongo, InMemory)
  ```go
  type UserRepository interface {
      FindByID(ctx context.Context, id string) (*User, error)
      Create(ctx context.Context, user *User) error
  }
  ```
- **When to use:** Every production app with data layer
- **Combines with:** DI (inject repo into services)

## Dependency Injection (DI)
- **Intent:** Pass dependencies in rather than creating internally
- **Solution:** Constructor injection — pass interfaces, not concrete types
  ```go
  func NewOrderService(repo OrderRepository, notifier Notifier) *OrderService {
      return &OrderService{repo: repo, notifier: notifier}
  }
  ```
- **Go frameworks:** Google Wire (compile-time), Uber fx (runtime)
- **When to use:** Always — foundational to testable code

## Middleware / Pipeline
- **Intent:** Composable chain of handlers for cross-cutting concerns
- **Solution:** `handler := WithAuth(WithLogging(WithRateLimit(actualHandler)))`
- **When to use:** Auth, logging, rate limiting, CORS
- **Real-world:** `net/http`, gin/echo/chi frameworks, gRPC interceptors

## Circuit Breaker
- **Intent:** Prevent cascading failures by failing fast when downstream is unhealthy
- **States:** Closed (normal) → Open (fail fast) → Half-Open (probe single request)
- **When to use:** Any external service dependency, database connections, API calls
- **Real-world:** `gobreaker`, Hystrix, Resilience4j

## Retry with Backoff
- **Intent:** Automatically recover from transient failures
- **Algorithm:** `delay = min(base * 2^attempt + random_jitter, max_delay)`
- **Requirements:** Operation MUST be idempotent; distinguish retryable vs permanent errors
- **When NOT:** Non-idempotent ops (double-charge risk), permanent errors (404, auth fail)

## Plugin Architecture
- **Intent:** Allow third-party extensions without modifying core — registry + lifecycle hooks
- **Components:** Plugin registry | API surface | lifecycle hooks (load/activate/dispose) | sandboxing
- **Extension points:** Commands, UI elements, event listeners, middleware
- **Real-world:** VS Code extensions, webpack loaders, ESLint rules
- Go: `type Plugin interface { Name() string; Activate(api HostAPI); Deactivate() }`

## Functional Composition
- **Intent:** Build complex transforms from simple, composable functions
- **pipe:** left-to-right `pipe(f, g, h)(x)` = `h(g(f(x)))`
- **Result/Either:** monadic error handling — chain operations without try/catch
- **Partial application/currying:** pre-bind args for reuse
- **When to use:** Data pipelines, validation chains, error propagation
- Example: `pipe := Pipe(validate, enrich, transform, save); result := pipe(input)`

## Feature Flags
- **Intent:** Strategy pattern where flag determines active strategy at runtime
- **Types:** Boolean | Percentage rollout | User-segment | A/B test
- **Decouples:** Deploy from release — ship dark, enable gradually
- **Real-world:** LaunchDarkly, Unleash, Split.io
- Example: `if flags.IsEnabled("new-checkout", user) { newCheckout(cart) } else { oldCheckout(cart) }`

## Pattern Combinations

| Combination | Purpose |
|-------------|---------|
| Repository + DI | Testable data access |
| Circuit Breaker + Retry | Resilient external calls |
| Middleware + Decorator | Composable request processing |
| Feature Flags + Strategy | Runtime behavior selection |

## Modern Patterns Decision Guide

| Problem | Pattern | Signal |
|---------|---------|--------|
| DB queries in business logic | Repository | SQL in service methods |
| Hard to unit test | DI | `new` inside methods |
| Duplicated cross-cutting logic | Middleware | Auth/logging in every handler |
| Downstream service failures | Circuit Breaker | Cascading timeouts |
| Transient network errors | Retry + Backoff | Intermittent 503/timeout |
| Third-party extensibility | Plugin Architecture | Extension points needed |
| Complex data transforms | Functional Composition | Pipeline of operations |
| Gradual feature rollout | Feature Flags | Dark launch, A/B test |
