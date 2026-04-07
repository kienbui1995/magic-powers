---
name: analytics-reporting
description: Use when building marketing dashboards, attribution models, or reporting on campaign performance
---

# Marketing Analytics & Reporting

## When to Use
When measuring marketing performance, attributing revenue to channels, or building the dashboards stakeholders use to make decisions.

## Core Jobs

### 1. Define Marketing KPIs
Tier 1 (CEO/board cares):
- Pipeline generated (revenue value of leads created)
- Revenue influenced by marketing
- Customer Acquisition Cost (CAC) by channel

Tier 2 (Marketing team cares):
- MQLs (marketing qualified leads) by channel
- SQL conversion rate (MQL → Sales Qualified Lead)
- Campaign ROI (revenue / spend per campaign)

Tier 3 (Channel managers care):
- CPL (cost per lead) by campaign
- Click-through rate, conversion rate
- Email open/click rates

### 2. Attribution Models
How to give credit to touchpoints:
- **Last touch**: 100% credit to last channel before conversion (simple, common, misleading)
- **First touch**: 100% credit to first channel (good for awareness measurement)
- **Linear**: equal credit across all touchpoints
- **Time decay**: more credit to recent touchpoints
- **Data-driven**: ML-based (requires high volume, GA4/Rockerbox)

Recommendation: use multi-touch for strategic decisions, last-touch for channel budgeting.

### 3. Build the Dashboard
Structure:
- Page 1: Executive summary (pipeline, revenue, CAC — this month vs last month vs goal)
- Page 2: Channel breakdown (spend, leads, CPL, CAC per channel)
- Page 3: Campaign performance (individual campaign ROI)
- Page 4: Email metrics (by segment and campaign)

### 4. Reporting Cadence
- Weekly: channel performance vs targets (10-min standup)
- Monthly: full report with insights and recommendations
- Quarterly: attribution review and budget reallocation

## Key Outputs
- Marketing KPI definitions
- Attribution model selection rationale
- Dashboard (with automated data refresh)
- Monthly report template

## Anti-Patterns
- Reporting without comparing to targets or previous period
- Only reporting what went well (cherry-picking)
- Last-touch attribution for multi-channel programs (misleads budget decisions)
- Dashboard no one looks at — ask stakeholders what decisions they need to make
