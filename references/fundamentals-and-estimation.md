# Fundamentals & Estimation

## 4-Step System Design Framework
1. **Requirements** (5 min) — functional, non-functional, scope boundaries
2. **Estimation** (5 min) — QPS, storage, bandwidth
3. **High-Level Design** (20 min) — API, data model, component diagram
4. **Deep Dive** (10 min) — bottlenecks, failures, trade-offs

## System Properties

| Property | Definition | Key Metric |
|----------|-----------|------------|
| Scalability | Handle load growth without proportional cost | QPS capacity |
| Reliability | Operate under failures | MTBF |
| Availability | % uptime (99.9% = 8.7h/yr, 99.99% = 52.6min/yr) | Nines |
| Maintainability | Ease of change | Deploy frequency |
| Efficiency | Latency vs throughput | p99 latency |

## Scaling Decision Tree
- **Read-heavy (>80% reads)** → read replicas → caching → CDN
- **Write-heavy (>50% writes)** → horizontal app servers → DB sharding → message queue
- **Mixed** → CQRS: separate read/write paths

## QPS Thresholds → Architecture

| QPS | Architecture |
|-----|-------------|
| <1K | Single server, vertical scaling |
| 1K-10K | Load balancer + servers + basic cache |
| 10K-100K | Read replicas, aggressive cache, CDN |
| >100K | Sharding, async processing, microservices |

## Estimation Formulas
```
QPS = DAU x queries/user/day / 86,400
Peak QPS = Average QPS x 2-3
Storage = DAU x data/user/day x retention_days x 3 (replication)
Bandwidth = QPS x avg_response_size
```

## Latency Reference (Jeff Dean)

| Operation | Latency |
|-----------|---------|
| L1 cache | 0.5 ns |
| RAM | 100 ns |
| SSD random read | 150 us |
| Intra-DC round trip | 500 us |
| HDD seek | 10 ms |
| Cross-continent | 150 ms |

**Key:** Memory 200x faster than SSD; SSD 1000x faster than HDD

## Quick Conversions
- 1M requests/day ~ 12 QPS
- 1 day = 86,400 ~ 100K seconds
- Replication always 3x; metadata overhead 10-30%
- Peak load 2-3x average; writes cost 5-10x more than reads

## Core Trade-offs
- **CAP:** P is mandatory → choose C (banking) or A (social feeds)
- **ACID vs BASE:** Strong consistency + lower throughput vs eventual consistency + higher throughput
- **Latency vs Throughput:** Batching increases throughput but individual latency
