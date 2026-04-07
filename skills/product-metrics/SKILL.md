---
name: product-metrics
description: Use when defining KPIs, building dashboards, or measuring whether a feature or product is healthy
---

# Product Metrics

## When to Use
When you need to define what "success" means for a product or feature, and build the measurement system to track it.

## Core Jobs

### 1. Define the North Star Metric
One metric that best captures the value users get:
- Must be actionable (team can influence it)
- Must correlate with business outcomes
- Examples: "weekly active users who complete 3+ tasks", "monthly recurring revenue"
Avoid vanity metrics: total signups, page views, app downloads.

### 2. Build the Metric Tree
North Star → Input Metrics → Leading Indicators
- Acquisition: new users, activation rate, channel mix
- Engagement: DAU/MAU, feature adoption, session depth
- Retention: day-7/30/90 retention, churn rate
- Revenue: ARPU, LTV, conversion rate

### 3. Instrument the Feature
Before launch, define:
- What events to track (user action → event name → properties)
- What the baseline is (current state before change)
- What the target is (expected improvement, with confidence level)
- How long to measure (minimum 2 weeks post-launch for significance)

### 4. Interpret Results
- Check statistical significance before declaring success
- Segment results: by cohort, platform, plan tier
- Look for unintended consequences (metric moved, but another degraded)

## Key Outputs
- North Star metric definition
- Input metric tree
- Instrumentation plan (event schema)
- Post-launch measurement report

## Anti-Patterns
- Measuring too many metrics (pick 3–5 that matter)
- Declaring success after 3 days
- Ignoring segment-level data
- No baseline before launching
