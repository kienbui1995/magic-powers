---
name: analyze-ai-topics
description: Analyze user inquiries to AI agents, identify topic coverage gaps, and prioritize improvements. Uses mcp__Amplitude__query_amplitude_data, mcp__Amplitude__get_feedback_insights, mcp__Amplitude__get_feedback_mentions.
---

# Analyze AI Topics

## When to Use

- Your product has an LLM-powered assistant, chatbot, or AI agent that users interact with
- AI response quality seems inconsistent and you need to understand why
- Planning what to add to the AI's system prompt or knowledge base — need evidence-based prioritization
- Monthly AI product review: what topics are users actually asking about?
- After launching a new AI feature: is it being used as intended? What unexpected use cases emerged?
- When user satisfaction scores for the AI are declining — need to diagnose which topic types are failing

## Core Jobs

### 1. Pull AI Interaction Events for Target Period

Query AI interaction event data for the analysis window:

```
mcp__Amplitude__query_amplitude_data:
  events: [ai_message_sent, ai_session_started, ai_response_received, ai_feedback_submitted]
  time_range: last 30 days
  metrics: [session_count, unique_users, avg_messages_per_session]
```

Also query:
```
mcp__Amplitude__get_feedback_insights:
  filter: source = ai_assistant
  time_range: last 30 days
```

**Baseline metrics to establish:**
- Total AI sessions in period
- Total unique users interacting with AI
- Average session length (messages per session)
- Overall satisfaction rating (thumbs up/down, star rating, or CSAT)

### 2. Extract User Intents / Questions

From the AI interaction events, extract what users are actually asking:

**Sources of intent data:**
- User message text (if stored as an event property: `user_message`, `query`, `prompt`)
- `mcp__Amplitude__get_feedback_mentions` — user feedback that names specific topics
- Session replay events showing the AI conversation flow
- Conversation tags if your system categorizes them

**Intent extraction approach:**
If raw message text is available:
- Group semantically similar messages (same intent, different wording)
- Look for question patterns: "how do I...", "can you help me...", "what is...", "why does..."
- Identify commands: "summarize", "create", "update", "find", "explain"

If only categorized events are available:
- Use event properties like `intent_category`, `topic`, `workflow` if they exist
- Fall back to feedback categories from `get_feedback_insights`

### 3. Cluster into Topics (5-15 Topic Clusters)

Organize extracted intents into meaningful topic clusters:

**Target: 5-15 clusters** — too few loses precision, too many loses actionability.

**Example cluster output:**
```
Topic Clusters (from 2,847 AI sessions):

1. Account & Billing (18% of sessions)
   - How to upgrade/downgrade plan
   - Invoice and payment questions
   - Password reset and account access

2. Feature How-To (31% of sessions)
   - How to use specific product features
   - Step-by-step task guidance
   - Setting configuration help

3. Data & Reporting (22% of sessions)
   - Generate reports / export data
   - Interpret dashboard metrics
   - Data integration questions

4. Troubleshooting (14% of sessions)
   - Error messages and what they mean
   - Feature not working as expected
   - Performance issues

5. General Product Questions (9% of sessions)
   - What can this product do?
   - Comparison to alternatives
   - Roadmap and feature requests

6. Off-Topic / Out of Scope (6% of sessions)
   - General knowledge questions
   - Requests outside product scope
```

### 4. Score Each Topic: Volume, Success Rate, Satisfaction, Deflection

For each topic cluster, calculate 4 key metrics:

**Volume**: Sessions in this topic / total sessions (already done above)

**Success rate**: Sessions where user achieved their goal / sessions in this topic
```
Proxies for success (in order of reliability):
  - User explicitly rated response positively
  - Session ended without escalation to human
  - User executed the action after getting AI guidance (e.g., navigated to the feature, completed the task)
  - Session length was short with positive feedback (got answer quickly)

Proxies for failure:
  - User rephrased question 3+ times (AI didn't understand)
  - User requested human agent
  - Session ended with negative rating
  - User abandoned without completing intended action
```

**User satisfaction**: Average rating for this topic (if ratings are captured)

**Deflection rate**: Percentage of sessions that didn't escalate to human support
```
High deflection = AI handled it successfully (good)
Low deflection = AI failed, users needed human help (bad)
```

### 5. Identify Coverage Gaps

Coverage gaps = topics with **high volume but low success rate**:

```
Coverage Gap Analysis:

HIGH PRIORITY GAPS (high volume + low success):
  Data & Reporting (22% volume, 45% success rate)
  → Users frequently ask about reports, AI rarely helps effectively
  → Gap: AI doesn't know how to generate the custom report types users need

  Troubleshooting (14% volume, 52% success rate)
  → AI can identify problems but often can't resolve them
  → Gap: AI needs access to error code documentation and resolution steps

LOWER PRIORITY (low volume + low success):
  Off-Topic (6% volume, 15% success rate)
  → Users occasionally ask off-topic; AI correctly declines
  → No action needed — low volume, correct behavior

WELL-COVERED (any volume + high success):
  Feature How-To (31% volume, 82% success rate)
  → AI handles this topic well — source of truth for other topic improvements
```

### 6. Identify Over-Served Topics

Over-served = topics with **significant AI investment but low business value**:

Signs of over-serving:
- Topic has high success rate but low user impact (e.g., AI great at answering FAQ that users could google)
- Topic volume is high but users could self-serve without AI (link to help doc would suffice)
- High token cost per session for low-value queries

For over-served topics: consider routing to help docs instead of LLM → reduces cost.

### 7. Recommend Improvements

Based on coverage analysis, provide prioritized recommendations:

**Recommendation categories:**
- **System prompt additions**: what knowledge or instructions to add to the system prompt
- **Routing changes**: which topics to handle differently (escalate, deflect, or route to specific flows)
- **Knowledge base additions**: what documentation or data the AI needs access to
- **UI changes**: where to add better copy/guidance so users don't need to ask the AI

## MCP Tools

- `mcp__Amplitude__query_amplitude_data` — query AI session volume, success metrics, and session-level data by topic
- `mcp__Amplitude__get_feedback_insights` — retrieve aggregated insights from user feedback on AI interactions
- `mcp__Amplitude__get_feedback_mentions` — get specific user feedback mentions to understand what users say about AI quality

## Key Concepts

- **Topic cluster**: A group of semantically related user intents treated as a unit for analysis — the right level of abstraction between individual questions and broad categories
- **Coverage gap**: A topic with high user demand but low AI success rate — the highest-priority improvement opportunity
- **Deflection rate**: Percentage of AI sessions that don't escalate to human support — the primary efficiency metric for AI assistants
- **Success proxy**: A measurable signal (rating, follow-up action, session length) used to infer whether the AI successfully helped the user
- **Over-served topic**: A topic where AI investment exceeds its value — a candidate for routing to cheaper self-serve alternatives

## Output Format

```
## AI Topic Analysis — <time range>

### Volume Summary
Total AI sessions: N
Unique users: N
Avg messages/session: N
Overall satisfaction: X%

### Topic Coverage Map

| Topic | Volume | Success Rate | Satisfaction | Deflection | Status |
|-------|--------|-------------|-------------|-----------|--------|
| Feature How-To | 31% | 82% | 4.2/5 | 91% | Well-covered |
| Data & Reporting | 22% | 45% | 2.8/5 | 58% | COVERAGE GAP |
| Account & Billing | 18% | 74% | 3.9/5 | 83% | Adequate |
| Troubleshooting | 14% | 52% | 3.1/5 | 61% | COVERAGE GAP |
| General Questions | 9% | 68% | 3.6/5 | 79% | Adequate |
| Off-Topic | 6% | 15% | 2.1/5 | 34% | Expected |

### Coverage Score: 64/100

### Top 5 Improvement Recommendations

1. [HIGH IMPACT] Add error resolution playbooks to knowledge base
   Topic: Troubleshooting | Potential success rate lift: +25%

2. [HIGH IMPACT] Add custom report generation guide to system prompt
   Topic: Data & Reporting | Potential success rate lift: +20%

3. [MEDIUM] Route "how to reset password" to direct link (over-served, self-serve candidate)

4. [MEDIUM] Add plan comparison table to AI context for billing questions

5. [LOW] Add "I can't help with that, here's a resource" for off-topic deflection
```
