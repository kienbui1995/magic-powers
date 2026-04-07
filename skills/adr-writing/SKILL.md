---
name: adr-writing
description: Use when documenting architecture decisions, capturing the context and trade-offs behind technical choices
---

# ADR Writing (Architecture Decision Records)

## When to Use
When making a significant technical decision that will be hard to reverse, affects multiple teams, or needs to be understood by future engineers.

## Core Jobs

### 1. Know When to Write an ADR
Write one when:
- Choosing between 2+ significant technical options
- The decision affects system architecture, not just implementation detail
- Future engineers will wonder "why did they do it this way?"
- The decision is hard to reverse (database choice, API protocol, auth system)

Don't write one for: library patch versions, CSS changes, minor refactoring.

### 2. ADR Template
```
# ADR-[NNN]: [Short Title]

**Date:** YYYY-MM-DD
**Status:** Proposed | Accepted | Deprecated | Superseded by ADR-NNN
**Deciders:** [names or teams]

## Context
[What situation are we in? What forces are at play? What is the problem?]

## Decision
[The decision we made. Use active voice: "We will use X because..."]

## Options Considered

### Option A: [Name]
**Pros:** ...
**Cons:** ...

### Option B: [Name]
**Pros:** ...
**Cons:** ...

## Consequences

**Positive:**
- [What becomes easier or better?]

**Negative:**
- [What becomes harder or worse? What do we give up?]

**Risks:**
- [What could go wrong?]

## References
- [Links to relevant docs, RFCs, benchmarks]
```

### 3. Keep ADRs Immutable
- Never edit an accepted ADR's decision section
- If decision changes: create a new ADR that supersedes it
- Update status of old ADR to "Superseded by ADR-NNN"

### 4. Store and Link
- Keep in `docs/adr/` in the repo (versioned with code)
- Link from CLAUDE.md or README
- Reference in code comments when a non-obvious choice was made

## Key Outputs
- ADR document (in `docs/adr/`)
- Status updated in future ADRs if decision changes

## Anti-Patterns
- ADR written after the decision, without options considered
- Decision section is vague ("we chose Postgres because it's good")
- Editing accepted ADRs instead of superseding
- ADRs stored in Confluence/Notion, not in the repo
