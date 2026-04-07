---
name: support-playbook
description: Use when building a support triage process, writing escalation paths, or creating templates for common support issues
---

# Support Playbook

## When to Use
When setting up a support function, improving response quality, or reducing time-to-resolution on common issues.

## Core Jobs

### 1. Triage Framework
Classify every ticket on arrival:
| Priority | Criteria | Response SLA | Resolution SLA |
|----------|----------|-------------|----------------|
| P1 | System down, data loss, security issue | 15 min | 4 hours |
| P2 | Core feature broken, major workflow blocked | 1 hour | 24 hours |
| P3 | Feature degraded, workaround exists | 4 hours | 3 business days |
| P4 | General question, feature request | 24 hours | Best effort |

### 2. Common Issue Templates
For top 10 most frequent issues, write:
- **Symptom**: what the user reports
- **Root cause**: why it happens
- **Diagnostic steps**: how to confirm
- **Resolution**: exact steps to fix
- **Prevention**: how to avoid in future

### 3. Escalation Path
Define who handles what:
```
Tier 1 (Support) → Tier 2 (Senior Support / CS) → Tier 3 (Engineering)
```
Escalate to engineering when:
- Bug confirmed (reproducible, not user error)
- Data issue requiring DB access
- Security or privacy concern
- P1 not resolved in 2 hours

### 4. Quality and Metrics
Track per week:
- Ticket volume by category (spot trends)
- First response time by priority
- Resolution time by priority
- CSAT score
- Escalation rate to engineering (high rate = product/docs gap)

## Key Outputs
- Triage guide with priority matrix
- Template library for top issues
- Escalation path document
- Weekly metrics dashboard

## Anti-Patterns
- No priority triage — every ticket treated equally
- Support resolving issues without root cause (band-aid fixes)
- Engineering resolves tickets directly (doesn't scale, no knowledge capture)
- No CSAT tracking — don't know if support is actually helping
