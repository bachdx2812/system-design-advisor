# Storage Systems & Infrastructure

## Object Storage (S3-like)
- Immutable objects: PUT/GET/DELETE, no partial updates
- **Durability:** 11 nines (99.999999999%) via erasure coding
- **Erasure coding (Reed-Solomon):** Split data into k data + m parity chunks; tolerate m failures with less storage than 3x replication
- Storage tiers: Hot (Standard) → Warm (Infrequent Access) → Cold (Glacier/Archive)
- Metadata: separate metadata service (consistent) from data path (available)

## Distributed File System (HDFS/GFS)
- **NameNode:** Metadata (file→blocks mapping), single point (HA with standby)
- **DataNode:** Store blocks (default 128MB), replicate 3x across racks
- **Rack awareness:** Place replicas on different racks for fault tolerance
- **Write pipeline:** Client → DN1 → DN2 → DN3 (pipeline replication)
- Scale: Add DataNodes horizontally; NameNode is bottleneck (federation for scale)

## File Sync (Dropbox-style)

| Component | Purpose |
|-----------|---------|
| Chunking | Split files into 4MB blocks (content-defined: Rabin fingerprinting) |
| Dedup | Hash each chunk (SHA-256); store only unique chunks |
| Delta sync | Only upload changed chunks (saves 90%+ bandwidth) |
| Metadata DB | File tree, versions, chunk→storage mapping |
| Notification | Long-polling/WebSocket to notify other clients of changes |

- **Conflict resolution:** Last-writer-wins or save both versions (let user resolve)
- **Block storage:** Chunks stored in object storage (S3), referenced by hash
- **Versioning:** Keep chunk list per version; point-in-time restore

## Configuration Management
- **etcd/Consul KV:** Distributed KV with strong consistency (Raft)
- **Push vs Pull:** Push (watch/notify, low latency) vs Pull (poll interval, simpler)
- **Feature flags:** Key-value toggle; evaluate client-side for low latency
- **Hot reload:** Watch key changes → reload config without restart
- **Versioning:** Every config change = new version; instant rollback to previous
- **Config drift:** Periodic reconciliation between desired state and actual state

## LSM-Tree (Log-Structured Merge Tree)
- Write path: Write-ahead log → MemTable (sorted, in-memory) → flush to SSTable (sorted, immutable on disk)
- Read path: MemTable → L0 SSTables → L1 → ... (Bloom filter to skip levels)
- **Compaction:** Merge SSTables to reclaim space + reduce read amplification
  - Size-tiered: merge similar-size SSTables (write-optimized)
  - Leveled: fixed-size levels, guaranteed sorted (read-optimized)
- Used by: Cassandra, RocksDB, LevelDB, HBase

## OLAP vs OLTP

| Dimension | OLTP | OLAP |
|-----------|------|------|
| Queries | Point lookups, short transactions | Complex aggregations, full scans |
| Schema | Normalized (3NF) | Denormalized (star/snowflake) |
| Storage | Row-oriented | Column-oriented (Parquet, ORC) |
| Examples | PostgreSQL, MySQL | BigQuery, Redshift, ClickHouse |
| Latency | ms | seconds-minutes |
| Concurrency | High (1000s TPS) | Low (few concurrent queries) |

## Data Warehouse Patterns
- **Star schema:** Fact table (metrics) + dimension tables (attributes)
- **ETL:** Extract → Transform → Load (batch, nightly)
- **ELT:** Extract → Load → Transform (in-warehouse, modern)
- **Materialized views:** Pre-computed aggregations for dashboard queries

## Logging Pipeline (ELK)
- **Agents:** Filebeat/Fluentd collect logs from nodes
- **Buffer:** Kafka absorbs spikes between collectors and indexers
- **Index:** Elasticsearch indexes logs (inverted index on message fields)
- **Visualize:** Kibana dashboards, alerts on error rate spikes
- **Retention:** Hot (7d, SSD) → Warm (30d, HDD) → Cold (S3, years)
