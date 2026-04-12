---
name: qa-audit
description: Use when conducting quality audits — reviewing process compliance, identifying gaps between defined process and actual practice, conducting structured inspections (code review audits, test quality reviews), and producing audit reports with remediation plans.
---

# QA Audit

## When to Use
- Assessing whether team is following defined QA processes
- Reviewing quality of existing test suite (not just coverage, but test quality)
- Preparing for external audit or certification (ISO, SOC2)
- Onboarding a new project and understanding current quality practices
- Investigating why defect escape rate suddenly increased

## Core Jobs

### 1. Process Audit Framework
```markdown
## QA Process Audit Checklist

### Requirements & Planning
[ ] User stories have acceptance criteria
[ ] Test approach defined before development starts
[ ] Testability considered in design decisions
[ ] Risk-based testing prioritization applied

### Development Phase
[ ] Code reviewed before merge (evidence in PR history)
[ ] Unit tests written alongside code (not after)
[ ] Static analysis enforced (CI scan results)
[ ] Security scanning in CI (Snyk/Dependabot active)

### Testing Phase
[ ] Test cases trace to requirements
[ ] Negative/boundary test cases present (not just happy path)
[ ] Defects logged with complete STR (steps to reproduce)
[ ] Regression suite maintained and green

### Release Phase
[ ] Release readiness criteria defined and checked
[ ] QA sign-off obtained before production
[ ] Rollback plan defined
[ ] Post-release monitoring plan in place

### Metrics & Improvement
[ ] Defect escape rate tracked monthly
[ ] Root cause analysis conducted for P1 defects
[ ] Process retrospectives including quality topics
[ ] QA metrics visible to stakeholders
```

### 2. Test Quality Audit
```python
# Heuristics for reviewing test quality (not just coverage)

def audit_test_quality(test_file: str) -> List[Issue]:
    issues = []
    content = read_file(test_file)
    tests = parse_tests(content)

    for test in tests:
        # Check: does test have assertions?
        if not has_assertions(test):
            issues.append(Issue("NO_ASSERTION", test.name,
                "Test has no assertions — always passes"))

        # Check: is assertion testing something meaningful?
        if has_only_truthy_assertion(test):
            issues.append(Issue("WEAK_ASSERTION", test.name,
                "assert response == True — what does True mean here?"))

        # Check: does test name describe behavior?
        if test.name.startswith("test_") and len(test.name) < 15:
            issues.append(Issue("POOR_NAME", test.name,
                "test_foo doesn't describe what's being tested"))

        # Check: is test independent?
        if calls_other_tests(test):
            issues.append(Issue("DEPENDENCY", test.name,
                "Test calls another test function — hidden dependency"))

        # Check: is setup/teardown balanced?
        if has_setup(test) and not has_teardown(test):
            issues.append(Issue("MISSING_CLEANUP", test.name,
                "Setup without teardown — state leaks between tests"))

    return issues
```

**Test quality anti-patterns to look for:**
- Tests that always pass (no assertions or assert True trivially)
- Tests testing implementation details instead of behavior
- Tests with misleading names (test_foo tests bar functionality)
- Duplicate tests testing the same thing in different ways
- Tests coupled to specific data values that will change

### 3. Code Review Quality Audit
```bash
# Review code review effectiveness using git history
git log --format="%H %ae" | while read sha author; do
    # Count reviewers per PR
    reviewers=$(git log $sha -1 --format="%B" | grep "Reviewed-by:" | wc -l)
    if [ "$reviewers" -eq 0 ]; then
        echo "PR $sha by $author: NO REVIEW (merged without review)"
    fi
done

# Check review turnaround time via PR creation -> approval date
# (run via GitHub/GitLab API)
```

**Code review audit questions:**
- Are PRs reviewed before merging? (check git log for merge without approval)
- What % of PRs have substantive comments vs rubber-stamp approvals?
- Are security-sensitive changes getting extra review?
- Is review turnaround within SLA?

### 4. Audit Report Structure
```markdown
## QA Process Audit Report
**Date:** 2026-04-12
**Team:** Platform Engineering
**Auditor:** QA Lead
**Period:** Q1 2026

## Executive Summary
Overall compliance: 67% (Needs Improvement)
Critical gaps: 3 | High gaps: 5 | Medium gaps: 4

## Findings

### CRITICAL: No test cases for negative/boundary scenarios
**Evidence:** Reviewed 47 test files — 41 test only happy path
**Impact:** High defect escape rate for edge cases (confirmed: 4 production bugs in Q1 from boundaries)
**Recommendation:** Mandate BVA/EP in test design; add to PR checklist

### HIGH: Release readiness checklist not followed
**Evidence:** 6 of 8 releases in Q1 had no formal sign-off documented
**Impact:** 2 of those releases had production incidents within 48 hours
**Recommendation:** Gate pipeline deployment on sign-off document creation

### MEDIUM: Static analysis enabled but findings ignored
**Evidence:** SonarQube shows 134 open issues (oldest: 6 months)
**Impact:** Technical debt accumulating; security issues unaddressed
**Recommendation:** Review backlog; set threshold: no new CRITICAL allowed

## Recommendations (Prioritized)
1. [Critical] Implement boundary/negative test requirement in DoD — 2 weeks
2. [High] Add release sign-off gate to deployment pipeline — 1 week
3. [High] Clear SonarQube backlog: Critical/Blocker items — 4 weeks
4. [Medium] Static analysis policy enforcement in CI — 2 weeks

## Next Audit: Q2 2026 (June)
```

## Key Concepts
- **Process audit** — systematic review of whether defined processes are being followed
- **Test quality review** — evaluation of test effectiveness beyond coverage (assertions, independence, naming)
- **Gap analysis** — difference between defined process (how it should be) and actual practice (how it is)
- **Finding** — specific observation with evidence, impact, and recommendation
- **Compliance rate** — % of audit criteria being met; tracks process health over time

## Checklist
- [ ] Audit scope and criteria defined before starting?
- [ ] Evidence collected objectively (git history, CI logs, not just interviews)?
- [ ] Findings include evidence + impact + recommendation (not just observations)?
- [ ] Critical findings have specific remediation timeline?
- [ ] Audit report shared with team and management?
- [ ] Follow-up audit scheduled to verify remediation?

## Key Outputs
- Audit checklist with compliance rate (% meeting each criterion)
- Findings report: critical/high/medium gaps with evidence and impact
- Remediation plan with owners and timelines
- Follow-up audit schedule

## Output Format
- 🔴 **Critical** — auditing without evidence (interviews only), no follow-up on findings, same issues recurring across audits
- 🟡 **Warning** — audit that only checks documentation (not actual practice), findings without recommendations, no compliance rate measurement
- 🟢 **Suggestion** — automate compliance checks where possible (PR review rate, coverage trend), quarterly audits, share audit results publicly within team for transparency

## Anti-Patterns
- Audit as blame exercise (creates fear; people hide problems)
- Checklist audit without judgment (tick boxes without assessing actual quality)
- Audit findings that go into a drawer (no follow-up = wasted effort)
- Auditing process that doesn't exist yet (define process first, then audit compliance)

## Integration
- `qa-process-design` — audits compliance with the process designed there
- `qa-metrics` — metrics provide evidence for audit findings
- `qa-risk-management` — audit findings feed risk assessment
