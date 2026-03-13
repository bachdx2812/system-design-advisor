# Operational Troubleshooting — Quick Reference

## Redis
- **Slow queries:** `SLOWLOG GET 10`; >1ms investigate; check O(N) commands (KEYS, SMEMBERS on large sets)
- **Memory:** `INFO MEMORY`; maxmemory-policy: allkeys-lru (cache) vs noeviction (data store); `OBJECT ENCODING` for type check
- **Connection exhaustion:** pool size = CPU cores * 2 + 1; `CLIENT LIST` to find leaks; use connection pooling library
- **Cache stampede:** lock-based recompute (SETNX), probabilistic early expiry, stale-while-revalidate
- **Hot key:** hash tag sharding, local L1 cache in-process, read replicas for hot data
- **Hit rate drop:** check key expiry changes, new feature bypassing cache, memory eviction spike

## Kafka
- **Consumer lag:** `kafka-consumer-groups.sh --describe`; lag > 0 = slow consumers or too few partitions
- **Rebalancing storms:** use cooperative sticky assignor (Kafka 2.4+), increase `session.timeout.ms`, reduce group size
- **ISR shrink:** broker disk I/O saturated, network partition, increase `replica.lag.time.max.ms`
- **Offset reset:** `earliest` (reprocess all) vs `latest` (skip missed); `kafka-consumer-groups.sh --reset-offsets`
- **Throughput tuning:** `batch.size=64KB`, `linger.ms=5`, `compression.type=lz4`, `acks=1` for speed vs `acks=all` for durability
- **Partition strategy:** #partitions >= #consumers; key-based for ordering; round-robin for throughput

## Postgres
- **Slow queries:** enable `pg_stat_statements`; `EXPLAIN (ANALYZE, BUFFERS)` to find seq scans on large tables
- **Missing indexes:** `pg_stat_user_tables` → high `seq_scan`, low `idx_scan` = needs index; partial indexes for filtered queries
- **Lock contention:** `SELECT * FROM pg_stat_activity WHERE wait_event_type = 'Lock'`; `pg_locks` for deadlock detection
- **Vacuum issues:** `pg_stat_user_tables.n_dead_tup` high = needs vacuum; tune `autovacuum_vacuum_cost_delay`
- **Connection pooling:** PgBouncer in transaction mode; `max_connections` = 100-300 typical; app pool = workers * 2
- **Read scaling:** streaming replicas + connection routing (read queries to replica); `synchronous_commit = off` for speed
- **Scaling without downtime:** add read replicas first, then vertical scale primary during low traffic, then shard if >1TB

## General Operational Patterns
- **Latency spike diagnosis:** DB slow? → cache miss? → external API timeout? → GC pause? → network? → CPU saturation?
- **Cascading failure:** circuit breakers per dependency, bulkhead isolation, timeout budgets (total < user SLA), graceful degradation
- **Capacity planning:** maintain p99 * 2x headroom; alert: CPU >70%, memory >80%, disk >85%, error rate >1%
- **Health checks:** liveness (process alive, restart if not) vs readiness (can serve traffic, remove from LB if not)
- **Incident response:** detect (alerting) → triage (severity) → mitigate (quick fix) → resolve (root cause) → postmortem

## Migration Strategies
- **Strangler Fig:** proxy routes new endpoints to new service; gradually migrate endpoint by endpoint; old service shrinks
- **Dual-write:** write to both old + new system; reconcile differences; cut over reads; stop old writes; decommission
- **Shadow traffic:** mirror production traffic to new service; compare responses; fix discrepancies; no user impact
- **Canary deployment:** route 1% → 5% → 25% → 100%; automated rollback on error rate spike or latency increase
- **Database migration:** expand-contract: add new column → backfill → switch app to new column → drop old column
- **Feature flags:** deploy code dark, enable per-user/percentage; instant rollback = disable flag; no redeploy needed
