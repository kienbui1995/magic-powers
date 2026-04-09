---
name: create-dashboard
description: Build Amplitude dashboards from requirements by discovering existing charts and organizing them into logical sections. Uses mcp__Amplitude__create_dashboard, mcp__Amplitude__get_charts, mcp__Amplitude__query_charts.
---

# Create Amplitude Dashboard

## When to Use

- A team needs a shared view of key metrics for a product area or initiative
- A new product launch requires an instrumentation dashboard for monitoring
- An existing dashboard is missing key charts and needs to be extended
- Weekly/monthly reporting requires a structured, shareable layout
- Onboarding a new stakeholder who needs a single place to understand product health

## Core Jobs

### 1. Understand Dashboard Purpose and Audience
Before building, clarify:

- **Who will use this dashboard?** (executive, PM, engineer, growth, marketing) — this determines the level of detail and the choice of metrics
- **What decisions will this dashboard inform?** — build only charts that drive decisions; remove decorative metrics
- **What is the primary time window?** (daily monitoring vs weekly review vs monthly reporting)
- **What is the North Star metric?** — every dashboard should have one primary metric that the others support
- **Is there an existing dashboard to extend or replace?**

### 2. Discover Existing Relevant Charts
Use `mcp__Amplitude__get_charts` to search broadly for existing charts before creating anything new. Search by:

- Product area name (e.g., "checkout", "onboarding", "notifications")
- Metric name (e.g., "DAU", "conversion", "retention")
- Event name (e.g., "purchase_completed", "signup")

For each relevant chart found, query it with `mcp__Amplitude__query_charts` to confirm it contains current, meaningful data. Prioritize reusing existing charts — they have proven definitions and are already trusted by the team.

Key principle: **never create a chart if an equivalent one already exists.** Only create new charts to fill genuine gaps.

### 3. Plan Dashboard Structure with Logical Sections
Organize charts into sections that tell a coherent story. Common section patterns:

- **North Star**: the single most important metric for the product area (1-2 charts)
- **Acquisition funnel**: how users enter and progress through key steps (funnel chart + segment breakdown)
- **Engagement**: depth and frequency of usage (retention, DAU/WAU/MAU, feature usage)
- **Health and quality**: errors, latency, support tickets, churn signals
- **Experiments**: active A/B tests and their results (if applicable)

Sequence sections from most strategic (top) to most operational (bottom). Executives read the top; engineers read the bottom.

### 4. Build and Organize
Call `mcp__Amplitude__create_dashboard` with:

- Dashboard name that clearly identifies the product area and audience
- Description explaining the dashboard's purpose
- Ordered list of chart IDs, grouped by section
- Layout configuration that gives more visual weight to North Star charts

For charts that need to be created (gaps identified in step 2), use the `create-chart` skill first, then add the resulting chart IDs to the dashboard.

### 5. Optimize Layout
After initial creation:

- Verify the top section loads with the most important metrics visible without scrolling
- Confirm chart titles are self-explanatory without requiring context (avoid abbreviations)
- Add text blocks between sections to explain what each section covers and why it matters
- Share the dashboard URL with the requester and confirm it meets their needs

## MCP Tools

- `mcp__Amplitude__get_charts` — search for existing charts to reuse (call broadly, multiple searches)
- `mcp__Amplitude__query_charts` — validate that discovered charts contain current data
- `mcp__Amplitude__create_dashboard` — build the dashboard with organized chart layout
- `mcp__Amplitude__get_context` — get projectId and organization context (always call first)
- `mcp__Amplitude__get_dashboard` — load an existing dashboard to understand its structure before extending

## Key Concepts

- **North Star metric**: The single most important metric that captures the core value the product delivers to users.
- **Chart reuse**: Prefer existing charts over new ones — they have established definitions and team trust.
- **Dashboard section**: A logical grouping of related charts within a dashboard, typically labeled by theme.
- **Layout weight**: Important charts should be displayed larger (full-width) than supporting charts.
- **Decision-driven design**: Every chart on a dashboard should exist because it informs a specific decision.
- **Audience calibration**: Executive dashboards emphasize outcomes (revenue, retention); engineering dashboards emphasize signals (errors, latency, event volume).

## Output Format

The output includes:
1. A brief statement of the dashboard's purpose and intended audience
2. A list of sections with which charts are included in each, distinguishing between existing charts (reused) and new charts (created)
3. The dashboard URL in Amplitude
4. Any gaps that could not be filled because relevant events were not instrumented
5. Recommended next steps (e.g., add experiment results chart once the test launches, connect to a weekly email digest)
