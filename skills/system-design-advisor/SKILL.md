---
name: system-design-advisor
description: Answer system design questions, explain tradeoffs, and provide architectural guidance. Use when user asks about scalability, databases, caching, load balancing, CAP theorem, microservices, or any distributed systems concept. Covers DNS, CDN, message queues, replication, consistency models, communication protocols, search systems, WebRTC, stream processing, distributed locks, unique ID generation, payment systems, spatial indexing, file sync, and 100+ system design topics.
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

Load the relevant reference(s) based on the question topic. If a question spans multiple topics, load all relevant references:

| Topic | Reference |
|-------|-----------|
| Scalability, CAP, estimation, QPS | [fundamentals-and-estimation.md](references/fundamentals-and-estimation.md) |
| DNS, load balancing, L4/L7 | [dns-and-load-balancing.md](references/dns-and-load-balancing.md) |
| Caching, Redis, CDN | [caching-and-cdn.md](references/caching-and-cdn.md) |
| SQL, NoSQL, sharding, replication, locking | [databases.md](references/databases.md) |
| Message queues, HTTP, gRPC, WebSocket | [queues-and-protocols.md](references/queues-and-protocols.md) |
| Microservices, event-driven, security, monitoring, 2PC, API gateway | [architecture-patterns.md](references/architecture-patterns.md) |
| URL shortener, chat, feed, video, ride-sharing, crawler, file sync, notifications | [case-studies.md](references/case-studies.md) |
| Cloud-native, ML systems, interview prep | [modern-and-interview.md](references/modern-and-interview.md) |
| Search, inverted index, trie, autocomplete, Elasticsearch, web crawler | [search-and-indexing.md](references/search-and-indexing.md) |
| WebRTC, video conferencing, stream processing, time-series DB, Flink | [real-time-and-streaming.md](references/real-time-and-streaming.md) |
| Object storage, HDFS, file sync, config management, LSM-tree, OLAP, ELK | [storage-and-infrastructure.md](references/storage-and-infrastructure.md) |
| Unique IDs, distributed locks, payments, stock exchange, gaming, spatial indexing, booking | [specialized-systems.md](references/specialized-systems.md) |

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
