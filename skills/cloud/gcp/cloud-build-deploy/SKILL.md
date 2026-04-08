---
name: cloud-build-deploy
description: Use when building CI/CD pipelines on GCP with Cloud Build, Cloud Deploy, or Artifact Registry. Covers GCP Cloud Developer domain: Building and testing (~26%) and Deploying (~19%). Also covers DevOps Engineer domain: CI/CD pipelines (~25%).
---

# Cloud Build & Cloud Deploy

## When to Use
- Setting up CI/CD pipelines on GCP
- Configuring build triggers, test steps, and artifact management
- Implementing progressive delivery (canary, blue/green)
- Preparing for GCP Professional Cloud Developer or DevOps Engineer exam

## Core Jobs

### 1. Cloud Build Pipeline
A basic cloudbuild.yaml:
- Step 1: Build Docker image tagged with commit SHA
- Step 2: Push image to Artifact Registry
- Step 3: Deploy to Cloud Run or GKE
- Use `$SHORT_SHA` for image tagging (traceability)
- Use `$PROJECT_ID`, `$BRANCH_NAME` substitution variables

### 2. Triggers
- **Push to branch** — trigger on push to main/develop
- **Pull request** — trigger on PR creation/update (for validation)
- **Tag** — trigger on version tag push (for release builds)
- **Pub/Sub** — trigger from external event via Pub/Sub message

### 3. Artifact Registry
- Multi-format: Docker, Maven, npm, Python, Go, Helm
- Regional repositories (co-locate with Cloud Run/GKE region)
- **Artifact Analysis** — vulnerability scanning on container images
- Replace Container Registry (gcr.io) — Artifact Registry is the successor

### 4. Cloud Deploy (Progressive Delivery)
- Manages deployment to a sequence of targets: dev → staging → prod
- Supports: GKE, Cloud Run, Anthos
- **Canary** — route % of traffic to new version; auto-promote if healthy
- **Blue/Green** — spin up full new environment; switch traffic; keep old for rollback
- Rollback in one click; full audit trail

### 5. Build Optimization
- Use **build cache** (caching Docker layers in Artifact Registry)
- Parallelize independent build steps with `waitFor: ['-']`
- Use **worker pools** (private pool) for builds needing VPC access
- Minimize base image size → faster build + smaller attack surface

## Key Concepts
- **$SHORT_SHA** — first 7 chars of git commit SHA (use for image tagging)
- **Substitution variables** — `$PROJECT_ID`, `$BUILD_ID`, `$BRANCH_NAME`
- **Service account** — Cloud Build runs as Cloud Build SA (grant needed roles)
- **Private pool** — Cloud Build workers in your VPC (access private resources)

## Checklist
- [ ] Images tagged with commit SHA (not `latest`)?
- [ ] Vulnerability scanning enabled in Artifact Registry?
- [ ] Cloud Deploy used for multi-environment promotion?
- [ ] Build service account has least-privilege roles?
- [ ] Build cache configured to speed up repetitive builds?
- [ ] Private pool used if builds need VPC resource access?

## Output Format
- 🔴 **Critical** — pushing to `latest` tag only (no traceability), no vulnerability scanning
- 🟡 **Warning** — no canary/blue-green for production (risky deploys), no build caching
- 🟢 **Suggestion** — Cloud Deploy for progressive delivery, Artifact Analysis for image scanning

## Exam Tips
- Cloud Build = CI (build, test, push); Cloud Deploy = CD (promote through environments)
- Artifact Registry replaces Container Registry (gcr.io is legacy)
- `cloudbuild.yaml` steps run sequentially unless `waitFor` specified
- Cloud Deploy canary = partial traffic shift; blue/green = full switch
- Private pool = Cloud Build workers inside your VPC (needed for private Artifact Registry/GKE)
- Substitutions: `$PROJECT_ID`, `$SHORT_SHA`, `$BRANCH_NAME` available by default
