---
name: systematic-debugging
description: Use when encountering any bug, test failure, or unexpected behavior, before proposing fixes
---

# Systematic Debugging

## Overview

Random fixes waste time and create new bugs. Quick patches mask underlying issues.

**Core principle:** ALWAYS find root cause before attempting fixes. Symptom fixes are failure.

**Violating the letter of this process is violating the spirit of debugging.**

## The Iron Law

```
NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST
```

If you haven't completed Phase 1, you cannot propose fixes.

## When to Use

Use for ANY technical issue: test failures, bugs, unexpected behavior, performance problems, build failures, integration issues.

**Use ESPECIALLY when:**
- Under time pressure (emergencies make guessing tempting)
- "Just one quick fix" seems obvious
- You've already tried multiple fixes
- You don't fully understand the issue

## The Four Phases

Complete each phase before proceeding to the next.

### Phase 1: Root Cause Investigation

**BEFORE attempting ANY fix:**

1. **Read Error Messages Carefully**
   - Don't skip past errors or warnings
   - Read stack traces completely
   - Note line numbers, file paths, error codes

2. **Reproduce Consistently**
   - Can you trigger it reliably?
   - What are the exact steps?
   - If not reproducible → gather more data, don't guess

3. **Check Recent Changes**
   - Git diff, recent commits
   - New dependencies, config changes
   - Environmental differences

4. **Gather Evidence in Multi-Component Systems**
   - Log what enters/exits each component boundary
   - Don't guess which component fails — prove it

5. **Form Hypothesis**
   - Based on evidence, not intuition
   - Must be falsifiable
   - "I think X because evidence Y shows Z"

### Phase 2: Verify Hypothesis

- Design a test that would DISPROVE your hypothesis
- Run it. If hypothesis survives, proceed.
- If disproved: back to Phase 1 with new evidence

### Phase 3: Fix

- Fix the ROOT CAUSE, not the symptom
- Minimal change — don't refactor while debugging
- One fix at a time

### Phase 4: Verify Fix

- Original bug no longer reproduces
- No new failures introduced
- Run full test suite
- Document what happened and why

## Red Flags — STOP

| Thought | Reality |
|---------|---------|
| "Let me just try this" | That's guessing, not debugging |
| "It's probably X" | Probably ≠ evidence |
| "Quick fix, then investigate" | Quick fixes become permanent |
| "I've seen this before" | Similar ≠ same. Verify. |
| "Let me change multiple things" | One change at a time |

## Model Routing

For complex multi-system bugs, consider dispatching the **debugger agent** (Sonnet) which has full tool access for systematic investigation.

## Integration

- **magic-powers:verification-before-completion** — verify fix before claiming done
- **magic-powers:test-driven-development** — write regression test for the bug
