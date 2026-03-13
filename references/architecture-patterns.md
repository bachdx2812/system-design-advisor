# Architecture Patterns

## Monolith vs Microservices

| Dimension | Monolith | Microservices |
|-----------|----------|---------------|
| Deployment | All-or-nothing | Independent per service |
| Scaling | Entire app | Individual services |
| Complexity | Simple initially | High ops from day 1 |
| Data | Shared DB (easy joins) | Each owns data |
| Latency | In-process (ns) | Network (ms) per hop |
| Fault isolation | One bug crashes all | Failures contained |

**Rule:** Start monolith. Migrate when team size, deploy frequency, or scaling justifies overhead.

## Service Discovery
- **Client-side:** Client queries registry → selects instance (Eureka, Consul)
- **Server-side:** Client calls LB → router does lookup (K8s DNS, AWS ALB)

## Event-Driven Architecture
- Events = immutable facts (OrderPlaced, PaymentProcessed)
- Loose coupling: producer unaware of consumers
- **Choreography:** Services react to events independently (decentralized)
- **Orchestration:** Central coordinator directs workflow (Saga pattern)

## Key Patterns

| Pattern | Solves | Trade-off |
|---------|--------|-----------|
| CQRS | Different read/write load | Sync complexity |
| Event Sourcing | Audit trail, temporal queries | Replay cost |
| Saga | Distributed transactions | Compensating actions needed |
| Circuit Breaker | Cascading failures | Threshold tuning |
| Bulkhead | Failure isolation | Resource overhead |
| Rate Limiting | Abuse prevention, fair usage | Legitimate traffic blocked |

## Rate Limiting Algorithms
- **Token Bucket:** Add tokens at rate, spend on request (most common)
- **Sliding Window Log:** Track timestamps, count in window (precise, memory-heavy)
- **Fixed Window Counter:** Simple, boundary spike issue
- **Sliding Window Counter:** Hybrid (Redis INCR + TTL)

## Security Essentials
- **AuthN:** Who? (OAuth 2.0 + PKCE, JWT)
- **AuthZ:** What can they do? (RBAC, ABAC)
- **JWT:** header.payload.signature — never store secrets in payload (base64, not encrypted)
- **Refresh tokens:** Rotate on use, revoke on double-use detection

## Reliability Patterns
- **Retry + exponential backoff** with jitter
- **Circuit breaker:** Closed → Open (fail fast) → Half-Open (probe)
- **Graceful degradation:** Reduce features under load
- **DR:** RPO (max data loss) + RTO (max downtime); Hot/Warm/Cold standby

## Monitoring (3 Pillars)

| Pillar | What | Cost | Best For |
|--------|------|------|---------|
| Metrics | Numeric aggregates | Low | Dashboards, alerting |
| Logs | Per-event records | Medium | Debugging |
| Traces | Cross-service request journey | High | Latency attribution |

**Alert on p95/p99 latency, not averages.** Averages hide tail latency.

## SLI/SLO/SLA
- SLI: measurable indicator (latency, error rate)
- SLO: target (99.95% availability)
- SLA: contractual (includes penalties)
- Error budget: SLO surplus → invest in velocity
