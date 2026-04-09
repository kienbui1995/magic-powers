---
name: replay-ux-audit
description: Synthesize multiple session replays into a UX friction map identifying systemic usability issues. Uses mcp__Amplitude__list_session_replays, mcp__Amplitude__get_session_replay_events, mcp__Amplitude__get_session_replays.
---

# Replay UX Audit

## When to Use

- A product team wants to understand why users struggle with a specific flow before redesigning it
- Conversion rate on a key funnel step is lower than expected — need to find the friction
- Before a UX research round: use session replays to form hypotheses to test in interviews
- After launch of a new feature: is it being used as intended? Where do users get stuck?
- When a flow has high bounce/abandon rates but no clear error signals
- Quarterly UX review: proactive audit of key flows before they become problems

## Core Jobs

### 1. Define Audit Scope

Clarify the focus before sampling sessions. The audit should target one of:

- **Specific user flow**: e.g., signup → onboarding → first action (multi-page flow)
- **Specific page**: e.g., pricing page (single-page behavior analysis)
- **Specific feature**: e.g., search filters, bulk action tool, data export

Define:
- Entry point (what page/action starts the flow)
- Exit point (what constitutes success vs. abandonment)
- Target user segment (new users? paid users? mobile-only?)
- Time window (last 7 days for recent data, last 30 days for statistical significance)

### 2. Sample 20-50 Relevant Sessions

Use `mcp__Amplitude__list_session_replays` to find sessions matching the scope:

**Sampling strategy — always mix success and failure:**
- ~40% **completed** sessions (users who finished the flow successfully)
- ~40% **abandoned** sessions (users who left mid-flow)
- ~20% **partial** sessions (users who made progress but didn't complete)

This balance is critical: studying only failures shows what's broken, but studying successful sessions reveals what workarounds users invented, which signals non-obvious friction.

**Sample size guidance:**
- 20 sessions: enough for a quick hypothesis check
- 35 sessions: enough for pattern confidence on a specific page
- 50 sessions: full audit with quantitative friction estimates

### 3. Watch for Friction Signals

For each session, use `mcp__Amplitude__get_session_replay_events` to extract the interaction timeline.

**The 5 friction signals — what to look for:**

**Rage Clicks** — rapid repeated clicks on the same element
```
Signal: 3+ clicks within 2 seconds on same element
Meaning: User expects interaction that isn't happening
Examples: disabled button that looks enabled, form submit that silently fails
```

**Dead Clicks** — clicks on non-interactive elements
```
Signal: Click with no page response or state change
Meaning: Element looks clickable but isn't; or link is broken
Examples: text that looks like a link, icon without hover state, grayed-out element
```

**U-Turns** — backward navigation immediately after forward navigation
```
Signal: User goes to Page B then immediately returns to Page A
Meaning: Page B didn't have what they expected, or they made a mistake and noticed immediately
Examples: clicking wrong menu item, seeing an unexpected modal, wrong filter applied
```

**Hesitation** — long pause before taking an action (>10s with cursor movement but no click)
```
Signal: Mouse movement without clicks, sustained time on element
Meaning: User is unsure what to do next; decision anxiety or unclear affordance
Examples: ambiguous CTA labels, multiple similar options, unclear next step
```

**Form Abandonment** — user starts form input then leaves
```
Signal: Focus on form field, then session ends or navigation away
Meaning: Form is too long, too confusing, requires unavailable information, or failed
Examples: unexpected required fields, confusing validation errors, too many steps
```

### 4. Build Friction Map

After reviewing all sessions, build a structured map of where friction occurs:

```
Flow: Checkout → Payment → Confirmation

Step 1: /checkout/cart     [friction: LOW]
  - Clear path forward
  - Minor: some users don't notice "Apply Coupon" link (dead click on cart total)

Step 2: /checkout/shipping [friction: MEDIUM]
  - 23% of sessions show hesitation on "Same as billing" checkbox
  - 12% of sessions show u-turn (back to cart, then forward again)
  - Form validation error on ZIP code triggers rage clicks in 18% of sessions

Step 3: /checkout/payment  [friction: HIGH]
  - Rage clicks on "Submit Payment" in 34% of sessions
  - 41% of abandonment happens at this step
  - Key signal: users click submit, wait 5s, click again (double submit pattern)

Step 4: /checkout/confirmation [friction: NONE]
  - Sessions that reach here show smooth behavior
  - Concern: only 59% of sessions that start checkout reach this step
```

### 5. Quantify Friction Points

For each identified friction signal, calculate:

- **Frequency**: What % of sampled sessions show this friction?
- **Recurrence**: Do the same users encounter this friction multiple times in one session?
- **Correlation with abandonment**: What % of sessions with this friction end in abandonment?

```
Friction: Rage clicks on "Submit Payment"
  - Frequency: 34% of sessions (17/50 sampled)
  - Recurrence: 71% of affected users click 3+ times
  - Abandon correlation: 68% of rage-clicking users abandon the session
  - Estimated impact: 34% × 68% = 23% of checkout sessions lost to this friction
```

### 6. Prioritize by Frequency × Severity

Rank issues using a simple matrix:

| Friction Point | Frequency | Severity | Priority Score | Recommendation |
|----------------|-----------|----------|---------------|----------------|
| Payment double-submit | 34% | High (abandonment) | 9/10 | Fix: show loading state on submit |
| ZIP validation rage click | 18% | Medium (frustration) | 6/10 | Fix: inline validation, clear format guide |
| Shipping checkbox hesitation | 23% | Low (slows down) | 4/10 | Improve: better label text |
| Coupon dead click | 8% | Low (confusion) | 2/10 | Improve: make coupon field more visible |

### 7. Recommend UX Improvements

For each high-priority friction point, provide a specific recommendation:

**Recommendation format:**
- **Problem**: what the user experiences (be concrete — "user clicks Submit 3 times")
- **Root cause hypothesis**: why this happens (button doesn't disable after click)
- **Recommended fix**: specific UI change (disable button after first click + show spinner)
- **Success metric**: how to measure if the fix worked (rage click rate on Submit button)

## MCP Tools

- `mcp__Amplitude__list_session_replays` — search and filter sessions for the audit scope (by page, user segment, time range, completion status)
- `mcp__Amplitude__get_session_replays` — get session metadata for the sampled set (duration, pages visited, device type)
- `mcp__Amplitude__get_session_replay_events` — extract the full interaction timeline per session to identify friction signals

## Key Concepts

- **Friction map**: A structured breakdown of where users struggle in a flow, with frequency and severity data
- **Rage click**: Rapid repeated clicks on the same element — the strongest signal of user frustration in replay data
- **Dead click**: Click with no UI response — indicates mismatched affordance (element looks interactive but isn't)
- **U-turn**: Immediate back navigation after forward navigation — signals the destination didn't meet expectations
- **Abandon correlation**: The percentage of sessions showing a friction signal that end in task abandonment — the key metric for prioritization
- **Friction score**: Frequency × severity, used to rank issues for the roadmap

## Output Format

```
## UX Audit: <flow or page name>
Sessions reviewed: N (XX successful, XX abandoned, XX partial)
Time window: <date range>

### Friction Map by Flow Step
<table or list of steps with friction level and key signals>

### Top Friction Issues (ranked by priority)

**Issue 1:** <name> [Priority: X/10]
Frequency: XX% of sessions
Signal: <specific behavior observed>
Root cause: <hypothesis>
Fix: <specific recommendation>
Success metric: <how to measure improvement>

**Issue 2:** ...

### Summary Metrics
- Steps with HIGH friction: N
- Estimated sessions lost to friction: XX%
- Top 3 improvement opportunities: <list>

### Recommended Next Actions
1. <highest impact fix — estimate: X% conversion lift>
2. <second fix>
3. <third fix>
```
