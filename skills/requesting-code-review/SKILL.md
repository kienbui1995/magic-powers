---
name: requesting-code-review
description: Use when completing tasks, implementing major features, or before merging to verify work meets requirements
---

# Requesting Code Review

Dispatch the **reviewer agent** (Haiku — fast and cheap) to catch issues before they cascade. The reviewer gets precisely crafted context — never your session history.

**Core principle:** Review early, review often.

## When to Request Review

**Mandatory:**
- After each task in subagent-driven development
- After completing major feature
- Before merge to main

**Optional but valuable:**
- When stuck (fresh perspective)
- Before refactoring (baseline check)
- After fixing complex bug

## How to Request

**1. Get git SHAs:**
```bash
BASE_SHA=$(git rev-parse HEAD~1)  # or origin/main
HEAD_SHA=$(git rev-parse HEAD)
```

**2. Dispatch reviewer agent** with context:
- What was implemented
- Plan or requirements reference
- Base and head SHAs
- Brief description

**3. Act on feedback:**
- 🔴 Critical → fix immediately
- 🟡 Important → fix before proceeding
- 🟢 Minor → note for later
- Push back if reviewer is wrong (with reasoning)

## Cost Advantage

Using the **reviewer agent** (Haiku) for code review is ~60x cheaper than using Opus. Reviews are fast, focused tasks — perfect for a smaller model. The reviewer has read-only tools (Read, Grep, Glob, Bash) which is all it needs.

## Integration

- **magic-powers:subagent-driven-development** — auto-dispatches review after each task
- **magic-powers:receiving-code-review** — how to handle review feedback
- **magic-powers:verification-before-completion** — verify fixes after review
