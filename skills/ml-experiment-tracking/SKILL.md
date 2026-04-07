---
name: ml-experiment-tracking
description: Use when managing ML experiments, ensuring reproducibility, or comparing model runs
---

# ML Experiment Tracking

## When to Use
When training models and need to compare runs, reproduce results, or share findings with the team.

## Core Jobs

### 1. Track Every Run
Use MLflow, W&B, or DVC. Log per experiment:
- **Parameters**: hyperparameters, data version, preprocessing config
- **Metrics**: loss, accuracy, precision/recall/F1, AUC
- **Artifacts**: model weights, feature importance plots, confusion matrix
- **Environment**: Python version, library versions, hardware

```python
import mlflow

with mlflow.start_run():
    mlflow.log_param("learning_rate", 0.01)
    mlflow.log_param("max_depth", 5)
    mlflow.log_metric("val_accuracy", 0.92)
    mlflow.log_artifact("model.pkl")
```

### 2. Version Your Data
- Pin dataset version alongside each experiment
- Use DVC or S3 versioning
- Never train on "latest" — always a specific version

### 3. Make Experiments Reproducible
- Set random seeds (`torch.manual_seed`, `np.random.seed`)
- Record hardware (GPU model affects float precision)
- Use Docker or conda envs with pinned versions
- Log git commit hash with each run

### 4. Compare and Select
- Don't compare metrics in isolation — look at training curves
- Check for overfitting (train vs val gap)
- Compare on holdout test set only once (before that: val set)
- Document why you chose the winner

## Key Outputs
- Experiment tracking setup (MLflow/W&B config)
- Run comparison report
- Model selection rationale
- Reproducibility checklist

## Anti-Patterns
- Training without logging parameters
- Comparing models trained on different data versions
- Evaluating on test set during model selection (data leakage)
- No seed → can't reproduce results
