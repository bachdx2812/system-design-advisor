# Distributed System Patterns

## Overview
Managing failure gracefully across multiple services with distributed data and eventual consistency. Every pattern answers: "What happens when part of the system breaks?"

## CQRS (Command Query Responsibility Segregation)
- **Intent:** Separate write model (normalized, integrity) from read model (denormalized, speed)
- **Problem:** Single model serves both reads and writes — optimizing one degrades the other
- **Solution:** Commands (writes) → normalized store; Queries (reads) → denormalized projections
- **Sync mechanism:** Event bus propagates write events → read model updaters
- **Trade-off:** Read performance vs model sync complexity + eventual consistency
- **When to use:** Read/write load imbalance (100:1+), complex denormalization needed
- **When NOT:** Strong consistency required, similar read/write patterns, simple CRUD
- **Combines with:** Event Sourcing (events as sync mechanism)

## Event Sourcing
- **Intent:** Store state as append-only sequence of events, reconstruct by replay
- **Problem:** State history lost on UPDATE, no audit trail, temporal queries impossible
- **Solution:** Event store (immutable log) + projections (materialized read views)
- **Key components:**
  - **Event store:** Append-only, immutable (never delete/update)
  - **Snapshots:** Periodic state captures to speed up replay (every N events)
  - **Projections:** Event consumers building optimized read models
  - **Event versioning:** Schema evolution for events (upcasters)
- **Trade-off:** Full audit trail + temporal queries vs replay cost + complexity
- **When to use:** Audit requirements (finance, healthcare), temporal queries, undo/redo
- **When NOT:** Simple CRUD, no audit need, strong consistency only
- **Real-world:** Banking ledgers, event-driven microservices, Git (commits = events)

## Saga
- **Intent:** Manage distributed transactions across multiple services without 2PC
- **Problem:** ACID transactions can't span multiple services in microservices architecture
- **Two approaches:**

| Approach | How | Coordination | Trade-off |
|----------|-----|-------------|-----------|
| Choreography | Services react to events, publish events | Decentralized | Simple but hard to track flow |
| Orchestration | Central coordinator manages flow | Centralized | Easier to reason, single point of failure |

- **Compensating transactions:** Undo operations on failure (e.g., refund payment if shipping fails)
- **When to use:** Multi-service workflows, eventual consistency acceptable
- **When NOT:** Must rollback atomically, simple direct calls suffice
- **Real-world:** Order processing (order → payment → inventory → shipping)

## Strangler Fig
- **Intent:** Incrementally migrate legacy system without downtime
- **Problem:** Big-bang rewrites fail — too risky, too long, no business value mid-flight
- **Migration stages:**
  1. **Identify boundaries** — extract service at domain boundary
  2. **Routing facade** — path-based routing, feature flags to direct traffic
  3. **Parallel running** — shadow traffic, compare outputs for correctness
  4. **Retire legacy** — route 100% to new system, decommission old
- **Trade-off:** Safety + zero downtime vs maintaining two systems temporarily
- **When to use:** Legacy to microservices migration, gradual modernization
- **When NOT:** Greenfield projects (start with desired architecture)
- **Real-world:** Monolith → microservices at most large companies

## Sidecar
- **Intent:** Attach helper process to main service for cross-cutting infrastructure concerns
- **Problem:** Polyglot services (Go, Python, Java) need same infra: logging, mTLS, metrics
- **Solution:** Separate process in same deployment unit, handles infrastructure transparently
- **Handled concerns:** Logging collection, metrics export, mTLS encryption, config reload, circuit breaking
- **Trade-off:** Separation of concerns vs operational overhead (extra process per service)
- **When to use:** Polyglot microservices, shared infrastructure concerns, service mesh
- **When NOT:** Monoliths, when in-process libraries are sufficient
- **Real-world:** Envoy proxy (Istio), Kubernetes sidecar containers, Dapr

## Distributed Patterns Decision Guide

| Problem | Pattern | Signal |
|---------|---------|--------|
| Read/write model mismatch | CQRS | 100:1 read:write ratio, complex joins |
| Need audit trail / history | Event Sourcing | "What was state at time X?" |
| Multi-service transaction | Saga | Order spanning payment+inventory+shipping |
| Legacy migration | Strangler Fig | "Rewrite without downtime" |
| Cross-cutting infra concerns | Sidecar | Polyglot services, service mesh |

## Pattern Relationships
```
CQRS ←→ Event Sourcing  (events sync read/write models)
Saga ←→ Choreography/Orchestration  (two implementation styles)
Strangler Fig → Facade  (routing facade is key component)
Sidecar → Proxy  (sidecar acts as infrastructure proxy)
```
