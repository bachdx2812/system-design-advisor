---
name: design-plan-generator
description: Generate step-by-step system design plans for any system. Use when user says "design a...", "architect a...", "plan a system for...", or needs a complete system design from scratch. Produces structured plans with components, data flow, scaling strategy, and tradeoffs.
version: 1.0.0
user-invocable: true
argument-hint: "[system-name] e.g. 'URL shortener', 'chat app', 'video platform'"
---

# Design Plan Generator

Generate a complete system design plan for `$ARGUMENTS` using the 4-step framework.

## Framework

Execute these 4 steps in order. Load references as needed.

### Step 1: Requirements (clarify scope)

**ALWAYS ask clarifying questions first** using `AskUserQuestion` tool before generating a plan. Ask 2-5 questions based on what's missing:

| Category | Questions |
|----------|-----------|
| **Scale** | "Target DAU/MAU?", "Expected QPS (read vs write)?", "Data volume per day?" |
| **Features** | "What are the 3-5 core features? (I'll suggest if unsure)", "What's explicitly out of scope?" |
| **Constraints** | "Latency SLA? (e.g., p99 < 200ms)", "Consistency model? (strong vs eventual)", "Availability target? (99.9% vs 99.99%)" |
| **Context** | "Is this greenfield or extending existing system?", "Any tech stack preferences/constraints?", "Cloud provider preference?" |
| **Access pattern** | "Read-heavy or write-heavy?", "Bursty or steady traffic?", "Global or single-region?" |

**If user provides `$ARGUMENTS` with enough detail** (e.g., "Design a URL shortener for 100M DAU with <100ms p99"), reduce to 1-2 confirmation questions.

After collecting answers, proceed with:

**Functional:** What must the system do? List 3-5 core features.
**Non-functional:** DAU target, latency SLA (p50/p99), availability (nines), consistency model.
**Out of scope:** What are we NOT building.

### Step 2: Estimation

Reference: [fundamentals-and-estimation.md](references/fundamentals-and-estimation.md)

Calculate and state assumptions:
- **Traffic:** QPS (read + write separately) from DAU. State the read:write ratio explicitly.
- **Storage:** Per-record size x daily volume x retention x 3 (replication)
- **Bandwidth:** QPS x avg payload size
- **Cache:** Hot data % x working set size

Use the read:write ratio to select scaling strategy (read-heavy → replicas+cache, write-heavy → sharding+queues).

### Step 3: High-Level Design

References: [case-studies.md](references/case-studies.md), [architecture-patterns.md](references/architecture-patterns.md)

Load additional references based on domain:
- Search/autocomplete → [search-and-indexing.md](references/search-and-indexing.md)
- Real-time/video/streaming → [real-time-and-streaming.md](references/real-time-and-streaming.md)
- Storage/file sync/OLAP → [storage-and-infrastructure.md](references/storage-and-infrastructure.md)
- Payments/IDs/locks/gaming/geo → [specialized-systems.md](references/specialized-systems.md)
- Recommendations/ML/fraud/ads → [recommendation-and-ml-systems.md](references/recommendation-and-ml-systems.md)
- Batch/stream processing/ETL/warehouse → [data-processing-and-analytics.md](references/data-processing-and-analytics.md)
- Auth/OAuth/JWT/rate limiting → [authentication-and-security-deep-dive.md](references/authentication-and-security-deep-dive.md)
- OOP design/parking lot/elevator/leaderboard → [low-level-design-patterns.md](references/low-level-design-patterns.md)

- Define API endpoints (REST/gRPC)
- Design data model (entities, relationships, access patterns)
- **Draw Mermaid architecture diagram** showing all components and data flow:
  ```mermaid
  graph LR
      Client --> LB[Load Balancer]
      LB --> API[API Servers]
      API --> Cache[(Redis)]
      API --> DB[(Primary DB)]
      API --> Queue[Message Queue]
      Queue --> Workers[Workers]
  ```
  Use `graph LR` for architecture, `sequenceDiagram` for API flows, `erDiagram` for data models
- Justify each component added

### Step 4: Deep Dive

References: [databases.md](references/databases.md), [caching-and-cdn.md](references/caching-and-cdn.md)

- Identify top 2-3 bottlenecks
- Propose scaling strategy for each
- Address failure scenarios
- Discuss trade-off decisions made

## Output Format

Present the plan inline. After presenting, ask: "Save this plan to a file?"
If yes, write to `plans/system-design-{name}.md` in the current project.

## Source

Framework from [The Engineer's Handbook](https://bachdx-learning-hub.vercel.app/) Ch25 Interview Framework.
