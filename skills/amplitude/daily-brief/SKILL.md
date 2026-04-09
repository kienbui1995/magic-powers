---
name: daily-brief
description: Morning analytics briefing covering the last 1-2 days — surfaces anomalies, trends, risks, and wins. Uses mcp__Amplitude__query_amplitude_data, mcp__Amplitude__get_charts, mcp__Amplitude__get_context.
---

# Daily Analytics Brief

## When to Use

- A team member asks "what happened yesterday?" or "how are we doing today?"
- You need to prepare a morning standup update for a product or growth team
- An executive wants a quick pulse check before starting their day
- Monitoring a product launch or major feature rollout in real-time
- Providing a daily briefing to a stakeholder who doesn't have time to read dashboards

## Core Jobs

### Phase 1: Understand User Role and Context
Before gathering any data, understand who is receiving the brief:

- **Executive** (CEO, CPO, CRO): focus on North Star, revenue, and risk signals; minimize technical detail
- **Product Manager**: focus on feature-level metrics, activation, and user behavior patterns
- **Growth**: focus on acquisition, activation, conversion, and funnel metrics
- **Engineer**: focus on event volume, error rates, and performance signals
- **Analyst**: full data, including methodology and confidence notes

Also establish: what product area or team does this brief cover? What are the 3-5 metrics that matter most to this person?

### Phase 2: Gather Focused Data for Today and Yesterday
Use `mcp__Amplitude__query_amplitude_data` and `mcp__Amplitude__get_charts` to pull data.

**Critical time scope rule**: The brief is about TODAY and YESTERDAY. The 7-day window is used only as a comparison baseline to establish what "normal" looks like — it is not the subject of the brief.

Gather:
- Primary metrics: today so far vs yesterday vs same day last week
- Funnel performance: conversion rates at each key step
- Acquisition: new users / signups for the period
- Engagement: DAU, session depth, feature usage
- Any real-time alerts or anomalies from existing charts

Use `mcp__Amplitude__get_context` to confirm projectId before all queries.

### Phase 3: Validate Findings — Check for False Positives
Before reporting any finding, apply these validation checks:

1. **Incomplete-day artifact**: Today's numbers are always lower because the day is not over. Do not report "DAU dropped 40%" if it is 9 AM. Either use yesterday's completed day or provide context ("today so far").
2. **Day-of-week effect**: Mondays and Sundays have lower engagement for most B2B and consumer apps. A Monday drop vs Friday is often normal.
3. **Tracking breaks**: If event volume itself dropped (not just the derived metric), suspect a logging issue before a behavior change.
4. **Sample size**: A 50% change on 20 users is noise. Flag findings with small absolute numbers as low-confidence.

Apply a confidence score to each finding: **High** (>0.8), **Medium** (0.6-0.8), **Low** (<0.6). Only report findings with confidence >0.6.

### Phase 4: Investigate Root Causes for 2-3 Most Significant Findings
For the top 2-3 findings that pass validation, go one level deeper:

- Segment by platform, user type, geography, or cohort to find where the signal is concentrated
- Check if the finding is broad (affecting all users) or narrow (specific segment)
- Look for correlated events that might explain the pattern
- Note if any experiment, release, or campaign launched recently that could be the cause

### Phase 5: Structure with Required Sections
The brief must have these sections in order:

1. **Opening hook** (1 sentence): The single most important finding from the past day. Make it concrete — a number, a direction, a named feature or metric.
2. **Today so far** (2-3 sentences): Real-time pulse. What are the key metrics showing as of now? Include comparison to same time yesterday.
3. **Key findings** (3-6 findings maximum): Each finding is 2-3 sentences. State the metric, the change, the magnitude, and the likely cause. Lead with the most impactful.
4. **What's working** (1-2 sentences): One positive signal worth acknowledging. Teams need wins as much as risks.
5. **Today's priorities** (numbered list of 2-3 concrete actions): Each action should name a team or owner and tie back to a specific finding. Not generic advice.
6. **Follow-on prompt** (1 sentence): Suggest one follow-up analysis the reader can ask for if they want to go deeper on any finding.

### Phase 6: Quality-Check Before Sending
Run through this checklist before finalizing:

- [ ] Every number has a unit and a comparison period
- [ ] No vague language ("metrics look okay," "some improvement")
- [ ] Today's incomplete data is clearly labeled
- [ ] Confidence scores are attached to uncertain findings
- [ ] Actions are specific and tied to named owners or teams
- [ ] Tone is direct and calm — avoid alarm unless truly warranted
- [ ] Length is 400-600 words

## MCP Tools

- `mcp__Amplitude__get_context` — get projectId and organization context (always first)
- `mcp__Amplitude__query_amplitude_data` — pull metrics for today and yesterday
- `mcp__Amplitude__get_charts` — find existing monitored charts for key metrics
- `mcp__Amplitude__query_chart` — deep-dive into specific charts for root cause investigation
- `mcp__Amplitude__render_chart` — visual snapshot of anomaly charts

## Key Concepts

- **Incomplete-day artifact**: Today's aggregated count is always lower than a completed day's count. Always label intra-day numbers as "so far."
- **Day-of-week effect**: Weekly seasonality in user behavior (e.g., B2B apps see lower weekend engagement). Check before flagging as anomaly.
- **Confidence score**: A 0-1 estimate of how certain a finding is, based on sample size, data quality, and cross-validation.
- **Comparison baseline**: The 7-day trailing average used to define "normal" for anomaly detection.
- **Signal vs noise**: Only findings with confidence >0.6 and clear business implication belong in the brief.
- **Tracking break**: A drop in raw event volume (not just the derived metric) suggests an instrumentation bug, not a behavior change.

## Output Format

The brief reads like a team email from a sharp analyst — confident, specific, actionable. Not a database export.

Target length: 400-600 words. Write in prose paragraphs for the findings; use a numbered list only for today's priorities. No raw JSON, no field names, no table of every metric.

Tone: calm authority. Only use words like "concern" or "risk" when the data warrants it. Lead with the most important finding, not with context-setting.
