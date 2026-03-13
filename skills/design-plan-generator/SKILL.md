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

**Functional:** What must the system do? List 3-5 core features.
**Non-functional:** DAU target, latency SLA (p50/p99), availability (nines), consistency model.
**Out of scope:** What are we NOT building?

If `$ARGUMENTS` is vague, ask clarifying questions before proceeding.

### Step 2: Estimation

Reference: [fundamentals-and-estimation.md](../../references/fundamentals-and-estimation.md)

Calculate and state assumptions:
- **Traffic:** QPS (read + write) from DAU
- **Storage:** Per-record size x daily volume x retention x 3 (replication)
- **Bandwidth:** QPS x avg payload size
- **Cache:** Hot data % x working set size

### Step 3: High-Level Design

References: [case-studies.md](../../references/case-studies.md), [architecture-patterns.md](../../references/architecture-patterns.md)

- Define API endpoints (REST/gRPC)
- Design data model (entities, relationships, access patterns)
- Draw component diagram: clients → LB → app servers → cache → DB → queue
- Justify each component added

### Step 4: Deep Dive

References: [databases.md](../../references/databases.md), [caching-and-cdn.md](../../references/caching-and-cdn.md)

- Identify top 2-3 bottlenecks
- Propose scaling strategy for each
- Address failure scenarios
- Discuss trade-off decisions made

## Output Format

Present the plan inline. After presenting, ask: "Save this plan to a file?"
If yes, write to `plans/system-design-{name}.md` in the current project.

## Source

Framework from [The Engineer's Handbook](https://bachdx-learning-hub.vercel.app/) Ch25 Interview Framework.
