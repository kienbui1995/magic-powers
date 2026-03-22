---
name: test-driven-development
description: Use when implementing any feature or bugfix, before writing implementation code
---

# Test-Driven Development (TDD)

## Overview

Write the test first. Watch it fail. Write minimal code to pass.

**Core principle:** If you didn't watch the test fail, you don't know if it tests the right thing.

**Violating the letter of the rules is violating the spirit of the rules.**

## When to Use

**Always:** New features, bug fixes, refactoring, behavior changes.

**Exceptions (ask your human partner):** Throwaway prototypes, generated code, configuration files.

Thinking "skip TDD just this once"? Stop. That's rationalization.

## The Iron Law

```
NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST
```

Write code before the test? Delete it. Start over. No exceptions.

## Red-Green-Refactor

### RED — Write Failing Test

Write one minimal test showing what should happen.

- Test behavior, not implementation
- One assertion per test (ideally)
- Descriptive test name = specification
- Run it. Verify it fails for the RIGHT reason.

**Wrong failure:** Syntax error, import error, wrong assertion → fix the test first.
**Right failure:** Feature not implemented yet → proceed to GREEN.

### GREEN — Minimal Code

Write the MINIMUM code to make the failing test pass.

- Resist the urge to write "complete" code
- Don't add features the test doesn't require
- Hardcode if that's all the test needs (next test will force generalization)
- Run ALL tests. Everything must be green.

### REFACTOR — Clean Up

With all tests green, improve code quality:

- Remove duplication
- Improve naming
- Extract methods/functions
- Simplify logic
- Run tests after EVERY change — stay green

## Test Quality

**Good tests are:**
- Fast (milliseconds, not seconds)
- Independent (no shared state between tests)
- Deterministic (same result every time)
- Self-validating (pass/fail, no manual checking)

**Test the contract, not the implementation:**
```
❌ assert mock.called_with(specific_internal_args)
✅ assert result == expected_output
```

## Common Rationalizations

| Excuse | Reality |
|--------|---------|
| "I'll write tests after" | You won't. And they'll test implementation, not behavior. |
| "This is too simple to test" | Simple code has the sneakiest bugs. |
| "I know this works" | Prove it. Write the test. |
| "Tests slow me down" | Debugging without tests slows you down more. |
| "Just this one function" | One function becomes ten. Start right. |

## Integration

- **magic-powers:writing-plans** — plans include TDD steps
- **magic-powers:verification-before-completion** — verify tests pass before claiming done
