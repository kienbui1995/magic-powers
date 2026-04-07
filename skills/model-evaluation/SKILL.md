---
name: model-evaluation
description: Use when selecting evaluation metrics, detecting bias, or validating model readiness for production
---

# Model Evaluation

## When to Use
When assessing whether a model is good enough to deploy, fairly represents all user groups, and won't degrade in production.

## Core Jobs

### 1. Choose the Right Metrics
Match metric to problem type:
- **Binary classification**: AUC-ROC, F1, precision, recall (choose based on cost of FP vs FN)
- **Multi-class**: macro/weighted F1, confusion matrix
- **Regression**: RMSE, MAE, MAPE (use MAE when outliers shouldn't dominate)
- **Ranking**: NDCG, MRR
- **Generation (LLM)**: BLEU/ROUGE (weak), human eval, LLM-as-judge

Business metric matters more than ML metric — always connect model performance to business outcome.

### 2. Evaluate Across Segments
Don't report only aggregate metrics. Slice by:
- User demographics (age, region, language)
- Data subgroups (product category, request type)
- Time (recent vs older data — look for drift)
- Edge cases (short inputs, rare labels)

### 3. Bias and Fairness Checks
- Equal opportunity: equal TPR across groups?
- Demographic parity: equal positive prediction rates?
- Use tools: Fairlearn, IBM AI Fairness 360

### 4. Pre-Production Validation
- [ ] Performance on holdout test set
- [ ] Performance on recent data (last 30 days)
- [ ] Latency at P50/P95/P99 (meets SLA?)
- [ ] Memory footprint (fits in serving environment?)
- [ ] Slice analysis (no group significantly underperforms)
- [ ] Shadow mode test (run alongside current system)

## Key Outputs
- Evaluation report with chosen metrics and rationale
- Slice analysis (breakdown by key segments)
- Bias/fairness assessment
- Pre-production validation checklist

## Anti-Patterns
- Optimizing for accuracy on imbalanced datasets
- Never slicing results by subgroup
- Declaring a model "ready" without latency testing
- Using test set for model selection (leakage)
