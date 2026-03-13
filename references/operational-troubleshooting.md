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

## Redis Cluster Recovery
- **Split-brain detection:** `CLUSTER INFO` → `cluster_state:fail`; nodes disagree on slot ownership
- **Recovery:** `CLUSTER FAILOVER FORCE` on replica to promote; `CLUSTER RESET SOFT` to rejoin healed node
- **Prevention:** `min-replicas-to-write 1`, `cluster-node-timeout 15000`; quorum prevents writes in minority partition
- **Rejoin after partition:** node auto-rejoin when reachable; use `CLUSTER MEET` if gossip fails

## Elasticsearch Cluster Health
- **Green:** all primary + replica shards assigned; **Yellow:** primaries OK, some replicas unassigned; **Red:** primary shard missing (data loss risk)
- **Unassigned shards:** `GET _cluster/allocation/explain` → root cause (disk, node, replica count)
- **Disk watermarks:** 85% → stop allocating replicas; 90% → relocate shards; 95% → block writes
- **Fix:** `PUT _cluster/settings {"transient":{"cluster.routing.allocation.disk.watermark.high":"92%"}}`; add nodes; `POST _cluster/reroute?retry_failed`

## S3 Multipart Upload
- **Part size:** 5MB min, 25-100MB optimal, max 10K parts per upload
- **Retry per-part:** track ETag per part; retry only failed parts, not entire file
- **Cleanup:** lifecycle rule `AbortIncompleteMultipartUpload` after 7 days (prevent storage waste)
- **Performance:** transfer acceleration (CloudFront edge) for cross-region; parallel part upload (8-16 threads)
- **Client-side upload:** pre-signed URLs per part; client uploads directly to S3; backend finalizes with `CompleteMultipartUpload`

## Deploy-Specific Latency Diagnosis
- **Cold cache:** after deploy, Redis/Memcached empty → pre-warm critical hot keys before traffic cut-over
- **Connection pool startup:** DB pools not initialized → pre-initialize pools during health check readiness probe
- **JIT/class loading (JVM):** first requests slow → send synthetic warmup requests before marking instance healthy
- **DNS cache invalidation:** old TTL delays routing → set low TTL (30-60s) before deploy; raise after stabilize
