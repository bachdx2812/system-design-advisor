# Collaborative Editing & Multi-Tenant — Quick Reference

## Collaborative Editing (Google Docs-style)

### CRDTs vs OT

| Approach | How | Pros | Cons | Libraries |
|----------|-----|------|------|-----------|
| OT (Operational Transform) | Transform op against concurrent ops | Proven (Google Docs) | Complex multi-client; server required | ShareDB, ot.js |
| CRDT (Conflict-free Replicated Data Type) | Merge by design; no coordination | P2P-capable, offline-first | Higher memory; tombstones accumulate | Yjs, Automerge |

- **Choose OT:** Existing infra with central server, simple text; Google Docs uses OT
- **Choose CRDT:** Offline-first, P2P, complex data types (lists, maps, rich text)
- **Yjs:** YATA CRDT; awareness protocol for presence; providers: WebSocket, WebRTC, IndexedDB
- **Automerge:** JSON CRDT; immutable snapshots; Rust core (Automerge 2.0)

### Document State Model
- **Operation log:** append-only; enables audit, undo, version history
- **Materialized view:** current state = apply ops in order; recomputed or incrementally maintained
- **Snapshots:** periodic full-state capture; replay from snapshot + ops (avoid full log scan)
- **Version history:** snapshot every N ops or on explicit save; ops between = diff

### Cursor & Presence Sync
- Each client sends `{userId, cursor: {line, col}, selection}` via WebSocket on change
- Server fan-outs to all peers in document session; ephemeral (not persisted)
- **Awareness:** Yjs awareness protocol — CRDT-based state per client; auto-expire on disconnect
- **Throttle:** debounce cursor events 50-100ms to avoid flooding

### Conflict Resolution
- **OT:** transform(op_A, op_B) → op_A' that applies after op_B; server defines canonical order
- **CRDT:** concurrent inserts resolved by unique site ID + Lamport timestamp; deletions via tombstone
- **Last-writer-wins (LWW):** for non-text fields (title, metadata); use vector clocks or wall-clock + ID tiebreak

## Multi-Tenant Architecture

### Tenant Isolation Models

| Model | Isolation | Cost | Complexity | Best For |
|-------|-----------|------|-----------|---------|
| Shared DB + `tenant_id` column | Low | Lowest | Low | Startups, SMB SaaS |
| Schema-per-tenant (Postgres schemas) | Medium | Low | Medium | Mid-market, compliance |
| DB-per-tenant | High | High | High | Enterprise, strict data residency |

- **Row-level security (RLS):** Postgres `CREATE POLICY`; enforce `tenant_id = current_setting('app.tenant')` automatically
- **Hybrid:** shared for small tenants, dedicated for enterprise tier

### Usage Metering Pipeline
```
Event → Kafka → Aggregator (per tenant/resource, per minute) → Time-series store → Billing period rollup → Invoice
```
- **Event:** `{tenant_id, resource, units, timestamp}`; emit on every billable action
- **Aggregator:** windowed sum (Flink/Spark or simple Redis INCR); flush every 60s
- **Billing period rollup:** sum aggregates per billing cycle (monthly); store in ledger table

### Subscription State Machine
```
Trial → Active → Past_Due → Canceled → Expired
                → Active (payment recovered)
```
- **Trial:** 14-30 days; feature-limited or full access
- **Past_due:** payment failed; retry schedule (1d, 3d, 7d, 14d — Stripe's Smart Retries)
- **Canceled:** access until period end (grace); then → Expired
- **Webhook events:** `invoice.payment_failed`, `customer.subscription.deleted`

### Proration (Mid-cycle Changes)
- **Upgrade:** charge `(days_remaining / days_in_cycle) * price_diff` immediately
- **Downgrade:** credit `(days_remaining / days_in_cycle) * price_diff` to next invoice
- Stripe handles automatically with `proration_behavior=create_prorations`

### Quota Enforcement
- **Soft limit:** allow overage, warn user, charge overage fee; better UX
- **Hard limit:** block at limit; use Redis counter `INCR tenant:usage:resource` + check against limit
- **Rate limit vs quota:** rate limit = per-second/minute burst; quota = monthly ceiling

### Payment Webhooks & Idempotency
- Verify webhook signature (`Stripe-Signature` header + HMAC-SHA256)
- Store `event_id` in DB; skip if already processed (idempotent handler)
- Respond `200 OK` quickly; process async via queue to avoid timeout
- Retry logic: Stripe retries up to 3 days on non-2xx response
