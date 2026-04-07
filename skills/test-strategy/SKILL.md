---
name: test-strategy
description: Use when building a test coverage plan, choosing what to test at each layer, or applying risk-based testing to focus effort
---

# Test Strategy

## When to Use
When starting a new project, the test suite is chaotic, or coverage is either too low (bugs slip through) or too high (tests slow everything down).

## Core Jobs

### 1. Apply the Testing Pyramid
```
         /\
        /E2E\         (few — slow, expensive, fragile)
       /------\
      /Integration\   (some — verify service interactions)
     /------------\
    /  Unit Tests  \  (many — fast, isolated, specific)
   /--------------\
```
Invert = ice cream cone = too many E2E tests = slow, flaky CI.

### 2. Decide What to Test at Each Layer
**Unit** (function/class level):
- Complex business logic (calculations, transformations)
- Edge cases and error paths
- Pure functions with clear inputs/outputs
- Skip: simple CRUD, framework boilerplate

**Integration** (service/DB level):
- API endpoints with real DB
- External service integrations (with test doubles or test environments)
- Data access layer

**E2E** (full stack):
- Critical user journeys (sign up, key workflow, checkout)
- 3–10 tests max — not comprehensive coverage

### 3. Risk-Based Testing
Prioritize coverage based on:
- **Business risk**: payment processing, auth, data integrity → high coverage
- **Change frequency**: code that changes often → more tests
- **Complexity**: high cyclomatic complexity → unit test thoroughly
- **User impact**: features used by 80% of users → E2E coverage

### 4. Test Quality Metrics
Track:
- Test pass rate (flaky tests = warning sign)
- Coverage % by layer (target: 80% unit + critical integration paths)
- Time to run full suite (target: < 10 min for pre-merge)

## Key Outputs
- Test strategy document (what to test, at what layer, why)
- Coverage targets by risk category
- CI test suite configuration
- Flaky test backlog

## Anti-Patterns
- Testing implementation details, not behavior (breaks on refactor)
- E2E tests for everything (slow, flaky, hard to debug)
- No integration tests (unit tests pass, integration fails)
- 100% coverage as a goal (diminishing returns after 80%)
