# Behavioral Patterns

## Overview
How objects communicate, delegate responsibilities, and coordinate — how control flows at runtime.

## Observer
- **Intent:** One-to-many dependency — when one object changes, all dependents notified
- **Go idiom:** Channels or callback registry
- **TS:** `type Listener<T> = (event: T) => void` / `class EventEmitter<T> { private ls: Listener<T>[] = []; on(l: Listener<T>) { this.ls.push(l) } emit(e: T) { this.ls.forEach(l => l(e)) } }`
- **When to use:** Loose coupling, multiple reactions to single event, event-driven
- **Real-world:** Webhooks, message queues, DOM events, React state

## Strategy
- **Intent:** Define family of algorithms, encapsulate each, make interchangeable
- **Go idiom:** `type Sorter func([]int) []int` or interface
- **TS:** `type PaymentStrategy = (amount: number) => Promise<Receipt>` / `const stripe: PaymentStrategy = async (amt) => stripeApi.charge(amt)`
- **When to use:** Multiple implementations of same concept, runtime selection
- **Real-world:** `sort.Interface`, payment processors, compression algorithms

## Command
- **Intent:** Encapsulate request as object — enables queuing, undo, logging
- **TS:** `interface Command { execute(): void; undo(): void }` / `class AddTextCmd implements Command { constructor(private doc: Doc, private text: string, private prev = '') {} execute() { this.prev = this.doc.content; this.doc.content += this.text } undo() { this.doc.content = this.prev } }`
- **When to use:** Task queues, undo/redo, macro recording, transaction logs
- **Real-world:** CLI subcommands (cobra), task queues, database migrations
  ```go
  type Command interface { Execute(); Undo() }
  type AddTextCmd struct { doc *Doc; text string; prev string }
  func (c *AddTextCmd) Execute() { c.prev = c.doc.Content; c.doc.Content += c.text }
  func (c *AddTextCmd) Undo() { c.doc.Content = c.prev }
  ```

## Chain of Responsibility
- **Intent:** Pass request along chain of handlers — each decides to handle or pass
- **Go idiom:** `type Middleware func(http.Handler) http.Handler`
- **When to use:** HTTP middleware, validation pipelines, approval workflows
- **Real-world:** `net/http` middleware, input validation chains

## State
- **Intent:** Object behavior changes based on internal state
- **When to use:** Order lifecycle, circuit breakers, workflow engines, game AI
- **Real-world:** TCP connection states, order processing, traffic lights

## Template Method
- **Intent:** Define algorithm skeleton, let subclasses fill in steps
- **Go idiom:** Interface with required methods + helper function
- **When to use:** Common algorithm with varying steps, data processing pipelines
- **Real-world:** `sort.Slice`, test frameworks

## Memento
- **Intent:** Capture/restore object state without exposing internals
- **Components:** Originator (creates/restores), Memento (snapshot), Caretaker (stores history)
- **When to use:** Undo/redo, checkpoints, state rollback
- Go: `type Memento struct { state string }` / `func (o *Originator) Save() Memento { return Memento{o.state} }`

## Mediator
- **Intent:** Centralize object communication — reduce many-to-many to many-to-one
- **Real-world:** Chat room, Redux store, air traffic control
- **When to use:** Many-to-many component interactions, decoupling peers
- Go: `type Mediator interface { Notify(sender Component, event string) }` / `func (m *ChatRoom) Notify(s Component, e string) { for _, p := range m.peers { p.Receive(e) } }`

## Iterator
- **Intent:** Traverse collection without exposing internals
- **Go idiom:** `for range`, custom iterators with channels
- **When to use:** Custom collection traversal, lazy sequences
- Go: `func (c *Collection) Iter() <-chan Item { ch := make(chan Item); go func() { for _, v := range c.items { ch <- v }; close(ch) }(); return ch }`

## Visitor
- **Intent:** Add operations to object structure without modifying classes
- **When to use:** Compiler AST traversal, document export formats, reporting
- Go: `type Visitor interface { VisitFile(*File); VisitDir(*Dir) }` / `func (f *File) Accept(v Visitor) { v.VisitFile(f) }`

## Behavioral Pattern Selector

| Problem | Pattern | Signal |
|---------|---------|--------|
| Notify many on change | Observer | "When X happens, do A, B, C" |
| Swap algorithms | Strategy | "Use algorithm A or B depending on..." |
| Queue/undo operations | Command | "Execute later", "undo/redo" |
| Pipeline of handlers | Chain of Responsibility | Middleware, validation chain |
| Behavior depends on state | State | Complex state machine, lifecycle |
| Algorithm skeleton + variants | Template Method | Same flow, different steps |
| Save/restore state | Memento | Undo/redo, checkpoints |
| Reduce peer coupling | Mediator | Many-to-many interactions |
| Traverse collection | Iterator | Custom collection, lazy seq |
| Add ops without modifying | Visitor | AST, document processing |
