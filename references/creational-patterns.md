# Creational Patterns

## Overview
Control object creation — hide complexity, enforce constraints, improve flexibility.

## Factory Method
- **Intent:** Delegate object creation to subtypes via factory function
- **Problem:** Adding new types requires modifying dispatch code (switch/if chains)
- **Solution:** Interface + concrete factories per type
- **Go idiom:** `func NewX(type string) Interface` or `sql.Open("postgres", dsn)`
- **When to use:** Multiple variants, anticipate new types
- **When NOT:** 1-2 types that won't change, trivial construction
- **Related:** Abstract Factory (families), Builder (complex construction)

## Abstract Factory
- **Intent:** Create families of related objects without specifying concrete classes
- **Problem:** Need consistent families (e.g., light/dark UI themes with matching buttons, inputs, dialogs)
- **Solution:** Factory interface producing entire families
- **Go idiom:** Composition + functional options (no class hierarchies)
- **When to use:** Product families must stay consistent, swap families at runtime
- **When NOT:** Single concrete type, composition works fine

## Builder
- **Intent:** Construct complex objects step-by-step with fluent interface
- **Problem:** Constructors with 5+ parameters, many optional, complex validation
- **Solution:** Separate builder with chainable methods + `Build()` final call
- **Go idiom:** Functional options pattern (preferred):
  ```go
  func NewServer(addr string, opts ...Option) *Server
  type Option func(*Server)
  func WithTimeout(d time.Duration) Option { return func(s *Server) { s.timeout = d } }
  ```
- **When to use:** 3+ optional params, complex initialization, different representations
- **When NOT:** Simple structs with few fields — direct initialization is cleaner

## Singleton
- **Intent:** Ensure single instance with global access point
- **Problem:** Shared resources (logger, connection pool, config) need single instance
- **Solution:** Private constructor + static getter with lazy init
- **Go idiom:** `sync.Once` for thread-safe lazy initialization:
  ```go
  var instance *DB
  var once sync.Once
  func GetDB() *DB { once.Do(func() { instance = &DB{} }); return instance }
  ```
- **When to use:** Connection pools, loggers, truly global config
- **When NOT:** Most code — global mutable state is hard to test. **Use DI instead**

## Prototype
- **Intent:** Create copies of existing objects (deep clone)
- **Problem:** Complex object construction when similar objects exist
- **Solution:** `Clone()` method implementing deep copy
- **Go idiom:** Rarely needed — value types copy naturally, use copy constructors
- **When to use:** Expensive initialization, object templates, undo snapshots
- **When NOT:** Simple objects, Go value semantics handle copying

## Decision Guide

| Problem | Pattern | Signal |
|---------|---------|--------|
| Multiple types, one interface | Factory Method | `switch` on type in creation code |
| Related object families | Abstract Factory | Inconsistent UI/config themes |
| Many optional params | Builder / Functional Options | Constructor with 5+ params |
| Single shared resource | Singleton (or DI) | Global state, connection pools |
| Copy existing objects | Prototype | Expensive init, need snapshots |
