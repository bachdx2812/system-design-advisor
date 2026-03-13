# System Design Advisor

AI coding assistant skills for system design — powered by knowledge from [The Engineer's Handbook](https://bachdx-learning-hub.vercel.app/).

> 25 chapters of system design knowledge distilled into 12 reference files covering 100+ system design topics — tested against 100 real interview problems.

## What's Included

| Skill | Description | Trigger |
|-------|------------|---------|
| **system-design-advisor** | Answer system design questions, explain tradeoffs, component selection | "Should I use SQL or NoSQL?", "Explain CAP theorem" |
| **design-plan-generator** | Generate step-by-step system design plans using 4-step framework | "Design a URL shortener", "Architect a chat system" |
| **architecture-reviewer** | Auto-scan and review project architecture against best practices | "Review my architecture", "Is this scalable?" |

### Interactive Clarifying Questions

All skills ask targeted questions before responding to deliver more relevant answers:

- **system-design-advisor** — Asks about your scale, access pattern, and constraints when context is missing. Skips for conceptual questions like "explain CAP theorem".
- **design-plan-generator** — Always asks 2-5 scoping questions (target DAU, read/write ratio, consistency model, tech constraints) before generating a plan.
- **architecture-reviewer** — Gathers context about your scale targets, top concerns, SLA, and planned changes before scanning. Say "just scan it" to skip.

## Knowledge Base

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

## Installation

### Claude Code

**Option 1: Copy skills (recommended)**

```bash
# Clone the repo
git clone https://github.com/bachdx2812/system-design-advisor.git

# Copy skills + references to your Claude Code skills directory
cp -r system-design-advisor/skills/* ~/.claude/skills/
cp -r system-design-advisor/references ~/.claude/skills/system-design-advisor/
cp -r system-design-advisor/references ~/.claude/skills/design-plan-generator/
cp -r system-design-advisor/references ~/.claude/skills/architecture-reviewer/
```

**Option 2: Project-level install**

```bash
# In your project directory
cp -r system-design-advisor/skills/* .claude/skills/
cp -r system-design-advisor/references .claude/skills/system-design-advisor/
cp -r system-design-advisor/references .claude/skills/design-plan-generator/
cp -r system-design-advisor/references .claude/skills/architecture-reviewer/
```

After installing, the skills appear as `/system-design-advisor`, `/design-plan-generator`, and `/architecture-reviewer` in Claude Code.

### Cursor

```bash
# Clone the repo
git clone https://github.com/bachdx2812/system-design-advisor.git

# Copy rules to your project
cp -r system-design-advisor/cursor/rules/* .cursor/rules/
```

Rules auto-activate based on your prompts — no manual invocation needed.

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

## Quality Validation

Skills were tested against **100 well-known system design interview problems** across 4 difficulty levels:

| Batch | Problems | Avg Accuracy | Avg Actionability | Coverage |
|-------|----------|-------------|-------------------|----------|
| Beginner (1-20) | Rate Limiter, URL Shortener, Web Crawler, Chat... | 4.15/5 | 4.10/5 | 85% |
| Intermediate A (21-40) | News Feed, Ride Sharing, Payment, Kafka... | 3.55/5 | 3.45/5 | 85% |
| Intermediate B (41-60) | Search Engine, Spotify, Zoom, YouTube... | 2.95/5 | 2.80/5 | 85% |
| Advanced (61-80) | Google Maps, HDFS, Blockchain, ML Pipeline... | 3.05/5 | 2.95/5 | 80% |
| Expert (81-100) | YouTube Rec Engine, Google Search, Twitter Scale... | 2.25/5 | 2.15/5 | 55% |

**Post-test improvements applied:**
- Added 4 new reference files (search, real-time, storage, specialized systems)
- Expanded case studies (web crawler, file sync, notifications)
- Added locking strategies, OLAP/OLTP, 2PC, API gateway patterns
- Updated topic routing to cover 12 reference files

Full test reports: [View on the handbook site](https://bachdx-learning-hub.vercel.app/skills#quality-validation)

## Source

All knowledge is from [The Engineer's Handbook](https://bachdx-learning-hub.vercel.app/) — a free, open-source system design reference with 25 chapters, 200+ diagrams, and real-world case studies.

## License

MIT
