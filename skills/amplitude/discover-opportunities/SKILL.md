---
name: discover-opportunities
description: Cross-reference analytics, experiments, session replays, and feedback to surface highest-impact product improvements. Uses mcp__Amplitude__query_amplitude_data, mcp__Amplitude__get_session_replays, mcp__Amplitude__get_feedback_insights.
---

# Discover Product Opportunities

## When to Use

- Quarterly planning requires a data-driven list of the highest-impact improvements to prioritize
- A team is struggling to identify what to build next and needs evidence-based direction
- A product area has plateaued and you need to find what is blocking growth
- Post-launch retrospective: understanding why a feature underperformed
- You want to build a roadmap grounded in multiple data sources, not just intuition or loudest-voice

## Core Jobs

### Phase 1: Set Scope
Before pulling any data, establish clear boundaries for the discovery:

- **Product area**: which feature set, user flow, or part of the product are we investigating?
- **User segment**: all users, new users, power users, churned users, paid users, specific plan tier?
- **Time window**: last 30 days, last quarter, since a specific launch?
- **Exclusions**: are there any known issues (outages, tracking bugs) to exclude from the window?

The tighter the scope, the more actionable the output. Discovery across "the entire product" produces generic recommendations.

### Phase 2: Quantitative Signals — Find Where Users Struggle
Use `mcp__Amplitude__query_amplitude_data` to identify where users drop off, disengage, or fail to return.

Quantitative signals to investigate:

- **Funnel drop-off points**: which step in the key user flow has the highest abandonment rate? A step with >30% drop-off in an otherwise healthy funnel is a strong opportunity signal.
- **Low-engagement features**: features that exist but show very low usage rates (bottom 20% of feature adoption). Low adoption may indicate discovery problems, friction, or poor fit.
- **High-churn indicators**: events or sequences of events that precede churn (users who did X were 3x more likely to churn within 14 days).
- **Activation gaps**: users who signed up but never reached the activation moment — what did their journey look like?
- **Frequency decay**: users who were highly engaged in week 1 but their usage declined in weeks 2-4 — what changed?

For each signal, quantify the scope: how many users are affected, what percentage of total users, what is the revenue or retention impact if this is fixed?

### Phase 3: Qualitative Signals — Understand Why
Use `mcp__Amplitude__get_session_replays` to watch recordings of users who exhibit the patterns found in Phase 2. Focus on:

- Users who dropped off at the top funnel drop-off point: what specifically caused the abandon? Confusion, missing information, an error, or distraction?
- Users who never used a low-adoption feature: did they navigate near it and not click? Or did they never encounter it?
- Users who churned: what was their last session like? What did they try that didn't work?

Watch 5-10 sessions per behavioral pattern. You are looking for the recurring theme — the one thing that appears in 3+ sessions. One session is an outlier; three sessions is a pattern.

Use `mcp__Amplitude__get_feedback_insights` to surface themes from user feedback (in-app surveys, NPS comments, support tickets). Cross-reference feedback themes with the quantitative drop-off points: when both sources point to the same problem, confidence is high.

### Phase 4: Experiment Learnings — What Has Already Been Tried
Before recommending a solution, review what has already been tested. Use `mcp__Amplitude__get_experiments` (via `analyze-experiment` skill if needed) to understand:

- Which improvements have already been tested and shown no effect?
- Which experiments showed partial positive results but were abandoned — is there a learning to build on?
- Are there any experiments currently running that should be concluded before starting new work in this area?

Avoid recommending solutions that have already been disproven by experiment data. This is critical context that prevents wasted investment.

### Phase 5: Synthesize into Ranked Opportunities
For each opportunity identified, score it using the ICE framework:

**ICE Score = Impact × Confidence × Ease** (each scored 1-10)

- **Impact**: If this is fixed, how much does it move the key metric? (1 = marginal, 10 = 2x the metric)
- **Confidence**: How certain are we the opportunity is real, based on evidence quality? Multiple converging data sources = high confidence.
- **Ease**: How easy is this to implement? (1 = major engineering effort, 10 = copy change or minor UI tweak)

ICE Score = I × C × E (max 1000). Rank all opportunities by ICE score.

For each opportunity in the ranked list, write an opportunity brief:

```
Opportunity: [Name]
Evidence: [Quantitative signal + qualitative signal + experiment learning]
ICE Score: [I=X, C=X, E=X, Total=XXX]
Hypothesis: If we [do X], then [metric Y] will improve by [Z%] because [reason].
Suggested next step: [Build prototype / Run experiment / Fix bug / User interview]
```

## MCP Tools

- `mcp__Amplitude__query_amplitude_data` — pull funnel drop-off, feature usage, churn signals
- `mcp__Amplitude__get_session_replays` — find and review session recordings of struggling users
- `mcp__Amplitude__get_feedback_insights` — surface themes from user feedback
- `mcp__Amplitude__get_experiments` — review what has already been tested in the product area
- `mcp__Amplitude__get_context` — get projectId and organization context (always first)
- `mcp__Amplitude__get_feedback_comments` — access specific feedback verbatim quotes for evidence

## Key Concepts

- **ICE score**: A prioritization framework: Impact × Confidence × Ease. Each dimension scored 1-10; multiply for total. Higher ICE = higher priority.
- **Funnel drop-off**: The percentage of users who start a step in a flow but do not complete it. High drop-off is a quantitative signal of friction.
- **Feature adoption rate**: The percentage of users who have ever used a feature at least once. Low adoption indicates discovery, friction, or fit problems.
- **Triangulation**: Using multiple independent data sources (quantitative + qualitative + experiment) to confirm an opportunity. Triangulated opportunities have higher confidence and lower investment risk.
- **Recurring theme**: A pattern that appears across 3+ independent session replays or feedback comments. The threshold for elevating an observation to a finding.
- **Activation gap**: The subset of users who signed up but never completed the activation moment. Often the highest-leverage opportunity in a product.
- **Churn indicator**: An event or behavioral pattern that precedes churn at significantly higher rates than the average user population.

## Output Format

The output is an opportunity brief — a prioritized list of product improvements, each backed by multi-source evidence.

Structure:
1. **Scope summary** (2-3 sentences): product area investigated, user segment, time window, data sources used.
2. **Ranked opportunity list** (5-10 opportunities): each with name, ICE score, evidence summary, and suggested next step. Sorted by ICE score, highest first.
3. **Top 3 deep-dives** (1 paragraph each): for the top 3 opportunities, a richer narrative that includes verbatim user quotes, specific drop-off numbers, and the experiment hypothesis.
4. **What has already been tried** (1 paragraph): summary of past experiments in this area to avoid duplicating failed approaches.
5. **Recommended starting point** (1-2 sentences): the single highest-confidence opportunity to begin with and why.
