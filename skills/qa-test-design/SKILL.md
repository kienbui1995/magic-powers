---
name: qa-test-design
description: Use when designing test cases — applying boundary value analysis, equivalence partitioning, decision tables, pairwise testing, and exploratory testing techniques to maximize defect detection with minimal test cases.
---

# QA Test Design

## When to Use
- Writing test cases for a new feature
- Reviewing if existing test cases cover requirements adequately
- Designing tests for complex business logic with many conditions
- Planning exploratory testing sessions
- Optimizing test suite by reducing redundant tests

## Core Jobs

### 1. Equivalence Partitioning (EP)
Group inputs into classes where the system behaves the same — test one value per class.

```
Example: Age field for insurance (must be 18-65)
Valid partitions:      [18-65] → test with 35
Invalid partitions:    [<18] → test with 10
                       [>65] → test with 70
                       [non-numeric] → test with "abc"
                       [empty] → test with ""

Result: 5 test cases instead of testing every possible age
```

### 2. Boundary Value Analysis (BVA)
Test at and around boundaries where defects cluster.

```
Example: Same age field [18-65]
Boundaries to test:
  Lower boundary: 17 (invalid), 18 (valid), 19 (valid)
  Upper boundary: 64 (valid), 65 (valid), 66 (invalid)
  Zero/null: 0, negative (-1), empty

Result: 8 focused tests covering the most defect-prone values
```

```python
# BVA test pattern
@pytest.mark.parametrize("age,expected", [
    (17, False),   # below lower boundary
    (18, True),    # at lower boundary
    (19, True),    # above lower boundary
    (64, True),    # below upper boundary
    (65, True),    # at upper boundary
    (66, False),   # above upper boundary
    (0, False),    # zero
    (-1, False),   # negative
])
def test_age_validation(age, expected):
    assert validate_age(age) == expected
```

### 3. Decision Table Testing
For business logic with multiple conditions and combinations.

```
Feature: Loan approval
Conditions:
  C1: Credit score >= 700?
  C2: Income >= $50K?
  C3: Debt ratio <= 40%?

Decision table:
  C1 | C2 | C3 | Action
  Y  | Y  | Y  | APPROVE
  Y  | Y  | N  | REVIEW (high debt)
  Y  | N  | Y  | REVIEW (low income)
  Y  | N  | N  | DENY
  N  | Y  | Y  | REVIEW (low credit)
  N  | Y  | N  | DENY
  N  | N  | Y  | DENY
  N  | N  | N  | DENY

Result: 8 test cases covering all condition combinations
```

### 4. Pairwise Testing
When too many combinations exist — test every pair of inputs at least once.

```
Example: 3 parameters, 3 values each = 27 combinations
Pairwise reduces to ~9 tests while catching most pair-interaction defects

Tools: allpairs (Python), PictMaster, ACTS

from allpairspy import AllPairs

parameters = [
    ["Windows", "Mac", "Linux"],    # OS
    ["Chrome", "Firefox", "Edge"],  # Browser
    ["English", "French", "Spanish"],  # Language
]
for i, pairs in enumerate(AllPairs(parameters)):
    print(i, pairs)  # 9 pairs instead of 27
```

### 5. Exploratory Testing
Structured unscripted testing to discover unexpected defects.

```
Session-Based Test Management (SBTM):
  Charter: "Explore the checkout flow focusing on payment edge cases"
  Time box: 90 minutes
  Area: Payment processing

  Session notes structure:
  - What I tested: [actions taken]
  - Issues found: [bugs/observations]
  - Questions: [things to investigate further]
  - Coverage: [what I covered vs didn't]

Common heuristics (SFDIPOT):
  Structure: test the thing itself
  Function: what it does
  Data: what it processes
  Interface: interactions with other components
  Platform: environment, browser, OS
  Operations: how users actually use it
  Time: timing, concurrency, sequences
```

### 6. State Transition Testing
For workflows and state machines.

```
Example: Order status workflow
States: Pending → Confirmed → Shipped → Delivered | Cancelled

Test matrix:
  From\To    | Pending | Confirmed | Shipped | Delivered | Cancelled
  Pending    |    -    |   ✓ test  |    ✗    |    ✗      |   ✓ test
  Confirmed  |    ✗    |    -      | ✓ test  |    ✗      |   ✓ test
  Shipped    |    ✗    |    ✗      |    -    |  ✓ test   |    ✗

✓ = valid transition to test (happy + unhappy path)
✗ = invalid transition to test (should be rejected)
```

## Key Concepts
- **Equivalence Partitioning** — divide inputs into groups with same behavior; test one per group
- **Boundary Value Analysis** — test at and just beyond boundaries; most defects live here
- **Decision table** — explicit mapping of condition combinations to expected outcomes
- **Pairwise testing** — test every pair of input combinations; finds most interaction defects with fewest tests
- **Test oracle** — the source of expected results (spec, domain expert, reference implementation)
- **State transition** — model system as states + transitions; test valid and invalid transitions
- **Charter** — exploratory testing mission statement defining scope, area, and time box

## Checklist
- [ ] Equivalence partitions identified for each input field?
- [ ] Boundaries tested (at, just below, just above)?
- [ ] Decision table created for complex business logic (3+ conditions)?
- [ ] Invalid inputs tested (null, empty, overflow, special characters)?
- [ ] State transitions tested including invalid transitions?
- [ ] Exploratory sessions chartered and time-boxed?
- [ ] Test cases trace to requirements (coverage matrix)?

## Key Outputs
- Test case suite covering all EP classes and BVA boundaries
- Decision table for complex business logic
- Exploratory testing charter and session notes
- Requirements coverage matrix (which tests cover which requirements)

## Output Format
- 🔴 **Critical** — only happy path tested (no boundary/invalid cases), no negative test cases, copy-paste test cases that test the same thing
- 🟡 **Warning** — random input selection instead of systematic techniques, no exploratory session for high-risk features
- 🟢 **Suggestion** — apply pairwise for large parameter spaces, create state transition diagram before writing tests, use heuristics checklist for exploratory sessions

## Anti-Patterns
- Testing only the obvious happy path (bugs live at boundaries and in combinations)
- Writing 100 test cases that all test the same equivalence class (wasteful)
- Skipping exploratory testing entirely (scripted tests only find known unknowns)
- Decision tables with missing condition combinations (coverage gaps)

## Integration
- `test-driven-development` — TDD drives test design; use these techniques to define the tests
- `qa-automation` — automate test cases designed here using the framework patterns
- `test-strategy` — these techniques feed into the overall test strategy
