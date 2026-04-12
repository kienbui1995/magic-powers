---
name: qa-process-design
description: Use when designing quality assurance processes — defining quality standards, integrating QA checkpoints into SDLC, creating process documentation, onboarding teams to quality practices, and building a quality-first engineering culture.
---

# QA Process Design

## When to Use
- Setting up QA for a new team or project from scratch
- Improving an existing process that's producing too many defects
- Integrating quality gates into CI/CD pipeline (beyond just running tests)
- Defining "Definition of Done" and quality standards
- Building a quality culture in a team that doesn't have one

## Core Jobs

### 1. Quality Standards Definition
```markdown
# Quality Standard: Code Quality

## Purpose
Ensure all code merged to main meets minimum quality standards.

## Standards

### Code Review (mandatory)
- Every PR requires at least 1 reviewer (2 for security-sensitive code)
- Reviewer checks: logic correctness, security, test coverage, style
- Author must not approve their own PR
- Review completed within 24 hours (48 hours for complex PRs)

### Test Coverage
- Unit test branch coverage: >= 80% for business logic
- New code without tests: block merge (enforced by CI)
- Flaky tests: fix within 2 business days or quarantine

### Static Analysis
- SonarQube quality gate: no new Critical/Blocker issues
- Security scan: no new HIGH/CRITICAL vulnerabilities (Snyk/Dependabot)
- Linting: must pass (no warnings allowed on new code)

### Documentation
- Public APIs: OpenAPI spec updated
- Architecture decisions: ADR written for significant changes
- README updated if behavior changes

## Enforcement
- CI pipeline enforces coverage, linting, security scan
- PR template reminds reviewers of standards
- Weekly metrics review: any team consistently below standard -> coaching
```

### 2. SDLC Quality Integration
```
Requirements phase:
  QA activity: Requirements review for testability, ambiguity
  Output: Testable requirements, acceptance criteria per story
  Gate: No story moves to development without acceptance criteria

Design phase:
  QA activity: Review architecture for testability, observability
  Output: Test approach defined (what level, which tools)
  Gate: Test approach approved before implementation starts

Development phase:
  QA activity: TDD coaching, PR review participation, daily stand-up
  Output: Unit tests alongside code, PR quality review
  Gate: Coverage threshold enforced in CI

Testing phase:
  QA activity: Test execution, defect reporting, regression
  Output: Test report, defect list, go/no-go recommendation
  Gate: All P1/P2 defects resolved before release

Release phase:
  QA activity: Release readiness review, sign-off
  Output: Release sign-off document
  Gate: QA sign-off required before production deployment

Post-release:
  QA activity: Production monitoring, escape rate measurement
  Output: Monthly QA metrics report
  Gate: Escape rate reviewed monthly
```

### 3. Definition of Done
```markdown
## Definition of Done (DoD)

A user story is Done when:

### Development
- [ ] Code reviewed and approved (2 reviewers for security changes)
- [ ] Unit tests written with >= 80% branch coverage for new code
- [ ] Integration tests added for new API endpoints
- [ ] No new SonarQube Critical/Blocker issues
- [ ] No new security vulnerabilities (Snyk)
- [ ] Code merged to main branch

### Testing
- [ ] AC (acceptance criteria) tested and passing
- [ ] Regression suite passes (no new failures)
- [ ] Cross-browser tested if UI changes
- [ ] Performance acceptable (no significant regression)

### Documentation
- [ ] API docs updated (if applicable)
- [ ] User-facing changes in release notes

### Operations
- [ ] Logging added for new operations
- [ ] Alerts configured for new failure modes
- [ ] Feature flag configured (for gradual rollout)
```

### 4. Quality Culture Building
```
Levels of quality maturity:

Level 1 — Reactive (fire-fighting)
  - Defects found in production
  - QA as final gatekeeper (bottleneck)
  - No test automation
  Actions: Establish basic process, introduce TDD, set up CI

Level 2 — Defined (process exists)
  - Test coverage exists
  - QA integrated in sprint
  - Some automation
  Actions: Enforce standards, introduce code review, measure escape rate

Level 3 — Managed (metrics-driven)
  - Escape rate tracked
  - Shift-left in progress (more unit tests, fewer prod bugs)
  - Developer-owned quality
  Actions: Shift QA to coaching role, improve metrics, automate quality gates

Level 4 — Optimizing (quality is owned by everyone)
  - Defects mostly caught in unit tests
  - QA focuses on strategy and risk
  - Quality metrics visible to all stakeholders

Current level assessment -> define improvement roadmap -> measure progress quarterly
```

## Key Concepts
- **QA** — Quality Assurance: process-oriented, proactive, focuses on prevention
- **Definition of Done (DoD)** — explicit criteria a story must meet before being "done"; enforced as a team agreement
- **Quality gate** — automated checkpoint that blocks progress if quality criteria not met
- **Shift-left** — moving quality activities earlier in SDLC (finding bugs in requirements/unit test, not production)
- **Quality culture** — organizational mindset where every team member owns quality (not just QA team)

## Checklist
- [ ] Quality standards documented and published (not just verbal agreements)?
- [ ] DoD defined and agreed by whole team (including PO)?
- [ ] Quality gates in CI pipeline (coverage, linting, security scan)?
- [ ] SDLC quality checkpoints defined at each phase?
- [ ] QA process reviewed and updated quarterly?
- [ ] Team quality maturity assessed (Level 1-4)?

## Key Outputs
- Quality standards document (code review, coverage, static analysis)
- Definition of Done checklist agreed by team
- SDLC quality integration map (QA activity per phase)
- Quality maturity assessment and improvement roadmap

## Output Format
- 🔴 **Critical** — no DoD (done means different things to different people), QA as final gatekeeper only (too late, bottleneck), no quality gates in CI
- 🟡 **Warning** — DoD exists but not enforced, quality standards verbal only (not documented), no SDLC integration beyond testing phase
- 🟢 **Suggestion** — run quality maturity assessment with team, automate DoD checklist in PR template, start shift-left initiative with TDD coaching

## Anti-Patterns
- QA team as the "quality police" (developers don't own quality -> adversarial culture)
- DoD only covering functional requirements (ignoring non-functional: performance, security)
- Process designed in ivory tower without team input (teams don't follow what they didn't help design)
- Heavy process for small teams (right-size process to team size and risk)

## Integration
- `test-strategy` — process design informs the overall test strategy
- `qa-audit` — process designed here is what gets audited for compliance
- `qa-risk-management` — risk assessment informs which process controls to prioritize
