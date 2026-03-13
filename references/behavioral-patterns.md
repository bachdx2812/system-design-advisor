# Behavioral Patterns

## Overview
How objects communicate, delegate responsibilities, and coordinate — how control flows at runtime.

## Observer
- **Intent:** One-to-many dependency — when one object changes, all dependents are notified
- **Problem:** State change in one component triggers multiple unrelated actions
- **Solution:** Event bus + register/publish mechanism (pub/sub)
- **Go idiom:** Channels (idiomatic) or callback registry (synchronous):
  ```go
  type EventBus struct { subscribers map[string][]func(Event) }
  func (e *EventBus) Publish(topic string, event Event) { for _, fn := range e.subscribers[topic] { fn(event) } }
  ```
- **When to use:** Loose coupling, multiple reactions to single event, event-driven
- **When NOT:** Simple direct calls (unnecessary indirection), 1-to-1 communication
- **Real-world:** Webhooks, message queues, DOM events, React state

## Strategy
- **Intent:** Define family of algorithms, encapsulate each, make interchangeable
- **Problem:** Multiple algorithms for same operation, chosen at runtime
- **Solution:** Interface per algorithm, inject chosen strategy
- **Go idiom:** Function-typed fields or interface:
  ```go
  type Sorter func([]int) []int  // Strategy as function type
  func Process(data []int, sort Sorter) { sorted := sort(data) }
  ```
- **When to use:** Multiple implementations of same concept, runtime selection
- **When NOT:** Single algorithm that won't change — direct implementation is simpler
- **Real-world:** `sort.Interface`, payment processors, compression algorithms

## Command
- **Intent:** Encapsulate request as object — enables queuing, undo, logging
- **Problem:** Need to queue operations, undo/redo, decouple invoker from receiver
- **Solution:** Command interface with `Execute()` (and optionally `Undo()`)
- **When to use:** Task queues, undo/redo, macro recording, transaction logs
- **When NOT:** Simple function calls — Command adds unnecessary indirection
- **Real-world:** CLI subcommands (cobra), task queues, database migrations

## Chain of Responsibility
- **Intent:** Pass request along chain of handlers — each decides to handle or pass
- **Problem:** Multiple handlers, unknown which will process, order matters
- **Solution:** Handler interface with `next` field, forms processing chain
- **Go idiom:** Middleware pipelines:
  ```go
  type Middleware func(http.Handler) http.Handler
  // Chain: auth → rateLimit → logging → handler
  ```
- **When to use:** HTTP middleware, validation pipelines, approval workflows
- **When NOT:** Single handler needed or fixed sequence better as explicit calls
- **Real-world:** `net/http` middleware, input validation chains

## State
- **Intent:** Object behavior changes based on internal state
- **Problem:** Complex state-dependent logic with many conditionals
- **Solution:** State interface, separate struct per state, delegate behavior to current state
- **State transitions:** Each state knows valid next states
- **When to use:** Order lifecycle, circuit breakers, workflow engines, game AI
- **When NOT:** Simple if/else with 2-3 states — pattern adds overhead
- **Real-world:** TCP connection states, order processing, traffic lights

## Template Method
- **Intent:** Define algorithm skeleton, let subclasses fill in steps
- **Problem:** Algorithm steps are fixed but specific implementations vary
- **Solution:** Base with algorithm flow, abstract methods for variant steps
- **Go idiom:** Interface with required methods + helper function:
  ```go
  type DataExporter interface { FetchData() []Record; Transform(Record) string; Write(string) }
  func Export(e DataExporter) { for _, r := range e.FetchData() { e.Write(e.Transform(r)) } }
  ```
- **When to use:** Common algorithm with varying steps, data processing pipelines
- **When NOT:** Single-use code, all steps vary (just use Strategy)
- **Real-world:** `sort.Slice` (provide Less function), test frameworks

## Behavioral Pattern Selector

| Problem | Pattern | Signal |
|---------|---------|--------|
| Notify many on change | Observer | "When X happens, do A, B, C" |
| Swap algorithms | Strategy | "Use algorithm A or B depending on..." |
| Queue/undo operations | Command | "Execute later", "undo/redo" |
| Pipeline of handlers | Chain of Responsibility | Middleware, validation chain |
| Behavior depends on state | State | Complex state machine, lifecycle |
| Algorithm skeleton + variants | Template Method | Same flow, different steps |
