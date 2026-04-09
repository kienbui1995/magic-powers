---
name: analyze-dashboard
description: Synthesize an Amplitude dashboard into executive narrative with key findings, trends, and risks. Uses mcp__Amplitude__get_dashboard, mcp__Amplitude__query_charts.
---

# Analyze Amplitude Dashboard

## When to Use

- A stakeholder asks for a summary of what a dashboard is showing
- You need to prepare talking points for a weekly or monthly business review
- An executive wants a written briefing instead of raw charts
- You need to synthesize multiple metrics into a single coherent story
- Identifying the most important signal across a dashboard with many charts

## Core Jobs

### 1. Load All Charts
Call `mcp__Amplitude__get_dashboard` to retrieve the dashboard configuration and chart list. Then use `mcp__Amplitude__query_charts` to fetch current data for all charts. Do not analyze charts individually in isolation — the goal is synthesis across the entire dashboard.

Note: query all charts before drawing conclusions. A metric that looks alarming in isolation may be explained by another chart on the same dashboard.

### 2. Identify the Story Across Metrics
Look for the narrative thread connecting the charts:

- What is the overall health signal? (Positive momentum, stable, declining, or mixed)
- Are the leading indicators consistent with the lagging indicators?
- If the North Star metric is up, are the supporting metrics aligned?
- If the North Star is flat or down, which upstream metrics explain it?
- Are there contradictions across charts that need investigation?

The story is not a list of what each chart shows. It is the meaning that emerges when the charts are read together.

### 3. Surface Top 3-5 Findings Ranked by Business Impact
Select the most important findings across the entire dashboard. Rank by business impact:

- **Impact tier 1**: Changes that affect revenue, retention, or growth rate directly
- **Impact tier 2**: Changes that affect leading indicators of revenue or retention (activation rate, feature adoption, engagement depth)
- **Impact tier 3**: Changes in operational metrics that may explain tier 1 or 2 findings

For each finding, provide: the specific metric, the direction and magnitude of change, the time window, and why it matters to the business.

### 4. Highlight Anomalies and Explain Context
Flag any metric that deviates unexpectedly from its trend. For each anomaly:

- Describe what is unusual (not just "it dropped" — by how much, compared to what baseline)
- Offer the most likely explanation based on what other charts show
- Flag whether the anomaly is confirmed or requires further investigation
- Note if it could be a tracking artifact (incomplete day, instrumentation break)

### 5. Correlate with User Feedback if Available
If the dashboard includes qualitative signals (NPS, CSAT, support ticket volume), correlate them with the quantitative metrics:

- Are users reporting friction in areas where quantitative metrics also show drop-off?
- Are there positive qualitative signals that explain quantitative growth?
- Contradictions between qualitative and quantitative signals often reveal the most interesting insights

### 6. Provide Specific Recommendations
Conclude with 2-4 concrete recommended actions. Each recommendation should:

- Be directly tied to a specific finding from the dashboard
- Name the team or person who should act on it
- Specify a timeline (this sprint, this week, this month)
- Have a clear success metric — how will you know if the recommendation worked?

## MCP Tools

- `mcp__Amplitude__get_dashboard` — load dashboard structure and chart list
- `mcp__Amplitude__query_charts` — fetch current data for all charts in the dashboard
- `mcp__Amplitude__render_chart` — visual rendering of individual charts for pattern recognition
- `mcp__Amplitude__get_feedback_insights` — correlate quantitative signals with user feedback (if available)

## Key Concepts

- **Narrative synthesis**: Translating a collection of charts into a single coherent story with a beginning (context), middle (findings), and end (recommendations).
- **Leading indicator**: A metric that changes before the outcome metric (e.g., activation rate predicts retention).
- **Lagging indicator**: A metric that reflects past performance (e.g., monthly revenue reflects decisions made weeks ago).
- **Business impact ranking**: Prioritizing findings by their consequence for revenue, retention, or growth — not by the size of the percentage change.
- **Anomaly context**: An anomaly is only meaningful when compared to a baseline. Always state both the deviation and the baseline.
- **Contradictions**: When two metrics tell opposite stories, that contradiction is often the most important finding.

## Output Format

Output is written in narrative paragraphs readable by executives — not labeled database fields or bullet dumps.

Structure:
1. **Opening** (1-2 sentences): The single most important thing the dashboard shows right now.
2. **Overall health** (1 paragraph): The big-picture read on the product area — momentum direction, key drivers.
3. **Key findings** (3-5 findings, each 2-3 sentences): Specific metrics with numbers, direction, magnitude, and business significance.
4. **Risks and anomalies** (1 paragraph): What to watch — deviations that need attention or investigation.
5. **What's working** (1 paragraph): Positive signals worth amplifying or doubling down on.
6. **Recommendations** (2-4 bullet points): Concrete next actions, each tied to a specific finding.

Every factual claim must include a specific number. No vague language ("metrics look good," "some improvement").
