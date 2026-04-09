---
name: weekly-brief
description: Weekly analytics briefing synthesizing 7 days of data with week-over-week momentum analysis. Uses mcp__Amplitude__query_amplitude_data, mcp__Amplitude__get_charts.
---

# Weekly Analytics Brief

## When to Use

- Preparing a Monday morning summary of the previous week's performance
- Delivering a weekly stakeholder update that spans multiple metric categories
- Synthesizing a week's worth of experiment results, feature launches, and growth signals
- When a team wants to understand trajectory — are we accelerating or decelerating?
- Building a weekly digest that replaces a recurring meeting

## Core Jobs

### Phase 1: Understand Audience and Scope
Before pulling data, clarify:

- **Who receives this brief?** The audience determines depth and vocabulary (exec vs PM vs growth vs engineering)
- **Which product area or team?** Scope determines which dashboards and charts to query
- **What is the North Star for this week?** There should be one headline metric that anchors the brief
- **Are there specific events from the week to cover?** (releases, campaigns, incidents, experiment launches)

Also establish the comparison period: this week (Mon-Sun) vs last week (Mon-Sun), and vs same week last month/quarter if available.

### Phase 2: Gather 7-Day Data with WoW Comparison
Use `mcp__Amplitude__query_amplitude_data` and `mcp__Amplitude__get_charts` to pull the full 7-day window. Compare week-over-week (WoW) for all key metrics.

Data to gather:
- **North Star**: primary metric for the week, WoW change
- **Growth**: new users, signups, activation rate — WoW
- **Engagement**: DAU, WAU, feature usage depth, session frequency — WoW
- **Retention**: D1, D7, D30 cohort retention for the week's new users (if available)
- **Conversion**: funnel conversion rates at each step — WoW
- **Revenue**: if applicable — MRR, ARR, conversion from trial, expansion

Use `mcp__Amplitude__get_context` to confirm projectId before all queries.

### Phase 3: Analyze Momentum Signals
The weekly brief is about momentum, not just state. For each key metric, assess:

- **Accelerating**: WoW growth rate is increasing (e.g., DAU grew 5% last week, 8% this week)
- **Decelerating**: WoW growth rate is declining (e.g., DAU grew 8% last week, 3% this week)
- **Stable**: consistent growth rate over multiple weeks
- **Reversing**: metric was declining, now growing, or vice versa

Momentum signals are often more important than the raw numbers. A metric that is flat but decelerating is a warning sign even if it hasn't dropped yet.

### Phase 4: Identify Week's Wins and Risks
**Wins**: Metrics that exceeded expectations, experiments that showed positive results, features that drove unexpected engagement. Wins deserve brief attribution — what drove them?

**Risks**: Metrics trending the wrong direction, guardrail metrics showing regression, experiments that need to be stopped, or features showing unexpectedly low adoption.

Distinguish between risks that require immediate action this week and risks to monitor over the coming weeks.

### Phase 5: Strategic Implications
Connect the week's data to longer-term strategy:

- Does this week's performance change any prioritization decisions?
- Are there experiments to ship, iterate, or abandon based on this week's results?
- Are there segments or geographies outperforming that deserve more investment?
- Is there a trend that, if it continues for 4 more weeks, will become a significant problem or opportunity?

### Phase 6: Structure the Brief
Required sections:

1. **Week summary** (2-3 sentences): The headline narrative of the week — what happened, what mattered most. Include the North Star metric with WoW change.
2. **Top metrics WoW** (table format): Key metrics with this week's value, last week's value, WoW % change, and momentum direction (arrow or accelerating/decelerating label).
3. **Key findings** (3-6 findings): Each 2-3 sentences with specific numbers. Lead with highest business impact.
4. **What's working** (1 paragraph): Positive signals and their drivers.
5. **What needs attention** (1 paragraph): Risks and risks-in-progress, with recommended owner.
6. **Next week priorities** (numbered list of 3-5 items): Concrete actions tied to findings. Each item names an owner or team, a specific action, and a success metric.

Target length: 500-700 words.

## MCP Tools

- `mcp__Amplitude__get_context` — get projectId and organization context (always first)
- `mcp__Amplitude__query_amplitude_data` — pull 7-day metrics with WoW comparison
- `mcp__Amplitude__get_charts` — find existing weekly tracking charts
- `mcp__Amplitude__query_charts` — batch query multiple charts for efficiency
- `mcp__Amplitude__query_chart` — deep-dive into specific charts for root cause

## Key Concepts

- **Week-over-week (WoW)**: Comparing the current week's metrics to the same metrics from the previous week. The standard comparison for weekly briefs.
- **Momentum**: The rate of change in a metric's rate of change. Distinguishes between stable growth and accelerating or decelerating growth.
- **Seasonality**: Regular patterns in metrics tied to the calendar (weekends, holidays, end-of-quarter). Always check before flagging WoW changes as anomalies.
- **North Star metric**: The single most important metric for the week's brief. Everything else supports or explains this metric.
- **Guardrail metric**: A metric that must not regress even if the primary metric improves (e.g., you can't improve activation if it increases churn).
- **Attribution**: Understanding what caused a change — which feature, campaign, or experiment drove the result.

## Output Format

The brief is written in prose paragraphs for the narrative sections, with a single metrics table for the WoW comparison. It reads like an analyst's weekly memo to leadership — confident, specific, actionable.

The metrics table uses markdown format:
| Metric | This Week | Last Week | WoW Change | Momentum |
|--------|-----------|-----------|------------|----------|
| DAU    | 52,400    | 48,100    | +8.9%      | Accelerating |

No raw JSON. No field names. No lists of every metric in bullet form. The prose sections synthesize — they do not enumerate.

Tone: professional and direct. Name what is working, name what is not. Avoid hedging language unless confidence is genuinely low.
