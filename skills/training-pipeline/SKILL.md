---
name: training-pipeline
description: Use when building reproducible ML training workflows, orchestrating training jobs, or versioning training artifacts
---

# Training Pipeline

## When to Use
When building the end-to-end system that takes raw data and produces a validated, registered model — reproducibly.

## Core Jobs

### 1. Define Pipeline Stages
```
Data → Validate → Preprocess → Train → Evaluate → Register
```
Each stage:
- Takes versioned inputs
- Produces versioned outputs
- Is independently re-runnable (idempotent)
- Has pass/fail criteria

### 2. Orchestrate the Pipeline
Tools: Airflow, Prefect, Kubeflow Pipelines, Metaflow, SageMaker Pipelines
- Each step = one container or task
- Pass artifacts between steps via shared storage (S3, GCS)
- Log metadata to experiment tracker at each step

### 3. Version Everything
- Data: DVC or dataset versioning in the registry
- Code: git commit hash logged with each run
- Environment: Docker image tag (pinned, not `latest`)
- Model: versioned in model registry with lineage to data + code

### 4. Automated Evaluation Gate
Before registering, automatically check:
- [ ] Performance > baseline (current prod model)
- [ ] Performance on recent data slice (last 30 days)
- [ ] No data leakage detected (temporal split verified)
- [ ] Latency within SLA
If any check fails: pipeline fails, Slack alert, no model registered.

### 5. CI/CD for ML
- PR → run unit tests on pipeline code
- Merge → trigger training run on subset (smoke test)
- Tag/release → full training run → deploy if gates pass

## Key Outputs
- Pipeline DAG definition
- Evaluation gate configuration
- Model registry entry (with lineage)
- Pipeline monitoring dashboard

## Anti-Patterns
- Manual steps in the pipeline (not reproducible)
- No evaluation gate — any model can go to prod
- `latest` tags on Docker images or data
- No lineage — can't trace a prod model back to its data
