# Structural Patterns

## Overview
How objects compose into larger structures while keeping flexibility. Key distinction: **Adapter** translates interfaces; **Decorator** adds behavior; **Proxy** controls access — all wrap objects but with different intent.

## Adapter
- **Intent:** Translate incompatible interface to expected one
- **Go idiom:** Struct wrapping foreign type, implementing local interface
- **When to use:** Integrate third-party libraries, legacy system wrapping
- **Real-world:** Payment gateway adapters (Stripe/PayPal → common PaymentProcessor)

## Decorator
- **Intent:** Add behavior to objects dynamically without changing structure
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
- **Real-world:** HTTP middleware (auth → logging → CORS → handler)

## Facade
- **Intent:** Provide simplified interface to complex subsystem
- **When to use:** Complex subsystems, unified API for library/package
- **Real-world:** `database/sql` hides connection pooling, driver management

## Proxy
- **Intent:** Control/augment access to object without changing it
- **Three types:** Protection (auth check) | Virtual (lazy load) | Logging (audit trail)
- **When to use:** Expensive resources, access control, instrumentation
- **Real-world:** `httputil.ReverseProxy`, mock objects in tests

## Composite
- **Intent:** Treat individual objects and compositions uniformly (tree structures)
- **Solution:** Interface implemented by both Leaf and Composite:
  ```go
  type Component interface { Operation() string }
  type Leaf struct { Name string }
  type Composite struct { Children []Component }
  ```
- **When to use:** File systems, UI component trees, org hierarchies, DOM
- **Real-world:** `io.MultiReader`, `io.MultiWriter`

## Bridge
- **Intent:** Separate abstraction from implementation — vary independently
- **Problem:** Cartesian explosion (3 shapes x 4 renderers = 12 classes)
- **Go idiom:** `type Notification struct { sender Sender }` — struct with interface field
- **When to use:** Multi-dimensional variation, runtime implementation swap
- **Real-world:** `database/sql` Driver interface, `io.Writer` abstraction

## Flyweight
- **Intent:** Share common state to reduce memory for large numbers of similar objects
- **Intrinsic state:** shared (font, color, tile type) | **Extrinsic state:** unique per instance
- **When to use:** Thousands of similar objects with shared properties
- **Real-world:** Game tiles, character glyphs, cached DB connections, string interning
- Go: `type FlyweightFactory struct { cache map[string]*Flyweight }` / `func (f *FlyweightFactory) Get(key string) *Flyweight { if fw, ok := f.cache[key]; ok { return fw }; fw := &Flyweight{key}; f.cache[key] = fw; return fw }`

## Structural Pattern Selector

| Problem | Pattern | Signal |
|---------|---------|--------|
| Incompatible interface | Adapter | "Need to make X work with Y" |
| Add behavior dynamically | Decorator | Logging, auth, caching wrappers |
| Simplify complex API | Facade | "Too many classes to coordinate" |
| Control access | Proxy | Lazy load, auth gate, audit log |
| Tree/recursive structure | Composite | Files/folders, UI components |
| Vary 2 dimensions independently | Bridge | Shape x Renderer, Notification x Channel |
| Thousands of similar objects | Flyweight | Game entities, cached instances |
