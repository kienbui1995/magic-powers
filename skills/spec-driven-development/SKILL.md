---
name: spec-driven-development
description: Use when starting any non-trivial feature — enforces requirements → design → tasks workflow with explicit approval gates before writing code. Prevents wasted implementation effort.
---

# Spec-Driven Development (SDD)

Approve the spec before writing the plan. Approve the plan before writing code. This catches wrong assumptions early, when they're cheap to fix.

<HARD-GATE>
Do NOT write any implementation code until you have completed all 3 phases and received explicit user approval at each gate. No exceptions.
</HARD-GATE>

## When to Use

- Any feature with more than one moving part
- Anything touching external APIs, databases, or auth
- Features that will take more than 30 minutes to implement
- When requirements are unclear or changing

## The 3-Phase Workflow

```
Phase 1: Requirements  →  [GATE: user approves]
Phase 2: Design        →  [GATE: user approves]
Phase 3: Tasks         →  [GATE: user approves]
                            ↓
                    writing-plans + executing-plans
```

---

## Phase 1: Requirements

**Goal:** Know exactly what to build before deciding how.

Ask the user one question at a time:
1. **Who** is this for? (user role, persona)
2. **What** problem does it solve? (job to be done)
3. **What** does success look like? (measurable outcome)
4. **What** are the constraints? (performance, security, compatibility)
5. **What** is explicitly out of scope?

Then write a structured requirements doc:

```markdown
# Requirements: [Feature Name]
Date: YYYY-MM-DD

## Problem
[1-2 sentences. What pain does this solve?]

## Users
[Who uses this and in what context]

## Requirements
### Must Have
- WHEN [trigger], the system SHALL [behavior]
- WHEN [user action], the system SHALL [response] WITHIN [constraint]

### Should Have
- [Nice-to-have, won't block launch]

### Out of Scope
- [Explicit exclusions — prevents scope creep]

## Success Criteria
- [ ] [Measurable, testable criterion]
- [ ] [Measurable, testable criterion]
```

Save to `docs/specs/YYYY-MM-DD-<feature>-requirements.md` and commit.

**Gate 1:**
> "Requirements written. Please review `<path>` before we move to design. Any corrections or additions?"

Wait for explicit approval. Do not proceed without it.

---

## Phase 2: Design

**Goal:** Decide how to build it before building.

Use `@architect` (Opus) for complex designs. For simple features, Sonnet is fine.

Cover:
- **Architecture** — what components, how they connect
- **Data model** — schemas, types, interfaces
- **API contracts** — endpoints, inputs, outputs, errors
- **Edge cases** — what can go wrong, how to handle it
- **Testing strategy** — unit, integration, e2e

```markdown
# Design: [Feature Name]

## Architecture
[Diagram or description of components and data flow]

## Data Model
[Schemas, types, key fields]

## API / Interface
[Endpoints or function signatures with types]

## Error Handling
[What fails, how to handle each case]

## Testing
[What to test, what not to test]

## Open Questions
[Unresolved decisions — resolve before implementing]
```

Save to `docs/specs/YYYY-MM-DD-<feature>-design.md` and commit.

Run `@reviewer` (Haiku) to check the design for inconsistencies. Fix issues, then:

**Gate 2:**
> "Design written. Please review `<path>`. Are there any open questions to resolve before we break this into tasks?"

Wait for explicit approval. Do not proceed without it.

---

## Phase 3: Task Breakdown

**Goal:** Break the design into atomic, executable tasks with clear dependencies.

Each task must be:
- **Independent** — can be reviewed and merged on its own
- **Verifiable** — has a clear done condition
- **Small** — completable in one focused session

```markdown
# Tasks: [Feature Name]

## Dependencies
- [ ] Task 1 must complete before Task 3
- [ ] Tasks 2 and 3 can run in parallel

## Task 1: [Name]
**Depends on:** none
**Done when:** [test passes / endpoint returns X / UI shows Y]

Steps:
- [ ] Write failing test
- [ ] Implement minimal code
- [ ] Verify test passes
- [ ] Commit

## Task 2: [Name]
...
```

Save to `docs/specs/YYYY-MM-DD-<feature>-tasks.md` and commit.

**Gate 3:**
> "Task breakdown ready at `<path>`. Ready to start implementation?
> 1. **Subagent-driven** (recommended) — fresh agent per task, review between
> 2. **Inline** — execute in this session with checkpoints"

---

## Execution

- Subagent-driven → use `magic-powers:subagent-driven-development`
- Inline → use `magic-powers:executing-plans`
- For the implementation plan format → use `magic-powers:writing-plans`

## Model Routing

| Phase | Agent | Model | Why |
|---|---|---|---|
| Requirements | Default | Sonnet | Dialogue, light reasoning |
| Design | `@architect` | Opus | Deep system thinking |
| Design review | `@reviewer` | Haiku | Fast consistency check |
| Tasks | Default | Sonnet | Structured breakdown |
| Implementation | Per-task agents | Varies | Cost-optimized routing |

## Key Principles

- **One gate at a time** — never skip approval
- **Write it down** — specs in repo, committed, reviewable
- **YAGNI** — cut scope ruthlessly at requirements phase
- **Wrong assumptions are cheap now, expensive later**
