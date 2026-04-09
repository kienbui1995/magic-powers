---
name: monitor-reliability
description: Proactive reliability health check using auto-captured error and network failure data. Uses mcp__Amplitude__query_amplitude_data, mcp__Amplitude__get_charts, mcp__Amplitude__get_context.
---

# Monitor Reliability

## When to Use

- Daily or weekly scheduled reliability review (before users notice issues)
- Immediately after a production deployment — is anything broken?
- When on-call monitoring alerts are quiet but you want to verify application health
- Before a major event (product launch, marketing campaign) — ensure system is stable
- When a team wants to establish baseline reliability metrics for SLO definition
- Complement to infrastructure monitoring (Datadog, CloudWatch) with user-experience data

## Core Jobs

### Phase 1: Establish Baselines

Before classifying anything as "abnormal," establish what normal looks like for this product.

**Baseline sources:**
- Same time window, previous week (7d rolling — controls for day-of-week patterns)
- Same time window, previous day (24h rolling — controls for time-of-day patterns)
- Use `mcp__Amplitude__get_charts` to find pre-built error rate charts if they exist

**Baseline template:**
```
Product: <name>
Check period: <date/time range>
Baseline period: <previous equivalent period>

Normal error rates (established from 30d history):
  Network error rate: ~0.3% of sessions
  JS error rate: ~0.1% of sessions
  Error click rate: ~2.1% of sessions
```

If no prior baseline exists: treat today as Day 1, document these numbers as the starting baseline.

### Phase 2: Check Network Error Rates

API failures are the most impactful errors — they block user actions entirely.

**Query:**
```
mcp__Amplitude__query_amplitude_data:
  event: "[Amplitude] Network Error"
  time_range: last 24h
  group_by: endpoint, http_status_code
  metric: unique users affected
```

**What to look for:**
- **Rate increase**: Is network error rate up >20% vs. baseline? → Flag as Yellow
- **New endpoints**: Any endpoints in top errors that weren't in yesterday's list? → Flag as new regression
- **4xx vs. 5xx split**: 4xx errors are often client-side (bad inputs, auth issues); 5xx are server-side failures
- **High-volume endpoints**: `/api/auth`, `/api/data/save`, `/api/payments` failing → Critical
- **Low-volume endpoints**: admin or rarely-used endpoints failing → Medium priority

**Threshold guidance:**
```
GREEN:  <0.5% of sessions have network errors, stable vs. baseline
YELLOW: 0.5–2% of sessions affected, or >20% increase vs. baseline
RED:    >2% of sessions affected, or critical endpoint (auth/payment) failing
```

### Phase 3: Check JS Error Rates

Unhandled JavaScript exceptions break page functionality even when APIs are working.

**Query:**
```
mcp__Amplitude__query_amplitude_data:
  event: "[Amplitude] JS Error"
  time_range: last 24h
  group_by: error_type, file
  metric: unique users affected
```

**What to look for:**
- **Unhandled promise rejections**: Often indicate async code without error handling
- **TypeError / ReferenceError**: Classic signs of code accessing undefined data — common in regressions
- **New errors since last deploy**: Errors with `first_seen` after the last deployment time
- **Error location**: Errors in critical files (checkout.js, auth.js, payment.js) are higher severity

**Threshold guidance:**
```
GREEN:  <0.1% of sessions have JS errors
YELLOW: 0.1–0.5% of sessions affected, or new error types since last deploy
RED:    >0.5% of sessions affected, or error in payment/auth critical path
```

### Phase 4: Check Error Click Rates

Error clicks — rage clicks and clicks on broken elements — reveal UX failures that don't generate HTTP errors.

**Query:**
```
mcp__Amplitude__query_amplitude_data:
  event: "[Amplitude] Error Click"
  time_range: last 24h
  group_by: element, page_url
  metric: unique users affected
```

**What to look for:**
- **Rage clicks on specific elements**: Buttons that don't respond, forms that don't submit
- **High concentration on single page**: Indicates a broken flow rather than scattered UX issues
- **Correlation with abandonment**: Pages with high error click rate + high exit rate = broken flow

**Threshold guidance:**
```
GREEN:  <2% of sessions have error clicks
YELLOW: 2–5% of sessions, or concentrated on one key page
RED:    >5% of sessions, or concentrated on checkout/signup/critical flows
```

### Phase 5: Compare to Previous Period

For each metric, calculate week-over-week and day-over-day change:

```
mcp__Amplitude__query_amplitude_data:
  same queries as above
  time_range: previous 24h / previous 7d equivalent
```

**Change threshold rules:**
- **>20% increase** in any error type → investigate cause (deploy? config change? traffic spike?)
- **New endpoint/error appearing** → investigate as potential regression
- **Stable or decreasing** → no action needed

**Correlation check:**
- Did error rate change correlate with a deploy? (check deploy log times)
- Did it correlate with a traffic spike? (check session volume)
- Did it correlate with a third-party service incident?

### Phase 6: Surface Top 3 Reliability Risks

Aggregate findings into a concise risk summary. Don't list everything — prioritize the top 3 issues that need action.

For each risk:
1. **What**: specific error type and affected endpoint/element
2. **Scope**: how many users affected?
3. **Trend**: is it getting worse, stable, or improving?
4. **Recommended action**: specific next step

## MCP Tools

- `mcp__Amplitude__query_amplitude_data` — query error event volumes by type (network, JS, error click), compare across time periods, group by endpoint/element
- `mcp__Amplitude__get_charts` — retrieve pre-built error rate charts and reliability dashboards; check if baselines have been previously established
- `mcp__Amplitude__get_context` — get project context and understand what error events are being captured; verify auto-capture is configured correctly

## Key Concepts

- **Auto-captured errors**: Amplitude records network errors, JS errors, and error clicks automatically when session replay is enabled — no custom instrumentation required
- **Error rate vs. error count**: Rate (errors / sessions) is more meaningful than count — it controls for traffic volume changes
- **Regression signal**: An error metric that increased sharply at a specific timestamp, correlating with a deployment or configuration change
- **Reliability scorecard**: A structured summary of error rates by category with GREEN/YELLOW/RED status — enables quick communication to stakeholders
- **Baseline drift**: When error rates slowly increase over weeks without triggering acute alerts — requires periodic review to detect

## Output Format

```
## Reliability Health Check — <date> <time>

### Scorecard

| Category | Rate | Status | vs. Yesterday | vs. Last Week |
|----------|------|--------|--------------|--------------|
| Network Errors | 0.4% of sessions | 🟡 YELLOW | +28% | +15% |
| JS Errors | 0.08% of sessions | 🟢 GREEN | -5% | +2% |
| Error Clicks | 1.8% of sessions | 🟢 GREEN | -3% | -8% |

**Overall Status: YELLOW** (1 category elevated)

### Top 3 Reliability Risks

**Risk 1: POST /api/payments → 500 rate increased 28%**
Scope: 423 users in last 24h
Trend: Increasing since 14:15 UTC (deploy window)
Action: Review payment service logs for timeout errors; consider rollback if rate continues rising

**Risk 2: <next issue>**
...

### What's Working Well
- JS error rate stable and within threshold
- No new error types detected
- Error click rate improved vs. last week

### Next Scheduled Check
<recommended check time based on cadence: daily/weekly>
```
