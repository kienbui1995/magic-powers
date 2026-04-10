---
name: ai-product-retention
description: Use when designing AI products for long-term retention — stickiness patterns, daily engagement hooks, workflow integration depth, habit loops specific to AI, and measuring whether users actually keep using your AI feature.
---

# AI Product Retention

## When to Use

- Month-1 retention below 50% and don't know why
- Users try product once and never come back
- Designing onboarding to maximize activation
- Choosing between product directions (pick the stickier one)
- Building AI features that become indispensable

## Core Jobs

### 1. The AI Retention Crisis

Only 5% of AI tools achieve meaningful retention (>50% month-12). Compare:

| Product | Month-12 Retention | Why |
|---------|-------------------|-----|
| GitHub Copilot | 80% | Daily coding habit, workflow integration |
| ChatGPT Plus | 71% | Daily use, replaces multiple tools |
| Google Gemini | 25% | Redundant with free alternatives |
| Most new AI tools | <30% | One-time use, low frequency problem |

**The retention formula:** Frequency × Depth × Irreplaceability

### 2. Stickiness Design Framework

Four dimensions that predict retention:

```
1. FREQUENCY: How often does the problem occur?
   Daily → excellent retention ceiling
   Weekly → good
   Monthly → hard to retain
   Quarterly → don't build a standalone product

2. DEPTH: How embedded in user's workflow?
   Surface (one-off queries) → easily replaced
   Embedded (part of daily process) → medium sticky
   Critical path (breaks workflow if unavailable) → very sticky

3. PERSONALIZATION: Does it know the user's context?
   Generic (same for all) → commodity
   Adapted (learns preferences) → medium sticky
   Deeply personal (knows my specific situation) → very sticky

4. SWITCHING COST: What does user lose by leaving?
   Nothing (stateless) → zero retention lock
   Some history (conversation, settings) → low lock
   Irreplaceable data (years of context, fine-tuning) → high lock
```

**Scoring:** Rate 1-3 on each dimension. Total <6 = retention risk. Target 8-12.

### 3. Habit Loop Design for AI Products

B.J. Fogg's model applied to AI tools:

```
Trigger: What brings user back?
  → Daily notification ("Your AI morning brief is ready")
  → Workflow trigger ("You opened Figma — AI design assistant activated")
  → External event ("New data in your CRM — AI analysis ready")
  → Internal cue ("It's Monday morning → I always check AI dashboard")

Action: What user does (must be frictionless)
  → One click → AI generates something useful
  → Open existing tool → AI is already there (embedded)
  → Not: navigate to separate app + log in + configure

Reward: The dopamine moment
  → "AI just saved me 2 hours" (visible time saved)
  → "That insight surprised me" (serendipitous discovery)
  → "I couldn't have found that myself" (genuine augmentation)

Investment: What makes next session more valuable
  → AI learns preferences over time
  → User adds context (notes, corrections) that improves AI
  → Integration creates network effects (more data = better AI)
```

### 4. Activation Optimization (The Critical First Session)

Users who don't activate in session 1 almost never return:

```
Activation target: User experiences core value within 10 minutes of signup

10-minute activation checklist:
  ✅ No complex onboarding wizard (max 3 steps)
  ✅ Pre-populated with sample data so AI can show its value
  ✅ First AI output is impressively relevant (not generic)
  ✅ Clear "aha moment" — AI does something user couldn't do alone
  ✅ One clear next action after aha moment

Activation measurement:
  Activated user = completed [key action] within first session
  Activation rate target: >40% (great), 20-40% (needs work), <20% (critical)
  
  Find your activation event by comparing activated vs not-activated users:
  "What did users who paid do in their first session that churned users didn't?"
```

### 5. Retention Metrics for AI Products

Beyond standard cohort retention:

```python
# AI-specific retention metrics
metrics = {
    # Standard
    "day_1_retention": users_return_day1 / new_users,
    "day_7_retention": users_return_day7 / new_users,
    "month_1_retention": users_return_day30 / new_users,

    # AI-specific
    "ai_acceptance_rate": outputs_accepted / outputs_generated,  # did user keep AI output?
    "ai_edit_rate": outputs_edited / outputs_used,              # how much did user change AI output?
    "ai_dependency_score": tasks_with_ai / total_tasks,         # % of work involving AI
    "regeneration_rate": regenerations / total_generations,     # proxy for quality
    "daily_active_ai_users": users_using_ai_today / total_users, # not just logged in
}

# Alert thresholds
alerts = {
    "acceptance_rate_drop": acceptance_rate < 0.6,  # quality problem
    "edit_rate_spike": edit_rate > 0.8,             # AI output not useful enough
    "dependency_decline": dependency_score declining week_over_week,  # abandonment signal
}
```

## Key Concepts

- **Activation event** — the specific action that predicts long-term retention; find it by data analysis
- **Stickiness score** — 1-12 rating across frequency/depth/personalization/switching cost
- **Habit loop** — trigger → action → reward → investment cycle that makes tool indispensable
- **AI acceptance rate** — % of AI outputs users actually use; primary quality metric for AI products
- **Critical path integration** — product is embedded in user's core workflow; highest retention
- **Day 1 churn** — users who don't return after first session; usually 60-80% for new products

## Checklist

- [ ] Problem frequency is ≥weekly (daily = best)?
- [ ] Activation event identified and tracked?
- [ ] Activation rate >40% in first session?
- [ ] Habit loop designed: what brings user back tomorrow?
- [ ] AI output improves over time with user data (investment loop)?
- [ ] Switching cost designed in (user loses something valuable by leaving)?
- [ ] AI-specific metrics tracked (acceptance rate, dependency score)?

## Key Outputs

- Stickiness score: 1-12 with dimension breakdown and improvement plan
- Activation funnel: steps to aha moment, activation rate, drop-off points
- Habit loop design: trigger / action / reward / investment for your product
- Retention dashboard: day 1/7/30 + AI-specific metrics (acceptance rate, dependency)

## Output Format

- 🔴 **Critical** — monthly-frequency problem (retention ceiling is low), no activation event tracked, no mechanism to bring users back tomorrow
- 🟡 **Warning** — stickiness score <6, activation taking >30 minutes, no habit loop designed, generic AI outputs (no personalization)
- 🟢 **Suggestion** — add daily trigger notification, build user context that improves AI over time, measure acceptance rate to track quality

## Anti-Patterns

- Building for low-frequency problems (quarterly reports can't retain weekly habits)
- Complex onboarding before showing value (users leave before aha moment)
- Stateless AI (no memory = no personalization = no switching cost)
- Measuring "logged in" as active (measure actual AI usage, not visits)
- Ignoring day 1 experience (80% of lifetime value decisions made in first session)

## Integration

- Use with `ai-product-design` for streaming/UX patterns that support habit loops
- Use with `llm-observability` to track AI acceptance rate and quality signals
- Use with `ai-product-validation` (validate problem frequency before building)
- Agent: `@solo-ai-builder` reviews retention design before launch
