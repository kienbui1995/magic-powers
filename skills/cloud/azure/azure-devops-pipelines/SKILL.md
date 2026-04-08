---
name: azure-devops-pipelines
description: Use when building Azure Pipelines CI/CD workflows, configuring YAML pipelines, setting up deployment environments with approvals, choosing agent types, or studying for Azure DevOps Engineer Expert (AZ-400).
---

# Azure DevOps Pipelines

## When to Use
- Building CI/CD pipelines in Azure DevOps for any language or platform
- Configuring YAML pipelines with stages, jobs, and deployment strategies
- Setting up deployment environments with approval gates and checks
- Choosing between Microsoft-hosted and self-hosted agents
- Implementing secure service connections with Workload Identity Federation
- Preparing for Azure DevOps Engineer Expert (AZ-400) exam

## Core Jobs

### 1. Pipeline Structure (YAML)
```yaml
trigger:
  branches:
    include: [main]

stages:
  - stage: Build
    jobs:
      - job: BuildApp
        pool:
          vmImage: ubuntu-latest
        steps:
          - script: npm run build
          - publish: dist
            artifact: drop

  - stage: Deploy
    dependsOn: Build
    jobs:
      - deployment: DeployProd
        environment: production
        strategy:
          runOnce:
            deploy:
              steps:
                - download: current
                  artifact: drop
```
- **trigger**: branches or paths that kick off CI
- **stages**: logical phases (Build, Test, Deploy); run sequentially by default
- **jobs**: run on agents; can run in parallel within a stage
- **steps**: individual tasks or scripts within a job

### 2. Agent Pools
| Agent Type | Pros | Cons | Use When |
|------------|------|------|---------|
| **Microsoft-hosted** | Zero maintenance; fresh VM per run; multiple OS | No private network access; ephemeral (no caching) | Public endpoints, standard build/test |
| **Self-hosted** | VNet access; persistent tools cache; custom software | You manage VMs/containers | Private endpoints, AKS, SQL MI, on-prem resources |

- Microsoft-hosted images: `ubuntu-latest`, `windows-latest`, `macos-latest`
- Self-hosted: install agent on VM, container, or use VMSS agent pool (auto-scale)
- **Scale Set (VMSS) agent pool**: auto-scale self-hosted agents based on queue depth

### 3. Environments and Approvals
- **Environment** = deployment target with history, approvals, and checks
- Define environment in YAML: `environment: production` in deployment job
- **Approval checks**: require manual approval before deployment starts
- **Branch control check**: only allow deploy from `main` or `release/*` branches
- **Business hours check**: restrict deployments to specific time windows
- Environment deployment history: full audit trail of what deployed when and by whom

### 4. Deployment Strategies
```yaml
strategy:
  # Option 1: runOnce (default)
  runOnce:
    deploy:
      steps: [...]

  # Option 2: rolling
  rolling:
    maxParallel: 25%  # Update 25% of targets at a time
    deploy:
      steps: [...]

  # Option 3: canary
  canary:
    increments: [10, 50]  # 10% → 50% → 100%
    deploy:
      steps: [...]
    postRouteTraffic:
      steps: [...]  # Validate before next increment
```
- `runOnce` = deploy everything at once; simple, no rollback built-in
- `rolling` = update subset of targets; reduces blast radius
- `canary` = gradual traffic shift with validation gates; best for high-traffic services

### 5. Service Connections
- **Service connection** = reusable authentication to external systems (Azure, Docker, GitHub, npm)
- Azure service connection types:
  - **Workload Identity Federation (OIDC)** — recommended; no secret rotation; uses federated credential
  - **Managed Identity** — pipeline agent's Managed Identity authenticates to Azure
  - **Service Principal (secret)** — legacy; requires secret rotation; avoid for new connections
- Create: Project Settings → Service Connections → New
- Workload Identity Federation setup: ADO creates app registration + federated credential automatically

### 6. Artifacts and Package Feeds
- **Pipeline Artifacts**: `publish`/`download` steps; pass build outputs between stages
- **Azure Artifacts**: package feed for npm, NuGet, pip, Maven, Universal Packages
  - Feed scoping: organization-level or project-level
  - Upstream sources: proxy public registries (npmjs.com, PyPI) with caching
- **Artifact retention**: configure retention policies to clean up old artifacts

### 7. Branch Policies (Azure Repos)
- **Require a minimum number of reviewers** before merge
- **Require linked work item** for traceability
- **Build validation**: CI pipeline must pass before PR can complete
- **Status checks**: require external checks (Sonar, security scan) to pass
- Apply to `main` and `release/*` branches; block direct push

## Key Concepts
- **YAML pipeline** — defined as code in repo; version-controlled; preferred over Classic UI pipelines
- **Environment** — deployment target with approval gates, history, and compliance checks
- **Workload Identity Federation** — OIDC-based service connection; no secret rotation required
- **Template** — reusable pipeline YAML; reference across projects with `extends` or `template`
- **Variable groups** — shared variables linked to pipeline; supports Key Vault-backed secrets
- **Artifact** — build output passed between stages; stored in Azure DevOps or external feed

## Checklist
- [ ] YAML pipeline used (not Classic UI pipeline) for version-controlled CI/CD?
- [ ] Workload Identity Federation configured for Azure service connections (no secrets)?
- [ ] Environments defined with approval checks for production deployments?
- [ ] Branch policies enforcing PR review + CI pass before merge to main?
- [ ] Self-hosted agents used when pipeline needs access to private network resources?
- [ ] Template references used to avoid duplicating pipeline code across projects?
- [ ] Key Vault-backed variable group used for pipeline secrets (not hardcoded values)?

## Output Format
- 🔴 **Critical** — service principal with password secret in service connection (no rotation plan)
- 🔴 **Critical** — no approval gate on production environment deployment job
- 🟡 **Warning** — Classic UI pipeline used (cannot be version-controlled; migrate to YAML)
- 🟡 **Warning** — Microsoft-hosted agent used for pipeline requiring access to private endpoints
- 🟢 **Suggestion** — use VMSS agent pool for self-hosted agents to auto-scale based on pipeline queue

## Exam Tips
- **YAML pipeline = code in repo** — version-controlled; stored alongside application code; preferred over Classic pipeline which is UI-only
- **Environment + approval gate = require manual approval before deployment to prod** — configured in environment settings; recorded in deployment history
- **Self-hosted agents = needed for private network access** — AKS private cluster, SQL Managed Instance, on-premises resources all require self-hosted
- **Workload Identity Federation = no secret rotation** — ADO creates federated credential automatically; OIDC token exchange at runtime
- **Template references = reuse pipeline code** — `template: templates/build.yml@repo` enables DRY pipelines across projects
- **Branch policies: require PR + CI pass before merge** — protect main/release branches from direct push and unvalidated changes
