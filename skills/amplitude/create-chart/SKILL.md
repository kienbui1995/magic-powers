---
name: create-chart
description: Build Amplitude charts from natural language descriptions. Uses mcp__Amplitude__get_event_properties, mcp__Amplitude__get_context, mcp__Amplitude__get_charts.
---

# Create Amplitude Chart

## When to Use

- A user describes a metric or question in plain language and wants a chart built
- You need to visualize a KPI, funnel, retention cohort, or user journey
- An existing chart doesn't exist and you need to create one from scratch
- You want to save an ad-hoc analysis so others can revisit and share it
- Building a dashboard and gaps exist in available charts

## Core Jobs

### 1. Get Context
Call `mcp__Amplitude__get_context` to understand the user's organization, active project, and available projects. This returns the projectId (appId) you will need for all subsequent calls. Never guess or hardcode a projectId.

### 2. Decompose the Request into Chart Components
Break the natural language request into structured chart components before touching any tool:

- **Chart type**: what kind of visualization is appropriate (see chart types below)
- **Metric**: what is being measured (count, DAU, conversion rate, p50 latency, etc.)
- **Time range**: last 7 days, last 30 days, custom range
- **Primary event**: the core action being tracked
- **Filters**: conditions that narrow the dataset (platform = iOS, plan = Pro, country = US)
- **Groupings**: dimensions to break the metric down by (by platform, by cohort, by geography)
- **Secondary events**: for funnels and retention — the sequence or return event

### 3. Search Events Broadly First
Use `mcp__Amplitude__get_event_properties` to discover valid event and property names. Search broadly — do not assume exact event names. Try multiple search terms if the first attempt returns no results. Event names are project-specific and must be discovered, never guessed.

### 4. Review All Results
Examine all returned events and properties. Look for naming conventions (snake_case, camelCase, verb-noun patterns). Understand the data model before selecting specific events.

### 5. Select Best Events with Rationale
Choose the most semantically appropriate events for the chart. If multiple candidates exist, select the one most likely to capture the user's intent. Document your selection rationale in the output so the user can validate.

### 6. Find Similar Existing Charts as Reference
Use `mcp__Amplitude__get_charts` to search for existing charts similar to what you are about to build. This serves two purposes: (a) avoid duplicating an existing chart, and (b) use an existing chart's structure as a template to ensure correctness.

### 7. Build the Chart Definition
Construct the chart definition object with all required fields based on the chart type. Use the existing chart structure as reference if found in step 6.

### 8. Query the Dataset
Execute the chart query to fetch real data and validate that the chart produces meaningful results. If the result is empty, revisit your event selection and filters.

### 9. Save the Result
Use the appropriate save tool to persist the chart. Return the chart URL so the user can view and share it.

## Chart Types

- **eventsSegmentation**: Most versatile type. Use for trends over time, KPI tracking, DAU/WAU/MAU, and single-metric analysis. Good default when unsure.
- **funnels**: Multi-step conversion analysis. Measures how many users complete step A then step B (then step C...). Essential for onboarding, checkout, and signup flows.
- **retention**: Cohort return analysis. Measures what percentage of users who did event A on day 0 return to do event B on day N. Use for stickiness and habit formation.
- **dataTableV2**: Tabular breakdown across multiple metrics and dimensions. Use when the user wants to compare many metrics side-by-side in table form.
- **customerJourney**: Path exploration. Shows what users do before and after a key event. Use when exploring unknown drop-off points or discovery patterns.
- **sessions**: Session-level analysis — duration, frequency, depth. Use when the question is about how deeply users engage per visit rather than over time.

## MCP Tools

- `mcp__Amplitude__get_context` — get organization and project context (call first, always)
- `mcp__Amplitude__get_event_properties` — discover valid event and property names for the project
- `mcp__Amplitude__get_charts` — search for existing charts to use as templates or to avoid duplication
- `mcp__Amplitude__query_chart` — execute a chart query to preview data before saving
- `mcp__Amplitude__save_chart_edits` — persist the final chart definition

## Key Concepts

- **projectId / appId**: The numeric identifier for an Amplitude project. Required by all data tools. Get it from `get_context`.
- **eventsSegmentation**: The default chart type for time-series trend analysis.
- **Sample Ratio Mismatch (SRM)**: An imbalance in traffic allocation that can invalidate results.
- **Grouping**: Breaking a metric down by a dimension (e.g., by platform, country, plan).
- **Filter**: Narrowing the dataset to a specific subset before computing the metric.
- **Cohort**: A group of users who share a common attribute or behavior in a defined time window.
- **Event property**: A key-value pair attached to an event at the time it fires (e.g., `plan_type = "pro"`).
- **User property**: A persistent attribute on a user profile that can change over time.

## Output Format

The output includes:
1. A brief explanation of which chart type was chosen and why
2. The events selected and the rationale for each selection
3. Any filters or groupings applied, with reasoning
4. A link to the saved chart in Amplitude
5. A 2-3 sentence interpretation of the data returned — what the chart shows at a high level

If the chart could not be built (e.g., no matching events found), the output explains what was searched, what was found, and what the user should do next (e.g., verify event names with their analytics team).
