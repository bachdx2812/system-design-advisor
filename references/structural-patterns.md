# Structural Patterns

## Overview
How objects compose into larger structures while keeping flexibility. Key distinction: **Adapter** translates interfaces; **Decorator** adds behavior; **Proxy** controls access — all wrap objects but with different intent.

## Adapter
- **Intent:** Translate incompatible interface to expected one
- **Problem:** Third-party SDK has different interface than your code expects
- **Solution:** Wrapper struct implementing your interface, delegating to vendor
- **Go idiom:** Struct wrapping foreign type, implementing local interface
- **When to use:** Integrate third-party libraries, legacy system wrapping
- **When NOT:** Interfaces already compatible — just use directly
- **Real-world:** Payment gateway adapters (Stripe/PayPal → common PaymentProcessor)

## Decorator
- **Intent:** Add behavior to objects dynamically without changing structure
- **Problem:** Cross-cutting concerns (logging, auth, caching) duplicated everywhere
- **Solution:** Wrapper implementing same interface with additional behavior
- **Go idiom:** `func(Handler) Handler` middleware chains (most idiomatic):
  ```go
  func WithLogging(next http.Handler) http.Handler {
      return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
          log.Printf("%s %s", r.Method, r.URL)
          next.ServeHTTP(w, r)
      })
  }
  ```
- **When to use:** Cross-cutting concerns, optional features, stackable behaviors
- **When NOT:** Core responsibilities — use composition instead
- **Real-world:** HTTP middleware (auth → logging → CORS → handler)

## Facade
- **Intent:** Provide simplified interface to complex subsystem
- **Problem:** Client must coordinate multiple interdependent components
- **Solution:** Single struct orchestrating subsystem with simple methods
- **When to use:** Complex subsystems, unified API for library/package
- **When NOT:** Hiding complexity that callers need to understand
- **Real-world:** `database/sql` hides connection pooling, driver management

## Proxy
- **Intent:** Control/augment access to object without changing it
- **Three types:**
  - **Protection:** Access control (auth check before forwarding)
  - **Virtual:** Lazy loading expensive resources (connect to DB on first query)
  - **Logging:** Audit trail (record all method calls)
- **When to use:** Expensive resources, access control, instrumentation
- **When NOT:** Adding new functionality (use Decorator instead)
- **Real-world:** `httputil.ReverseProxy`, mock objects in tests

## Composite
- **Intent:** Treat individual objects and compositions uniformly (tree structures)
- **Problem:** Need recursive structures where leaf and container share interface
- **Solution:** Interface implemented by both Leaf and Composite (has children)
- **When to use:** File systems, UI component trees, org hierarchies, DOM
- **When NOT:** Leaf and composite need fundamentally different behavior
- **Real-world:** `io.MultiReader`, `io.MultiWriter`, file system APIs

## Bridge
- **Intent:** Separate abstraction from implementation — vary independently
- **Problem:** Cartesian explosion of classes (3 shapes x 4 renderers = 12 classes)
- **Solution:** Abstraction holds interface field → swap implementations
- **Go idiom:** Struct with interface field (natural composition):
  ```go
  type Notification struct { sender Sender }  // Bridge
  type Sender interface { Send(msg string) }  // Implementation
  ```
- **When to use:** Multi-dimensional variation, runtime implementation swap
- **When NOT:** Single dimension of variation — simple interface suffices
- **Real-world:** `database/sql` (Driver interface), `io.Writer` abstraction

## Structural Pattern Selector

| Problem | Pattern | Signal |
|---------|---------|--------|
| Incompatible interface | Adapter | "Need to make X work with Y" |
| Add behavior dynamically | Decorator | Logging, auth, caching wrappers |
| Simplify complex API | Facade | "Too many classes to coordinate" |
| Control access | Proxy | Lazy load, auth gate, audit log |
| Tree/recursive structure | Composite | Files/folders, UI components |
| Vary 2 dimensions independently | Bridge | Shape x Renderer, Notification x Channel |
