---
name: investigate-ai-session
description: Deep-dive into a specific AI agent session to identify failure root cause and improvement opportunities. Uses mcp__Amplitude__get_session_replay_events, mcp__Amplitude__query_amplitude_data.
---

# Investigate AI Session

## When to Use

- A specific user complained about an AI response and you need to understand what happened
- QA or an internal reviewer flagged a session as "AI failure" and needs root cause
- A user gave a very low rating (1-star, thumbs down) and you want to know why
- An escalation to human support mentions "the AI couldn't help" — review the AI session first
- Systematic sampling of low-rated sessions for AI quality improvement
- Validating a prompt change: did the AI handle similar queries better after the update?

## Core Jobs

### 1. Retrieve Target Session

Find the session to investigate using one of two paths:

**Path A — Known session ID:**
```
mcp__Amplitude__get_session_replay_events:
  session_id: <provided session ID>
```

**Path B — Find sessions matching failure criteria:**
```
mcp__Amplitude__query_amplitude_data:
  event: ai_session_ended  (or equivalent)
  filters:
    - user_satisfaction_rating < 3  (low rating)
    OR
    - escalated_to_human = true
    OR
    - session_abandoned = true (no completion event)
  time_range: last 7 days
  limit: 20
```

Then select the most representative session from the results — prefer sessions where the failure pattern is clear and the conversation is long enough to diagnose.

### 2. Reconstruct the Conversation

From session events, build a complete conversation timeline:

```
Session ID: sess_abc123
Duration: 4 minutes 32 seconds
User: user_xyz (Pro plan, joined 2024-03-15)
Platform: Web, Chrome 120

Conversation Timeline:
─────────────────────────────────────────────
T+0:00  Session started
T+0:08  [USER] "How do I export my data to CSV?"
T+0:09  [AI] "You can export data from the Reports section.
               Go to Reports > Export > Select CSV format."
T+0:45  [USER] "I don't see an Export option in Reports"
T+0:46  [AI] "The export option may be in the Actions menu at
               the top right of your report."
T+1:23  [USER] "There's no Actions menu either"
T+1:24  [AI] "I apologize for the confusion. You can try
               navigating to Settings > Data Management > Export."
T+2:01  [USER] "That's not right either, that's for integrations"
T+2:02  [AI] "Let me try a different approach. Click the three-dot
               menu next to any report..."
T+3:15  [USER] "This isn't working. Can I talk to a human?"
T+3:16  Escalation to human support triggered
T+3:16  [USER] Low rating submitted: 1/5 stars
─────────────────────────────────────────────
Outcome: FAILURE — escalated to human, low rating
```

### 3. Identify the Failure Point

Locate the exact moment the conversation went wrong:

**Failure point in this example:** T+0:08 — AI gave incorrect navigation instructions on first response.

**Failure progression pattern:**
1. AI provided wrong information
2. User tried to follow instructions, couldn't
3. AI tried different wrong information (hallucinating navigation paths)
4. User lost confidence, escalated

**Common AI failure patterns to recognize:**

| Failure Type | Signals | Example |
|-------------|---------|---------|
| Hallucination | User reports instructions don't exist in UI | AI invented navigation paths that don't exist |
| Topic refusal | AI declines a reasonable request | AI says "I can't help with account changes" when it can |
| Context loss | AI forgets earlier context | Asks for information user already provided |
| Unhelpful hedging | AI gives disclaimer-heavy non-answer | "I'm not sure but maybe try..." without specifics |
| Confusion | AI misunderstands the user's intent | User asks about CSV export, AI explains JSON API |
| Tool failure | AI tool call failed silently | AI said it looked up the answer but returned generic response |

### 4. Analyze Root Cause

Categorize the root cause and be specific:

**Root cause categories:**

**System prompt gap:**
- AI doesn't have the correct information about this feature
- System prompt describes old UI that has since changed
- AI wasn't told it can / cannot do this action

**Knowledge gap:**
- Product knowledge is missing or outdated
- AI was trained on documentation that predates a UI redesign
- New feature launched without updating AI context

**Ambiguous user input:**
- User's question was genuinely ambiguous
- AI could have asked a clarifying question but didn't
- Multiple valid interpretations, AI chose the wrong one

**Routing failure:**
- This query should have been routed differently (to human, to a specific flow, to a help doc)
- AI tried to handle something it shouldn't handle

**Tool failure:**
- AI was supposed to call a tool (search, lookup, action) but failed
- Tool returned an error and AI handled it poorly

**Root cause statement example:**
```
Root cause: System prompt gap + outdated knowledge

Specific: The AI's navigation instructions for "CSV export" reference
the old Reports UI (pre-Nov 2024 redesign). The export feature moved
from Reports > Export to Dashboards > Download in the Nov redesign.
The AI has no knowledge of the new location.
```

### 5. Recommend a Fix

Provide a specific, actionable recommendation:

**Recommendation format — be concrete:**

**System prompt change:**
```diff
- "Users can export data from Reports > Export > CSV format"
+ "Users can export dashboard data by clicking the Download button
+  (↓ icon) in the top right of any Dashboard. For report data,
+  use the three-dot menu (⋯) next to the report title > Export."
```

**Knowledge base addition:**
```
Add to AI knowledge base:
Title: "How to export data (post-Nov 2024 UI)"
Content: [new navigation path with screenshots]
Tag: data-export, csv, download
```

**Routing rule:**
```
If user asks about [export, download, CSV] AND
AI cannot resolve in 2 turns:
  → Route to help article: /docs/export-data
  → Offer: "Would you like me to connect you with our team?"
```

**UI change recommendation:**
```
The export button location is non-obvious (requires finding ↓ icon).
Recommendation: Add "Export" label text next to the download icon,
or add an "Export" option in the main navigation to reduce AI load
on this topic.
```

## MCP Tools

- `mcp__Amplitude__get_session_replay_events` — retrieve the full event timeline for a specific AI session, including user messages, AI responses, tool calls, and outcome events
- `mcp__Amplitude__query_amplitude_data` — find sessions matching failure criteria (low ratings, escalations, abandoned sessions) when a specific session ID is not provided

## Key Concepts

- **Failure point**: The exact exchange in a conversation where the AI's response caused or revealed the failure — usually the first wrong answer
- **Hallucination**: AI generating plausible-sounding but incorrect information — most common in product feature navigation and API details
- **Context loss**: AI failing to maintain awareness of earlier conversation context — often causes the user to repeat themselves
- **Escalation trigger**: The event that causes the user to request human support or abandon the AI session — the hardest failure signal
- **Root cause specificity**: The difference between "AI didn't know" (vague) and "AI had outdated navigation instructions from pre-Nov 2024 redesign" (actionable)

## Output Format

```
## AI Session Investigation

**Session ID:** <ID>
**User:** <user segment, plan>
**Outcome:** FAILURE — <escalated | abandoned | low rating>
**Rating:** <X/5 or thumbs down>
**Duration:** <X minutes>

### Conversation Summary
[3-5 bullet condensed conversation recap]

### Failure Point
Turn X (T+X:XX): "<user message>" → "<AI response>"
The AI [hallucinated navigation / refused topic / lost context / etc.]

### Failure Pattern
<Which of the 6 failure types applies>

### Root Cause
Category: <System prompt gap | Knowledge gap | Ambiguous input | Routing failure | Tool failure>
Specific: <One paragraph explaining exactly what knowledge or instruction was wrong/missing>

### Recommended Fix
Type: <Prompt change | Knowledge addition | Routing rule | UI change>

<Concrete change with before/after if applicable>

### Impact Estimate
- Sessions affected: ~N similar sessions in last 30 days
- Topics affected: <topic cluster this falls into>
- Fix priority: <High | Medium | Low>
```
