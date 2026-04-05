---
name: refactoring
description: Use when improving code structure without changing behavior - extract methods, simplify conditionals, reduce duplication, improve naming
---

# Code Refactoring

## Overview

Refactoring improves code structure without changing external behavior. Every refactoring must be backed by passing tests.

**Core principle:** Small, safe, verified steps. Never refactor and add features simultaneously.

## When to Use

- Code smells: long methods, deep nesting, duplicated logic, unclear naming
- Before adding features to messy code ("make the change easy, then make the easy change")
- After getting tests green — clean up before committing
- Tech debt reduction sprints

## The Refactoring Loop

```
1. Ensure tests pass (green baseline)
2. Identify ONE smell
3. Apply ONE refactoring
4. Run tests → must stay green
5. Commit
6. Repeat
```

## Common Refactorings by Smell

| Smell | Refactoring |
|-------|-------------|
| Long method (>20 lines) | Extract Method |
| Deep nesting (>3 levels) | Early return / Guard clauses |
| Duplicated code | Extract shared function/module |
| Primitive obsession | Introduce value object/type |
| Long parameter list (>3) | Introduce parameter object |
| Feature envy | Move method to owning class |
| God class | Extract class by responsibility |
| Magic numbers/strings | Extract named constants |
| Complex conditional | Extract to named boolean / strategy pattern |
| Shotgun surgery | Consolidate into single module |

## Safety Rules

1. **Tests first** — no tests = no refactoring. Write characterization tests if none exist.
2. **One refactoring per commit** — easy to revert if something breaks
3. **No behavior changes** — if you're changing what code does, that's not refactoring
4. **Run tests after every step** — not just at the end
5. **Use IDE tools** — rename, extract, inline are safer automated

## Red Flags — STOP

| Signal | Action |
|--------|--------|
| Tests failing after refactoring | Revert immediately, smaller step |
| Refactoring + feature in same commit | Split into two commits |
| "While I'm here, let me also..." | Finish current refactoring first |
| No tests exist | Write characterization tests before touching code |

## Integration

- **magic-powers:test-driven-development** — ensure test coverage before refactoring
- **magic-powers:verification-before-completion** — verify behavior unchanged after refactoring
- **magic-powers:requesting-code-review** — get review on significant refactors
