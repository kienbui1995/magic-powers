---
name: model-monitoring
description: Use when setting up drift detection, retraining triggers, or production model health dashboards
---

# Model Monitoring

## When to Use
When a model is live in production and needs ongoing health tracking to catch degradation before users notice.

## Core Jobs

### 1. Monitor Data Drift
Input distribution changes → model becomes unreliable.
- **Univariate drift**: monitor each feature's distribution (KS test, PSI)
- **Multivariate drift**: monitor joint distribution (MMD, PCA shift)
- Tools: Evidently AI, WhyLogs, Alibi Detect
- Threshold: PSI > 0.2 = alert, > 0.25 = investigate retraining

### 2. Monitor Prediction Drift
- Distribution of model outputs changing
- Useful when ground truth is delayed (common in production)
- Alert if output distribution shifts significantly from baseline

### 3. Monitor Ground Truth (when available)
- Compare predictions vs actuals as labels arrive
- Calculate: accuracy, precision, recall (same metrics as eval)
- Set alert thresholds: >10% degradation from baseline = page on-call

### 4. Set Retraining Triggers
Define trigger strategy:
- **Schedule**: retrain weekly/monthly regardless of drift
- **Performance-based**: retrain when accuracy drops below threshold
- **Drift-based**: retrain when PSI > 0.25 on key features
- Combine: schedule + drift detection for critical models

### 5. Dashboard Essentials
- Prediction volume over time
- Feature distributions (current vs baseline)
- Model performance metrics (rolling 7-day)
- Latency P50/P95/P99
- Error rates (failed inferences)

## Key Outputs
- Monitoring pipeline (drift detection + alerting)
- Model health dashboard
- Retraining trigger policy
- Runbook for drift alerts

## Anti-Patterns
- No monitoring after deployment ("set and forget")
- Alerting on every metric — pick 3–5 critical signals
- No ground truth pipeline — can't measure real accuracy
- Retraining without validating the new model first
