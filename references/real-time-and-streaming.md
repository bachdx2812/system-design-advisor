# Real-Time Communication & Stream Processing

## WebRTC
- Peer-to-peer media transport (audio/video/data)
- Signaling (out-of-band): exchange SDP offers/answers via WebSocket
- ICE/STUN/TURN: NAT traversal; TURN relay when direct P2P fails
- SRTP: encrypted media transport
- Codecs: Opus (audio), VP8/VP9/H.264 (video), AV1 (next-gen)

## Video Conferencing Architectures

| Architecture | How | Latency | Bandwidth (server) | Best For |
|-------------|-----|---------|-------------------|---------|
| P2P Mesh | Each peer sends to every other peer | Lowest | None | 2-4 participants |
| SFU | Server forwards streams (no mixing) | Low | N x streams | 5-50 participants (Zoom, Discord) |
| MCU | Server mixes into single stream | Higher | 1 stream out | Large rooms, low-bandwidth clients |

- **SFU (Selective Forwarding Unit):** Most common; server forwards selected streams, clients choose quality (simulcast: send 3 resolutions)
- **Simulcast:** Sender encodes 3 quality layers; SFU picks per receiver based on bandwidth
- **SVC (Scalable Video Coding):** Single encode with temporal/spatial layers

## Audio/Voice Specifics
- Opus codec: 6-510 kbps, built for real-time
- Jitter buffer: smooth out packet timing variations (20-200ms)
- Echo cancellation: AEC (Acoustic Echo Cancellation)
- Noise suppression: ML-based (RNNoise) or WebRTC built-in

## Stream Processing

| Framework | Latency | Guarantees | Best For |
|-----------|---------|------------|---------|
| Kafka Streams | Low (ms) | Exactly-once | Lightweight, JVM apps |
| Apache Flink | Very low | Exactly-once | Complex event processing |
| Spark Streaming | Micro-batch (s) | Exactly-once | Batch + stream unified |

## Windowing Types
- **Tumbling:** Fixed, non-overlapping (every 5 min)
- **Sliding:** Fixed size, overlapping (5 min window, 1 min slide)
- **Session:** Gap-based (close after 30 min inactivity)
- **Late data:** Watermarks define when window closes; allowed lateness for stragglers

## Time-Series Databases

| DB | Model | Best For | Notes |
|----|-------|---------|-------|
| InfluxDB | Custom TSDB engine | Metrics, IoT | InfluxQL/Flux, built-in downsampling |
| TimescaleDB | PostgreSQL extension | SQL-compatible metrics | Hypertables, continuous aggregates |
| Prometheus | Pull-based scraping | K8s monitoring | PromQL, 15s default scrape |
| VictoriaMetrics | Fork-optimized | High-cardinality metrics | Drop-in Prometheus replacement |

## Time-Series Patterns
- **Downsampling:** 1s raw → 1min avg → 1hr avg (reduce storage 100x)
- **Retention tiers:** Hot (SSD, 7d) → Warm (HDD, 90d) → Cold (S3, years)
- **Pre-aggregation:** Compute rollups on ingest (not query time)
- Write pattern: append-only, partition by time + series ID

## Real-Time Dashboard Architecture
```
Events → Kafka → Stream Processor (Flink) → Pre-aggregated store (Redis/TSDB)
Dashboard → WebSocket/SSE → Aggregation Service → Store
```
