---
name: mlops-deployment
description: Use when deploying ML models to production, setting up canary releases, or designing the serving infrastructure
---

# MLOps Deployment

## When to Use
When taking a trained model from experiment to production serving.

## Core Jobs

### 1. Package the Model
- Serialize: pickle (small models), ONNX (cross-framework), TorchScript (PyTorch)
- Container: Docker image with model + inference code + dependencies pinned
- Register: store in model registry (MLflow, W&B, SageMaker) with version + metadata

### 2. Choose Serving Pattern
**Online (real-time)**:
- REST API (FastAPI + uvicorn) or gRPC for low latency
- Batch size 1, P95 latency target < 200ms
- Scale: Kubernetes + HPA or serverless (Lambda, Cloud Run)

**Batch (offline)**:
- Run on schedule, write predictions to DB/S3
- Higher throughput, latency doesn't matter
- Use Spark or Ray for large-scale

**Streaming**:
- Consume from Kafka, predict, publish results
- Use Flink ML or custom consumer

### 3. Canary / Shadow Release
- **Shadow**: new model runs alongside old, predictions logged but not served
- **Canary**: new model serves X% of traffic (start 1%, ramp up)
- Compare: business metrics, not just ML metrics
- Rollback trigger: define threshold before launch

### 4. Inference Optimization
- Quantization: INT8 (4x smaller, ~2x faster, <1% accuracy drop)
- Batching: group requests for throughput
- Caching: cache predictions for identical inputs
- Hardware: GPU for large models, CPU for small/fast

## Key Outputs
- Model serving API (Dockerfile + app code)
- Deployment manifest (k8s YAML or Terraform)
- Canary release plan with rollback criteria
- Latency benchmark report

## Anti-Patterns
- Deploying without a rollback plan
- No shadow mode before production traffic
- Using dev environment pickle files in prod
- No latency SLA defined before deployment
