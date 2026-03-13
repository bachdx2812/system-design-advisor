---
name: system-design-advisor
description: Answer system design questions, explain tradeoffs, and provide architectural guidance. Use when user asks about scalability, databases, caching, load balancing, CAP theorem, microservices, or any distributed systems concept. Covers DNS, CDN, message queues, replication, consistency models, communication protocols, search systems, WebRTC, stream processing, distributed locks, unique ID generation, payment systems, spatial indexing, file sync, and 100+ system design topics.
version: 1.0.0
user-invocable: true
---

# System Design Advisor

Answer system design questions using distilled knowledge from The Engineer's Handbook (25 chapters).

## When Activated

### Step 0: Clarify Context (before answering)

Before responding, check if the question lacks critical context. If so, ask 1-3 clarifying questions using `AskUserQuestion` tool:

| Missing Context | Question to Ask |
|----------------|----------------|
| Scale unknown | "What's your expected scale? (QPS, DAU, data volume)" |
| Use case vague | "What's the primary access pattern? (read-heavy, write-heavy, mixed)" |
| Constraints unclear | "Any hard constraints? (latency SLA, consistency requirement, budget)" |
| Comparing options | "What's your current stack? (helps narrow recommendation)" |
| Architecture unclear | "Is this a monolith, microservices, or serverless setup?" |

**Skip clarification if:** The question is conceptual ("explain CAP theorem"), a direct comparison ("X vs Y?"), the user provides sufficient context, or the question has a universal answer.

**Context awareness:** If prior skill output is visible in conversation (reviewer findings, design plan, etc.), acknowledge it and add depth — skip re-explaining concepts already covered.

### Step 1: Answer with Structure

Provide structured answers with:
1. **Direct answer** with recommendation
2. **Trade-off analysis** (pros/cons table when comparing options)
3. **When to use / when NOT to use**
4. **Key numbers** if applicable (latency, throughput thresholds)
5. **Mermaid diagram** — include a diagram when it clarifies the architecture, data flow, or component relationships:

```mermaid
graph LR
    Client --> LB[Load Balancer]
    LB --> App[App Server]
    App --> Cache[(Redis)]
    App --> DB[(PostgreSQL)]
```

Use `graph LR`/`graph TD` for architecture, `sequenceDiagram` for request flows, `stateDiagram-v2` for state machines, `flowchart` for decision trees.

### Step 2: Follow-up

After answering, offer: "Want me to dive deeper into any aspect, or design a full plan for this?" (bridges to design-plan-generator skill).

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
| Recommendation engines, ML serving, feature store, fraud detection, content moderation, ad tech | [recommendation-and-ml-systems.md](references/recommendation-and-ml-systems.md) |
| Batch processing, MapReduce, Spark, Flink, windowing, ETL, data warehouse, lambda/kappa | [data-processing-and-analytics.md](references/data-processing-and-analytics.md) |
| JWT, OAuth, SSO, SAML, OIDC, API keys, rate limiting, mTLS, RBAC/ABAC, secrets | [authentication-and-security-deep-dive.md](references/authentication-and-security-deep-dive.md) |
| Parking lot, vending machine, elevator, leaderboard, LRU cache, SOLID, OOP design | [low-level-design-patterns.md](references/low-level-design-patterns.md) |
| Redis debugging, Kafka lag, Postgres slow queries, operational troubleshooting, migration, capacity planning | [operational-troubleshooting.md](references/operational-troubleshooting.md) |

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
