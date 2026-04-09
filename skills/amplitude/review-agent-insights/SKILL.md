---
name: review-agent-insights
description: Retrieve and synthesize AI agent analysis findings ranked by business impact. Uses mcp__Amplitude__get_agent_results, mcp__Amplitude__get_feedback_insights.
---

# Review Agent Insights

## When to Use

- Weekly review of AI-generated analytics findings before team planning meetings
- When Amplitude's AI agents have run analyses and you need to synthesize what they found
- Before a product review meeting: "what does the data say this week?"
- When multiple automated analyses have run in parallel and need to be consolidated
- When a product manager or exec asks "what are our top data insights right now?"
- Triaging alerts from Amplitude's AI-powered anomaly detection and forecasting features

## Core Jobs

### 1. Retrieve Recent Agent Analysis Results and Findings

Pull all recent agent results from the target time window:

```
mcp__Amplitude__get_agent_results:
  time_range: last 7 days  (or since last review)
  status: completed
  types: [anomaly_detection, forecast, correlation, funnel_analysis, retention_analysis]
```

Also retrieve user feedback insights that may have been automatically processed:
```
mcp__Amplitude__get_feedback_insights:
  time_range: last 7 days
  min_mentions: 3  (filter noise — only topics mentioned 3+ times)
```

**Expected finding types from Amplitude agents:**
- **Anomaly alerts**: Metrics that deviated significantly from baseline (spikes, drops)
- **Correlation findings**: Unexpected relationships between events or user segments
- **Funnel insights**: Steps with unusually high drop-off, conversion changes
- **Retention insights**: Cohorts with better or worse retention than expected
- **Forecast deviations**: Actual metrics diverging from projected trends
- **Segment insights**: Specific user segments behaving differently from the whole

### 2. Rank by Estimated Business Impact

Not all findings are equal. Prioritize by impact on the metrics that matter most.

**Impact estimation framework:**

**Revenue impact** (highest priority):
- Findings that affect paid conversion, upgrade rate, or churn rate
- Anomalies in purchase funnel steps
- Segments with significantly different LTV behavior

**Engagement impact** (high priority):
- Changes to activation rate or time-to-first-value
- Retention curve changes in key user segments
- Feature adoption that correlates with paid conversion

**Operational impact** (medium priority):
- Error rate changes that affect user experience
- Performance degradations that increase session abandonment
- Support volume drivers (features causing high escalation to support)

**Informational** (lower priority):
- Normal seasonal variations correctly identified as anomalies by the agent
- Findings about low-traffic features with minimal user impact
- Correlation findings that are interesting but not actionable

**Scoring guidance:**
```
High impact: finding affects >10% of MAU or >5% of revenue metric
Medium impact: affects 1-10% of MAU or 1-5% of revenue metric
Low impact: affects <1% of MAU or <1% of revenue metric, or informational
```

### 3. Identify Patterns Across Multiple Analyses

Multiple agent analyses often surface related signals. Look for recurring themes:

**Pattern types:**
- **Same metric, multiple angles**: "retention dropping" appears in cohort analysis, funnel analysis, AND anomaly detection → strong signal, high confidence
- **Same user segment**: multiple findings pointing to problems with mobile users, or enterprise users, or new signups
- **Same feature**: multiple insights connecting to one product area (checkout, onboarding, search)
- **Same time period**: multiple metrics changed at the same time → likely same root cause (deploy, external event, marketing campaign)

**Pattern recognition example:**
```
Finding 1 (Funnel Analysis): Checkout completion rate dropped 8% this week
Finding 2 (Anomaly Detection): "checkout_confirmation_viewed" event volume down 12%
Finding 3 (Retention Analysis): Users who completed checkout last week have lower D7 return rate
Finding 4 (Error Monitoring): POST /api/payments error rate up 23% this week

Pattern: These 4 findings point to the same root cause — payment flow degradation
This is a CRITICAL connected insight, not 4 separate findings.
```

### 4. Flag Time-Sensitive Findings

Some findings require immediate attention. Identify and escalate:

**Criteria for time-sensitive flagging:**
- **Rapidly worsening metrics**: Rate of change is increasing (acceleration, not just increase)
- **New failure modes**: Something that wasn't happening before suddenly started (regression)
- **Revenue-impacting anomalies**: Conversion or revenue metric is below trend by >5%
- **Cascade risk**: One finding that, if not addressed, is likely to get worse (error rate climbing)

**Time-sensitivity classification:**
```
URGENT (respond today):
  - Conversion metric down >10% vs. trend
  - New error pattern affecting >5% of users
  - Revenue-impacting regression identified

SOON (address this sprint):
  - Metric trending wrong direction for 3+ consecutive days
  - New failure mode with moderate user impact

WATCH (monitor, no immediate action):
  - Metric slightly below trend but stable
  - Interesting correlation that needs further investigation
```

### 5. Package into Executive Summary

Consolidate all findings into a concise, action-oriented brief:

**Structure the summary for different audiences:**

For **engineering**: lead with regressions, error rates, and technical root causes

For **product**: lead with funnel changes, feature adoption, and user behavior shifts

For **executive/leadership**: lead with revenue impact, user count affected, and trend direction

**Summary template:**
```
## Weekly AI Agent Insights — <date>

### Executive Summary
This week's agent analyses surfaced [N] significant findings.
Top concern: [one sentence on highest-impact finding].
[X] findings require immediate action; [Y] to monitor.

### Action Items by Team

ENGINEERING (respond this week):
  1. [Finding + specific action + estimated impact]
  2. ...

PRODUCT (address in planning):
  1. [Finding + specific action + estimated impact]
  2. ...

DESIGN (consider for next iteration):
  1. [Finding + specific action + estimated impact]
  2. ...

### Connected Insights (Patterns)
[Pattern name]: [list of related findings that point to same root cause]
Implication: [what this pattern means for the business]

### Findings That Need More Investigation
[Findings that are interesting but not yet actionable — need more data or deeper analysis]

### Findings Closed (No Action Needed)
[Findings that were investigated and explained — seasonal, expected, resolved]
```

## MCP Tools

- `mcp__Amplitude__get_agent_results` — retrieve completed AI agent analysis results from the target time window; provides the raw findings that this skill synthesizes
- `mcp__Amplitude__get_feedback_insights` — retrieve processed feedback insights that may complement the agent results with qualitative signals from user feedback

## Key Concepts

- **Agent result**: A completed analysis produced by Amplitude's AI agents — may include anomaly detection, correlation analysis, funnel insights, or retention analysis
- **Connected insight**: Multiple separate agent findings that point to the same root cause — synthesizing these is the core value of this skill
- **Time-sensitive finding**: A finding that, if not acted on promptly, will likely worsen — identified by rate of change, not just magnitude
- **Impact ranking**: Prioritizing findings by their effect on revenue, engagement, and operational health — ensures the team focuses on what matters
- **Pattern vs. noise**: Agent analyses can surface many findings; distinguishing meaningful patterns from expected variation is the key skill

## Output Format

```
## AI Agent Insights Brief — <date range>
Analyses reviewed: N agent results + N feedback insight reports
New findings: N | Ongoing: N | Resolved: N

### URGENT — Respond Today
<finding with impact estimate and recommended action>

### HIGH PRIORITY — Address This Sprint
<findings ranked by impact>

### Connected Insights
Pattern: <name>
  - Related findings: [list]
  - Root cause hypothesis: <hypothesis>
  - Business impact: <impact>
  - Recommended owner: <team>

### Weekly Trend Highlights
- Improving: <metrics trending in the right direction>
- Declining: <metrics trending wrong>
- Stable: <key metrics holding steady>

### Team Action Items
Engineering: <list>
Product: <list>
Design: <list>

### Next Review
Recommended: <date/time based on urgency of current findings>
```
