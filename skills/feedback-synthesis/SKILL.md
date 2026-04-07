---
name: feedback-synthesis
description: Use when processing user interviews, support tickets, NPS comments, or survey responses into actionable insights
---

# Feedback Synthesis

## When to Use
When you have a collection of user feedback (interviews, surveys, tickets, reviews) and need to extract patterns and priorities.

## Core Jobs

### 1. Collect and Tag
Sources: interviews, support tickets, NPS verbatims, app reviews, sales calls, Twitter/Reddit
Tag each piece of feedback with:
- **Theme**: what topic (onboarding, performance, pricing, missing feature)
- **Sentiment**: positive / negative / neutral
- **Frequency**: how many users mention this
- **Severity**: blocking (can't use product) / frustrating / nice-to-have

### 2. Find Patterns
Group by theme, then look for:
- High frequency + high severity = fix now
- High frequency + low severity = backlog
- Low frequency + high severity = investigate (might be a segment)
- Low frequency + low severity = ignore for now

### 3. Write the Insight
Format: "Users [doing X] struggle with [specific pain] because [root cause]. Evidence: [N] mentions across [sources]."
Not: "Users want a better UI." (too vague)
Yes: "New users abandon onboarding at step 3 because the API key setup is unclear. 14 support tickets, 3 interview mentions."

### 4. Prioritize Actions
Map insights to roadmap items. Each insight should connect to:
- A specific user segment
- A measurable outcome if fixed
- An estimated effort (rough)

## Key Outputs
- Tagged feedback database
- Theme frequency/severity matrix
- Top 5 actionable insights (with evidence)
- Roadmap input recommendations

## Anti-Patterns
- Treating loudest feedback as most important (volume ≠ priority)
- Synthesizing without reading primary sources
- Reporting "what users said" without "what it means"
- Skipping the root cause — solving symptoms, not problems
