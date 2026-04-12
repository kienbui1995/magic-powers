---
name: qc-uat-facilitation
description: Use when facilitating User Acceptance Testing — planning UAT sessions with business stakeholders, designing business-scenario test cases (not technical), coordinating UAT execution, managing UAT defects, and obtaining formal sign-off.
---

# QC UAT Facilitation

## When to Use
- Preparing business users for UAT before a release
- Translating technical test cases into business-language scenarios
- Coordinating a UAT cycle with multiple business stakeholders
- Collecting and managing UAT defects to release decision
- Obtaining formal UAT sign-off documentation

## Core Jobs

### 1. UAT Planning
```markdown
## UAT Plan — v2.0 Release

### Scope
Business processes covered:
  ✅ Customer onboarding (primary)
  ✅ Order placement and payment
  ✅ Reporting and exports
  ❌ Admin user management (internal only, separate UAT)

### Participants
| Role | Person | Responsibility |
|------|--------|---------------|
| UAT Coordinator | QC Lead | Plan, coordinate, report |
| Business Lead | [Name] | Final sign-off authority |
| End User Rep | [Name x3] | Execute test scenarios |
| SME | [Name] | Clarify business rules |
| Dev Support | [Name] | Fix critical UAT blockers same-day |

### Schedule
Week 1 (Apr 14-16): UAT preparation — scenarios, test data, environment
Week 2 (Apr 17-21): UAT execution — testers run scenarios, log defects
Week 3 (Apr 22-23): Defect resolution + re-test
Apr 24: UAT sign-off meeting

### Environment
URL: https://uat.myapp.com
Credentials: shared separately via secure channel
Test data: see section 4 (pre-loaded in UAT environment)

### Entry Criteria (must be met before UAT starts)
  ✅ All P1/P2 defects from QC resolved
  ✅ UAT environment stable (no planned maintenance during UAT period)
  ✅ Test data loaded and verified
  ✅ UAT participants confirmed and briefed

### Exit Criteria (must be met for sign-off)
  ✅ All critical scenarios executed
  ✅ No open P1 defects
  ✅ P2 defects reviewed and accepted/deferred by business lead
  ✅ Business lead signs off
```

### 2. Business Scenario Test Case Design
```
UAT test cases = business scenarios, not technical steps

QC mindset (technical):
  "POST /api/orders with payload {product_id: 123, quantity: 2}"

UAT mindset (business):
  "Customer places order for 2 units of Blue Widget"

Example UAT scenario:
---
Scenario: New customer completes first purchase

Business context: Sarah is a new customer who found the product on Google.
She has no account yet.

Steps:
1. Go to [product page URL]
2. Click "Add to Cart"
3. Click "Checkout"
4. Create new account with your test email [provided]
5. Enter shipping address: [provided test address]
6. Select "Standard Shipping"
7. Enter payment: [provided test card number]
8. Click "Place Order"

Expected outcomes (check all):
□ Order confirmation page shows correct items and total
□ Confirmation email received within 5 minutes
□ Order appears in "My Orders" when you log back in
□ Inventory count decreased on product page

Notes: Use only the provided test card. Do not use real payment information.
---
```

### 3. UAT Defect Management
```markdown
## UAT Defect Triage Process

UAT defects are business-reported — triage with both business and QC:

Priority for UAT defects:
  P1 (UAT Blocker): Cannot proceed with UAT, must fix before UAT continues
  P2 (UAT High): Critical business process broken, fix before sign-off
  P3 (UAT Medium): Process works with workaround, fix before go-live
  P4 (UAT Low): Minor UI/cosmetic, document for next release
  Won't Fix: Business acknowledges and accepts (document in sign-off)

UAT defect log template:
| ID | Scenario | Step | Expected | Actual | Severity | Status | Notes |
|----|---------|------|---------|--------|---------|--------|-------|
| U001 | New purchase | Step 7 | Order confirmed | Payment error | P1 | Open | |
| U002 | Order history | Step 3 | Shows all orders | Missing 2 orders | P2 | Open | |

Daily UAT status report (send to all stakeholders):
  - Scenarios completed today: X/Y
  - Defects found: N (P1: n, P2: n, P3: n)
  - Defects resolved: N
  - Blockers: [list or "none"]
  - Tomorrow's plan: [scenarios scheduled]
  - Risk: [any risks to UAT timeline]
```

### 4. UAT Environment and Test Data Setup
```bash
# UAT environment setup checklist
□ Environment URL confirmed and accessible to all UAT testers
□ Test accounts created for each tester (named accounts, not shared)
□ Test data representing real business scenarios loaded:
    - Sample customers (new, existing, VIP)
    - Sample products (in stock, out of stock, on sale)
    - Sample orders (pending, completed, cancelled)
    - Historical data for reporting tests
□ Email testing configured (Mailhog or similar — capture UAT emails)
□ Payment gateway in test mode (Stripe test cards, not real)
□ Any integrations sandboxed (ERP, CRM, warehouse system)
□ Data reset procedure documented (if testers corrupt data)
□ Support channel established (Slack, Teams) for tester questions
```

### 5. UAT Sign-Off Process
```markdown
## UAT Sign-Off Document

**System:** MyApp v2.0
**UAT Period:** April 17-24, 2026
**Sign-off Date:** April 24, 2026

### UAT Summary
| Metric | Result |
|--------|--------|
| Total scenarios | 45 |
| Scenarios passed | 43 (96%) |
| Scenarios failed | 2 (non-critical, documented) |
| P1 defects | 0 open |
| P2 defects | 1 open (deferred to v2.1 — workaround documented) |
| P3 defects | 3 open (accepted for post-go-live fix) |

### Known Issues at Go-Live
| ID | Description | Workaround | Next Fix |
|----|-------------|-----------|---------|
| U002 | Order history missing orders >90 days | Use export function | v2.1 |

### Decision
☐ GO — approved for production deployment
☐ NO-GO — do not deploy until issues resolved

**Business Lead Sign-off:** ___________________ Date: ______
**QC Lead Sign-off:** ___________________ Date: ______
**Project Manager:** ___________________ Date: ______

By signing, the business confirms:
1. Critical business processes have been tested and accepted
2. Known issues listed above are acceptable for go-live
3. Business is ready to support the production release
```

## Key Concepts
- **UAT** — User Acceptance Testing: business stakeholders verify software meets business needs (different from QC testing technical correctness)
- **Business scenario** — test case written in business language describing a real workflow, not technical steps
- **UAT Coordinator** — typically QC lead who plans, organizes, tracks, and reports on UAT (does not execute test cases — business users do)
- **Entry/Exit criteria** — conditions that must be true for UAT to start/end
- **Sign-off** — formal written approval from business authority confirming acceptance

## Checklist
- [ ] UAT plan created with scope, schedule, participants, entry/exit criteria?
- [ ] Test scenarios written in business language (not technical)?
- [ ] UAT environment separate from dev/staging (business users should not see dev noise)?
- [ ] Test data representative of real business scenarios?
- [ ] Daily status reports sent to stakeholders?
- [ ] UAT sign-off document obtained before production deployment?

## Key Outputs
- UAT plan with schedule, participants, scope, entry/exit criteria
- Business scenario test cases (non-technical, written with business users)
- Daily UAT status reports
- UAT defect log with priority classifications
- Signed UAT sign-off document

## Output Format
- 🔴 **Critical** — no formal UAT (business users test on production), deploying without UAT sign-off, using production data for UAT
- 🟡 **Warning** — UAT test cases written by QC only (not with business users), no UAT environment separate from QC testing, no formal sign-off document
- 🟢 **Suggestion** — involve business users in writing test scenarios (they know edge cases), record UAT sessions (with permission) for training, use UAT defects to improve QC test coverage

## Anti-Patterns
- Technical test cases in UAT ("click button with id='submit'") — business users can't follow these
- QC team executing UAT scenarios on behalf of business (defeats the purpose)
- No entry criteria — starting UAT with unstable build (wastes business users' time)
- Treating UAT feedback as optional ("the business doesn't understand what they tested")
- No sign-off document (verbal agreement not auditable for compliance)

## Integration
- `qc-defect-management` — UAT defects follow same lifecycle, with business-priority classification
- `qa-risk-management` — UAT exit criteria derived from risk register
- `qa-process-design` — UAT is a phase in the SDLC quality process
