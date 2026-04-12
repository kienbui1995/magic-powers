---
name: ado-pipeline-design
description: Use when designing Azure Pipelines YAML — multi-stage pipelines, reusable templates, conditions and expressions, matrix strategies, triggers, and pipeline dependencies for complex CI/CD workflows.
---

# ADO Pipeline Design

## When to Use
- Designing a new CI/CD pipeline for an application
- Refactoring a spaghetti pipeline to multi-stage YAML
- Creating reusable templates for multiple repos
- Setting up matrix builds for multiple platforms/versions
- Configuring complex trigger conditions

## Core Jobs

### 1. Multi-Stage Pipeline Structure
```yaml
# azure-pipelines.yml — canonical multi-stage structure
trigger:
  branches:
    include: [main, release/*]
  paths:
    exclude: [docs/**, '*.md']

pr:
  branches:
    include: [main]
  drafts: false  # don't run on draft PRs

variables:
  - group: global-config          # variable group from Library
  - name: imageRepository
    value: myapp
  - name: tag
    value: $(Build.BuildId)

stages:
  - stage: Build
    displayName: Build & Test
    jobs:
      - job: BuildJob
        pool:
          vmImage: ubuntu-latest
        steps:
          - task: UseDotNet@2
            inputs:
              version: '8.x'
          - script: dotnet build --configuration Release
          - script: dotnet test --collect:"XPlat Code Coverage"
          - task: PublishTestResults@2
            inputs:
              testResultsFiles: '**/TestResults/*.xml'
          - task: PublishPipelineArtifact@1
            inputs:
              artifactName: drop
              targetPath: $(Build.ArtifactStagingDirectory)

  - stage: Deploy_Dev
    displayName: Deploy to Dev
    dependsOn: Build
    condition: succeeded()
    jobs:
      - deployment: DeployDev
        environment: dev
        strategy:
          runOnce:
            deploy:
              steps:
                - download: current
                  artifact: drop
                - task: AzureWebApp@1
                  inputs:
                    appName: myapp-dev

  - stage: Deploy_Prod
    displayName: Deploy to Production
    dependsOn: Deploy_Dev
    condition: and(succeeded(), eq(variables['Build.SourceBranch'], 'refs/heads/main'))
    jobs:
      - deployment: DeployProd
        environment: production  # has approval gates configured in UI
        strategy:
          runOnce:
            deploy:
              steps:
                - download: current
                  artifact: drop
```

### 2. Reusable Templates
```yaml
# templates/build-steps.yml — reusable build template
parameters:
  - name: dotnetVersion
    type: string
    default: '8.x'
  - name: buildConfiguration
    type: string
    default: Release
  - name: runTests
    type: boolean
    default: true

steps:
  - task: UseDotNet@2
    inputs:
      version: ${{ parameters.dotnetVersion }}
  - script: dotnet build --configuration ${{ parameters.buildConfiguration }}
  - ${{ if parameters.runTests }}:
    - script: dotnet test --no-build

# Using the template in azure-pipelines.yml:
steps:
  - template: templates/build-steps.yml
    parameters:
      dotnetVersion: '8.x'
      runTests: false  # skip tests in hotfix
```

**Template types:**
- **Step templates** — reusable steps across jobs
- **Job templates** — reusable entire jobs
- **Stage templates** — reusable entire stages (most powerful, best for org-wide reuse)
- **Variable templates** — shared variable definitions across pipelines

### 3. Conditions & Expressions
```yaml
# Run only on main branch after successful build
condition: and(succeeded(), eq(variables['Build.SourceBranch'], 'refs/heads/main'))

# Run even if previous stage failed (e.g. cleanup stage)
condition: always()

# Run only when commit message contains a deploy keyword
condition: and(succeeded(), contains(variables['Build.SourceVersionMessage'], '[deploy]'))

# Pre-compute condition into a variable for clarity
variables:
  isMain: $[eq(variables['Build.SourceBranch'], 'refs/heads/main')]

stages:
  - stage: ProdDeploy
    condition: eq(variables.isMain, 'true')
```

### 4. Matrix Strategy
```yaml
# Test across multiple versions and OS combinations
jobs:
  - job: Test
    strategy:
      matrix:
        Linux_Python310:
          imageName: ubuntu-latest
          pythonVersion: '3.10'
        Linux_Python311:
          imageName: ubuntu-latest
          pythonVersion: '3.11'
        Windows_Python310:
          imageName: windows-latest
          pythonVersion: '3.10'
      maxParallel: 3
    pool:
      vmImage: $(imageName)
    steps:
      - task: UsePythonVersion@0
        inputs:
          versionSpec: $(pythonVersion)
      - script: pytest tests/
```

### 5. Pipeline Dependencies & Stage Outputs
```yaml
stages:
  - stage: Build
    jobs:
      - job: BuildJob
        steps:
          - script: echo "##vso[task.setvariable variable=imageTag;isOutput=true]$(Build.BuildId)"
            name: setTag

  - stage: Deploy
    dependsOn: Build
    variables:
      # Reference output from previous stage
      imageTag: $[stageDependencies.Build.BuildJob.outputs['setTag.imageTag']]
    jobs:
      - job: DeployJob
        steps:
          - script: echo "Deploying image tag $(imageTag)"
```

## Key Concepts
- **Stage** — logical phase (Build, Test, Deploy); each stage can have multiple jobs
- **Job** — runs on one agent; steps execute sequentially within a job
- **Template** — reusable YAML fragment; parameterized for flexibility; can be in same repo or a templates repo
- **Condition** — expression controlling if stage/job/step runs; defaults to `succeeded()`
- **Matrix** — runs the same job with different variable values in parallel; controlled by `maxParallel`
- **Stage output** — pass computed values between stages using `stageDependencies` + `isOutput=true`
- **Deployment job** — special job type with `environment` and deployment `strategy` (runOnce, rolling, canary)

## Checklist
- [ ] Stages reflect logical phases (Build, Test, Deploy Dev, Deploy Prod) not technical steps?
- [ ] Shared logic extracted to templates (not copy-pasted across pipelines)?
- [ ] Conditions prevent unnecessary deploys (check branch, check previous stage success)?
- [ ] Pipeline artifacts used to pass build output between stages (not rebuilding in deploy)?
- [ ] PR triggers exclude draft PRs and docs-only changes (use `paths.exclude`)?
- [ ] Stage outputs used where values need to cross stage boundaries (image tag, version)?
- [ ] `dependsOn` explicit for non-linear stage dependencies?

## Key Outputs
- Multi-stage YAML pipeline with clear Build → Test → Deploy Dev → Deploy Prod stages
- Reusable templates extracted to `templates/` directory and parameterized
- Conditions preventing prod deploys from feature branches or failed builds
- Stage output variables threaded through pipeline (e.g. image tag from build to deploy)

## Output Format
- 🔴 **Critical** — prod deploys without condition check (any branch can deploy to production), rebuilding code in deploy stage instead of using artifacts, secrets hardcoded in YAML variables
- 🟡 **Warning** — no templates (copy-paste pipeline YAML across repos), single-stage pipeline (no deployment separation), no PR trigger configuration (runs on every push including forks)
- 🟢 **Suggestion** — use matrix for multi-version/platform testing, extract common steps to stage templates, use stage outputs for image tags instead of re-querying registry

## Anti-Patterns
- Downloading source code in deploy stage and rebuilding (always use pipeline artifacts — build once)
- Conditions using `==` instead of `eq()` (YAML expression syntax is different from standard comparison)
- Single monolithic pipeline YAML file exceeding 500 lines (split into stage/job templates)
- No `paths` filter on trigger (rebuilds on every commit including documentation changes)
- Using `trigger: none` on a pipeline that should run on push (accidental manual-only pipeline)

## Integration
- `ado-release-management` — add gates and approvals to the deploy stages designed here
- `ado-pipeline-optimization` — optimize the build and test stages for speed and cost
- `ado-pipeline-security` — harden the pipeline designed here against secret exfiltration and unauthorized access
