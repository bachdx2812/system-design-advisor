# Caching & CDN

## Cache Strategies

| Strategy | How | Consistency | Latency | Best For |
|----------|-----|-------------|---------|---------|
| Cache-Aside | App reads cache, misses → DB | Eventual | Cold start penalty | General purpose |
| Read-Through | Cache auto-fetches on miss | Eventual | Transparent | Read-heavy |
| Write-Through | Write cache + DB sync | Strong | Higher write latency | Must-not-lose data |
| Write-Behind | Write cache, async DB | Risk on crash | Low write latency | Write-heavy, tolerate loss |
| Refresh-Ahead | Proactive reload before TTL | Near real-time | No expiry spikes | Hot data |

## Cache Problems & Solutions
- **Stampede/Thundering Herd** → distributed lock, request coalescing
- **Cache Penetration** (query non-existent) → Bloom filter, cache null
- **Cache Avalanche** (mass expiry) → probabilistic early expiry, staggered TTL
- **Hot Key** → local cache + distributed cache, key replication

## Cache Invalidation
- **TTL-Based:** Simplest, eventual consistency
- **Event-Based:** Reactive, tight coupling
- **Versioned Keys:** Zero invalidation, append version to key

## Cache Hierarchy (latency)
Browser (~0ms) → CDN (1-10ms) → Reverse Proxy (<1ms) → App Cache/Redis (0.1-1ms) → DB Buffer (0.5-5ms)

## Redis vs Memcached
- **Redis:** Persistence (AOF/RDB), data structures, Pub/Sub, cluster, Lua scripting
- **Memcached:** Simple K/V, multi-threaded, no persistence, volatile

## CDN: Push vs Pull

| Model | Cold Start | Storage Cost | Best For |
|-------|-----------|-------------|---------|
| Pull | First user hits origin | Only requested content | Web assets, APIs |
| Push | Zero (pre-cached) | All content at all PoPs | Large files, video |

## CDN Key Concepts
- **Origin Shield:** Regional hub prevents thundering herd to origin
- **Stale-While-Revalidate:** Serve stale, revalidate in background
- **Fingerprinted URLs:** `style.abc123.css` → long TTL, instant invalidation
- **ESI (Edge Side Includes):** Assemble personalized pages at edge

## When to Add Cache
- DB reads > 80% of load
- Same data requested repeatedly (hot 20% serves 80% of traffic)
- Acceptable staleness window exists
- 90%+ hit rate multiplies DB capacity ~10x
