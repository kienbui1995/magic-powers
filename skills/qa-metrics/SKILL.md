---
name: qa-metrics
description: Use when measuring and reporting QA quality — defect escape rate, test coverage analysis, flaky test rate, mean time to detect, shift-left metrics, and building quality dashboards for stakeholders.
---

# QA Metrics & Reporting

## When to Use
- Building a QA metrics dashboard for stakeholders
- Evaluating effectiveness of the test strategy
- Demonstrating QA value to leadership
- Identifying where to invest testing effort
- Tracking quality trends over time (improving or degrading?)

## Core Jobs

### 1. Core QA KPIs
```
Defect Escape Rate (most important)
  Formula: Production defects / (Pre-prod defects + Production defects) × 100
  Target: < 10% (less than 10% of defects found in production)
  Why it matters: Measures testing effectiveness; high rate = gaps in coverage

Test Coverage
  Line coverage: % of code lines executed by tests
  Branch coverage: % of code branches executed
  Requirement coverage: % of requirements with test cases
  Target: > 80% branch coverage for business-critical paths
  Caution: Coverage is a floor not a ceiling; 100% with bad tests is worthless

Defect Detection Distribution
  % defects found per phase: Unit test | Integration | QA | UAT | Production
  Target: Most defects found in unit/integration (shift-left)
  Cost multiplier: Defect in prod costs ~30x more than unit test phase

Flaky Test Rate
  Formula: Tests that failed non-deterministically in last 7 days / total tests
  Target: < 2% flaky rate
  Impact: High flaky rate erodes trust in test suite, developers start ignoring failures

Mean Time to Detect (MTTD)
  Time from bug introduction (code commit) to detection
  Target: < 24 hours for critical paths
  Enables: Faster feedback, cheaper fixes

Test Execution Time
  Time from code commit to test results
  Target: < 10 min for unit+integration, < 30 min for full suite
  Impact: Slow tests = developers don't run them locally
```

### 2. Defect Escape Rate Calculation
```python
# Monthly defect escape rate report
def calculate_escape_rate(month: str) -> dict:
    pre_prod_defects = get_defects_found_before_production(month)
    prod_defects = get_production_incidents(month)
    total = len(pre_prod_defects) + len(prod_defects)

    escape_rate = len(prod_defects) / total * 100 if total > 0 else 0

    return {
        "month": month,
        "pre_prod_defects": len(pre_prod_defects),
        "production_defects": len(prod_defects),
        "escape_rate": f"{escape_rate:.1f}%",
        "trend": "improving" if escape_rate < get_previous_month_rate() else "degrading"
    }
```

### 3. Test Pyramid Health Check
```
Healthy test pyramid:
  E2E tests:          5-10%   (slow, expensive, cover critical paths)
  Integration tests: 20-30%   (medium speed, component interactions)
  Unit tests:        60-70%   (fast, cheap, cover business logic)

Unhealthy patterns:
  Ice cream cone (inverted pyramid):
    Many E2E, few unit tests → slow CI, brittle suite
    Fix: Identify what E2E tests are actually testing unit-level logic

  Hourglass (gaps in middle):
    Many unit + many E2E, no integration
    Fix: Add API/service-level integration tests

Check your pyramid:
  grep -r "@pytest.mark" tests/ | grep -c "e2e\|integration\|unit"
```

### 4. Quality Dashboard Components
```
Dashboard sections:

1. Build Health (real-time)
   - Last build status: PASS/FAIL
   - Build duration trend (line chart)
   - Flaky test list (top 10)

2. Coverage Trends (weekly)
   - Line coverage % over time (trend line)
   - Files with lowest coverage (table)
   - Coverage delta per PR

3. Defect Metrics (monthly)
   - Defect escape rate over time
   - Defect distribution by phase (bar chart)
   - Open P1/P2 count (KPI card)
   - Time to resolution by priority

4. Release Readiness (per release)
   - Test completion % by feature
   - Outstanding P1/P2 defects
   - Test pass rate last 5 runs
   - Sign-off status
```

### 5. Shift-Left Metrics
```
Measuring shift-left effectiveness:
  Before shift-left: 70% bugs found in QA/UAT, 30% in unit tests
  After 6 months: 50% bugs in unit, 30% integration, 20% QA, <5% production

Leading indicators (predict future quality):
  - PR code review turnaround time (faster = fewer bugs pass through)
  - Unit test coverage per PR (requires tests with new code)
  - Static analysis violations per PR (code quality proxy)

Lagging indicators (measure past quality):
  - Defect escape rate (measures testing effectiveness)
  - Production incident rate (measures overall quality)
  - Customer-reported bugs (ultimate quality measure)

Report: leading indicators weekly (actionable), lagging monthly (strategic)
```

## Key Concepts
- **Defect escape rate** — % of defects reaching production; primary QA effectiveness metric
- **Shift-left** — finding defects earlier in development (unit > integration > QA > production)
- **Test pyramid** — distribution of test types; more unit, fewer E2E
- **Flaky test** — test that fails non-deterministically; track and quarantine
- **Leading vs lagging indicators** — leading predict future (coverage), lagging measure past (escape rate)
- **MTTD (Mean Time to Detect)** — time from bug introduction to discovery

## Checklist
- [ ] Defect escape rate tracked monthly?
- [ ] Test coverage measured (branch coverage, not just line)?
- [ ] Flaky test rate monitored (< 2% target)?
- [ ] Test pyramid health checked (ratio of unit:integration:E2E)?
- [ ] Quality dashboard accessible to stakeholders?
- [ ] Leading indicators (coverage trends) reviewed weekly?

## Key Outputs
- Monthly QA metrics report (escape rate, coverage, flaky rate, defect distribution)
- Quality dashboard for stakeholder visibility
- Shift-left effectiveness measurement over time
- Recommendations based on metrics (where to invest testing effort)

## Output Format
- 🔴 **Critical** — no defect escape rate tracking (blind to production quality), flaky test rate >10% (suite is unreliable), no coverage measurement
- 🟡 **Warning** — tracking only line coverage (not branch), no trend analysis (point-in-time only), metrics not visible to stakeholders
- 🟢 **Suggestion** — build automated weekly metrics email, track coverage delta per PR (not just absolute), add defect phase distribution to understand shift-left progress

## Anti-Patterns
- Optimizing for 100% code coverage instead of meaningful tests (vanity metric)
- Reporting only passing tests (ignores flaky tests, skipped tests)
- Metrics with no target (measurement without direction is pointless)
- Only lagging indicators (escape rate tells you after the fact; add leading indicators)

## Integration
- `qa-defect-management` — defect data feeds escape rate and distribution metrics
- `ado-pipeline-optimization` — test result publishing enables coverage trending
- `test-strategy` — metrics validate and inform the overall test strategy
