---
name: analyze-experiment
description: Comprehensive A/B test analysis with statistical validity, segment breakdown, and SHIP/ITERATE/ABANDON recommendation. Uses mcp__Amplitude__query_experiment, mcp__Amplitude__get_experiments.
---

# Analyze Amplitude Experiment

## When to Use

- An A/B test has run for at least one week and you need a go/no-go decision
- A stakeholder asks "did the experiment work?"
- You need to check if an experiment is statistically valid before acting on results
- A test shows a positive primary metric but you need to check for regressions in guardrail metrics
- Reviewing multiple experiments to prioritize which results to ship

## Core Jobs

### Dimension 1: Initial Setup — Identify the Experiment
Use `mcp__Amplitude__get_experiments` to find the experiment by name, feature flag, or product area. Retrieve:

- Experiment name and hypothesis
- Variants: control and treatment(s), with traffic allocation percentages
- Start date and current status (running, paused, concluded)
- Primary success metric and guardrail metrics

**Workaround — Metric Name Limitation**: The Amplitude MCP cannot retrieve metric names directly by metric ID. To identify what metrics the experiment tracks, search for charts related to the experiment via `mcp__Amplitude__get_charts` and look for associated funnel or segmentation charts that reference the experiment's flag.

### Dimension 2: Data Quality Assessment
Before analyzing results, validate that the data is trustworthy. Run these 7 validity checks:

1. **Traffic balance**: Is traffic split as configured? If a 50/50 split shows 55/45, there may be a selection bias issue.
2. **Sample Ratio Mismatch (SRM)**: A statistically significant difference in traffic between control and treatment (p<0.05 on a chi-square test of traffic counts) invalidates the experiment. Flag and do not proceed with analysis.
3. **Statistical power**: Does the experiment have enough users to detect the expected effect size? Target 80%+ power. A small sample cannot confirm a null result.
4. **Novelty effect**: Did engagement spike in the first 1-3 days for the treatment variant? If so, the true effect may be smaller than early results suggest.
5. **Experiment pollution**: Are users crossing between control and treatment? (Can happen if bucketing is user-level but the variant affects a shared resource.)
6. **Pre-experiment parity**: Were control and treatment groups equivalent on key metrics before the experiment launched? A difference in the pre-period suggests selection bias.
7. **Instrumentation check**: Did both variants log events at similar rates? A drop in event logging for one variant suggests a tracking bug.

### Dimension 3: Primary Metric Analysis
Use `mcp__Amplitude__query_experiment` to retrieve results for the primary metric:

- **Absolute lift**: treatment value minus control value (e.g., "conversion rate: 12.3% vs 11.1%, lift = +1.2 percentage points")
- **Relative lift**: (treatment - control) / control (e.g., "+10.8% relative improvement")
- **p-value**: probability the result is due to chance. p<0.05 = statistically significant at standard threshold.
- **95% Confidence Interval**: the range of plausible true effect sizes. If the CI crosses zero, the result is not conclusive.
- **Statistical significance**: p<0.05 is the standard threshold. Note: significance does not mean the effect is large enough to matter.
- **Practical significance**: is the lift large enough to be worth shipping? A 0.1% conversion improvement that is statistically significant may not be worth the maintenance cost.

### Dimension 4: Segment Analysis
Breaking down results by user segments is mandatory. Present results as markdown tables.

Required segments to check:

| Segment | Control Rate | Treatment Rate | Lift | p-value | Significant? |
|---------|-------------|----------------|------|---------|--------------|
| iOS | — | — | — | — | — |
| Android | — | — | — | — | — |
| Web | — | — | — | — | — |
| New users (<30 days) | — | — | — | — | — |
| Returning users (30+ days) | — | — | — | — | — |
| Free tier | — | — | — | — | — |
| Paid tier | — | — | — | — | — |
| High-activity users | — | — | — | — | — |
| Low-activity users | — | — | — | — | — |

Fill this table from `mcp__Amplitude__query_experiment` results. Segment heterogeneity (the treatment working very differently across segments) is important: it may indicate the change should only ship to specific segments, or that the aggregate result is misleading.

### Dimension 5: Secondary Metrics and Guardrail Metrics
Check all secondary and guardrail metrics for regressions. A positive primary metric result is invalid if a guardrail metric regresses.

Key guardrail metrics to check:
- **Revenue metrics**: did ARPU or conversion to paid decline?
- **Retention**: did D7 or D30 retention change for either group?
- **Engagement depth**: did session depth, feature usage, or time-on-product change?
- **Support signals**: did error rates or support ticket rates increase in the treatment?

Any statistically significant regression in a guardrail metric must be disclosed prominently and factored into the recommendation.

### Dimension 6: Duration Assessment
Assess whether the experiment has run long enough:

- **Power analysis**: given the observed traffic rate and effect size, was the pre-specified sample size reached?
- **Learning curves**: some effects take 2-3 weeks to stabilize as users adapt to the change. Has the effect been stable for at least 2 weeks?
- **Seasonality**: does the experiment span any known seasonal patterns (weekends, end of month, holidays) that could bias results?
- **Business cycles**: for B2B products, experiments that don't include a full weekly cycle (Mon-Sun) may not capture the full user behavior pattern.

If the experiment hasn't run long enough, the recommendation may be "NEED MORE DATA" even if current results look positive.

### Dimension 7: Qualitative Validation
Cross-reference quantitative results with qualitative signals:

- Are there session replays of treatment users that show how they interact with the change?
- Has user feedback (NPS, CSAT, support tickets) changed since the experiment launched?
- Do qualitative signals align with or contradict the quantitative findings?

### Dimension 8: Final Recommendation
Deliver one of four verdicts with quantified rationale:

**SHIP**: Primary metric improved significantly (p<0.05), no guardrail regressions, sample size adequate, effect stable over time. State the expected impact at full rollout.

**ITERATE**: Results show promise but are inconclusive, or there is a guardrail regression that needs to be fixed. State specifically what to change and why.

**ABANDON**: Primary metric shows no improvement (p>0.05 with adequate power) or shows a significant negative effect, or a guardrail metric has regressed and cannot be fixed. State what was learned.

**NEED MORE DATA**: Sample size insufficient, experiment ran too briefly, or SRM detected. State the minimum additional runtime or sample size required before a decision can be made.

Be comprehensive, not brief. Stakeholders need to understand the reasoning behind the recommendation, not just the verdict.

## MCP Tools

- `mcp__Amplitude__get_experiments` — retrieve experiment configuration and metadata
- `mcp__Amplitude__query_experiment` — fetch experiment results by variant and segment
- `mcp__Amplitude__get_charts` — find charts associated with the experiment for metric identification
- `mcp__Amplitude__get_context` — get projectId and organization context

## Key Concepts

- **Sample Ratio Mismatch (SRM)**: A statistically significant imbalance between the number of users assigned to each variant, suggesting bucketing is broken. Invalidates the experiment.
- **Statistical power**: The probability that the experiment can detect an effect of the expected size if one truly exists. Target 80%+.
- **p-value**: The probability that the observed result (or more extreme) would occur by chance if there were no true effect. p<0.05 is the standard significance threshold.
- **Confidence interval (CI)**: The range of values that likely contains the true effect size. A CI that does not cross zero indicates a significant result.
- **Guardrail metric**: A metric that must not regress as a result of the experiment, even if the primary metric improves.
- **Novelty effect**: A temporary boost in engagement for a new treatment that fades as users acclimate. Experiments should run long enough to distinguish novelty from sustained change.
- **Practical significance**: Whether the effect size is large enough to justify shipping, independent of statistical significance.
- **Segment heterogeneity**: When the treatment effect varies significantly across user segments, suggesting the change should be targeted rather than shipped to all users.

## Output Format

The analysis is comprehensive — do not summarize. Executives and PMs need the full reasoning.

Structure:
1. **Experiment summary** (1 paragraph): Name, hypothesis, variants, dates, traffic allocation.
2. **Data quality verdict** (7 validity checks, each pass/fail with brief explanation)
3. **Primary metric results** (specific numbers: absolute lift, relative lift, p-value, 95% CI, significance verdict)
4. **Segment breakdown** (filled markdown table per the template above)
5. **Guardrail metric status** (each guardrail: value, direction, significance, verdict)
6. **Duration and power assessment** (adequate / needs more time)
7. **Qualitative signals** (if available)
8. **Recommendation**: SHIP / ITERATE / ABANDON / NEED MORE DATA — bold, prominent — followed by 2-4 sentences of specific rationale with numbers.
