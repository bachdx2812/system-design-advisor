# Modern Application Patterns

## Overview
Production-level patterns addressing real-world challenges: testability, failure resilience, cross-cutting concerns. These are not academic — used every week in production.

## Repository
- **Intent:** Abstract data access behind interface — decouple business logic from DB
- **Problem:** SQL queries scattered through business logic, untestable, DB-specific
- **Solution:** Interface with `Find`, `Create`, `Update`, `Delete` → implementations (Postgres, Mongo, InMemory)
  ```go
  type UserRepository interface {
      FindByID(ctx context.Context, id string) (*User, error)
      Create(ctx context.Context, user *User) error
  }
  type postgresUserRepo struct { db *sql.DB }  // Production
  type inMemoryUserRepo struct { users map[string]*User }  // Testing
  ```
- **When to use:** Every production app with data layer (not optional)
- **When NOT:** Never skip — Repository is standard practice
- **Combines with:** DI (inject repo into services), Strategy (swap DB implementations)

## Dependency Injection (DI)
- **Intent:** Pass dependencies in rather than creating them internally
- **Problem:** Services create own dependencies → tight coupling, untestable
- **Solution:** Constructor injection — pass interfaces, not concrete types
  ```go
  func NewOrderService(repo OrderRepository, notifier Notifier) *OrderService {
      return &OrderService{repo: repo, notifier: notifier}
  }
  ```
- **Go frameworks:** Google Wire (compile-time), Uber fx (runtime)
- **When to use:** Always — DI is foundational to testable code
- **When NOT:** Never skip DI. Even simple apps benefit from it
- **Test benefit:** Pass mock/stub implementations for unit testing

## Middleware / Pipeline
- **Intent:** Composable chain of handlers for cross-cutting concerns
- **Problem:** Auth, logging, rate limiting duplicated across handlers
- **Solution:** `func(Handler) Handler` wrapping pattern, stackable
  ```go
  handler := WithAuth(WithLogging(WithRateLimit(actualHandler)))
  ```
- **Types:** HTTP middleware, message processing pipelines, validation chains
- **When to use:** Auth, logging, rate limiting, request transformation, CORS
- **When NOT:** Single-use logic (indirection without benefit)
- **Real-world:** `net/http` middleware, gin/echo/chi frameworks, gRPC interceptors

## Circuit Breaker
- **Intent:** Prevent cascading failures by failing fast when downstream is unhealthy
- **States:** Closed (normal) → Open (fail fast, no requests sent) → Half-Open (probe with single request)
- **Thresholds:** Configure failure count/rate to trip, timeout before probing, success count to close
- **When to use:** Any external service dependency, database connections, API calls
- **When NOT:** In-process calls where failure is immediate
- **Combines with:** Retry (retry inside closed state, circuit breaks after threshold)
- **Real-world:** `gobreaker` library, Hystrix, Resilience4j

## Retry with Backoff
- **Intent:** Automatically recover from transient failures
- **Algorithm:** Exponential backoff + jitter to avoid thundering herd
  ```
  delay = min(base * 2^attempt + random_jitter, max_delay)
  ```
- **Requirements:** Operation MUST be idempotent, distinguish retryable vs permanent errors
- **When to use:** Network calls, external service integration, flaky dependencies
- **When NOT:** Non-idempotent operations (double-charge risk), permanent errors (404, auth failure)
- **Combines with:** Circuit Breaker (retry inside, break after threshold)

## Pattern Combinations

| Combination | Purpose | Example |
|-------------|---------|---------|
| Repository + DI | Testable data access | Inject mock repo in unit tests |
| Strategy + Factory | Configurable algorithms | Payment processor selection |
| Circuit Breaker + Retry | Resilient external calls | API client with backoff |
| Middleware + Decorator | Composable request processing | HTTP middleware stack |
| Observer + Command | Event-driven task execution | Event bus + command queue |

## Modern Patterns Decision Guide

| Problem | Pattern | Signal |
|---------|---------|--------|
| DB queries in business logic | Repository | SQL in service methods |
| Hard to unit test | DI | `new` or `init` inside methods |
| Duplicated cross-cutting logic | Middleware | Auth/logging in every handler |
| Downstream service failures | Circuit Breaker | Cascading timeouts |
| Transient network errors | Retry + Backoff | Intermittent 503/timeout |
