---
name: system-design-advisor
description: Answer system design questions, explain tradeoffs, and provide architectural guidance. Use when user asks about scalability, databases, caching, load balancing, CAP theorem, microservices, or any distributed systems concept. Covers DNS, CDN, message queues, replication, consistency models, and communication protocols.
version: 1.0.0
user-invocable: true
---

# System Design Advisor

Answer system design questions using distilled knowledge from The Engineer's Handbook (25 chapters).

## When Activated

Respond to questions about system design concepts, trade-offs, and component selection. Provide structured answers with:
1. **Direct answer** with recommendation
2. **Trade-off analysis** (pros/cons table when comparing options)
3. **When to use / when NOT to use**
4. **Key numbers** if applicable (latency, throughput thresholds)

## Topic Routing

Load the relevant reference based on the question topic:

| Topic | Reference |
|-------|-----------|
| Scalability, CAP, estimation, QPS | [fundamentals-and-estimation.md](../../references/fundamentals-and-estimation.md) |
| DNS, load balancing, L4/L7 | [dns-and-load-balancing.md](../../references/dns-and-load-balancing.md) |
| Caching, Redis, CDN | [caching-and-cdn.md](../../references/caching-and-cdn.md) |
| SQL, NoSQL, sharding, replication | [databases.md](../../references/databases.md) |
| Message queues, HTTP, gRPC, WebSocket | [queues-and-protocols.md](../../references/queues-and-protocols.md) |
| Microservices, event-driven, security, monitoring | [architecture-patterns.md](../../references/architecture-patterns.md) |
| URL shortener, chat, feed, video, ride-sharing | [case-studies.md](../../references/case-studies.md) |
| Cloud-native, ML systems, interview prep | [modern-and-interview.md](../../references/modern-and-interview.md) |

## Response Format

```
## [Topic]

**Recommendation:** [Direct answer]

**Trade-offs:**
| Option | Pros | Cons |
|--------|------|------|

**When to use:** [Specific scenarios]
**When NOT to use:** [Anti-patterns]
**Key numbers:** [Relevant thresholds]
```

## Source

Knowledge from [The Engineer's Handbook](https://bachdx-learning-hub.vercel.app/) — 25 chapters on system design.
