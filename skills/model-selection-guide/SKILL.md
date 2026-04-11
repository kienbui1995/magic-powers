---
name: model-selection-guide
description: Use when choosing between Claude models for a task — decision tree for Haiku/Sonnet/Opus based on task type, cost estimates, escalation triggers, and cascade patterns.
---

# Model Selection Guide

## When to Use
- Unsure which model to use for a specific task
- Want to reduce cost without sacrificing quality
- Designing a multi-phase workflow with model assignments per phase
- @workflow-model-advisor uses this as its decision framework

## Core Jobs

### 1. Decision Tree

**Step 1: Identify task type**

```
Is this primarily reading + pattern matching + structured output?
  → Haiku (fast, cheap, accurate for structured tasks)
  Examples: code review, lint check, classify intent, format output,
            summarize doc, extract fields, check compliance

Is this implementation, debugging, or moderate reasoning?
  → Sonnet (balanced quality + cost)
  Examples: write code, fix bug, explain concept, write tests,
            analyze trade-offs (simple), build feature

Is this deep architecture, novel problem, or complex multi-step reasoning?
  → Opus (highest capability, use sparingly)
  Examples: system design, architecture decisions, evaluate complex trade-offs,
            research synthesis, "should we X or Y?" with many unknowns
```

**Step 2: Apply cost heuristic**

| Model | Relative cost | Speed | Best for |
|-------|-------------|-------|---------|
| Haiku | $ (1x) | Fastest | Review, classify, format, extract |
| Sonnet | $$ (5x) | Fast | Implement, debug, explain, write |
| Opus | $$$$ (15x) | Slower | Design, architecture, deep analysis |

**Step 3: Check override conditions**

Use Opus even for "simple" tasks if:
- Task has irreversible consequences (production changes, data migrations)
- Previous Sonnet attempt produced insufficient output

Use Haiku even for "complex" tasks if:
- Output is structured/templated (Haiku excels at templates)
- Task is repetitive across many items (batch processing)
- Speed is critical and quality threshold is moderate

### 2. Per-Workflow Model Assignments

| Workflow | Phase | Agent | Model | Why |
|---------|-------|-------|-------|-----|
| feature | plan | @architect | Opus | Architecture decisions need deep reasoning |
| feature | implement | subagent | Sonnet | Code generation, balanced |
| feature | test | subagent | Sonnet | Test writing needs understanding |
| feature | review | @reviewer | Haiku | Pattern matching, structured output |
| bugfix | reproduce | subagent | Sonnet | Needs to understand codebase |
| bugfix | diagnose | @debugger | Sonnet | Systematic debugging |
| bugfix | fix | subagent | Sonnet | Code fix, minimal |
| bugfix | verify | @reviewer | Haiku | Check fix completeness |
| refactor | analyze | @architect | Opus | Understanding complex structure |
| refactor | plan | @architect | Opus | Design target state |
| refactor | implement | subagent | Sonnet | Mechanical refactoring |
| refactor | review | @reviewer | Haiku | Pattern check |
| research | gather | subagent | Sonnet | Information gathering |
| research | synthesize | @architect | Opus | Complex reasoning over options |
| research | document | @technical-writer | Haiku | Structured doc output |
| incident | triage | @debugger | Sonnet | Fast diagnosis |
| incident | hotfix | subagent | Sonnet | Minimal fix |
| incident | postmortem | @technical-writer | Haiku | Structured template |

### 3. Cascade Pattern

When uncertain, start cheaper and escalate only if needed:

```
1. Try Haiku → evaluate output quality
2. If insufficient → escalate to Sonnet → evaluate
3. If still insufficient → escalate to Opus
4. Never auto-escalate without notifying user of cost increase
```

### 4. Cost Estimates Per Task

| Task type | Model | Estimated cost |
|-----------|-------|---------------|
| Code review (500 lines) | Haiku | ~$0.01 |
| Bug fix (small) | Sonnet | ~$0.05-0.15 |
| Feature implementation | Sonnet | ~$0.10-0.50 |
| Architecture design | Opus | ~$0.50-2.00 |
| Research synthesis | Opus | ~$0.50-1.50 |

**Cost reminder:** Opus = 15x Haiku. Code review in Opus costs 15x more with same quality output.

## Key Concepts
- **Haiku** — fast, cheap, accurate for structured/pattern tasks; NOT for deep reasoning
- **Sonnet** — balanced for most implementation; default for unknown tasks
- **Opus** — most capable; use only when task genuinely requires deep reasoning
- **Cascade** — start cheap, escalate if output quality insufficient
- **Cost multiplier** — Opus = 15x Haiku; always ask "does this task need Opus?"

## Checklist
- [ ] Task type identified before selecting model?
- [ ] Haiku considered first for review/classification/formatting tasks?
- [ ] Opus reserved for genuine architecture/deep-reasoning tasks?
- [ ] User notified if escalating from Haiku to Opus (15x cost increase)?
- [ ] Per-phase model assignments made for multi-phase workflows?

## Key Outputs
- Model recommendation with reasoning + cost estimate
- Cascade suggestion if task type is ambiguous

## Output Format
- 🔴 **Critical** — using Opus for code review or formatting (massive overspend), using Haiku for architecture decisions (under-powered)
- 🟡 **Warning** — defaulting to Sonnet for everything without considering Haiku for structured tasks
- 🟢 **Suggestion** — use cascade pattern for uncertain tasks, assign Haiku to all review phases

## Anti-Patterns
- Using Opus as the safe default (expensive, often unnecessary)
- Never using Haiku (leaving 60x savings on the table for review tasks)
- Using model complexity as proxy for task importance
- Switching models mid-task without reason (inconsistent output)

## Integration
- `workflow-templates` — model assignments per phase come from this skill
- `@workflow-model-advisor` uses this as its decision framework
- `@workflow-orchestrator` reads model assignments when dispatching phase subagents
