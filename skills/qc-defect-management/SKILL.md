---
name: qc-defect-management
description: Use when managing defects — writing effective bug reports, applying severity/priority matrix, tracking defect lifecycle, conducting root cause analysis, and measuring defect metrics for process improvement.
---

# QA Defect Management

## When to Use
- Writing a bug report that will actually get fixed
- Triaging a backlog of defects with the team
- Conducting root cause analysis on a production incident
- Measuring and improving defect escape rate
- Establishing defect workflow and SLAs

## Core Jobs

### 1. Effective Bug Report Structure
```markdown
## [BUG] Checkout fails when applying 100% discount coupon

**Environment:** Production | Chrome 121 | Windows 11
**Severity:** Critical | **Priority:** P1
**Reproducibility:** 100% (reproduced 5 times)

### Steps to Reproduce
1. Add any item to cart (e.g., "Blue Widget" SKU-001)
2. Proceed to checkout
3. Apply coupon code: SAVE100
4. Click "Place Order"

### Expected Result
Order is placed successfully with $0.00 total, confirmation email sent.

### Actual Result
Error: "Payment required" displayed. Order not created.
Network tab shows 400 response from POST /api/orders with body:
`{"error": "amount_must_be_positive", "amount": 0}`

### Evidence
- Screenshot: [attached]
- Network HAR: [attached]
- Error ID: ERR-2026-04-12-001

### Impact
All users with 100% discount coupons cannot complete checkout.
Estimated affected: ~150 active promo codes distributed in last campaign.

### Workaround
None available. Users must contact support for manual processing.
```

Key elements: Environment, reproducibility, STR (Steps to Reproduce), expected vs actual, evidence, impact, workaround.

### 2. Severity vs Priority Matrix
```
Severity = technical impact on system
Priority = business urgency to fix

         | High Priority | Low Priority
---------+---------------+--------------
High     | P1: Critical  | P2: Major
Severity | Fix today     | Fix this sprint
---------+---------------+--------------
Low      | P2: Major     | P3/P4: Minor
Severity | Schedule soon | Fix when possible

Examples:
  High severity + High priority (P1):
    - Payment processing failure in production
    - Security vulnerability with active exploit
    - Data loss scenario

  High severity + Low priority (P2):
    - Crash in rarely-used admin export feature
    - Performance degradation in non-peak hours

  Low severity + High priority (P2):
    - CEO's name misspelled on homepage
    - Wrong logo on marketing campaign page

  Low severity + Low priority (P4):
    - Tooltip text has typo in settings
    - Minor alignment issue in footer
```

### 3. Defect Lifecycle
```
New → Assigned → In Progress → Fixed → Verification → Closed
                                  ↓               ↓
                               Reopened ←──── Failed Verification

States:
  New:              Bug reported, not yet triaged
  Assigned:         Assigned to developer for investigation
  In Progress:      Developer actively working on fix
  Fixed:            Developer marked as fixed, needs QA verification
  Verification:     QA retesting the fix
  Closed:           Fix verified by QA, defect resolved
  Reopened:         Fix verification failed, back to developer
  Won't Fix:        Acknowledged but decision made not to fix
  Duplicate:        Same defect already reported
  Cannot Reproduce: Cannot replicate with given information
```

### 4. Root Cause Analysis (5 Whys)
```
Production bug: Users cannot log in after midnight UTC

Why 1: Authentication service returns 401 after midnight
Why 2: JWT tokens with 24h expiry issued at midnight all expire simultaneously
Why 3: Token expiry was set to 24h from issuance time, not rolling window
Why 4: Requirement said "sessions expire after 24 hours" — implemented literally
Why 5: No specification for how to handle mass simultaneous expiry

Root cause: Ambiguous requirement + no testing of midnight boundary condition

Actions:
  Immediate: Deploy fix to use rolling token refresh (30 min inactivity)
  Short-term: Add test case for high-concurrency token expiry scenario
  Long-term: Add requirement review checklist for time-based features
```

### 5. Defect Triage Process
```
Weekly triage meeting agenda (30 minutes):
1. Review new defects since last triage (10 min)
   - Confirm severity/priority
   - Assign owner
   - Set target sprint

2. Review in-progress defects (10 min)
   - Any blockers?
   - On track for target sprint?

3. Review aging defects (10 min)
   - P1/P2 defects >5 days old: escalate
   - P3/P4 defects >30 days: accept/defer/close

Triage criteria questions:
- Can users work around it? (reduces priority)
- How many users affected? (increases priority)
- Is there a security implication? (always high priority)
- Is it in a critical path? (increases priority)
```

## Key Concepts
- **Severity** — technical impact (data loss, crash, cosmetic); set by QA/developer
- **Priority** — business urgency (fix order); set by product/business
- **Defect escape** — bug found in production that should have been caught in testing
- **Regression** — previously working feature broken by new change
- **Root cause analysis** — systematic investigation of WHY a defect occurred (not just what)
- **Defect density** — defects per line of code or function point; quality indicator

## Checklist
- [ ] Bug report includes STR, expected, actual, evidence, and environment?
- [ ] Severity and priority set correctly (different concerns)?
- [ ] Defect lifecycle states and transitions defined?
- [ ] Root cause analysis conducted for P1 defects?
- [ ] Defect triage meeting scheduled (at least weekly)?
- [ ] Old defects reviewed and dispositioned (accept/defer/close)?

## Key Outputs
- Effective bug reports with complete reproduction information
- Severity/priority matrix for consistent defect classification
- Defect lifecycle workflow configured in issue tracker
- Root cause analysis documents for critical defects

## Output Format
- 🔴 **Critical** — bug reports with no STR (cannot reproduce = cannot fix), no severity/priority distinction, no production defect tracking
- 🟡 **Warning** — no triage process (defects pile up unreviewed), severity == priority (different concepts confused)
- 🟢 **Suggestion** — use defect templates for consistent reporting, automate defect aging alerts, add root cause category field for trend analysis

## Anti-Patterns
- "It doesn't work" bug reports with no reproduction steps
- All bugs marked P1 (priority inflation = no real priority)
- Never closing old defects (won't fix, cannot reproduce)
- Fixing bugs without root cause analysis (same bug type recurs)

## Integration
- `qa-metrics` — defect data feeds quality metrics
- `qa-test-design` — root cause analysis drives new test cases to prevent recurrence
- `test-strategy` — defect density informs risk-based testing focus
