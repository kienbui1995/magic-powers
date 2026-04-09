---
name: compare-user-journeys
description: Identify behavioral differences between two user groups combining session replays with quantitative metrics. Uses mcp__Amplitude__get_session_replays, mcp__Amplitude__query_amplitude_data.
---

# Compare User Journeys

## When to Use

- Understanding why some users convert and others don't
- Comparing power users vs casual users to find what drives deep engagement
- Analyzing churned users vs retained users to identify churn predictors
- Comparing onboarding paths for users with high vs low activation rates
- Understanding how behavior differs between user segments (plan tier, geography, acquisition channel)
- Pre-experiment analysis: understanding baseline differences before running a test

## Core Jobs

### Step 1: Define the Two Groups Clearly
Precision in group definition is the foundation of useful comparison. Ambiguous groups produce ambiguous insights.

For each group, specify:
- **Definition**: exactly what behavior or attribute defines membership (e.g., "users who completed checkout within 7 days of signup" vs "users who signed up but never completed checkout")
- **Time window**: the cohort date range (e.g., users who signed up in Q1 2025)
- **Size**: how many users are in each group? Groups with fewer than 50 users may not produce generalizable findings.
- **Overlap**: are the groups mutually exclusive? They should be.

Common useful group pairs:
- Converted vs churned (same acquisition cohort)
- Power users (top 20% by activity) vs casual users (bottom 20%)
- Activated vs non-activated (within first 7 days)
- Paid vs free (same signup cohort)
- High-NPS vs low-NPS users
- Users who discovered feature X vs those who didn't

### Step 2: Pull Quantitative Metrics for Both Groups
Use `mcp__Amplitude__query_amplitude_data` to compute key behavioral metrics for each group. Run parallel queries for Group A and Group B:

- **Session depth**: average number of events per session
- **Feature breadth**: average number of distinct features used per week
- **Return frequency**: how often do they return per week/month?
- **Funnel completion**: what percentage complete each key step?
- **Time to key milestone**: how long (in minutes, hours, or days) does each group take to reach the activation moment?
- **Event sequences**: what are the most common sequences of events in the first session?
- **Drop-off points**: where do users in each group most commonly stop?

Compute for each metric: Group A value, Group B value, absolute difference, relative difference (%). This sets up the side-by-side comparison table.

### Step 3: Find Session Replays for 5-10 Sessions per Group
Use `mcp__Amplitude__get_session_replays` to find recordings for users in each group. Filter by the segment criteria defined in Step 1.

Watch 5-10 sessions per group. For each session, note:
- Entry point (where did the session start?)
- Navigation path (what did they explore?)
- Time spent on key steps
- Confusion signals (rage clicks, repeated back/forward, hesitation before key actions)
- Feature discovery (how did they find key features — navigation, search, tooltip, onboarding?)
- Exit point (where did the session end?)

Do not summarize individual sessions — look for what recurs across sessions. A behavior that appears in 3+ Group A sessions but not in Group B sessions is a meaningful differentiator.

### Step 4: Extract Behavioral Patterns from Replays
After watching replays, synthesize patterns by group:

**Group A patterns** (e.g., converters):
- What do they do in the first 5 minutes that Group B doesn't?
- Which features do they discover early?
- What navigation path do they follow?
- What signals of confusion do they show (or not show)?

**Group B patterns** (e.g., churners):
- Where do they get stuck?
- What do they attempt but fail at?
- What features do they never discover?
- Are there visible moments of frustration?

### Step 5: Identify Key Differences
Synthesize the behavioral differences between the two groups into a ranked list. For each difference:

- Name the behavior
- Quantify it (what % of Group A does X vs % of Group B?)
- Note the source (quantitative data, session replay, or both)
- Assess the business impact: does this difference explain conversion/retention/churn?

The most powerful findings are those confirmed by both quantitative data and session replay evidence.

### Step 6: Quantify the Gap
For the top 3-5 differentiators, compute the gap quantitatively:

- "Group A uses the collaboration feature in 67% of sessions; Group B uses it in 12% of sessions."
- "Group A reaches the 'aha moment' (first successful export) within 8 minutes on average; Group B takes 31 minutes or never reaches it."
- "Group A's first session has 24 events on average; Group B's has 9."

The gap quantification transforms observations into leverage: if you could move Group B toward Group A on metric X, what would the business impact be?

### Step 7: Recommend Behavioral Interventions
Based on the differences identified, recommend specific product changes that could move Group B toward Group A's behavioral patterns:

- For each key difference: what specific product change could close the gap?
- Frame as a testable hypothesis: "If we [add feature discovery prompt for X], then [Group B activation rate] will increase by [Y%] because [Group B currently doesn't find X in the first session]."
- Prioritize recommendations by: (a) size of the gap, (b) feasibility of the intervention, (c) confidence based on evidence strength.

## MCP Tools

- `mcp__Amplitude__get_session_replays` — find and watch session recordings for both user groups
- `mcp__Amplitude__query_amplitude_data` — pull quantitative behavioral metrics for both groups
- `mcp__Amplitude__get_event_properties` — discover user properties for group segmentation
- `mcp__Amplitude__get_context` — get projectId and organization context (always first)
- `mcp__Amplitude__query_chart` — build funnel or retention charts broken down by the two groups

## Key Concepts

- **Behavioral differentiator**: A specific action or pattern that occurs significantly more often in one group than the other.
- **Confirmation triangulation**: A finding is high-confidence when it appears in both quantitative data AND session replays.
- **Aha moment**: The first moment a user experiences the core value of the product. Often the most important behavioral differentiator between activated and non-activated users.
- **Rage click**: Repeated rapid clicking on a UI element, indicating frustration or confusion. A strong signal of friction in session replays.
- **Feature discovery**: How and when users first encounter a feature. Users who discover key features early often have higher retention.
- **Session depth**: The number of meaningful events in a session. Power users typically have higher session depth.
- **Gap quantification**: Computing the specific numerical difference between groups on a behavioral metric. Transforms observation into leverage.

## Output Format

The output combines a comparison table with narrative insights.

Structure:
1. **Group definitions** (2-3 sentences each): precise definition of Group A and Group B, with sizes.
2. **Side-by-side metrics table** (markdown):

| Metric | Group A | Group B | Difference |
|--------|---------|---------|------------|
| Avg session depth (events) | 24 | 9 | Group A 2.7x deeper |
| Feature breadth (features/week) | 6.2 | 1.8 | Group A 3.4x broader |
| Time to aha moment | 8 min | 31 min | Group A 4x faster |
| Week 4 retention | 68% | 12% | +56pp |

3. **Behavioral patterns** (1 paragraph per group): what does each group's typical session look like?
4. **Key differentiators** (ranked list of 3-5): what Group A does that Group B doesn't, with evidence from both quantitative data and session replays.
5. **Recommendations** (numbered list): specific product changes to move Group B toward Group A behavior, each framed as a testable hypothesis.
