---
name: cost-aware-routing
description: Use when deciding which model or agent to use for a task - guides cost-optimized model selection based on task complexity
---

# Cost-Aware Model Routing

## Overview

Not every task needs the most expensive model. Route tasks to the right model based on complexity, saving cost without sacrificing quality.

## The Routing Table

| Model | Agent | Cost | Best For |
|-------|-------|------|----------|
| Opus | architect | $$$$$ | Complex architecture, novel design, ambiguous requirements |
| Sonnet | debugger, ui-designer, (default) | $$ | Implementation, debugging, most coding tasks |
| Haiku | reviewer | $ | Code review, verification, simple lookups, formatting |

**Cost ratios (approximate):**
- Opus : Sonnet : Haiku ≈ 25 : 5 : 1
- A Haiku review costs ~1/60th of an Opus review

## Decision Framework

```
WHEN receiving a task:

1. Can Haiku handle this? (review, verify, format, lookup)
   → YES: Use reviewer agent or --model haiku
   
2. Is this standard implementation/debugging?
   → YES: Use default Sonnet (or debugger/ui-designer agent)
   
3. Does this require deep reasoning about novel problems?
   → YES: Use architect agent (Opus)
```

## Task → Model Mapping

### Use Haiku (reviewer agent) for:
- Code review after implementation
- Verification checks (tests pass? linter clean?)
- Simple refactoring (rename, reformat)
- Documentation review
- Checking git status/diff
- Quick lookups in codebase

### Use Sonnet (default) for:
- Feature implementation
- Bug fixing and debugging
- Writing tests
- Database migrations
- API development
- UI component building
- Most day-to-day coding

### Use Opus (architect agent) for:
- System architecture design
- Complex brainstorming with many trade-offs
- Ambiguous requirements that need deep analysis
- Cross-system integration planning
- Performance optimization strategy
- Security architecture review

## Anti-Patterns

| Pattern | Problem | Fix |
|---------|---------|-----|
| Using Opus for everything | 25x cost for same result | Default to Sonnet |
| Using Opus for code review | Overkill, slow | Use Haiku reviewer |
| Using Haiku for implementation | Too many mistakes | Use Sonnet |
| Not using agents at all | Missing cost savings | Dispatch to right agent |

## CLI Shortcuts

```bash
# Quick review with Haiku
claude -p "review the last commit" --model haiku

# Debug with Sonnet (default)
claude -p "fix the failing test in auth.py"

# Architecture with Opus
claude -p "design the caching layer" --model opus

# Budget cap
claude --max-budget-usd 0.50 -p "implement the login form"
```

## Measuring Impact

Track your usage in Claude Code settings or Vertex AI console:
- Before: ~98% Opus = high cost
- After: ~10% Opus, ~70% Sonnet, ~20% Haiku = ~75% cost reduction
