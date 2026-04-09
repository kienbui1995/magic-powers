---
name: analyze-feedback
description: Synthesize customer feedback into themes, pain points, and prioritized product roadmap recommendations. Uses mcp__Amplitude__get_feedback_insights, mcp__Amplitude__get_feedback_comments, mcp__Amplitude__get_feedback_trends.
---

# Analyze Customer Feedback

## When to Use

- Quarterly planning requires a user-grounded view of product priorities
- An NPS survey has concluded and leadership wants to understand what drove the scores
- Support ticket volume has increased and you need to understand the root causes
- A product team wants to validate quantitative analytics findings with qualitative evidence
- A new feature launched and you want to understand user reception beyond adoption metrics
- Building a business case for a product investment and need quantified evidence of user pain

## Core Jobs

### Step 1: Collect Feedback Across Sources
Use `mcp__Amplitude__get_feedback_insights` to surface high-level themes across all connected feedback sources. Then use `mcp__Amplitude__get_feedback_comments` to access the raw feedback text.

Feedback sources to include:
- **In-app surveys**: NPS follow-ups, CSAT prompts, feature-specific surveys
- **Support tickets**: categorized by topic from your support tool
- **Sales feedback**: customer objections and "reasons why not" from CRM
- **Review sites**: G2, Capterra, App Store reviews (if connected)
- **User research**: open-ended interview notes (if uploaded to Amplitude)

For each source, note: the volume of feedback in the time window, the source type, and any known biases (support tickets skew negative; NPS promoters may over-represent happy users).

Use `mcp__Amplitude__get_feedback_trends` to understand how feedback themes have changed over time — is a pain point growing or shrinking?

### Step 2: Theme Identification
Group feedback into 5-8 themes maximum. More themes dilute prioritization; fewer themes lose nuance.

Theme identification process:
1. Read 20-30 verbatim comments to build initial intuition
2. Draft candidate themes based on recurring topics
3. Assign each remaining comment to the best-fit theme
4. Merge themes with fewer than 3 comments
5. Refine theme names to be specific and actionable (not "UX issues" — instead "Slow load time on mobile dashboard")

Good theme names are:
- Specific enough to inform a product decision
- Neutral (do not pre-judge whether the theme is a feature request, bug, or praise)
- Representative of multiple user voices, not one loud customer

### Step 3: Pain Point vs Feature Request vs Praise Classification
For each theme, classify its nature:

- **Pain point**: something that currently doesn't work well, causes frustration, or blocks a user workflow. These represent reactive fixes.
- **Feature request**: something users want that doesn't exist yet. These represent investment decisions.
- **Praise**: something working well that users explicitly value. These should be protected from being changed or removed accidentally.

Note: a single theme can contain all three types. "Reporting" might have pain points (export is slow), feature requests (more chart types), and praise (the metrics are exactly what we need).

### Step 4: Frequency × Severity Scoring
Score each theme on two dimensions:

- **Frequency** (1-10): how many distinct users mentioned this theme? Normalize by the total feedback volume. More mentions = higher frequency score.
- **Severity** (1-10): how severely does this affect user workflows? Use these anchors:
  - 1-3: Mild annoyance, workaround exists
  - 4-6: Meaningful friction, impacts productivity
  - 7-9: Blocks core workflow or causes data loss/errors
  - 10: Forces user to find alternative product

**Priority Score = Frequency × Severity** (max 100). Rank all themes by priority score.

For each theme, include a verbatim quote that best captures the essence of the pain or request. Select quotes that are specific, vivid, and representative — not the most extreme.

### Step 5: Prioritized Recommendations Aligned to Business Goals
Translate the ranked themes into concrete product recommendations. For each of the top 3-5 themes:

- State the theme and its priority score
- Provide 2-3 representative verbatim quotes
- Name the recommended action: bug fix, UX improvement, new feature, documentation update, or "no action" (with rationale)
- Align to the business goal impacted: activation, retention, expansion, NPS/CSAT, support cost reduction
- Estimate the user population affected: what % of the user base submitted feedback in this theme?
- Recommend the team or squad who should own the work

For themes where the recommendation is "no action," explain why (low severity despite high frequency, out of scope for the product's vision, better addressed by documentation or education).

## MCP Tools

- `mcp__Amplitude__get_feedback_insights` — surface aggregate themes across all feedback sources
- `mcp__Amplitude__get_feedback_comments` — access raw verbatim feedback text
- `mcp__Amplitude__get_feedback_trends` — track how feedback themes change over time
- `mcp__Amplitude__get_feedback_sources` — understand which feedback channels are connected
- `mcp__Amplitude__get_feedback_mentions` — find mentions of specific features or product areas
- `mcp__Amplitude__get_context` — get projectId and organization context (always first)

## Key Concepts

- **Theme**: A named, recurring pattern in feedback that represents a coherent user need, pain, or experience.
- **Verbatim**: Direct, unedited user language. Verbatim quotes are more persuasive than paraphrases and preserve the user's emotional tone.
- **Frequency × Severity**: The prioritization formula for feedback themes. A high-frequency, low-severity theme (many users mildly annoyed) may rank lower than a low-frequency, high-severity theme (few users completely blocked).
- **Survivorship bias**: Feedback from users who stayed may not represent users who churned. Look for churned user feedback separately if available.
- **Source bias**: Different feedback sources attract different types of feedback. Support tickets skew negative. NPS promoters tend to give positive qualitative feedback. Weight accordingly.
- **Feedback loop**: The cycle of collecting feedback, acting on it, and communicating the action back to users. Closing the loop builds trust and increases future feedback quality.
- **Signal-to-noise ratio**: Much feedback is repetitive or low-information. The goal of analysis is to extract the high-signal themes from the noise.

## Output Format

The output is a feedback analysis report structured for product leadership and roadmap planning.

Structure:
1. **Feedback summary** (2-3 sentences): total feedback volume, time window, sources included, key limitations or biases.
2. **Theme overview** (table):

| Theme | Type | Frequency | Severity | Priority Score |
|-------|------|-----------|----------|----------------|
| Slow dashboard load on mobile | Pain point | 8/10 | 7/10 | 56 |
| Request: CSV export | Feature request | 6/10 | 5/10 | 30 |
| Praise: onboarding flow | Praise | 5/10 | — | — |

3. **Top theme deep-dives** (3-5 themes): 1-2 paragraphs each with verbatim quotes, frequency/severity rationale, and recommended action.
4. **What to protect** (1 paragraph): the praise themes — what users explicitly value that must not be degraded.
5. **Prioritized recommendations** (numbered list): specific actions ranked by priority score, each tied to a business goal and a recommended owner.
6. **Trends note** (1-2 sentences): are any themes growing or shrinking in volume? A growing pain point is more urgent than a stable one.
