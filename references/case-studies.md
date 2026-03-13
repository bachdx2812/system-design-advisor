# Case Studies — Quick Reference

## Design X → Key Components

| System | Core Components | Key Pattern |
|--------|----------------|-------------|
| URL Shortener | SQL + Redis cache + KGS (collision-free IDs) | Cache-aside, Base62, Bloom filter |
| Social Feed | Posts DB + Feed Redis + Kafka fan-out workers | Hybrid fan-out (push normal, pull celebrities) |
| Chat System | Cassandra (messages) + Redis (presence) + WebSocket gateway | Persistent connections, heartbeat |
| Video Platform | S3 (storage) + Transcoding queue + CDN (segments) | HLS/DASH adaptive bitrate |
| Ride-Sharing | Redis GEO (locations) + Trip DB + Matching service | Geohashing, real-time matching |

## URL Shortener (10:1 read:write)
- KGS for collision-free 7-char IDs (Base62: a-z, A-Z, 0-9)
- 301 (cached, reduces load) vs 302 (trackable, flexible)
- Hot 20% in Redis LRU cache; Bloom filter for non-existent keys
- Scale: 100M URLs/day → 1.2K write QPS, 12K read QPS

## Social Feed (fan-out problem)
- **Push (on-write):** Pre-compute feeds → low read latency, high write amplification
- **Pull (on-read):** Compute on demand → low write cost, high read latency
- **Hybrid:** Push for <10K followers, pull for celebrities (50M+ followers)
- CQRS: separate post store (write-optimized) from feed cache (read-optimized)

## Chat System (real-time)
- WebSocket primary, long-polling fallback; ~65K connections/server
- Message ordering per-conversation (Kafka partition by conversation_id)
- Presence: Redis heartbeat every 30s; lazy loading for 500+ member groups
- Scale: 500M DAU → 250M concurrent WebSockets, 231K msgs/sec peak

## Video Streaming (bandwidth-heavy)
- Upload → Transcode (GPU workers, resolution ladder 360p-4K) → CDN
- HLS/DASH: 2-10s segments, adaptive bitrate based on bandwidth
- Multi-CDN failover; origin shield prevents thundering herd
- Codec: H.264 (universal) vs H.265 (50% smaller, limited support) vs AV1 (best, slow encode)

## Ride-Sharing (geospatial)
- Redis GEO: geohashing + sorted sets; 250K GPS updates/sec in ~64MB
- Match by ETA (not just distance); 5-second SLA
- Dynamic pricing: supply/demand ratio per geohash zone
- Location update every 4s; sampling for history (1/30s for 30-day retention)

## Web Crawler (distributed)
- URL Frontier: priority queue (importance) + per-host politeness queue
- Dedup: URL fingerprint (MD5) + content fingerprint (SimHash for near-duplicates)
- robots.txt compliance; 1 req/s per domain; exponential backoff
- Consistent hashing assigns URL ranges to crawler nodes
- Scale: 1B pages/month → ~400 URLs/sec, ~1 PB storage/month

## File Sync (Dropbox-style)
- Content-defined chunking (Rabin fingerprinting, ~4MB blocks)
- SHA-256 per chunk for dedup; only upload changed chunks (delta sync)
- Metadata service: file tree + versions + chunk mapping
- Conflict: last-writer-wins or save both versions
- Notification: long-polling/WebSocket for cross-device sync

## Notification System
- Event → Notification Service → Channel Router → Provider Queue → Delivery
- Channels: Push (APNs/FCM), Email (SES), SMS (Twilio), In-App (WebSocket)
- Priority tiers: P0 instant, P1 near-real-time, P2 batched digests
- User preferences: per-channel opt-in, quiet hours, frequency caps
- Tracking: Sent → Delivered → Read; retry with exponential backoff + DLQ
