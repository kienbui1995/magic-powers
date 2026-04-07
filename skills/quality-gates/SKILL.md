---
name: quality-gates
description: Use when defining definition of done, setting release criteria, or building automated quality checks into the CI/CD pipeline
---

# Quality Gates

## When to Use
When establishing what "done" means, preventing low-quality code from reaching production, or reducing manual QA overhead.

## Core Jobs

### 1. Definition of Done (DoD)
Agree team-wide: a story is done only when ALL of these pass:
- [ ] Code reviewed and approved (at least 1 reviewer)
- [ ] Unit tests written and passing
- [ ] Integration tests passing
- [ ] No new lint errors
- [ ] No new security vulnerabilities (SAST scan)
- [ ] Feature tested in staging environment
- [ ] Acceptance criteria verified by PO or QA
- [ ] Documentation updated (if user-facing)

DoD applies to every story — no exceptions without explicit team agreement.

### 2. Automated Gates in CI
Pipeline structure:
```
PR opened → lint → unit tests → build
           → integration tests
           → security scan (Snyk/Semgrep)
           → coverage check (must not drop below threshold)
           → [merge gated on all passing]

Merge to main → E2E tests → staging deploy → smoke tests
              → [production deploy gated on all passing]
```

### 3. Release Criteria
Before any production release:
- [ ] All CI gates passing
- [ ] No open Critical or High severity bugs
- [ ] Load test run at expected peak traffic
- [ ] Rollback plan documented and tested
- [ ] On-call briefed on what's shipping and any risk areas
- [ ] Feature flags in place for rollback without deploy (if needed)

### 4. Non-Negotiable Gates
Some gates should block unconditionally:
- Critical security vulnerability → cannot merge
- Test coverage drops > 5% → cannot merge
- Build fails → cannot merge

Make these non-negotiable and enforce in CI — not as optional warnings.

## Key Outputs
- Team Definition of Done checklist
- CI pipeline configuration (gates per stage)
- Release criteria checklist
- Non-negotiable gates policy

## Anti-Patterns
- DoD that's aspirational but not enforced
- Manual-only quality gates (human gates get skipped under pressure)
- Gates that warn but don't block (everyone ignores warnings)
- No release criteria — "it's done when it's done"
