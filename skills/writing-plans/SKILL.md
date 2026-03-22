---
name: writing-plans
description: Use when you have a spec or requirements for a multi-step task, before touching code
---

# Writing Plans

## Overview

Write comprehensive implementation plans assuming the engineer has zero context. Document everything: which files to touch, code, testing, how to verify. Bite-sized tasks. DRY. YAGNI. TDD. Frequent commits.

**Announce at start:** "I'm using the writing-plans skill to create the implementation plan."

**Save plans to:** `docs/plans/YYYY-MM-DD-<feature-name>.md`
- User preferences for plan location override this default

## Scope Check

If the spec covers multiple independent subsystems, suggest breaking into separate plans — one per subsystem. Each plan should produce working, testable software on its own.

## File Structure

Before defining tasks, map out which files will be created or modified:
- Clear boundaries and well-defined interfaces per file
- Prefer smaller, focused files over large ones
- Files that change together should live together
- In existing codebases, follow established patterns

## Bite-Sized Task Granularity

Each step is one action (2-5 minutes):
- "Write the failing test" — step
- "Run it to verify it fails" — step
- "Implement minimal code to pass" — step
- "Run tests to verify they pass" — step
- "Commit" — step

## Plan Document Header

```markdown
# [Feature Name] Implementation Plan

> **For agentic workers:** Use magic-powers:subagent-driven-development (recommended) or magic-powers:executing-plans to implement this plan task-by-task.

**Goal:** [One sentence]
**Architecture:** [2-3 sentences]
**Tech Stack:** [Key technologies]

---
```

## Task Structure

````markdown
### Task N: [Component Name]

**Files:**
- Create: `exact/path/to/file.py`
- Modify: `exact/path/to/existing.py:123-145`
- Test: `tests/exact/path/to/test.py`

- [ ] **Step 1: Write the failing test**
- [ ] **Step 2: Run test to verify it fails**
- [ ] **Step 3: Write minimal implementation**
- [ ] **Step 4: Run test to verify it passes**
- [ ] **Step 5: Commit**
````

## Plan Review Loop

After writing the plan:
1. Dispatch reviewer subagent with plan path and spec path
2. If issues found: fix, re-dispatch
3. If approved: proceed to execution handoff
4. Max 3 iterations, then surface to human

## Execution Handoff

After saving the plan:

> "Plan saved to `<path>`. Two execution options:
> 1. **Subagent-Driven (recommended)** — fresh subagent per task, review between tasks
> 2. **Inline Execution** — execute in this session with checkpoints
>
> Which approach?"

- Subagent-Driven → use magic-powers:subagent-driven-development
- Inline → use magic-powers:executing-plans

## Remember
- Exact file paths always
- Complete code in plan (not "add validation")
- Exact commands with expected output
- DRY, YAGNI, TDD, frequent commits
