---
name: qa-risk-management
description: Use when managing quality risk — identifying quality risks in a product or release, applying risk-based testing prioritization, creating risk mitigation plans, and communicating quality risk to stakeholders for go/no-go decisions.
---

# QA Risk Management

## When to Use
- Planning testing for a release with limited time/resources
- Deciding which areas need most testing attention
- Presenting quality risk to stakeholders before a release
- Assessing risk of deploying a change to production
- Building a risk register for a new product or feature

## Core Jobs

### 1. Risk Identification
```markdown
## Quality Risk Register — v2.0 Release

| Risk ID | Risk Description | Area | Likelihood | Impact | Risk Level |
|---------|-----------------|------|-----------|--------|-----------|
| QR-01 | Payment flow regression due to refactor | Checkout | High | Critical | CRITICAL |
| QR-02 | Performance degradation from new DB queries | Search | Medium | High | HIGH |
| QR-03 | Third-party auth provider API changes | Login | Low | Critical | HIGH |
| QR-04 | Mobile layout broken on iOS 17 | UI | Medium | Medium | MEDIUM |
| QR-05 | Email notifications delayed | Notifications | Low | Low | LOW |

Risk Level = Likelihood x Impact:
  CRITICAL: Likelihood High + Impact Critical/High
  HIGH: Likelihood Medium + Impact Critical, OR High + High
  MEDIUM: Medium x Medium combinations
  LOW: Low likelihood or low impact
```

### 2. Risk-Based Testing Prioritization
```
Given: 40 hours of testing available for v2.0 release

Risk-based allocation:
  CRITICAL risks (QR-01): 16 hours (40%)
    - Full regression of payment flow
    - All payment methods tested
    - Boundary testing on amounts

  HIGH risks (QR-02, QR-03): 16 hours (40%)
    - Performance test: search under load
    - Auth provider integration smoke test
    - Fallback behavior tested

  MEDIUM risks (QR-04): 6 hours (15%)
    - iOS 17 spot check on critical pages

  LOW risks (QR-05): 2 hours (5%)
    - Smoke test email delivery

Without risk-based approach:
  - Equal time per feature = critical areas undertested
  - QR-01 payment regression found in production
```

### 3. Release Risk Assessment
```markdown
## Release v2.0 — Go/No-Go Risk Assessment

**Release Date:** 2026-04-15
**QA Lead:** [Name]

### Change Risk Summary
| Change | Risk Level | Test Coverage | Outstanding Issues |
|--------|-----------|--------------|-------------------|
| Payment refactor | CRITICAL | 95% | 0 P1, 1 P2 |
| Search optimization | HIGH | 82% | 0 P1, 2 P2 |
| Auth integration | HIGH | 78% | 0 P1, 0 P2 |
| Mobile layout | MEDIUM | 90% | 0 P1, 1 P3 |

### Risk Mitigation Status
OK QR-01: Payment regression fully tested, no issues found
OK QR-02: Performance tested — 12% improvement, no regressions
WARN QR-03: Auth provider test partially complete (3rd party sandbox down)
OK QR-04: iOS 17 tested on critical paths, minor P3 in settings

### Outstanding Risk Items
| Item | Risk | Mitigation |
|------|------|-----------|
| P2: Search slow on >10K results | MEDIUM | Feature flag: disable for enterprise |
| Auth provider untested | HIGH | Rollback plan ready; monitor after deploy |

### Recommendation
**CONDITIONAL GO** — deploy with:
1. Feature flag enabled for enterprise search (P2 mitigation)
2. Enhanced monitoring on auth service for 24h post-release
3. On-call engineer available for 4h after deployment
4. Rollback plan: revert auth config if error rate >1%

QA Sign-off: _________________ Date: _______
```

### 4. Risk Mitigation Strategies
```
For each identified risk, choose a mitigation strategy:

AVOID — eliminate the risk entirely
  "Don't release the payment refactor this sprint — too high risk before holiday sale"

MITIGATE — reduce likelihood or impact
  "Add integration tests for the auth provider to reduce likelihood"
  "Use feature flag to limit exposure if issues arise (reduce impact)"

TRANSFER — shift risk to someone else
  "SLA with third-party provider covers downtime"
  "Insurance for financial loss from payment failures"

ACCEPT — acknowledge risk and proceed
  "Minor UI issue on iOS 17 — accept and fix in next sprint"
  "Very low likelihood — monitoring in place, proceed"

Decision matrix:
  CRITICAL risk + no mitigation -> DELAY release
  HIGH risk + mitigation in place -> CONDITIONAL GO
  MEDIUM risk + monitoring -> GO with observation
  LOW risk -> GO, document for future
```

## Key Concepts
- **Quality risk** — possibility that a quality problem will occur and cause harm
- **Risk-based testing** — allocating testing effort proportional to risk level (not equally)
- **Risk register** — living document of identified risks with likelihood, impact, and mitigation
- **Go/No-Go** — release decision based on outstanding risk vs mitigation in place
- **Residual risk** — risk remaining after mitigation has been applied
- **Risk appetite** — how much risk an organization is willing to accept

## Checklist
- [ ] Risk register created before testing begins (not after)?
- [ ] Both likelihood AND impact assessed (not just one)?
- [ ] Testing effort allocated proportionally to risk level?
- [ ] Mitigation strategy defined for each HIGH/CRITICAL risk?
- [ ] Go/No-Go decision criteria defined before release (not subjective)?
- [ ] Stakeholders informed of remaining risks before production deploy?

## Key Outputs
- Quality risk register with likelihood/impact/level for each risk
- Risk-based test plan with effort allocation matching risk levels
- Release risk assessment with go/no-go recommendation and conditions
- Risk mitigation tracking showing which risks have been addressed

## Output Format
- 🔴 **Critical** — no risk assessment before release (flying blind), testing effort distributed equally regardless of risk, releasing with unmitigated CRITICAL risks
- 🟡 **Warning** — risk register created but not used for test prioritization, go/no-go decision subjective (not criteria-based)
- 🟢 **Suggestion** — update risk register after each release (retroactively), track risk prediction accuracy over time, involve developers in risk identification

## Anti-Patterns
- Risk assessment done AFTER testing starts (risk should DRIVE testing)
- All risks rated as "High" (risk inflation = no real prioritization)
- Risk register created but never updated (stale register = false confidence)
- Go/No-Go decision based on feelings, not explicit criteria

## Integration
- `qa-process-design` — quality process should include risk assessment step
- `qa-audit` — audit findings generate new risks for the risk register
- `qc-metrics` — historical defect data informs risk likelihood estimates
- `test-strategy` — risk register directly drives test strategy prioritization
