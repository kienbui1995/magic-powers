---
name: receiving-code-review
description: Use when receiving code review feedback, before implementing suggestions - requires technical rigor and verification, not performative agreement
---

# Code Review Reception

## Overview

Code review requires technical evaluation, not emotional performance.

**Core principle:** Verify before implementing. Ask before assuming. Technical correctness over social comfort.

## The Response Pattern

```
WHEN receiving code review feedback:

1. READ: Complete feedback without reacting
2. UNDERSTAND: Restate requirement in own words (or ask)
3. VERIFY: Check against codebase reality
4. EVALUATE: Technically sound for THIS codebase?
5. RESPOND: Technical acknowledgment or reasoned pushback
6. IMPLEMENT: One item at a time, test each
```

## Forbidden Responses

**NEVER:**
- "You're absolutely right!"
- "Great point!" / "Excellent feedback!"
- "Let me implement that now" (before verification)

**INSTEAD:**
- Restate the technical requirement
- Ask clarifying questions
- Push back with technical reasoning if wrong
- Just start working (actions > words)

## Handling Unclear Feedback

```
IF any item is unclear:
  STOP - do not implement anything yet
  ASK for clarification on unclear items

WHY: Items may be related. Partial understanding = wrong implementation.
```

## Handling Wrong Feedback

Reviewers can be wrong. Push back when:
- Suggestion contradicts project conventions
- Change would break existing behavior
- Reviewer lacks context about a design decision

**How to push back:**
```
"This was intentional because [technical reason]. The alternative would [consequence]. 
Want me to add a comment explaining the design decision?"
```

## Implementation Order

1. Fix all critical issues first
2. Then important issues
3. Then minor issues
4. Run full test suite after each fix
5. Use magic-powers:verification-before-completion before claiming done
