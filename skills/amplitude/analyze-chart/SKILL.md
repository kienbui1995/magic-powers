---
name: analyze-chart
description: Deep-dive investigation of Amplitude charts to identify trends, anomalies, and root causes. Uses mcp__Amplitude__query_chart, mcp__Amplitude__render_chart, mcp__Amplitude__get_event_properties.
---

# Analyze Amplitude Chart

## When to Use

- A stakeholder asks "why did this metric drop/spike?"
- You need to understand what is driving a trend in a chart
- A chart shows unexpected behavior and root cause is unknown
- You want to segment a metric to find which user groups are driving a pattern
- Pre-briefing preparation — need to understand the story behind data before presenting
- QA of a chart that may have incorrect filters or event definitions

## Core Jobs

### 1. Pattern Recognition
Load the chart using `mcp__Amplitude__query_chart` (deep-dive, interactive) or `mcp__Amplitude__render_chart` (visual snapshot). Identify the primary patterns:

- **Trend direction**: is the metric rising, falling, or flat over the period?
- **Rate of change**: is the trend accelerating, decelerating, or linear?
- **Magnitude**: how large is the change in absolute and relative terms?
- **Baseline**: where does this metric sit relative to historical norms?

Always extract specific numbers. Avoid vague statements like "the metric went up." Say "DAU increased 23% from 41,200 to 50,700 between March 1 and March 15."

### 2. Anomaly Identification
Scan for deviations from expected behavior:

- **Spikes**: sudden upward deviations (check if coincide with releases, campaigns, or bot traffic)
- **Drops**: sudden downward deviations (check for outages, tracking breaks, platform changes)
- **Plateaus**: metric stops growing when growth was expected
- **Day-of-week effects**: lower weekend numbers are often normal, not anomalies
- **Incomplete day artifacts**: today's number is always lower because the day isn't over

Flag any anomaly with: when it occurred, how large the deviation was, and whether it recovered.

### 3. Segmentation Analysis
Break the metric down by key dimensions to isolate the driver. Apply segmentation systematically:

- **By platform**: iOS vs Android vs Web — is the pattern platform-specific?
- **By user properties**: new vs returning, free vs paid, by geography, by plan type
- **By cohort**: is the change driven by new users acquired recently or long-term users?
- **By feature usage**: users who used feature X vs those who didn't

Use `mcp__Amplitude__get_event_properties` to discover available properties for segmentation. Look for the segment where the pattern is most pronounced — that is where the root cause likely lives.

### 4. Contextual Investigation
Correlate the finding with external context:

- **Product releases**: did a deploy happen near the anomaly date?
- **Experiments**: was an A/B test running that could explain the change?
- **Campaigns**: did a marketing campaign launch or end?
- **External events**: holidays, seasonality, competitor activity
- **Tracking breaks**: did the event volume itself drop (suggesting a logging bug) or did only the metric change?

Ask: "What changed on or just before this date?"

### 5. Hypothesis Formation
Formulate 2-3 specific, falsifiable hypotheses for what is causing the pattern. Rank by likelihood based on evidence. Each hypothesis should be in the form: "I believe X is happening because I see Y in the data, which would be consistent with Z."

### 6. Conclusion with Confidence Level
State your conclusion clearly:

- What the chart shows
- The most likely explanation for the pattern
- Your confidence level: **High** (multiple converging signals), **Medium** (one strong signal), or **Low** (insufficient data, hypotheses only)
- What additional investigation would increase confidence

## MCP Tools

- `mcp__Amplitude__query_chart` — deep-dive into a single chart with interactive data
- `mcp__Amplitude__render_chart` — visual snapshot of a chart for pattern recognition
- `mcp__Amplitude__get_event_properties` — discover dimensions available for segmentation
- `mcp__Amplitude__get_charts` — find related charts for cross-referencing
- `mcp__Amplitude__query_amplitude_data` — run custom queries for additional context

## Key Concepts

- **Anomaly**: A deviation from expected behavior that requires explanation.
- **Segmentation**: Breaking a metric down by a dimension to isolate which group is driving a pattern.
- **Cohort analysis**: Comparing user groups defined by when they first performed an action.
- **Root cause**: The underlying reason a metric changed, as distinct from the surface symptom.
- **Correlation vs causation**: Two metrics moving together does not mean one causes the other. Distinguish carefully.
- **Confidence level**: How certain the analysis is, based on the number and quality of converging signals.
- **Incomplete day artifact**: Today's aggregated number looks lower because not all events have been logged yet. Do not treat this as a drop.

## Output Format

Output is written in narrative paragraphs, not bullet lists. The analysis reads like an analyst memo, not a database dump.

Structure:
1. **What the chart shows** (1 paragraph, specific numbers throughout)
2. **Key finding** (1-2 paragraphs on the most important pattern or anomaly)
3. **Segmentation breakdown** (1 paragraph describing which segment drives the pattern)
4. **Context and hypotheses** (1 paragraph correlating with releases, experiments, or external events)
5. **Conclusion** (1-2 sentences with confidence level and recommended next step)

Every claim must be backed by a specific number from the data. No vague statements.
