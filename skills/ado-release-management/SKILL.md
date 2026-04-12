---
name: ado-release-management
description: Use when implementing release management on Azure DevOps — deployment gates (quality gates), pre/post-deployment approvals, deployment rings, rollback strategies, deployment freeze windows, and multi-environment promotion.
---

# ADO Release Management

## When to Use
- Need quality gates before production deployment (smoke tests, monitor alerts)
- Implementing staged rollout (dev → staging → prod with approvals)
- Setting up deployment freeze windows for production
- Designing rollback strategy for failed deployments
- Implementing deployment rings (canary → early adopter → broad)
- Preventing concurrent deployments racing to the same environment

## Core Jobs

### 1. Environment Approvals & Checks
```yaml
# azure-pipelines.yml — production stage uses environment with checks
stages:
  - stage: Deploy_Prod
    jobs:
      - deployment: DeployProd
        environment: production   # approvals and checks configured on this environment in UI
        strategy:
          runOnce:
            deploy:
              steps:
                - download: current
                  artifact: drop
                - task: AzureWebApp@1
                  inputs:
                    appName: myapp-prod
```

**Configure via UI:** Pipelines → Environments → production → Approvals and checks:
- **Approvals** — add approvers (individuals or groups), set timeout, add instructions for approver
- **Branch control** — only allow deployment from `main` or `release/*` branches
- **Exclusive lock** — only one deployment at a time (prevents concurrent deploy race conditions)
- **Azure Monitor alerts** — must have no active alerts before deploying (automated health gate)

### 2. Gates (Quality Gates)
```yaml
# Classic release pipeline gates — automated pre/post-deployment checks
# Pre-deployment gate: Azure Monitor alert query
Gate: Azure Monitor
  Query: "customEvents | where name == 'AppError' | where timestamp > ago(30m)"
  Threshold: fewer than 5 errors in 30-minute window
  Sampling interval: 5 minutes
  Timeout: 30 minutes (fail if not passing within timeout)

# REST API gate — call any endpoint as gate
Gate: Invoke REST API
  URL: https://api.myapp.com/health
  Success criteria: eq(root['status'], 'healthy')
  Sampling interval: 10 minutes
```

**YAML pipeline equivalent — environment checks:**
```yaml
# In YAML pipelines, add gates via environment checks (not pipeline YAML)
# Pipelines → Environments → production → Approvals and checks:
#   "Invoke Azure Function" — run custom logic, return pass/fail
#   "Query Azure Monitor" — check alert state before deploy
#   "Required template" — enforce pipeline template usage
```

### 3. Deployment Rings Pattern
```yaml
stages:
  - stage: Ring0_Canary
    displayName: Ring 0 - Canary (5% traffic)
    jobs:
      - deployment: DeployCanary
        environment: canary
        strategy:
          canary:
            increments: [10, 20]
            preDeploy:
              steps:
                - script: echo "Deploying to canary ring"
            postRouteTraffic:
              steps:
                - task: AzureMonitor@1
                  inputs:
                    connectedServiceName: Azure-ServiceConnection
                    # Monitor error rate for 10 minutes at each increment
            on:
              failure:
                steps:
                  - script: echo "Canary unhealthy — initiating rollback"

  - stage: Ring1_EarlyAdopters
    displayName: Ring 1 - Early Adopters (20%)
    dependsOn: Ring0_Canary
    condition: and(succeeded(), eq(variables['canaryHealthy'], 'true'))
    jobs:
      - deployment: DeployEarlyAdopters
        environment: early-adopters

  - stage: Ring2_Production
    displayName: Ring 2 - Production (100%)
    dependsOn: Ring1_EarlyAdopters
    condition: succeeded()
    jobs:
      - deployment: DeployProduction
        environment: production  # approval gate here
```

### 4. Rollback Strategy
```yaml
# Option 1: Redeploy previous artifact (universal — works for any app type)
- stage: Rollback
  condition: failed()   # trigger automatically if deploy stage failed
  jobs:
    - deployment: RollbackDeploy
      environment: production
      strategy:
        runOnce:
          deploy:
            steps:
              - download: specific
                pipeline: $(Build.DefinitionId)
                buildVersionToDownload: latestFromBranch
                branchName: refs/heads/main
                artifact: drop
              - task: AzureWebApp@1
                inputs:
                  appName: myapp-prod
                  package: $(Pipeline.Workspace)/drop/*.zip

# Option 2: Slot swap rollback (Azure App Service — instant, zero-downtime)
- task: AzureAppServiceManage@0
  displayName: Swap slots to rollback
  inputs:
    action: 'Swap Slots'
    azureSubscription: Azure-ServiceConnection
    appName: myapp-prod
    sourceSlot: production
    targetSlot: staging   # swap back to known-good staging version
```

### 5. Deployment Freeze Windows
```bash
# Option 1: Branch protection — block merges to main during freeze
# Create branch protection rule preventing PRs to main for freeze period
# Environment check "Branch control" then prevents deploys from non-main branches

# Option 2: Azure Function gate — check maintenance calendar
# Add "Invoke Azure Function" check on production environment
# Function returns 200 = allowed, 4xx = blocked with reason message

# Option 3: Manual approval with informational message to approvers
# Approval check instructions: "Deployment freeze active until [date].
#   Contact devops@ for emergency override. Log override reason in ticket."

# Option 4: Schedule-based gate using pipeline schedule
schedules:
  - cron: '0 2 * * 1-5'   # weekdays 2am only
    displayName: Nightly deploy window
    branches:
      include: [main]
    always: false   # only run if there are changes
```

### 6. Multi-Environment Promotion Pattern
```yaml
# Promotion: same artifact, progressive environments
variables:
  artifactVersion: $(Build.BuildId)

stages:
  - stage: Build
    jobs:
      - job: Build
        steps:
          - task: PublishPipelineArtifact@1
            inputs:
              artifactName: release-$(artifactVersion)

  - stage: Deploy_Staging
    dependsOn: Build
    jobs:
      - deployment: DeployStaging
        environment: staging        # automated checks only
        strategy:
          runOnce:
            deploy:
              steps:
                - download: current
                  artifact: release-$(artifactVersion)
                - script: ./run-smoke-tests.sh staging

  - stage: Deploy_Production
    dependsOn: Deploy_Staging
    condition: and(succeeded(), eq(variables['Build.SourceBranch'], 'refs/heads/main'))
    jobs:
      - deployment: DeployProduction
        environment: production     # human approval + monitor gate
```

## Key Concepts
- **Deployment ring** — subset of users/infrastructure receiving a deployment first (canary → early adopter → broad)
- **Gate** — automated quality check that must pass before/after deployment; polled on interval until pass or timeout
- **Slot swap** — Azure App Service feature to swap staging/production slots instantly (zero-downtime, instant rollback)
- **Environment check** — approval, branch control, exclusive lock, or automated check tied to a deployment environment
- **Canary deployment** — route a small percentage of traffic to the new version, validate metrics, then increase
- **Blue/green deployment** — maintain two identical environments; switch all traffic at load balancer level
- **Exclusive lock** — only one pipeline run can deploy to an environment at a time; others queue or fail

## Checklist
- [ ] Every production deployment requires at least one human approval?
- [ ] Branch control check prevents non-main branches from deploying to production?
- [ ] Rollback procedure documented, tested, and runnable (not just written in Confluence)?
- [ ] Post-deployment smoke test validates key user journeys (not just HTTP 200)?
- [ ] Exclusive lock on production environment (prevents concurrent deployments)?
- [ ] Deployment freeze windows enforced via checks (not just Slack messages)?
- [ ] Deployment ring strategy defined for high-risk changes?

## Key Outputs
- Multi-environment pipeline with approval gates and automated checks on production
- Automated quality checks (Azure Monitor, smoke tests) before production deploy
- Rollback procedure runnable from pipeline (not manual steps only)
- Deployment rings for progressive rollout of high-risk or high-traffic changes

## Output Format
- 🔴 **Critical** — no approvals on production environment, no rollback strategy defined, any branch can trigger production deployment
- 🟡 **Warning** — manual-only quality checks with no automated gates, no exclusive lock configured (concurrent deploy risk), rollback requires manual steps not covered in runbook
- 🟢 **Suggestion** — add Azure Monitor gate for automated health validation, implement slot swap for zero-downtime instant rollback, use deployment rings for services with large user base

## Anti-Patterns
- Approval-only gates without automated checks (human approvers cannot verify system health metrics at approval time)
- Rollback not tested in staging (rollback procedure fails in production when needed most)
- Bypassing approval "just this once" without audit trail — document any bypass in the work item or change log
- Deploying to all environments simultaneously instead of sequentially (no staged validation opportunity)
- Classic release pipelines for new work (not version-controlled, harder to review and audit than YAML)

## Integration
- `ado-pipeline-design` — the multi-stage pipeline structure that release management builds upon
- `ado-pipeline-optimization` — optimize the build pipeline that feeds into the release
- `ado-pipelines-ops` — environments and approval infrastructure setup (creating environments, adding checks via UI)
