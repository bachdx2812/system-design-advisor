# Databases

## SQL vs NoSQL Decision

| Factor | SQL | NoSQL |
|--------|-----|-------|
| Schema | Fixed, write-time | Flexible, read-time |
| Consistency | Strong (ACID) | Eventual (BASE) |
| Joins | Native, efficient | Application-level |
| Scaling | Vertical + read replicas | Horizontal sharding |
| Transactions | Multi-row ACID | Single-doc atomic |
| Best for | Complex queries, relationships | High throughput, flexible schema |

## SQL Indexing
- **B-Tree (default):** O(log n), supports range + ordering
- **Hash:** O(1) equality only, no range
- **Composite:** Leftmost prefix rule (a,b,c) → (a), (a,b), NOT (b)
- **Covering:** All query cols in index = zero heap lookup

## NoSQL Types

| Type | Model | Examples | Use Case |
|------|-------|---------|----------|
| Key-Value | O(1) get/set | Redis, DynamoDB | Sessions, cache, rate limiting |
| Document | Nested JSON, queryable | MongoDB, CouchDB | Profiles, catalogs, CMS |
| Wide-Column | Column families | Cassandra, HBase | Time-series, IoT, analytics |
| Graph | Nodes + edges | Neo4j, Neptune | Social networks, fraud, recommendations |

## Sharding Strategies

| Strategy | Pros | Cons |
|----------|------|------|
| Range | Efficient range queries | Hot spots on popular ranges |
| Hash | Even distribution | No range queries |
| Directory | Flexible mapping | Lookup overhead, SPOF |
| Consistent Hashing | Minimal reshuffling | Virtual nodes needed |

## Replication Models

| Model | Writes | Consistency | Availability |
|-------|--------|-------------|-------------|
| Single-Leader | One node | Strong (sync) / Eventual (async) | Failover needed |
| Multi-Leader | Multiple regions | Conflict resolution required | High |
| Leaderless (Dynamo) | Any node (quorum W+R>N) | Tunable | Highest |

## CAP Classification
- **CP:** HBase, MongoDB (strong), Redis Cluster, PostgreSQL
- **AP:** Cassandra, DynamoDB, CouchDB

## Replication Lag Issues
- Read-your-own-writes violation → read from leader after write
- Monotonic read violation → sticky sessions
- Causality violation → vector clocks

## Consensus Protocols
- **Raft:** Leader election + log replication (etcd, Consul)
- **Paxos:** Complex but proven (Google Spanner)
- **ZAB:** Zookeeper's consensus

## Locking Strategies
- **Optimistic:** Read version → UPDATE WHERE version=X → retry on conflict (low contention)
- **Pessimistic:** SELECT FOR UPDATE → hold lock during transaction (high contention)
- **Distributed lock:** Redis SETNX+TTL (fast, weak) or ZooKeeper/etcd (strong, slower)
- Use optimistic for reads >> writes; pessimistic for booking/inventory systems

## OLAP vs OLTP
- **OLTP:** Row-oriented, point queries, ms latency (PostgreSQL, MySQL)
- **OLAP:** Column-oriented, aggregation scans, seconds latency (BigQuery, ClickHouse, Redshift)
- **Star schema:** Fact table (metrics) + dimension tables (attributes) for analytics

## Default Choice
Start with SQL (PostgreSQL). Move to NoSQL when: schema changes frequently, horizontal scale needed, access pattern is simple K/V or append-only, or data naturally fits document/graph model.
