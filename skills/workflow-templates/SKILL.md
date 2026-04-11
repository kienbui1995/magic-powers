---
name: workflow-templates
description: Use when executing a structured workflow — select and run a feature, bugfix, refactor, research, or incident template with correct agent and model assignments per phase.
---

# Workflow Templates

## When to Use
- Starting any multi-step development task with a known type
- Want consistent, repeatable workflow for feature/bugfix/refactor/research/incident
- Need to know which agents and models to use for each phase of work

## Core Jobs

### 1. Template Selection

Auto-detect from task description keywords:

| Keywords | Template |
|----------|---------|
| add, implement, build, create, new | **feature** |
| fix, broken, error, bug, failing, crash | **bugfix** |
| clean, refactor, improve, simplify, restructure | **refactor** |
| research, investigate, understand, explore, evaluate | **research** |
| down, outage, urgent, production, incident, p0, p1 | **incident** |

If ambiguous → ask user to confirm before executing.

Always confirm (don't auto-detect) when description contains BOTH types:
- "fix AND refactor the auth module" → bugfix or refactor?
- "improve login performance" → feature (add optimization) or refactor (restructure)?
- "clean up broken tests" → bugfix (tests failing) or refactor (tests messy but passing)?
- "investigate and fix the memory leak" → research first, or straight to bugfix?

### 2. Template Definitions

**Feature Template** — Adding new functionality:
```
Phase 1: PLAN        @architect (Opus)   — clarify requirements, design, write plan
Phase 2: IMPLEMENT   subagents (Sonnet)  — parallel implementation per component
Phase 3: TEST        subagents (Sonnet)  — write and run tests for implemented code
Phase 4: REVIEW      @reviewer (Haiku)   — code review, spec compliance check
```

**Bugfix Template** — Fixing broken behavior:
```
Phase 1: REPRODUCE   subagent (Sonnet)   — write failing test that reproduces bug
Phase 2: DIAGNOSE    @debugger (Sonnet)  — systematic root cause analysis
Phase 3: FIX         subagent (Sonnet)   — minimal fix to make test pass
Phase 4: VERIFY      @reviewer (Haiku)   — verify fix, check for regressions
```

**Refactor Template** — Improving existing code without changing behavior:
```
Phase 1: ANALYZE     @architect (Opus)   — understand current structure, identify problems
Phase 2: PLAN        @architect (Opus)   — design target state, migration path
Phase 3: IMPLEMENT   subagents (Sonnet)  — refactor in small, test-passing increments
Phase 4: REVIEW      @reviewer (Haiku)   — final review, confirm behavior unchanged
```

**Research Template** — Investigation and decision-making:
```
Phase 1: GATHER      subagents (Sonnet)  — parallel research on options/alternatives
Phase 2: SYNTHESIZE  @architect (Opus)   — analyze tradeoffs, form recommendation
Phase 3: DOCUMENT    @technical-writer (Haiku) — write ADR or decision doc
```

**Incident Template** — Production emergency response:
```
Phase 1: TRIAGE      @debugger (Sonnet)  — identify blast radius, immediate mitigations
Phase 2: HOTFIX      subagent (Sonnet)   — minimal fix to restore service
Phase 3: POSTMORTEM  @technical-writer (Haiku) — document timeline, root cause, prevention
```

### 3. Phase Dispatch Rules

- **Sequential phases:** Each phase waits for previous to complete (default)
- **Parallel within phase:** If IMPLEMENT phase has 3 independent components → dispatch 3 subagents simultaneously
- **Phase completion gate:** After each phase, @orchestrator reviews output before proceeding
- **User interrupt point:** After each phase completion message, user can redirect or stop
- **Snapshot trigger:** @session saves progress after each phase

### 4. Context Isolation Per Phase

Each phase subagent receives ONLY:
- Task description (original)
- Phase-specific instructions
- Output from directly preceding phase (not full session history)
- Relevant file paths

Never forward full session history to subagents — causes confusion and wastes tokens.

## Key Concepts
- **Phase** — one logical step in a workflow (plan, implement, review)
- **Template** — ordered sequence of phases with agent+model assignments
- **Phase gate** — orchestrator review between phases before proceeding
- **Parallel dispatch** — multiple subagents in same phase for independent subtasks

## Checklist
- [ ] Template type identified (auto-detected or confirmed with user)?
- [ ] Phase sequence loaded with correct agent + model per phase?
- [ ] Context isolation enforced (no session history leak to subagents)?
- [ ] User interrupt opportunity after each phase completion?
- [ ] @session snapshot called after each major phase?

## Key Outputs
- Phase-by-phase execution with progress tracking via TodoWrite
- Completion summary: what each phase produced

## Output Format
- 🔴 **Critical** — starting implementation without plan phase, no phase gates (rushing through)
- 🟡 **Warning** — using same model for all phases (over/under-powered), no parallel dispatch when phases have independent subtasks
- 🟢 **Suggestion** — snapshot after each phase for resumability, confirm template before executing for ambiguous tasks

## Anti-Patterns
- Skipping plan phase for features (causes rework)
- Leaking full session context to subagents (confusion + token waste)
- Using Opus for review phases (Haiku is 60x cheaper and sufficient)
- Not allowing user interrupt between phases (removes control)

## Integration
- `@workflow-orchestrator` uses this skill to load and execute templates
- `dispatching-parallel-agents` skill used within phases that have parallel subagents
- `subagent-driven-development` skill used for sequential phase execution with review
