# Modern Systems & Interview Framework

## Cloud-Native (12-Factor Essentials)
- Stateless processes: external state (DB, cache, queue)
- Config from environment (not hardcoded)
- Disposability: <5s startup enables fast rescheduling
- Immutable deployments: new image tag = upgrade, previous tag = rollback

## Kubernetes Key Concepts
- **HPA:** Scale replicas on CPU/memory/custom metrics
- **VPA:** Right-size resource requests
- **Cluster Autoscaler:** Add/remove nodes on demand
- Service mesh (Istio/Linkerd): mTLS + traffic splitting (2-3% CPU overhead)

## Container vs VM
- Container: <1s startup, higher density, shared kernel
- VM: stronger isolation, worse density, full OS

## ML Systems Pipeline
Data Collection → Feature Engineering → Training → Evaluation → Serving

## ML Key Concepts
- **Feature Store:** Unified offline (training) + online (serving) features; prevents training-serving skew
- **Distributed Training:** Data parallelism (same model, different batches) vs model parallelism (split model across GPUs)
- **Quantization:** INT8 = 2-4x faster, ~1% accuracy loss; FP16 = <0.1% loss
- **ML system = 5% ML code + 95% infrastructure**

## Interview Framework (5-10-20-10)

### Step 1: Requirements (5 min)
- Functional: user actions, APIs, scope in/out
- Non-functional: DAU, RPS, latency SLA, consistency model

### Step 2: Estimation (10 min)
- Traffic: RPS from DAU x actions/day / 86,400
- Storage: per-record x daily x retention x 3 (replication)
- State assumptions explicitly; round aggressively

### Step 3: High-Level Design (20 min)
- Client → API → services → storage
- Walk through critical user journey end-to-end
- Justify each component added

### Step 4: Deep Dive (10 min)
- Bottlenecks, failure scenarios, scale strategies
- Express trade-offs: "I chose X because..."

## 11 Critical Patterns

| Pattern | Use When | Trade-off |
|---------|---------|-----------|
| Read replica | Scale reads | Eventual consistency |
| Horizontal sharding | Scale writes | Cross-shard queries expensive |
| Cache-aside | Reduce DB load | Invalidation complexity |
| Write-through cache | Keep cache warm | Higher write latency |
| Fan-out on write | Low-latency reads | High write amplification |
| Fan-out on read | Low write cost | Higher read latency |
| CQRS | Different read/write scaling | Sync complexity |
| Event sourcing | Audit trail, temporal queries | Replay cost |
| Saga | Distributed transactions | Compensating actions |
| Circuit breaker | Prevent cascades | Threshold tuning |
| Consistent hashing | Minimize rehashing | Virtual nodes needed |

## Component Decision Tree
- Read-heavy + hot data fits memory → **Cache (Redis)**
- Write-heavy + DB bottleneck → **Message queue**
- Multi-region + static → **CDN**
- Full-text search → **Elasticsearch**
- Distributed transactions → **Saga pattern**
- Flaky downstream → **Circuit breaker + backoff**

## Red Flags to Avoid
- Over-engineering without justification
- Silence (narrate your thinking)
- Jumping to implementation before completing requirements
- Defending bad decisions instead of discussing trade-offs
- Ignoring failure modes
