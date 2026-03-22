---
name: subagent-driven-development
description: Use when executing implementation plans with independent tasks in the current session
---

# Subagent-Driven Development

Execute plan by dispatching fresh subagent per task, with review after each.

**Why subagents:** Fresh context per task = focused work. Precisely crafted instructions = reliable results. Your context preserved for coordination.

**Core principle:** Fresh subagent per task + review = high quality, fast iteration.

## When to Use

- Have an implementation plan with independent tasks
- Want to stay in current session
- Tasks can be worked on without shared state

**vs. executing-plans:** Same session, fresh context per task, review between tasks, faster iteration.

## The Process

### For Each Task:

1. **Dispatch implementer subagent** with:
   - Task description from plan
   - Relevant file paths and context
   - Testing requirements
   - Commit message format

2. **Implementer works:** implements, tests, commits

3. **Dispatch reviewer agent** (Haiku — fast, cheap):
   - Review the diff
   - Check spec compliance
   - Check code quality

4. **Handle review results:**
   - If approved → mark task complete, next task
   - If issues → dispatch implementer to fix, re-review

5. **Mark task complete** in TodoWrite

### Model Routing for Subagents

| Role | Agent | Model | Why |
|------|-------|-------|-----|
| Implementation | (default subagent) | Sonnet | Good balance of quality/cost |
| Code review | reviewer | Haiku | Fast, cheap, read-only |
| Complex design questions | architect | Opus | Deep reasoning needed |

## Subagent Instructions Template

When dispatching an implementer subagent, provide:

```
## Task
[Exact task from plan]

## Context
- Working directory: [path]
- Relevant files: [list]
- Dependencies: [what previous tasks created]

## Requirements
- Follow TDD: write test first, verify it fails, implement, verify it passes
- Commit after each step
- Run full test suite before reporting done

## Do NOT
- Modify files outside the task scope
- Skip tests
- Change architecture decisions from the plan
```

## Completion

After all tasks:
- Use magic-powers:verification-before-completion
- Use magic-powers:finishing-a-development-branch

## Integration

- **magic-powers:writing-plans** — creates the plan this skill executes
- **magic-powers:requesting-code-review** — review pattern used between tasks
- **magic-powers:dispatching-parallel-agents** — for truly independent tasks that can run concurrently
