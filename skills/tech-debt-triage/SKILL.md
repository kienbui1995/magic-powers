---
name: tech-debt-triage
description: Use when prioritizing technical debt, deciding what to fix vs live with, or allocating time for debt reduction
---

# Tech Debt Triage

## When to Use
When technical debt is accumulating and affecting velocity, morale, or reliability, and the team needs a structured approach to address it.

## Core Jobs

### 1. Make Debt Visible
Collect all known debt items:
- Developer gripes in retros
- TODO/FIXME comments in code
- Slow test suites, flaky tests
- Manual processes that should be automated
- Known architectural shortcomings (no abstraction layer, tight coupling)
- Security vulnerabilities below critical threshold

Create a debt register: name, location, rough effort, last touched date.

### 2. Classify Debt
| Type | Example | Treatment |
|------|---------|-----------|
| Critical | Security vuln, data corruption risk | Fix this sprint |
| High | Causes bugs, slows feature dev significantly | Schedule soon |
| Medium | Slows dev, not blocking | Batch with related work |
| Low | Annoyance, cosmetic | Opportunistic (fix when passing by) |

### 3. Prioritize with Business Impact
Score: (Developer pain × Feature velocity impact) / Effort
- High pain + high velocity impact + low effort → fix now
- Low pain + low impact → deprioritize, don't spend cycles on it

### 4. Allocate Time
Options:
- **Explicit allocation**: 20% of sprint capacity reserved for debt
- **Paired with features**: fix debt in the area you're already touching
- **Debt sprints**: occasional full sprints for major rework (use sparingly)

### 5. Prevent Accumulation
- Definition of done includes: "no new debt added without a ticket"
- Code review: flag debt additions, not just bugs
- Architectural decisions get ADRs so future debt is intentional

## Key Outputs
- Debt register with classification
- Prioritized top 5 debt items this quarter
- Time allocation policy
- Debt-prevention process

## Anti-Patterns
- "We'll fix it later" with no ticket created
- Debt sprints as the only mechanism (too infrequent)
- Prioritizing low-impact cosmetic debt over high-impact architectural debt
- No measurement of whether debt reduction improved velocity
