# System Design Advisor

AI coding assistant skills for system design — powered by knowledge from [The Engineer's Handbook](https://bachdx-learning-hub.vercel.app/).

> 25 chapters of system design knowledge distilled into **16 reference files** covering 100+ topics — **tested across 3 rounds against 100 real interview problems** (4.90/5 beginner, 4.25/5 intermediate accuracy). Plus 6 design pattern reference files covering GoF, modern, and distributed patterns. All skills generate **Mermaid diagrams** for architecture visualization.

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

### Interactive Clarifying Questions

All skills ask targeted questions before responding to deliver more relevant answers:

- **system-design-advisor** — Asks about your scale, access pattern, and constraints when context is missing. Skips for conceptual questions like "explain CAP theorem".
- **design-plan-generator** — Always asks 2-5 scoping questions (target DAU, read/write ratio, consistency model, tech constraints) before generating a plan.
- **architecture-reviewer** — Gathers context about your scale targets, top concerns, SLA, and planned changes before scanning. Say "just scan it" to skip.

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

### Design Pattern References

6 reference files covering software design patterns:

- **creational-patterns.md** — Factory Method, Abstract Factory, Builder, Prototype, Singleton
- **structural-patterns.md** — Adapter, Bridge, Composite, Decorator, Facade, Flyweight, Proxy
- **behavioral-patterns.md** — Strategy, Observer, Command, State, Chain of Responsibility, Mediator, Iterator, Visitor, Template Method, Memento
- **modern-patterns.md** — Functional patterns, Dependency Injection, Options pattern, Plugin architecture
- **distributed-patterns.md** — CQRS, Event Sourcing, Saga, Outbox, Circuit Breaker, Bulkhead, Anti-Corruption Layer
- **anti-patterns-and-selection.md** — God Object, Spaghetti Code, Golden Hammer, Cargo Cult, pattern selection guide

## Installation

### Claude Code (global)

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

Skills tested against **100 system design interview problems** across 3 rounds of iterative improvement:

| Batch | # Problems | Difficulty | Avg Accuracy | Avg Actionable | Coverage |
|-------|-----------|------------|-------------|----------------|---------|
| Batch 1 | 20 | Beginner | **4.90** / 5 | **4.55** / 5 | **85%** |
| Batch 2 | 20 | Intermediate | **4.25** / 5 | **4.10** / 5 | **75%** |
| Batch 3-4 | 25 targeted | Intermediate–Advanced | **4.08** / 5 | **3.88** / 5 | **80%** |

### Improvement Across 3 Rounds

| Metric | R1 (8 refs) | R2 (12 refs) | R3 (16 refs) |
|--------|------------|-------------|-------------|
| Avg Accuracy | 3.08/5 | 4.18/5 | **4.41/5** |
| Full Coverage | 31% | 61% | **80%** |
| Zero-Coverage | 25% | 5% | **2%** |
| Reference Files | 8 | 12 | **16** |

Full test reports: [View on the handbook site](https://bachdx-learning-hub.vercel.app/skills#quality-validation)

## Source

All knowledge is from [The Engineer's Handbook](https://bachdx-learning-hub.vercel.app/) — a free, open-source system design reference with 25 chapters, 200+ diagrams, and real-world case studies.

## License

MIT
