# System Design Advisor

AI coding assistant skills for system design — powered by knowledge from [The Engineer's Handbook](https://bachdx-learning-hub.vercel.app/).

> 25 chapters of system design knowledge distilled into **17 reference files** covering 100+ topics — **tested across 3 rounds against 100 real interview problems** (4.90/5 beginner, 4.25/5 intermediate accuracy). Plus 6 design pattern reference files covering GoF, modern, and distributed patterns. All skills generate **Mermaid diagrams** for architecture visualization.

## What's Included

### System Design Skills

| Skill | Description | Trigger |
|-------|------------|---------|
| **system-design-advisor** | Answer system design questions, explain tradeoffs, component selection | "Should I use SQL or NoSQL?", "Explain CAP theorem" |
| **design-plan-generator** | Generate step-by-step system design plans using 4-step framework | "Design a URL shortener", "Architect a chat system" |
| **architecture-reviewer** | Auto-scan and review project architecture against best practices | "Review my architecture", "Is this scalable?" |

### Design Pattern Skills

| Skill | Description | Trigger |
|-------|------------|---------|
| **design-patterns-advisor** | Answer questions about GoF, modern, and distributed design patterns with Mermaid diagrams | "When should I use Factory vs Builder?", "Explain Observer pattern" |
| **pattern-implementation-guide** | Generate implementation plans with code examples and class diagrams for applying patterns | "How do I implement Strategy pattern in TypeScript?", "Add CQRS to my service" |
| **code-pattern-reviewer** | Auto-scan code for anti-patterns, God Objects, and pattern improvement opportunities | "Review my code for patterns", "Is this good design?" |

### Which Skill When?

```
📚 Learning / Studying
   → /system-design-advisor        "Explain CAP theorem"
   → /design-patterns-advisor      "When to use Factory vs Builder?"

🏗️ Building a New System
   → /design-plan-generator        "Design a chat system for 10M DAU"
   → /pattern-implementation-guide "Implement CQRS for my order service"

🔍 Reviewing Existing Code
   → /architecture-reviewer        "Is my system scalable?"
   → /code-pattern-reviewer        "Review my code for anti-patterns"

❓ Making a Decision
   → /system-design-advisor        "SQL or NoSQL for my use case?"
   → /design-patterns-advisor      "Strategy vs State pattern?"
```

### Interactive Clarifying Questions

All skills ask targeted questions before responding:

- **system-design-advisor** — Asks about scale, access pattern, constraints. Skips for conceptual questions.
- **design-plan-generator** — Asks 2-5 scoping questions (DAU, read/write ratio, consistency, tech constraints).
- **architecture-reviewer** — Gathers context about scale targets, concerns, SLA. Say "just scan it" to skip.

## Knowledge Base

### System Design References

Distilled from 25 chapters across 5 parts:

- **Fundamentals** — Scalability, CAP/PACELC, estimation, latency analysis
- **Building Blocks** — DNS, load balancing, caching, CDN, SQL/NoSQL, message queues, protocols
- **Architecture** — Microservices, event-driven, replication, security, monitoring
- **Case Studies** — URL shortener, social feed, chat, video streaming, ride-sharing, web crawler, file sync, notifications
- **Modern** — Cloud-native, ML systems, interview framework
- **Search & Indexing** — Inverted index, trie, BM25, Elasticsearch, autocomplete, web crawler
- **Real-Time & Streaming** — WebRTC, SFU/MCU, Flink, time-series DBs, stream processing
- **Storage & Infrastructure** — Object storage, HDFS, file sync, config management, LSM-tree, OLAP, ELK
- **Specialized Systems** — Unique IDs, distributed locks, payments, stock exchange, game networking, spatial indexing
- **Operational Troubleshooting** — Redis debugging (SLOWLOG, memory, stampede), Kafka (consumer lag, rebalancing), Postgres (pg_stat_statements, locks, vacuum), migration strategies (Strangler Fig, dual-write, canary)

### Design Pattern References

6 reference files covering software design patterns:

- **creational-patterns.md** — Factory Method, Abstract Factory, Builder, Prototype, Singleton
- **structural-patterns.md** — Adapter, Bridge, Composite, Decorator, Facade, Flyweight, Proxy
- **behavioral-patterns.md** — Strategy, Observer, Command, State, Chain of Responsibility, Mediator, Iterator, Visitor, Template Method, Memento
- **modern-patterns.md** — Functional patterns, Dependency Injection, Options pattern, Plugin architecture
- **distributed-patterns.md** — CQRS, Event Sourcing, Saga, Outbox, Circuit Breaker, Bulkhead, Anti-Corruption Layer
- **anti-patterns-and-selection.md** — God Object, Spaghetti Code, Golden Hammer, Cargo Cult, pattern selection guide

## Installation

### Claude Code (plugin — recommended)

```bash
claude plugin add bachdx2812/system-design-advisor
```

After installing, invoke with `/system-design-advisor:system-design-advisor`, `/system-design-advisor:design-plan-generator`, etc.

### Claude Code (global skills)

```bash
# One-line install (or update)
bash <(curl -s https://raw.githubusercontent.com/bachdx2812/system-design-advisor/main/install.sh)
```

Or manually:

```bash
git clone https://github.com/bachdx2812/system-design-advisor.git
cd system-design-advisor && bash install.sh
```

After installing, invoke with `/system-design-advisor`, `/design-plan-generator`, `/architecture-reviewer`, `/design-patterns-advisor`, `/pattern-implementation-guide`, or `/code-pattern-reviewer`.

### Claude Code (project-level)

```bash
git clone https://github.com/bachdx2812/system-design-advisor.git
cp -r system-design-advisor/skills/* .claude/skills/
for skill in system-design-advisor design-plan-generator architecture-reviewer design-patterns-advisor pattern-implementation-guide code-pattern-reviewer; do
  cp -r system-design-advisor/references .claude/skills/$skill/
done
```

### Cursor

```bash
git clone https://github.com/bachdx2812/system-design-advisor.git
cd system-design-advisor && bash install-cursor.sh
```

Rules auto-activate based on your prompts — no manual invocation needed.

### Update

```bash
cd system-design-advisor && git pull && bash install.sh
```

## Usage Examples

### System Design Advisor
```
> /system-design-advisor
> Should I use Redis or Memcached for my caching layer?
```

### Design Plan Generator
```
> /design-plan-generator chat messaging system
```

### Architecture Reviewer
```
> /architecture-reviewer
```
(Auto-scans your project and produces a findings table)

### Design Patterns Advisor
```
> /design-patterns-advisor
> When should I use Factory vs Builder pattern?
```

### Pattern Implementation Guide
```
> /pattern-implementation-guide implement Observer pattern for my event system in TypeScript
```

### Code Pattern Reviewer
```
> /code-pattern-reviewer
```
(Auto-scans your project code and produces a findings table with pattern recommendations)

## Quality Validation

Tested across **4 rounds** using 3 methods: reference coverage (100 problems), live response generation (20 problems), and workflow simulation (4 scenarios).

### How We Tested

1. **Reference Coverage** — Each of 100 system design problems evaluated: Does the reference cover it? How accurate? How actionable?
2. **Live Response Generation** — Skill generates a full response (trade-offs, diagrams, key numbers) which is then scored on accuracy, completeness, actionability, diagram quality, and practical value (1-5 each).
3. **Workflow E2E** — Chain 2-4 skills in sequence (e.g., reviewer → advisor → implementation guide) and evaluate coherence, redundancy, and handoff quality.

### Improvement Across 4 Rounds

| Metric | R1 (8 refs) | R2 (12 refs) | R3 (16 refs) | R4 (23 refs) |
|--------|------------|-------------|-------------|-------------|
| Avg Accuracy | 3.08/5 | 4.18/5 | 4.41/5 | **4.88/5** |
| Full Coverage | 31% | 61% | 80% | **95%** |
| Zero-Coverage | 25% | 5% | 2% | **0%** |
| Reference Files | 8 | 12 | 16 | **23** |

### R4 Live Test: Sample Results

| Problem | Type | Score | Highlights |
|---------|------|-------|-----------|
| Kafka vs RabbitMQ (10K orders/day) | Interview | 5.0 | Correct recommendation, exactly-once pattern with sequence diagram |
| URL Shortener (100M/day, <50ms p99) | Interview | 5.0 | KGS, latency budget breakdown, Bloom filter for invalid keys |
| Postgres 90% CPU (50M rows, 5K QPS) | Real-world | 5.0 | 3-phase fix (indexes → cache → replicas), decision flowchart |
| Idempotent payment webhooks (Stripe) | Real-world | 5.0 | Atomic ON CONFLICT pattern, race condition handling |
| 3 microservices deadlocking shared DB | Real-world | 5.0 | Root cause (lock ordering), before/after architecture diagram |
| API p99 spike (50ms → 2s) | Real-world | 5.0 | Parallel + async + cache + circuit breaker hierarchy |
| Factory vs Abstract Factory | Interview | 5.0 | Decision criteria with Mermaid class diagram |
| Saga for checkout (TypeScript) | Real-world | 5.0 | Full orchestrator code, compensating actions, tests |
| God Object decomposition | Real-world | 4.6 | Facade + Strategy, step-by-step refactoring plan |

**Overall: 4.88/5** — Real-world problems (5.0) scored higher than interview questions (4.76).

### R4 Workflow E2E: Results

| Scenario | Skills Used | Score |
|----------|------------|-------|
| Interview Prep (SQL/NoSQL → URL design → caching) | 3 skills | 4.3/5 |
| E-Commerce Checkout (design → Saga → implement) | 3 skills | 4.5/5 |
| Legacy Code Improvement (review → diagnose → fix → validate) | 4 skills | 4.5/5 |
| Rapid A-vs-B Decisions (4 quick questions) | 2 skills | 3.5/5 |

**R4 improvements:** TypeScript examples alongside Go, operational troubleshooting reference, context-aware workflow to reduce redundancy when chaining skills.

Full test reports and all 100 problems: [View on the handbook site](https://bachdx-learning-hub.vercel.app/skills#quality-validation)

## Source

All knowledge is from [The Engineer's Handbook](https://bachdx-learning-hub.vercel.app/) — a free, open-source system design reference with 25 chapters, 200+ diagrams, and real-world case studies.

## License

MIT
