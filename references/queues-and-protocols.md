# Message Queues & Communication Protocols

## When to Add a Queue
- Decouple producers from consumers
- Absorb traffic spikes (temporal decoupling)
- DB write bottleneck (buffer writes)
- Long-running tasks (async processing)
- Fan-out to multiple consumers

## Delivery Guarantees
- **At-most-once:** Fire-forget, no retries (metrics, logs)
- **At-least-once:** ACK after processing, retries (most business logic)
- **Exactly-once:** At-least-once + idempotent consumer (payments, inventory)

## Queue Comparison

| Feature | Kafka | RabbitMQ | SQS |
|---------|-------|----------|-----|
| Model | Distributed commit log | AMQP broker | Managed queue |
| Ordering | Per-partition | Per-queue | FIFO variant only |
| Replay | Yes (offset-based) | No (consumed = gone) | No |
| Throughput | Very high (MB/s) | Moderate | Moderate |
| Best for | Event streaming, CDC | Task queues, routing | Simple async, serverless |

## Queue Patterns
- **Fan-out:** One event → many consumers (consumer groups)
- **Fan-in:** Aggregate results from workers
- **Pub/Sub:** Topic-based broadcast
- **Dead Letter Queue:** Failed messages after max retries
- **Back pressure:** Drop / Buffer / Throttle / Rate limit

## Communication Protocols

| Protocol | Transport | Multiplexing | Best For |
|----------|-----------|-------------|---------|
| HTTP/1.1 | TCP | No | Legacy, simple APIs |
| HTTP/2 | TCP | Yes (streams) | Web apps, APIs |
| HTTP/3 | QUIC/UDP | Yes (no HoL blocking) | Mobile, high-latency |
| WebSocket | TCP | Bidirectional | Chat, real-time, gaming |
| gRPC | HTTP/2 + Protobuf | Bidirectional streaming | Microservices, low-latency |
| SSE | HTTP | Server → client only | Live feeds, notifications |

## REST vs GraphQL vs gRPC

| Aspect | REST | GraphQL | gRPC |
|--------|------|---------|------|
| Contract | URL paths + verbs | Schema + resolvers | Protobuf IDL |
| Over-fetching | Yes (fixed responses) | No (client specifies) | No (typed messages) |
| Caching | HTTP native | Custom | No HTTP caching |
| Streaming | No (SSE workaround) | Subscriptions | Native bidirectional |
| Best for | Public APIs, web | Mobile, complex UIs | Internal microservices |

## HTTP Idempotency
- **Idempotent (safe to retry):** GET, PUT, DELETE
- **Not idempotent:** POST (use idempotency keys for payments)
