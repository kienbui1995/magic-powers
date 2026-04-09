---
name: debug-replay
description: Transform bug reports into actionable reproduction steps using session replay data. Uses mcp__Amplitude__list_session_replays, mcp__Amplitude__get_session_replay_events, mcp__Amplitude__get_session_replays.
---

# Debug Replay

## When to Use

- A user reports a bug and you need to reproduce it without access to their environment
- QA files a ticket with insufficient reproduction steps ("it just broke")
- A bug shows up in support tickets but can't be reproduced in staging
- An engineer needs to understand the exact user sequence that led to an error
- Investigating intermittent issues that are hard to trigger on demand
- Root-cause analysis for a production incident — what did users actually do?

## Core Jobs

### 1. Parse the Bug Report

Extract actionable signals from the incoming bug report:

**Key signals to extract:**

| Signal | Where to Find It | Use |
|--------|-----------------|-----|
| Affected URL / page | Bug description | Filter replays by page |
| Error message | Sentry, console logs, screenshot | Filter by error event |
| User ID | Support ticket, auth logs | Find sessions for specific user |
| Approximate time | "It happened around 3pm" | Set time range filter |
| Device / browser | Support form, user agent | Filter by device type |
| Action sequence | User description | Verify in replay timeline |

If any signal is missing, note it — missing user ID means broader search; missing time means longer window.

### 2. Find Matching Sessions

Use Amplitude Session Replay to search for sessions matching the bug signals:

```
mcp__Amplitude__list_session_replays:
  - Filter by: URL containing the affected page path
  - Filter by: error events (if Amplitude auto-captures the error type)
  - Filter by: user_id (if known)
  - Time range: ±2 hours around reported time, or last 48h if time unknown
  - Sort by: relevance / recency
```

Search strategy:
- **Narrow search first**: specific user + specific time → most likely to find exact session
- **Broaden if needed**: same page + same error type → find pattern across users
- **Broadest**: same page + last 24h → sample of all activity on that page

### 3. Select 3-5 Most Relevant Sessions

From the results list, select sessions most likely to reproduce the issue:

**Prioritize sessions with:**
- The user who reported the bug (highest priority)
- Sessions that ended abruptly (abandoned after error)
- Sessions showing the error message mentioned in the bug report
- Sessions on the same browser/device type as reported
- Sessions with rage clicks (indicator of UX failure)

**Get session details:**
```
mcp__Amplitude__get_session_replays: [session_id_1, session_id_2, ...]
```

### 4. Extract Interaction Timeline from Each Session

For each selected session, use `mcp__Amplitude__get_session_replay_events` to get the full event timeline:

Build a chronological sequence:
```
T+0:00  Page loaded: /checkout/payment
T+0:12  Scrolled to credit card form
T+0:34  Clicked "Card Number" field
T+0:35  Typed card number (16 digits)
T+1:02  Clicked "Expiry" field
T+1:15  Clicked "Submit Payment" button
T+1:16  Network request: POST /api/payments → HTTP 500
T+1:16  JS Error: "Cannot read property 'id' of undefined"
T+1:20  Page showed spinner (no error message to user)
T+2:45  User clicked browser back button
```

Note: the exact sequence reveals the **breaking point** — the last successful step before failure.

### 5. Identify the Breaking Point

From the timeline, pinpoint exactly where the failure began:

- **Last successful action**: what was the last thing that worked?
- **Failure trigger**: what action or event triggered the failure?
- **Failure manifestation**: how did the failure appear to the user (error message, spinner, blank page, wrong state)?
- **User response**: what did the user do after the failure (retry, abandon, navigate away)?

Look for: network errors immediately after a user action, JS errors in the error events, page state that doesn't change after a click (dead click pattern).

### 6. Document Reproduction Steps

Write precise steps that any engineer can follow:

```
## Reproduction Steps (verified in 3/5 sessions)

**Environment:** Chrome 120, macOS, logged-in user with Basic plan

**Preconditions:** User must have at least one item in cart

**Steps:**
1. Navigate to /checkout/payment
2. Scroll down to the credit card form
3. Enter a valid card number (any 16-digit number)
4. Click the Expiry field
5. Enter expiry date (e.g., 12/26)
6. Click "Submit Payment"

**Expected:** Payment processes, redirect to /checkout/confirmation
**Actual:** Spinner shows indefinitely; no error message displayed

**Technical failure:** POST /api/payments returns HTTP 500
  Response body: {"error": "Cannot read property 'id' of undefined"}
  JS Error: "TypeError: Cannot read property 'id' of undefined at processPayment (payment.js:142)"

**Affected sessions:** 3/5 sampled sessions show identical failure pattern
**First occurrence:** 2024-11-08 14:32 UTC (matches deploy at 14:15 UTC)
```

### 7. Assess Fix Priority

Based on session data, determine severity:

**Severity classification:**

| Signal | Severity |
|--------|---------|
| Blocks core user action (checkout, login, signup) | P0 — Critical |
| Blocks important action, workaround exists | P1 — High |
| Degrades UX but doesn't block the action | P2 — Medium |
| Cosmetic only, no functional impact | P3 — Low |

**Frequency assessment:**
- How many unique sessions show this failure?
- What % of all sessions on this page show the failure?
- Is it 100% reproducible or intermittent?
- Is the rate increasing or stable?

## MCP Tools

- `mcp__Amplitude__list_session_replays` — search for sessions matching bug signals (URL, error type, user ID, time range)
- `mcp__Amplitude__get_session_replays` — get metadata and details for selected sessions
- `mcp__Amplitude__get_session_replay_events` — extract the full interaction timeline and event sequence from a session

## Key Concepts

- **Breaking point**: The exact moment in a session replay where the failure begins — the key diagnostic signal
- **Rage click**: Multiple rapid clicks on the same element — indicates user frustration, often precedes abandonment
- **Dead click**: Click on an element that doesn't respond — indicates either a UI bug or a non-interactive element that looks interactive
- **Session abandonment**: User leaves without completing the intended action — high-priority signal when correlated with errors
- **Reproduction rate**: The percentage of sampled sessions showing the same failure pattern — determines confidence in the root cause

## Output Format

```
## Bug Report: <one-line description>

**Severity:** P<N> — <Critical|High|Medium|Low>
**Affected Sessions:** N sessions in last 24h (X% of sessions on this page)
**First Occurrence:** <timestamp> (correlates with: <deploy / config change / etc.>)

### Reproduction Steps
<numbered steps>

**Expected vs. Actual:** <one-liner>

### Technical Details
**Network Error:** <endpoint> → HTTP <status>
**JS Error:** <error message + stack location>
**Device/Browser:** <from session metadata>

### Evidence
Session IDs reviewed: [<id1>, <id2>, <id3>]
Failure confirmed in: N/5 sessions
Pattern: <description of the consistent failure pattern>

### Recommended Fix
<specific hypothesis based on the error message and stack trace>
```
