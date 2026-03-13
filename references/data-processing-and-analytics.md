# Data Processing & Analytics

## Batch vs Stream vs Hybrid
| Dimension | Batch | Stream | Hybrid (Lambda/Kappa) |
|-----------|-------|--------|-----------------------|
| Latency | Minutes–hours | Milliseconds–seconds | Both |
| Throughput | Very high | High | High |
| Complexity | Low | Medium | High |
| Use case | ETL, reports, ML training | Alerts, dashboards, fraud | Historical + real-time |

## Stream Processing Frameworks
| Framework | Model | Latency | State | Best For |
|-----------|-------|---------|-------|----------|
| Kafka Streams | Record-at-a-time | Low | RocksDB (local) | Simple stateful ops, no cluster mgr |
| Apache Flink | Event-time, exactly-once | Very low | Managed, checkpointed | Complex CEP, low-latency stateful |
| Spark Streaming | Micro-batch | ~1s | In-memory | Batch + stream same codebase |

## Windowing
| Window Type | Definition | Use Case |
|-------------|------------|----------|
| Tumbling | Fixed, non-overlapping (e.g., 1h buckets) | Hourly reports |
| Sliding | Fixed size, shifts by step (e.g., 1h window, 5m slide) | Moving averages |
| Session | Gap-based, ends after inactivity | User session analytics |
| Global | Entire stream, trigger manually | Aggregates over all time |

## Watermarks & Late Data
- **Watermark**: timestamp `T` = max event time seen − allowed lateness; triggers window close
- **Late data**: hold window open until watermark passes; drop or side-output beyond threshold
- **Allowed lateness**: `withAllowedLateness(Duration.ofMinutes(5))`

## Exactly-Once Semantics
```
Idempotent producer (enable.idempotence=true)
  + Transactional consumers (isolation.level=read_committed)
  + Flink checkpoints (two-phase commit to Kafka)
→ exactly-once end-to-end
```

## Lambda vs Kappa Architecture
| | Lambda | Kappa |
|-|--------|-------|
| Layers | Batch layer + Speed layer + Serving layer | Stream layer only |
| Complexity | High (two codebases) | Lower (one codebase) |
| Reprocessing | Rerun batch | Replay Kafka from offset |
| Use when | Batch accuracy critical | Stream reprocessing sufficient |

## ETL vs ELT
| | ETL | ELT |
|-|-----|-----|
| Transform | Before load (pipeline) | After load (in warehouse) |
| Tool | Spark, dbt (sometimes) | Snowflake, BigQuery, dbt |
| Best for | Sensitive data masking, complex transforms | Cloud DWH with elastic compute |

## Data Warehouse Schemas
- **Star schema**: fact table + denormalized dimension tables; fast queries, redundancy OK
- **Snowflake schema**: normalized dimensions; saves storage, more joins
- **SCD Type 1**: overwrite old value; **Type 2**: new row with effective dates (history preserved)

## Storage Tiers
| | Data Lake | Data Warehouse | Lakehouse |
|-|-----------|----------------|-----------|
| Format | Raw (JSON, Parquet, CSV) | Structured, curated | Open table format (Delta, Iceberg) |
| Schema | Schema-on-read | Schema-on-write | Schema-on-read + ACID |
| Cost | Low | High | Medium |
| Use | ML training, archive | BI, reporting | Unified analytics |

## Columnar vs Row Storage
| | Columnar (Parquet, ORC) | Row (PostgreSQL heap) |
|-|------------------------|----------------------|
| Scan | Read only needed columns | Read entire row |
| Compression | High (same-type values) | Lower |
| Best for | Analytical (OLAP) | Transactional (OLTP) |

## Materialized Views & Incremental Computation
- **Materialized view**: precomputed query result stored on disk; refresh on schedule or trigger
- **Incremental**: only recompute changed partitions (dbt incremental models, Spark structured streaming)
- Use for: dashboards, aggregations that are expensive to recompute

## Decision Guide
| Scenario | Choose |
|----------|--------|
| Nightly ETL, ML training data | Batch (Spark) |
| Fraud alerts, live dashboards | Stream (Flink) |
| Historical analytics + real-time | Lambda or Kappa |
| Ad-hoc BI queries | Data warehouse (Snowflake/BigQuery) + star schema |
| ML feature pipeline | Feature store + batch offline + real-time online |
