---
name: vertex-ai-mlops
description: Use when building ML pipelines on Vertex AI, managing model lifecycle, setting up feature stores, or deploying models for serving. Covers GCP-PDE domain: Maintain and automate data workloads (~10-15%) and GCP ML Engineer domain: MLOps (~30-35%).
---

# Vertex AI MLOps

## When to Use
- Designing ML training or serving infrastructure on GCP
- Setting up model monitoring or retraining pipelines
- Choosing between AutoML and custom training
- Preparing for GCP Professional Data Engineer or ML Engineer exam

## Core Jobs

### 1. AutoML vs Custom Training
| Factor | AutoML | Custom Training |
|--------|--------|----------------|
| Code required | None | Python/TensorFlow/PyTorch |
| Control | Limited | Full control |
| Speed | Fastest to deploy | Requires ML expertise |
| Best for | Tabular, image, text (standard tasks) | Novel architectures, research |

### 2. Vertex AI Pipelines
- Orchestrates ML workflows as DAGs (Kubeflow Pipelines or TFX)
- Each step = a containerized component (preprocessing, training, evaluation, deployment)
- Use kfp.v2 SDK or pre-built Google Cloud Pipeline Components
- Store pipeline artifacts in Cloud Storage; metadata in Vertex ML Metadata

### 3. Feature Store
- Centralized repository for ML features (avoid feature duplication across teams)
- **Online store** — low-latency serving (< 10ms) for real-time inference
- **Offline store** — batch access for training (BigQuery-backed)
- Features defined once, reused across models

### 4. Model Serving
- **Endpoint** — deploys one or more model versions, handles prediction requests
- **Batch prediction** — asynchronous, for large offline prediction jobs
- **Online prediction** — synchronous, for real-time serving
- Traffic splitting between model versions for A/B testing or canary releases

### 5. Model Monitoring
- **Skew detection** — training vs serving data distribution drift
- **Drift detection** — serving data distribution changes over time
- Alert thresholds configurable per feature
- Monitored logs sent to BigQuery for analysis

### 6. Model Registry
- Version all trained models centrally
- Stage models through: Experiment → Staging → Production
- Alias support for promoting/rolling back versions

## Key Concepts
- **ML Metadata** — tracks lineage: which dataset trained which model, which pipeline produced what artifact
- **Explainable AI** — feature attributions (SHAP values) for model transparency
- **Vertex AI Workbench** — managed JupyterLab for experimentation
- **Training pipeline vs custom job** — pipeline = orchestrated multi-step; custom job = single training run

## Checklist
- [ ] Training data versioned and reproducible?
- [ ] Model evaluation metrics gated before promotion?
- [ ] Serving endpoint has traffic splitting for safe rollout?
- [ ] Model monitoring enabled (skew + drift detection)?
- [ ] Feature Store used to avoid feature duplication?
- [ ] Pipeline steps containerized and versioned?

## Output Format
- 🔴 **Critical** — no model monitoring in production (silent degradation)
- 🟡 **Warning** — no traffic splitting for new model versions, no feature versioning
- 🟢 **Suggestion** — Feature Store for cross-team feature reuse, Explainable AI for compliance

## Exam Tips
- **Feature Store online** = real-time serving (low latency); **offline** = batch training (BigQuery)
- Model monitoring = skew (train vs serve) + drift (serve distribution over time)
- Vertex AI Pipelines = Kubeflow Pipelines on GCP (not Cloud Composer/Airflow)
- AutoML Tabular = good baseline; custom training when you need specific architecture
- Batch prediction = no endpoint needed; just submit job → results to GCS/BigQuery
- Traffic splitting on endpoints = canary release for models (same as canary deployments)
