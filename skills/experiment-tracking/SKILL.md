---
name: experiment-tracking
description: Use when designing A/B tests, managing experiment hypotheses, analyzing results, or building an experimentation culture
---

# Experiment Tracking

## When to Use
When validating product decisions with data before full rollout — A/B tests, multivariate tests, or staged rollouts with measurement.

## Core Jobs

### 1. Write the Hypothesis
Format: "We believe [change] will [outcome] for [user segment] because [reason]. We'll know we're right when [metric] changes by [amount] within [timeframe]."

Example: "We believe showing the pricing table earlier will increase trial-to-paid conversion for SMB users because they need to see value/cost before engaging. We'll know when 30-day conversion rate increases by 5% within 4 weeks."

### 2. Design the Experiment
- **Unit of randomization**: user, session, or request?
  - User: consistent experience, required for behavioral tests
  - Session: quick iteration, but user sees both variants
- **Sample size**: calculate minimum detectable effect (MDE)
  - Tools: Evan Miller's A/B sample size calculator
  - Higher traffic → detect smaller effects
- **Duration**: run until significance reached, minimum 2 weeks (capture weekly patterns)
- **Control**: what is the baseline? Is it actually the current production behavior?

### 3. Track the Experiment
Log per experiment:
- Hypothesis, variants, start date, expected end date
- Primary metric, secondary metrics, guardrail metrics
- Team owner, status (running/paused/concluded)

Prevent: running too many experiments simultaneously (interaction effects)

### 4. Analyze Results
- Check statistical significance (p < 0.05) before declaring winner
- Check practical significance (is the effect size meaningful?)
- Look at guardrail metrics (did we improve X but break Y?)
- Segment by key user groups — aggregate results can hide segment-level effects

### 5. Document and Share
- Write up results even for failed experiments (prevents re-running same test)
- Share with wider team — learning compounds

## Key Outputs
- Experiment brief (hypothesis, design, metrics)
- Statistical analysis (significance, effect size)
- Segment breakdown
- Decision memo (ship, iterate, or revert)

## Anti-Patterns
- Running experiments without statistical significance calculation
- Stopping early when results look good (peeking problem)
- No guardrail metrics (improving one metric while breaking another)
- Not documenting failed experiments
