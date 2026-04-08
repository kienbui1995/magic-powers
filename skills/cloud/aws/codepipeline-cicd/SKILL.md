---
name: codepipeline-cicd
description: Use when building AWS CI/CD pipelines with CodePipeline/CodeBuild/CodeDeploy, choosing deployment strategies, configuring buildspec.yml, or setting up artifact management with CodeArtifact. Covers AWS DOP-C02 and DVA-C02 CI/CD domains.
---

# AWS CodePipeline CI/CD

## When to Use
- Building CI/CD pipelines with AWS CodePipeline, CodeBuild, and CodeDeploy
- Choosing between deployment strategies (In-Place, Blue/Green, Canary, Linear)
- Configuring CodeBuild buildspec.yml phases and artifacts
- Implementing approval gates and notifications in pipelines
- Managing package dependencies with CodeArtifact
- Preparing for AWS DOP-C02 or DVA-C02 exams

## Core Jobs

### 1. Pipeline Architecture

**Standard pipeline flow**:
```
Source → Build → Test → [Approval] → Deploy (Staging) → [Approval] → Deploy (Production)
```

**Pipeline stages and actions**:

| Stage | Services | Purpose |
|-------|---------|---------|
| **Source** | CodeCommit, S3, GitHub, ECR | Trigger on code/artifact change |
| **Build** | CodeBuild | Compile, test, package artifacts |
| **Test** | CodeBuild, Lambda | Integration/load tests |
| **Deploy** | CodeDeploy, ECS, CloudFormation, S3, Elastic Beanstalk | Deploy to target |
| **Approval** | Manual approval action | Human gate with SNS notification |

**Action constraints**:
- Actions in the same stage run in parallel by default
- Use `runOrder` to sequence actions within a stage (runOrder 1 before runOrder 2)
- Cross-region actions: replicate artifacts to target region's S3 first

### 2. CodeBuild — buildspec.yml

```yaml
version: 0.2

env:
  variables:
    ENV: production
  parameter-store:
    DB_PASSWORD: /myapp/db/password  # from SSM Parameter Store
  secrets-manager:
    API_KEY: myapp/api-key            # from Secrets Manager

phases:
  install:
    runtime-versions:
      nodejs: 18
    commands:
      - npm install

  pre_build:
    commands:
      - echo "Running pre-build checks..."
      - aws ecr get-login-password | docker login --username AWS --password-stdin $ECR_REGISTRY

  build:
    commands:
      - npm run build
      - npm run test
      - docker build -t $IMAGE_TAG .

  post_build:
    commands:
      - docker push $IMAGE_TAG
      - echo "Build completed"

artifacts:
  files:
    - '**/*'
  base-directory: dist
  discard-paths: no

cache:
  paths:
    - node_modules/**/*  # cache for faster builds
```

**Key sections**:
- `install`: Install runtime and tools
- `pre_build`: Authentication, setup
- `build`: Main compilation and testing
- `post_build`: Push images, notifications
- `artifacts`: Files passed to next pipeline stage
- `cache`: S3-backed cache between builds (speeds up dependency downloads)

### 3. CodeDeploy Deployment Strategies

**For EC2 / On-premises**:

| Strategy | Description | Downtime | Rollback |
|----------|------------|---------|---------|
| **In-Place (Rolling)** | Deploy to existing instances; configurable batch size | Brief (batch update) | Redeploy old version |
| **Blue/Green** | Create new ASG with new version; shift traffic via ELB | Zero downtime | Keep old ASG, redirect traffic back |

In-Place minimum health: `MinimumHealthyHosts` (percentage or count that must remain healthy during deployment).

**For AWS Lambda**:

| Strategy | Behavior |
|----------|---------|
| **AllAtOnce** | Immediately shift 100% traffic to new version |
| **Canary10Percent5Minutes** | Shift 10%, wait 5 min, shift remaining 90% |
| **Linear10PercentEvery1Minute** | Shift 10% every 1 minute (10 steps = 100% in 10 min) |
| **Linear10PercentEvery3Minutes** | Shift 10% every 3 min (30 min total) |

**For ECS (Blue/Green)**:
- CodeDeploy manages ELB target group switching
- New task set (green) created alongside original (blue)
- Traffic shifted gradually using same Lambda strategies (Canary, Linear)
- Rollback: immediate traffic shift back to original task set

### 4. CodeDeploy appspec.yml

**For EC2**:
```yaml
version: 0.0
os: linux
files:
  - source: /src
    destination: /var/www/html
hooks:
  BeforeInstall:
    - location: scripts/stop_server.sh
      timeout: 60
  AfterInstall:
    - location: scripts/install_dependencies.sh
  ApplicationStart:
    - location: scripts/start_server.sh
  ValidateService:
    - location: scripts/validate.sh
      timeout: 60
```

**For Lambda**:
```yaml
version: 0.0
Resources:
  - MyFunction:
      Type: AWS::Lambda::Function
      Properties:
        Name: MyFunction
        Alias: live
        CurrentVersion: !Ref LambdaVersion
        TargetVersion: !Ref NewLambdaVersion
Hooks:
  BeforeAllowTraffic: PreTrafficHook  # Lambda to run before traffic shift
  AfterAllowTraffic: PostTrafficHook  # Lambda to run after traffic shift
```

**Hook lifecycle order** (EC2):
ApplicationStop → DownloadBundle → BeforeInstall → Install → AfterInstall → ApplicationStart → ValidateService

### 5. Triggering Pipelines

| Source event | Pipeline trigger |
|-------------|----------------|
| CodeCommit push | EventBridge rule (automatic) |
| S3 object change | EventBridge rule |
| GitHub/Bitbucket push | CodeStar Connection webhook |
| ECR image push | **EventBridge rule** → pipeline (not direct) |
| Scheduled | EventBridge schedule → pipeline |
| Manual | Console, CLI, SDK |

**ECR push → Pipeline**: CodePipeline cannot watch ECR directly. Use EventBridge rule:
`source: aws.ecr` → `detail-type: "ECR Image Action"` → Pipeline trigger.

### 6. CodeArtifact

- Managed artifact repository: npm, Maven, PyPI, NuGet, RubyGems, Swift
- Upstream repositories: proxy public repos (npmjs.com, PyPI) with caching
- Domain: grouping of repositories; single KMS key for all repos in domain
- Cross-account: share repositories across accounts via resource policy
- Integration: CodeBuild pulls from CodeArtifact (private mirror); reduces public registry dependencies

## Key Concepts

- **Artifact** — file(s) passed between pipeline stages (S3-backed); CodePipeline manages lifecycle
- **Rollback** — CodeDeploy monitors CloudWatch alarms; triggers rollback if alarms fire during deployment
- **Deployment configuration** — named set of deployment rules (health check %, traffic shift strategy)
- **Deployment group** — set of target instances/functions for a deployment (tags, ASG, ECS service)
- **CloudFormation + CodePipeline** — CREATE_UPDATE action in pipeline for IaC deployments; supports change sets (review before apply)
- **Elastic Beanstalk** — PaaS that CodePipeline can deploy to directly; handles Blue/Green via environment swaps
- **CodeGuru Reviewer** — ML-powered code review; integrates with CodePipeline for automated review gates

## Checklist

- [ ] Manual approval gates before production deployments?
- [ ] CodeDeploy deployment alarms configured (CloudWatch → auto rollback on alarm)?
- [ ] Blue/Green deployment for zero-downtime Lambda and ECS deploys?
- [ ] buildspec.yml artifact section correctly defined for pipeline stage handoff?
- [ ] CodeBuild cache configured for dependency directories (node_modules, .m2, pip)?
- [ ] ECR push pipeline trigger via EventBridge rule (not direct ECR source)?
- [ ] CodeArtifact used as private mirror for external packages (security + availability)?
- [ ] IAM roles for CodePipeline/CodeBuild follow least-privilege principle?

## Output Format

- 🔴 **Critical** — no approval gates before production; no rollback configured for CodeDeploy (manual recovery only); CodeBuild retrieving secrets via env vars in plain text (use Secrets Manager integration)
- 🟡 **Warning** — In-Place deployment on production (downtime risk); ECR source not via EventBridge (pipeline won't trigger on image push); no CodeBuild cache (slow builds)
- 🟢 **Suggestion** — Lambda Linear traffic shifting for safer production deploys; CodeArtifact for dependency control; CodeGuru Reviewer for automated code quality gates

## Exam Tips

- **CodeDeploy appspec.yml** = deployment instructions and lifecycle hook scripts; file required for all CodeDeploy deployments
- **Blue/Green EC2** = new ASG created; traffic shifted via ELB; old ASG kept for configurable period for rollback
- **Lambda Linear10PercentEvery1Minute** = 10% traffic shifted every minute (10 steps to reach 100% in 10 minutes)
- **CodePipeline cannot trigger from ECR push directly** — use EventBridge rule (`aws.ecr` image action event) → trigger pipeline
- **buildspec.yml artifacts section** = files passed to next pipeline stage (stored in S3); missing this = next stage has no input
- **CodeDeploy minimum health** (`MinimumHealthyHosts`) = must keep X% of instances healthy during rolling deploy to production
- **Canary deployment**: 10% of traffic for validation period, then shift remaining 90% — fastest rollback if canary fails
- **appspec.yml hooks** execute scripts at each lifecycle event; hook timeouts default 3600s; best practice validate with `ValidateService` hook
