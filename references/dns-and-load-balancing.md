# DNS & Load Balancing

## DNS Routing Strategies

| Strategy | Use Case | Trade-off |
|----------|---------|-----------|
| Round-Robin | Simple distribution | No health awareness |
| Weighted | Blue-green, A/B testing | Manual weight mgmt |
| Latency-Based | Global routing | Needs latency infra |
| Geolocation | Data residency, compliance | VPN accuracy issues |
| Failover | Disaster recovery | Requires health checks |

## DNS Records
- **A/AAAA:** IP mapping (IPv4/IPv6)
- **CNAME:** Alias (not on root domain)
- **MX:** Email routing
- **TXT:** Verification, SPF, DKIM

## TTL Trade-off
- Short (seconds): quick failover, higher DNS load
- Long (hours): lower load, slower failover

## Load Balancer: L4 vs L7

| Dimension | L4 (Transport) | L7 (Application) |
|-----------|----------------|-------------------|
| Inspection | IP + port only | Full HTTP parsing |
| Routing | 4-tuple hash | URL, headers, cookies |
| SSL | Pass-through only | Terminates (offloads backend) |
| Content routing | No | Yes (/api/* → API servers) |
| Overhead | Microseconds | Milliseconds |
| Best for | Gaming, DBs, raw throughput | Web apps, microservices |
| Examples | AWS NLB, HAProxy TCP | AWS ALB, Nginx, Envoy |

## LB Algorithms

| Algorithm | Best For | Weakness |
|-----------|---------|----------|
| Round-Robin | Homogeneous servers | Ignores load |
| Weighted RR | Different capacity servers | Manual tuning |
| Least Connections | Variable request duration | Connection tracking overhead |
| IP Hash | Session affinity | Pool changes break affinity |
| Consistent Hashing | Minimal remapping on change | Complex implementation |

## Decision Guide
- Stateless HTTP → L7 ALB with least connections
- Database/TCP → L4 NLB
- WebSocket → L7 with sticky sessions
- Global → DNS latency-based + regional L7
- Session affinity needed → consistent hashing or cookie-based
