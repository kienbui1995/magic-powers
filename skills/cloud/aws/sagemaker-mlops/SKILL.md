---
name: sagemaker-mlops
description: Use when building ML training/serving pipelines on AWS SageMaker, implementing MLOps with SageMaker Pipelines and Model Registry, monitoring models in production, or optimizing training costs with Spot instances. Covers AWS MLA-C01 exam domains.
---

# Amazon SageMaker MLOps

## When to Use
- Designing ML training and serving infrastructure on AWS SageMaker
- Building ML pipelines with SageMaker Pipelines (training → evaluation → deployment)
- Implementing model versioning with SageMaker Model Registry
- Monitoring models in production with SageMaker Model Monitor
- Optimizing training costs with Spot instances and managed checkpointing
- Preparing for AWS Certified Machine Learning Engineer Associate (MLA-C01) exam

## Core Jobs

### 1. Training Job Configuration

| Option | Cost | Best For |
|--------|------|---------|
| **On-Demand instances** | Full price | Short jobs, time-critical, no interruption risk |
| **Spot training** | Up to 90% savings | Long batch jobs; must use checkpointing |
| **SageMaker Training Warm Pools** | Reserve compute between runs | Iterative development (reduces startup time) |

**Spot training requirements**:
- Must implement checkpointing (save model state periodically to S3)
- On interruption, SageMaker saves checkpoint; resumes from last checkpoint when capacity returns
- Checkpoint path: `s3://bucket/checkpoints/job-name/`
- Training frameworks (TensorFlow, PyTorch, MXNet) have native checkpoint support

**Managed Spot Training code**:
```python
estimator = Estimator(
    ...
    use_spot_instances=True,
    max_run=3600,          # max total training time (seconds)
    max_wait=7200,         # max wait including interruptions
    checkpoint_s3_uri="s3://bucket/checkpoints/",
    checkpoint_local_path="/opt/ml/checkpoints"
)
```

**Built-in algorithms vs custom containers**:

| Approach | Use Case | Example |
|----------|---------|---------|
| **Built-in algorithms** | Common ML tasks, fast start | XGBoost, Linear Learner, K-Means, BlazingText |
| **Script mode** | Familiar framework (TF/PyTorch/sklearn), custom code | Bring your own training script |
| **Custom container** | Exotic runtime, custom dependencies | Custom C++ inference, specialized research |
| **Pre-trained model (Jumpstart)** | Fine-tune foundation models | LLMs, BERT, ResNet |

### 2. Inference Endpoint Types

| Endpoint Type | Latency | Payload Size | Use Case |
|--------------|---------|-------------|---------|
| **Real-time endpoint** | Synchronous, milliseconds | < 6MB | Interactive APIs, recommendations, fraud detection |
| **Serverless endpoint** | Cold start possible | < 4MB (request), < 20MB (model) | Infrequent traffic (cost savings, no idle cost) |
| **Async endpoint** | Minutes (result to S3) | Up to 1GB | Large payloads, long processing (NLP, video) |
| **Batch Transform** | Offline, hours | Entire dataset | Offline scoring, pre-computation, bulk inference |

**Async endpoint**: request queued in SQS; processing result written to S3; notification via SNS/EventBridge.

**Batch Transform**: no endpoint needed; input from S3; output to S3; best for periodic bulk scoring.

**Multi-model endpoint (MME)**: host thousands of models on a single endpoint; SageMaker loads/unloads models from S3 to GPU/CPU memory dynamically. Cost-effective for many similar models.

**Multi-container endpoint**: run different models/containers on one endpoint; invoke a specific container. Use for A/B testing or ensemble inference.

### 3. SageMaker Pipelines (MLOps Workflow)

**Supported step types**:

| Step Type | Purpose |
|-----------|---------|
| `ProcessingStep` | Data preprocessing, feature engineering, evaluation |
| `TrainingStep` | Model training job |
| `TuningStep` | Hyperparameter optimization (HPO) |
| `TransformStep` | Batch inference |
| `RegisterModel` | Register model version in Model Registry |
| `ConditionStep` | Branch pipeline based on evaluation metrics |
| `CreateModelStep` | Create SageMaker model from training artifacts |
| `LambdaStep` | Invoke Lambda function (custom logic) |
| `ClarifyCheckStep` | Bias/explainability analysis |

**Example pipeline flow**:
```
ProcessingStep (feature engineering)
    ↓
TrainingStep (train XGBoost)
    ↓
ProcessingStep (evaluate on test set)
    ↓
ConditionStep (accuracy > 0.9?)
    ├── Yes → RegisterModel (Approved)
    └── No → RegisterModel (Rejected)
```

**SageMaker Pipelines vs Step Functions**:
- Pipelines = ML-native; step types understand ML artifacts (models, datasets); experiment tracking built-in
- Step Functions = general workflow; use when integrating ML with non-ML AWS services

### 4. Model Registry

- Version ML models with metadata, metrics, and approval status
- Approval states: **Pending** (default) → **Approved** / **Rejected**
- CI/CD trigger: approved model version → EventBridge → CodePipeline → deploy to endpoint
- Cross-account: share model package groups across accounts (for separate dev/staging/prod accounts)

**Workflow**:
1. Training pipeline registers new model version (status: Pending)
2. Automatic evaluation → conditional approval or human review
3. Approval → EventBridge event → CodePipeline deploys to staging endpoint
4. Staging validation passes → deploy to production endpoint

### 5. Model Monitor

Continuously monitors deployed endpoint data for:

| Monitor Type | What It Detects | Baseline |
|-------------|----------------|---------|
| **Data quality** | Feature distribution drift (input data statistics change) | Baseline from training data |
| **Model quality** | Accuracy/precision drift (compare predictions vs ground truth) | Baseline from training evaluation |
| **Bias drift** | Fairness metric changes (demographic parity, etc.) | Baseline from Clarify bias analysis |
| **Feature attribution drift** | SHAP value changes (important features changing) | Baseline from Clarify explainability analysis |

**Setup requirements**:
1. Enable data capture on endpoint (captures request/response samples to S3)
2. Generate baseline statistics from training data
3. Schedule monitoring job (hourly, daily, etc.)
4. CloudWatch alerts on constraint violations → SNS notification

### 6. SageMaker Feature Store

| Store Type | Latency | Backed By | Best For |
|-----------|---------|----------|---------|
| **Online store** | Milliseconds | In-memory cache | Real-time inference (serving) |
| **Offline store** | Seconds-minutes | S3 (Parquet, Iceberg) | Model training, batch queries |

**Feature reuse**: compute features once, store in Feature Store, reuse across multiple models and teams.
**Point-in-time queries**: offline store supports time-travel queries (get feature values as of specific timestamp) — prevents training/serving skew.

## Key Concepts

- **SageMaker Studio** — unified web IDE: notebooks, experiments, pipelines, model registry, endpoints; replaces individual SageMaker interfaces
- **SageMaker Experiments** — track training runs, hyperparameters, metrics, artifacts; query to find best run
- **SageMaker Clarify** — bias detection and explainability (SHAP values) for training data and predictions
- **SageMaker Debugger** — capture tensors during training; detect training issues (vanishing gradients, overfitting)
- **Hyperparameter Tuning (HPO)** — Bayesian optimization or random search over defined hyperparameter ranges
- **Model Dashboard** — unified view of all models, endpoint health, monitor violations
- **Inference Recommender** — benchmark instance types for your model (right-sizing for cost/latency)
- **SageMaker JumpStart** — pre-trained models and solution templates (foundation models, computer vision, NLP)

## Checklist

- [ ] Spot training enabled with checkpointing for long training jobs?
- [ ] Endpoint type matched to use case (real-time, async, batch, serverless)?
- [ ] SageMaker Pipelines defined for reproducible ML workflow (not ad-hoc notebooks)?
- [ ] Model Registry used for versioning and approval workflow?
- [ ] Data capture enabled on endpoint before setting up Model Monitor?
- [ ] Model Monitor baseline generated from training data statistics?
- [ ] Feature Store used for shared features across models (avoid feature duplication)?
- [ ] IAM execution roles for training jobs follow least-privilege principle?

## Output Format

- 🔴 **Critical** — Spot training without checkpointing (job restarts from scratch on interruption, wasting compute); no model versioning (cannot roll back; no approval workflow)
- 🟡 **Warning** — Real-time endpoint for large payload inference (use async); no Model Monitor (production drift undetected); all training on on-demand instances (significant cost savings missed)
- 🟢 **Suggestion** — Multi-model endpoint for many similar models (cost savings vs individual endpoints); SageMaker Inference Recommender for instance right-sizing; Feature Store for cross-team feature reuse

## Exam Tips

- **Spot training = up to 90% cost savings**; must enable checkpointing for long jobs — SageMaker resumes from last checkpoint after interruption
- **Async endpoint = for payloads > 6MB or processing > 60 seconds**; results written to S3; poll or use SNS for completion notification
- **Batch Transform = offline scoring of entire dataset**; no endpoint required; input from S3, output to S3
- **Model Monitor requires baseline** from training data statistics; monitors for data drift in production (compare incoming request distributions)
- **SageMaker Pipelines = NOT Step Functions**; native ML pipeline service with ML-specific steps (ProcessingStep, TrainingStep, ConditionStep, RegisterModel)
- **Feature Store: online (low-latency serving) + offline (S3-backed, for training)** — same concept as Vertex AI Feature Store; online and offline stores are separate
- **ConditionStep** = branch pipeline based on evaluation metric threshold (if accuracy > 0.9 → approve model; else → reject)
- **Multi-model endpoint (MME)** = host thousands of models on one endpoint; SageMaker dynamically loads/evicts models from memory based on traffic
