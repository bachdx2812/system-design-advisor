# Low-Level Design Patterns

## SOLID Quick Reference
| Principle | Rule | Violation Signal |
|-----------|------|-----------------|
| **S**ingle Responsibility | One reason to change | Class does auth + email + logging |
| **O**pen/Closed | Extend without modifying | Giant switch/if-else on type |
| **L**iskov Substitution | Subtypes replaceable | Override breaks parent contract |
| **I**nterface Segregation | Small, focused interfaces | Implementing unused methods |
| **D**ependency Inversion | Depend on abstractions | `new ConcreteClass()` inside logic |

## Classic LLD Problems

### Parking Lot
- **Entities**: ParkingLot, Level, ParkingSpot (Compact/Large/Handicapped), Vehicle, Ticket
- **Patterns**: Strategy (pricing by type + duration), Observer (notify spot freed), Factory (spot by type)
- **Key logic**: `findAvailableSpot(vehicleType)` → scan levels → first fit
- **Concurrency**: optimistic locking on spot status

### Vending Machine
- **State machine**: `Idle → HasMoney → Dispensing → Idle` (+ `OutOfStock`)
- **States**: Idle (accepts coin), HasMoney (accepts selection/refund), Dispensing (ejects item, returns change)
- **Patterns**: State (each state is a class), Strategy (payment validation)
- **Key data**: `inventory: Map<Item, count>`, `balance: number`

### Elevator System
| Algorithm | Description | Best For |
|-----------|-------------|----------|
| FCFS | Service in request order | Simple |
| SCAN | Move one direction, reverse at end | Balanced |
| LOOK | Reverse at last request | Efficient |
| Destination Dispatch | Group by destination floor | High-rise |

- **Entities**: Elevator, Request (floor, direction), Scheduler, Button
- **Patterns**: Strategy (scheduling), Observer (floor arrival), Command (request as object)

### Library Management
- **Entities**: Book, Member, Librarian, Loan, Reservation, Fine
- **Flow**: Search → Reserve → Checkout (create Loan) → Return (fine if late)
- **Patterns**: Observer (notify reserved book available), Strategy (fine calc), Repository (catalog)

## Leaderboard Patterns
| Approach | Mechanism | Latency | Consistency |
|----------|-----------|---------|-------------|
| Redis Sorted Set | ZADD score, ZREVRANGE top-K | O(log N) write | Real-time |
| SQL + index | ORDER BY score LIMIT K | Index scan | Strong |
| Batch precompute | Periodic job → cache | O(1) read | Eventual |

- **Redis**: `ZADD lb 1500 user:123`, `ZREVRANGE lb 0 9 WITHSCORES`, `ZREVRANK lb user:123`
- **Pagination**: `ZREVRANGEBYSCORE lb +inf -inf LIMIT offset count`
- **HyperLogLog**: approximate unique counts — `PFADD`, `PFCOUNT` (12KB per counter)

## Cache Implementation
### LRU Cache
- **Structure**: Doubly linked list (order) + HashMap (O(1) lookup)
- **Get**: move node to head; **Put**: add to head, evict tail if full; O(1) both ops

### LFU Cache
- **Structure**: HashMap + frequency buckets (linked list per freq)
- **Eviction**: lowest frequency bucket; tie-break by LRU within bucket

## Rate Limiter Implementation
- **Token Bucket**: `tokens` counter + `lastRefill`; refill = (now - lastRefill) * rate; allow if tokens > 0
- **Sliding Window Counter**: `count = prev_count * overlap% + current_count`; allow if < limit
- **Redis atomic**: `INCR key` + `EXPIRE key window` — wrap in Lua script for atomicity

## LLD Problem → Pattern Mapping
| Problem | Primary Pattern | Key Data Structure |
|---------|----------------|-------------------|
| Parking Lot | Strategy + Observer | HashMap (spot → vehicle) |
| Vending Machine | State | State machine + inventory map |
| Elevator | Strategy + Command | Priority queue |
| Leaderboard | — | Redis Sorted Set |
| LRU Cache | — | DLL + HashMap |
| Rate Limiter | — | Token bucket / sliding window |
| Library | Repository + Observer | DB + reservation queue |
