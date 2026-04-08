---
name: cloud-run-functions
description: Use when choosing between Cloud Run and Cloud Functions, designing serverless compute on GCP, configuring concurrency/scaling, or building event-driven architectures. Covers GCP Cloud Developer domain: Designing apps (~36%).
---

# Cloud Run & Cloud Functions

## When to Use
- Deciding between Cloud Run, Cloud Functions, and App Engine
- Configuring autoscaling, concurrency, and cold start behavior
- Building event-driven serverless architectures
- Preparing for GCP Professional Cloud Developer exam

## Core Jobs

### 1. Compute Option Decision
| Option | Best for | Billing |
|--------|---------|---------|
| **Cloud Run** | Containerized apps, any language, HTTP/gRPC | Per request + CPU |
| **Cloud Functions (2nd gen)** | Cloud Run under the hood, longer timeout, concurrency | Per request + CPU |
| **App Engine Standard** | Specific runtimes (Python/Java/Go/Node), instant scaling | Per instance hour |
| **App Engine Flexible** | Custom runtimes, Docker, always-on | Per instance hour |

### 2. Cloud Run Configuration
- **Concurrency** — requests per container instance (default 80, max 1000)
- **Min instances** — keep warm instances to avoid cold starts (set to 1+ for latency-sensitive)
- **Max instances** — cap scaling to control costs
- **CPU allocation** — always-on vs request-only (request-only = cheaper, cold starts)
- **Traffic splitting** — route % of traffic to different revisions (canary/blue-green)

### 3. Cloud Functions Triggers
- **HTTP trigger** — synchronous, returns response
- **Pub/Sub trigger** — async, event-driven
- **Cloud Storage trigger** — on object create/delete/finalize
- **Firestore trigger** — on document create/update/delete
- **Eventarc** — unified eventing; routes events from GCP services to Cloud Run/Functions

### 4. Cold Start Mitigation
- Set **min-instances** > 0 for latency-sensitive services
- Keep container images small (use distroless or alpine base)
- Lazy-load dependencies (don't load everything at startup)
- Use Cloud Functions 2nd gen (faster cold starts than 1st gen)

### 5. Authentication Patterns
- **Unauthenticated** — public APIs (Cloud Run allows-unauthenticated)
- **Service-to-service** — use service account + ID token (not API key)
- **IAM invoker role** — `roles/run.invoker` for Cloud Run, `roles/cloudfunctions.invoker`
- **Audience** — ID token audience must match the service URL

## Key Concepts
- **Revision** — immutable deployment of a Cloud Run service
- **Service identity** — each Cloud Run service runs as a service account
- **VPC connector** — connect Cloud Run to private VPC resources (Cloud SQL, Redis)
- **Ingress control** — restrict to internal, load balancer only, or all traffic

## Checklist
- [ ] Min-instances set for latency-sensitive services?
- [ ] Max-instances capped to prevent runaway costs?
- [ ] Service runs as dedicated service account (not default compute SA)?
- [ ] VPC connector configured for private resource access?
- [ ] Unauthenticated access explicitly enabled/disabled?
- [ ] Image stored in Artifact Registry (not Docker Hub)?

## Output Format
- 🔴 **Critical** — using default compute service account (over-privileged), unauthenticated enabled unintentionally
- 🟡 **Warning** — no min-instances for latency-sensitive, no max-instances cap
- 🟢 **Suggestion** — CPU always-on for latency; min-instances for warm pool

## Exam Tips
- Cloud Run = containers, any language, HTTP/gRPC; Functions = event-driven, simpler
- Cloud Functions 2nd gen = built on Cloud Run (same infrastructure)
- Traffic splitting → use for canary releases without a load balancer
- Service-to-service auth = ID token (not API key, not user credentials)
- VPC connector required to access Cloud SQL/Memorystore from Cloud Run
- App Engine Standard = instant scale to zero; Flexible = always at least 1 instance
