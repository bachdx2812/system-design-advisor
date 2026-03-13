# Specialized System Patterns

## Unique ID Generation

| Method | Sortable | Coordination | Size | Collision |
|--------|----------|-------------|------|-----------|
| UUID v4 | No | None | 128-bit | Negligible (2^122) |
| Snowflake | Yes (time) | Clock sync | 64-bit | None (worker ID) |
| ULID | Yes (time) | None | 128-bit | Negligible |
| DB Auto-increment | Yes | Single DB | 64-bit | None (bottleneck) |
| TSID | Yes (time) | None | 64-bit | Low |

- **Snowflake structure:** 1-bit sign + 41-bit timestamp (69 years) + 10-bit worker ID (1024 nodes) + 12-bit sequence (4096/ms)
- **Clock skew:** NTP sync required; if clock goes backward, wait or reject
- **Multi-DC:** Encode datacenter ID in worker bits

## Distributed Locks

| Approach | Consistency | Performance | Complexity |
|----------|-------------|-------------|-----------|
| Redis SETNX + TTL | Weak (single node) | Fast | Low |
| Redlock (5 Redis) | Moderate | Moderate | Medium |
| ZooKeeper ephemeral | Strong (ZAB consensus) | Slower | High |
| etcd lease | Strong (Raft) | Slower | High |

- **Fencing tokens:** Monotonic token issued with lock; storage rejects stale tokens
- **SETNX pattern:** `SET key value NX PX 30000` (atomic set-if-not-exists with TTL)
- **ZK ephemeral nodes:** Auto-deleted on session timeout; sequential nodes for fair queuing
- **Redlock:** Acquire on majority (3/5) of independent Redis nodes; clock-dependent (controversial)

## Financial Systems

### Double-Entry Bookkeeping
- Every transaction = debit one account + credit another (always balanced)
- Ledger: append-only log of entries (immutable for audit)
- Balance = SUM(credits) - SUM(debits) for account

### Payment State Machine
```
Created → Processing → Succeeded
                    → Failed → Retrying → Succeeded/Failed
```
- Idempotency key: client-generated UUID per payment attempt
- Reconciliation: batch compare internal ledger vs payment provider records (daily)

### Order Matching (Stock Exchange)
- **Order book:** Buy orders (bids, descending) + Sell orders (asks, ascending)
- **Matching:** Price-time priority (FIFO at same price)
- **Engine:** Single-threaded per instrument for determinism (LMAX Disruptor pattern)
- **Latency:** Sub-microsecond matching; kernel bypass (DPDK), lock-free queues
- **Settlement:** T+2 (trade date + 2 business days)

## Booking/Reservation Systems
- **Optimistic locking:** Read version → update WHERE version = X (retry on conflict)
- **Pessimistic locking:** SELECT FOR UPDATE (hold lock during transaction)
- **Reservation with TTL:** Hold inventory 15 min → auto-release if not confirmed
- **Overbooking:** Allow N+X bookings; manage with waitlist (airlines, hotels)

## Notification System
- **Channels:** Push (APNs/FCM), Email (SES/SendGrid), SMS (Twilio), In-App (WebSocket)
- **Architecture:** Event → Notification Service → Channel Router → Provider Queue → Delivery
- **Priority:** P0 (instant: security alerts) → P1 (near-real-time: messages) → P2 (batched: digests)
- **User preferences:** Per-channel opt-in/out; quiet hours; frequency caps
- **Delivery tracking:** Sent → Delivered → Read status; retry failed with exponential backoff

## Game Networking

| Pattern | How | Latency | Use Case |
|---------|-----|---------|---------|
| Lockstep | All clients process same inputs per tick | Deterministic, high latency tolerance | RTS, fighting games |
| State transfer | Server sends authoritative state | ~50ms | FPS, action games |
| Client prediction | Client predicts locally, server corrects | Lowest perceived | Most multiplayer |

- **Tick rate:** Server updates/sec (20-128Hz); higher = smoother but more bandwidth
- **Lag compensation:** Server rewinds state to client's view time for hit detection
- **Interest management:** Only send updates for nearby entities (spatial partitioning)
- **Authoritative server:** Server is truth; reject impossible client actions (anti-cheat)

## Spatial Indexing

| Method | Lookup | Insert | Best For |
|--------|--------|--------|---------|
| Geohash | O(1) prefix | O(1) | Proximity search, Redis GEO |
| Quadtree | O(log n) | O(log n) | Variable density (maps) |
| R-tree | O(log n) | O(log n) | Rectangles, polygons (PostGIS) |
| S2 Geometry | O(1) cell | O(1) | Spherical geometry (Google Maps) |
| H3 (Uber) | O(1) hex | O(1) | Ride-sharing, hexagonal grid |

- **Geohash precision:** 6 chars ≈ 1.2km; 7 chars ≈ 150m; 8 chars ≈ 19m
- **Quadtree:** Recursively divide 2D space; good for non-uniform distribution
- **R-tree:** Group nearby objects in bounding rectangles; used in PostGIS, spatial DBs
