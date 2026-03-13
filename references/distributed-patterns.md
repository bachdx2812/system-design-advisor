# Distributed System Patterns

## Overview
Managing failure gracefully across multiple services with distributed data and eventual consistency. Every pattern answers: "What happens when part of the system breaks?"

## CQRS
- **Intent:** Separate write model (normalized) from read model (denormalized)
- **Sync mechanism:** Event bus propagates write events → read model updaters
- **Trade-off:** Read performance vs model sync complexity + eventual consistency
- **When to use:** Read/write load imbalance (100:1+), complex denormalization needed
- **Combines with:** Event Sourcing (events as sync mechanism)

## Event Sourcing
- **Intent:** Store state as append-only event sequence, reconstruct by replay
- **Key components:** Event store (immutable) | Snapshots (every N events) | Projections (read views) | Event versioning
- **Trade-off:** Full audit trail + temporal queries vs replay cost + complexity
- **When to use:** Audit requirements (finance, healthcare), temporal queries, undo/redo
- **Real-world:** Banking ledgers, event-driven microservices, Git

## Saga
- **Intent:** Manage distributed transactions across services without 2PC
- **Choreography:** Services react to events (decentralized, hard to track)
- **Orchestration:** Central coordinator (easier to reason, single point of failure)
- **Compensating transactions:** Undo on failure (e.g., refund if shipping fails)
- **TS:** `class OrderSaga { async run(order: Order) { await paymentSvc.charge(order); await inventorySvc.reserve(order); await shippingSvc.ship(order) } async compensate(order: Order) { await shippingSvc.cancel(order); await inventorySvc.release(order); await paymentSvc.refund(order) } }`
- **When to use:** Multi-service workflows, eventual consistency acceptable
- **Real-world:** Order processing (order → payment → inventory → shipping)

## Strangler Fig
- **Intent:** Incrementally migrate legacy system without downtime
- **Stages:** Identify boundaries → Routing facade → Parallel running → Retire legacy
- **Trade-off:** Safety + zero downtime vs maintaining two systems temporarily
- **When to use:** Legacy to microservices migration

## Sidecar
- **Intent:** Attach helper process to main service for cross-cutting infrastructure concerns
- **Handles:** Logging, metrics, mTLS, config reload, circuit breaking
- **Trade-off:** Separation of concerns vs extra process per service overhead
- **Real-world:** Envoy proxy (Istio), Kubernetes sidecar containers, Dapr

## Outbox
- **Intent:** Reliably publish events without dual-write problem
- **How:** Write event to outbox table in same DB transaction as state change; CDC/poller publishes to broker
- **vs direct publish:** Reliable (no lost events) but slightly higher latency
- **When to use:** Any service publishing events alongside DB writes
- SQL: `INSERT INTO outbox(event_type, payload) VALUES(...) -- same tx as business write`
- **TS:** `async createOrder(order: Order) { await db.transaction(tx => { tx.insert('orders', order); tx.insert('outbox', { type: 'OrderCreated', payload: order }) }) }`

## Anti-Corruption Layer (ACL)
- **Intent:** Translation layer between legacy and new domain models — prevent legacy concepts leaking in
- **Components:** Facade + Adapter + Translator
- **When to use:** Integrating legacy systems, bounded context boundaries in DDD
- Go: `type LegacyAdapter struct { legacy LegacyAPI }` / `func (a *LegacyAdapter) GetUser() User { return translate(a.legacy.FetchRecord()) }`

## Bulkhead
- **Intent:** Isolate failure domains with separate resource pools per dependency
- **Types:** Thread pool isolation | Semaphore isolation | Process isolation
- **When to use:** Prevent one slow dependency from exhausting all resources
- **Combines with:** Circuit Breaker (Bulkhead isolates; Circuit Breaker trips)
- Go: `paymentPool := semaphore.NewWeighted(10); searchPool := semaphore.NewWeighted(20) // separate limits per dep`

## Distributed Patterns Decision Guide

| Problem | Pattern | Signal |
|---------|---------|--------|
| Read/write model mismatch | CQRS | 100:1 read:write ratio |
| Need audit trail / history | Event Sourcing | "What was state at time X?" |
| Multi-service transaction | Saga | Order spanning payment+inventory |
| Legacy migration | Strangler Fig | "Rewrite without downtime" |
| Cross-cutting infra concerns | Sidecar | Polyglot services, service mesh |
| Dual-write problem | Outbox | Event publish + DB write atomically |
| Legacy integration | ACL | Prevent legacy model pollution |
| Cascading resource exhaustion | Bulkhead | One slow dep killing all threads |

## Event Reliability
- **Ordering:** partition key guarantees per-partition order; use sequence numbers for cross-partition ordering
- **Idempotency keys:** `hash(event_type + entity_id + timestamp)` → consumer deduplicates before processing
- **Dead letter queue (DLQ):** max retries (3-5) → move to DLQ → alert + manual review; never silently drop
- **Effectively exactly-once:** at-least-once delivery + idempotent consumer = no duplicate side-effects
- **Poison message handling:** catch deserialization/processing errors → log with full context → skip or DLQ; never block partition

## Pattern Relationships
```
CQRS ←→ Event Sourcing  (events sync read/write models)
Saga ←→ Choreography/Orchestration  (two implementation styles)
Outbox → Event Sourcing  (outbox events fed into event store)
Bulkhead + Circuit Breaker  (defense in depth for resilience)
Strangler Fig → Facade  (routing facade is key component)
```
