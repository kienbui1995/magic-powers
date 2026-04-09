---
name: diagnose-errors
description: Triage and investigate application errors using Amplitude's auto-captured error events. Uses mcp__Amplitude__query_amplitude_data, mcp__Amplitude__get_session_replays, mcp__Amplitude__get_charts.
---

# Diagnose Errors

## When to Use

- Users are reporting errors but you don't know which errors or how many users are affected
- A deploy just went out and you want to check for new errors
- Error monitoring alert fired but you need more context (which users, which flows)
- Weekly error review — proactive check before users notice
- Investigating why a conversion metric dropped (errors causing drop-off?)
- When Sentry/error monitoring tools don't give enough user context

## Core Jobs

### 1. Pull Error Volume by Type (Last 24-48h)

Amplitude auto-captures three error categories. Query all three:

**Network errors** — failed API/HTTP calls:
```
mcp__Amplitude__query_amplitude_data:
  event: "[Amplitude] Network Error"  (or project-specific name)
  time_range: last 24h
  group_by: endpoint, http_status_code, error_message
```

**JS errors** — unhandled JavaScript exceptions:
```
mcp__Amplitude__query_amplitude_data:
  event: "[Amplitude] JS Error"
  time_range: last 24h
  group_by: error_type, error_message, file, line_number
```

**Error clicks** — clicks on elements in an error state:
```
mcp__Amplitude__query_amplitude_data:
  event: "[Amplitude] Error Click"  (or rage_click, error_element_clicked)
  time_range: last 24h
  group_by: element, page_url
```

Also check: `mcp__Amplitude__get_charts` for any pre-built error rate dashboards in the project.

### 2. Identify Top Errors by Frequency

Rank errors by unique user count (not total occurrences — one user hitting an error 100 times is less severe than 100 users hitting it once):

```
Top Errors (last 24h):

#1: POST /api/payments → 500 Internal Server Error
    Affected users: 847  |  Total occurrences: 1,203
    First seen: 2024-11-08 14:15 UTC

#2: TypeError: Cannot read property 'name' of undefined (profile.js:89)
    Affected users: 312  |  Total occurrences: 419
    First seen: 2024-11-07 09:22 UTC

#3: GET /api/user/preferences → 404 Not Found
    Affected users: 89   |  Total occurrences: 234
    First seen: 2024-11-06 16:40 UTC
```

### 3. Check if Errors Are New (Regression) or Existing (Known Issue)

For each top error, determine its history:

**Query error volume over 7 days:**
```
mcp__Amplitude__query_amplitude_data:
  event: "network_error"
  filter: endpoint = "/api/payments", status = 500
  time_range: last 7 days
  breakdown: by day
```

**Classification:**
- **Regression**: Error appears at a specific timestamp, correlates with a deploy/config change → urgent
- **Known issue**: Error has been present for >7 days, stable volume → schedule fix
- **New issue**: Error appeared in last 24h but no clear deploy correlation → investigate cause
- **Spike**: Error has existed but volume suddenly increased → investigate trigger

**Regression detection:**
```
If error_volume[today] > 5x error_volume[yesterday] → regression flag
If error_first_seen correlates with deploy_time → regression flag
```

### 4. Find Affected Session Replays for Top Errors

For the top 3 errors, find sessions where the error occurred:

```
mcp__Amplitude__get_session_replays:
  filter: error_events containing [error_type, error_endpoint]
  time_range: last 24h
  limit: 10
```

The session replay context reveals:
- What user action immediately preceded the error
- What the user experienced after the error (did they see an error message? did they retry?)
- Whether there's a consistent user flow that leads to the error
- Browser/device context (is this iOS-only? specific browser?)

### 5. Extract Error Context

From the session replays and event data, extract:

**Affected user profile:**
- Are these all logged-in users? Anonymous?
- Is there a user plan/segment correlation? (e.g., only Pro plan users hit this)
- Geographic or device pattern?

**Affected flows:**
- Which pages are users on when errors occur?
- What is the user trying to accomplish?
- Is the error happening in a specific feature or globally?

**Affected endpoints/elements:**
- For network errors: which API endpoint, what's the consistent response body?
- For JS errors: which function, what's the call stack?
- For error clicks: which element, what was the user trying to click?

**Error context template:**
```
Error: POST /api/payments → 500
Context:
  - Flow: checkout → payment submission
  - Trigger: user clicks "Submit Payment" after entering card details
  - User segment: all authenticated users, no plan restriction
  - Device: 78% Chrome desktop, 22% Safari mobile
  - Error response: {"error": "payment_processor_timeout"}
  - User experience: form shows spinner indefinitely, no error message
  - User action after error: 68% abandon, 22% retry (triggers error again), 10% refresh
```

### 6. Assess Severity

Classify each error for response priority:

**P0 — Critical (respond now):**
- Blocks a core user action (payment, login, signup, data save)
- Error rate >5% of users performing the action
- Revenue impact detectable

**P1 — High (fix this sprint):**
- Degrades a key user action but workaround exists
- Error rate 1-5% of users performing the action
- No revenue impact, but user satisfaction impact

**P2 — Medium (schedule fix):**
- Affects a secondary feature
- Error rate <1% of users
- Cosmetic or minor UX impact

**P3 — Low (backlog):**
- Cosmetic only
- No functional impact
- Affects <0.1% of users

## MCP Tools

- `mcp__Amplitude__query_amplitude_data` — query error event volumes, group by error type/endpoint, analyze trends over time to distinguish regressions from existing issues
- `mcp__Amplitude__get_session_replays` — find sessions where specific errors occurred to understand user context and flow
- `mcp__Amplitude__get_charts` — check pre-built error monitoring dashboards and charts for baseline context

## Key Concepts

- **Unique user count vs. total occurrences**: Severity is better measured by how many distinct users are affected, not total error count (one user in a retry loop skews occurrence counts)
- **Regression**: An error that correlates with a specific deployment or configuration change — time-sensitive, requires immediate rollback investigation
- **Error context**: The user flow, device, and segment data surrounding an error — essential for prioritization and root cause
- **Auto-captured errors**: Network errors, JS errors, and error clicks that Amplitude records automatically without custom instrumentation — available in all projects with session replay enabled
- **Error click**: Amplitude's term for a click on an element that is in an error state (e.g., a form submit button when validation has failed) — useful for detecting silent UX failures

## Output Format

```
## Error Triage Report — <time range>

### Top Errors by Impact

| # | Error | Type | Affected Users | Classification | Priority |
|---|-------|------|----------------|----------------|---------|
| 1 | POST /api/payments → 500 | Network | 847 | Regression (deploy 14:15) | P0 |
| 2 | TypeError: 'name' undefined | JS | 312 | Known (7d) | P1 |
| 3 | GET /api/preferences → 404 | Network | 89 | New (24h) | P2 |

### Error Details

**P0: POST /api/payments → 500** [Regression — started 14:15 UTC]
Users affected: 847 (23% of checkout attempts)
Trigger: user submits payment form
User experience: infinite spinner, no error message
Session replay: [session_id_1] [session_id_2]
Recommended action: [rollback deploy / hotfix payment processor timeout handling]

**P1: TypeError: 'name' undefined** [Known — stable volume]
...

### Summary
- P0 issues: 1 (requires immediate action)
- P1 issues: 1 (schedule this sprint)
- P2 issues: 1 (backlog)
- Total unique users affected: 1,248
```
