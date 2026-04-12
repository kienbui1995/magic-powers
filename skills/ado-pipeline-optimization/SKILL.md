---
name: ado-pipeline-optimization
description: Use when improving Azure Pipelines performance — caching dependencies, parallel job strategies, artifact management between stages, test result publishing, code coverage gates, and reducing pipeline runtime.
---

# ADO Pipeline Optimization

## When to Use
- Pipeline taking more than 15 minutes and needs to be faster
- Wasting parallel job minutes on redundant work
- Test results not visible in Azure DevOps Tests tab
- Code coverage not being tracked or trending over time
- Artifact sharing between stages causing issues
- Flaky or redundant jobs increasing cost without adding value

## Core Jobs

### 1. Dependency Caching
```yaml
# npm — cache node_modules using package-lock.json as key
- task: Cache@2
  inputs:
    key: 'npm | "$(Agent.OS)" | package-lock.json'
    restoreKeys: 'npm | "$(Agent.OS)"'
    path: $(npm_config_cache)
  displayName: Cache npm packages
- script: npm ci   # use ci not install (respects lockfile, deterministic)

# NuGet — cache packages folder
- task: Cache@2
  inputs:
    key: 'nuget | "$(Agent.OS)" | **/packages.lock.json,!**/bin/**,!**/obj/**'
    restoreKeys: 'nuget | "$(Agent.OS)"'
    path: $(NUGET_PACKAGES)
  displayName: Cache NuGet packages
- task: DotNetCoreCLI@2
  inputs:
    command: restore
    feedsToUse: select

# pip — cache Python packages
- task: Cache@2
  inputs:
    key: 'pip | "$(Agent.OS)" | requirements.txt'
    restoreKeys: 'pip | "$(Agent.OS)"'
    path: $(PIP_CACHE_DIR)
  displayName: Cache pip packages
- script: pip install -r requirements.txt
```

Cache hits reduce dependency install time from 2-5 minutes down to seconds. The key must include the lockfile to invalidate when dependencies change.

### 2. Parallel Jobs Strategy
```yaml
# Run independent validation jobs in parallel within a stage
stages:
  - stage: Validate
    jobs:
      - job: Lint          # runs in parallel
        pool:
          vmImage: ubuntu-latest
        steps:
          - script: npm run lint
      - job: TypeCheck     # runs in parallel
        pool:
          vmImage: ubuntu-latest
        steps:
          - script: npm run typecheck
      - job: UnitTests     # runs in parallel
        pool:
          vmImage: ubuntu-latest
        steps:
          - script: npm test
      - job: BuildDocker   # runs in parallel
        pool:
          vmImage: ubuntu-latest
        steps:
          - script: docker build .

  - stage: IntegrationTests
    dependsOn: Validate   # waits for ALL Validate jobs to succeed
    jobs:
      - job: IntTests
        steps:
          - script: npm run test:integration
```

### 3. Test Splitting for Parallel Execution
```yaml
# Split large test suite across multiple agents
jobs:
  - job: TestSplit
    strategy:
      parallel: 4   # spin up 4 identical agents
    pool:
      vmImage: ubuntu-latest
    steps:
      - script: |
          # Azure DevOps provides these variables automatically
          # System.JobPositionInPhase: 1, 2, 3, or 4
          # System.TotalJobsInPhase: 4
          python -m pytest tests/ \
            --splits $(System.TotalJobsInPhase) \
            --group $(System.JobPositionInPhase) \
            --junitxml=test-results-$(System.JobPositionInPhase).xml
      - task: PublishTestResults@2
        inputs:
          testResultsFiles: test-results-$(System.JobPositionInPhase).xml
        condition: always()
```

### 4. Publishing Test Results & Coverage
```yaml
# Run tests with coverage collection
- task: DotNetCoreCLI@2
  inputs:
    command: test
    arguments: '--collect:"XPlat Code Coverage" --results-directory $(Agent.TempDirectory)'

# Publish test results — shows in Tests tab, required for failure visibility
- task: PublishTestResults@2
  inputs:
    testResultsFormat: VSTest
    testResultsFiles: '$(Agent.TempDirectory)/**/*.trx'
  condition: always()   # CRITICAL: publish even when tests fail, so failures show up

# Publish code coverage — shows in Coverage tab, enables trending over time
- task: PublishCodeCoverageResults@2
  inputs:
    summaryFileLocation: $(Agent.TempDirectory)/**/coverage.cobertura.xml
    pathToSources: $(Build.SourcesDirectory)/src
  condition: always()

# Optional: fail build if coverage drops below threshold
- script: |
    COVERAGE=$(python -c "import xml.etree.ElementTree as ET; \
      tree=ET.parse('coverage.cobertura.xml'); \
      root=tree.getroot(); \
      print(round(float(root.attrib['line-rate'])*100))")
    echo "Coverage: $COVERAGE%"
    [ "$COVERAGE" -ge 80 ] || (echo "Coverage below 80%!" && exit 1)
```

### 5. Build Once, Deploy Many
```yaml
# Build stage: compile and publish artifact exactly once
- stage: Build
  jobs:
    - job: BuildJob
      steps:
        - script: dotnet publish -c Release -o $(Build.ArtifactStagingDirectory)/app
        - task: PublishPipelineArtifact@1
          inputs:
            artifactName: app-package
            targetPath: $(Build.ArtifactStagingDirectory)/app

# Deploy Dev: download the SAME artifact built above
- stage: Deploy_Dev
  dependsOn: Build
  jobs:
    - deployment: DeployDev
      environment: dev
      strategy:
        runOnce:
          deploy:
            steps:
              - download: current
                artifact: app-package
              - task: AzureWebApp@1
                inputs:
                  appName: myapp-dev
                  package: $(Pipeline.Workspace)/app-package

# Deploy Prod: download the SAME artifact — identical binary that was tested
- stage: Deploy_Prod
  dependsOn: Deploy_Dev
  jobs:
    - deployment: DeployProd
      environment: production
      strategy:
        runOnce:
          deploy:
            steps:
              - download: current
                artifact: app-package  # same artifact as deployed to Dev
              - task: AzureWebApp@1
                inputs:
                  appName: myapp-prod
                  package: $(Pipeline.Workspace)/app-package
```

### 6. Pipeline Timing Analysis
```bash
# Identify slow stages via Azure DevOps REST API
az pipelines runs list \
  --pipeline-ids 5 \
  --project MyProject \
  --result succeeded \
  --top 10 \
  --output table

# Get timeline for a specific run (shows per-job durations)
az pipelines runs show \
  --id 12345 \
  --project MyProject \
  --open   # opens in browser with visual timeline

# Rules of thumb:
# Build + unit test stage: target < 10 minutes
# Integration test stage: target < 15 minutes
# Full pipeline (build through dev deploy): target < 25 minutes
```

## Key Concepts
- **Cache task** — stores and restores directories between pipeline runs; cache key must include lockfile hash to invalidate properly
- **Parallel jobs** — independent jobs in the same stage run simultaneously on separate agents; each consumes one parallel job slot
- **Pipeline artifact** — build outputs stored in Azure DevOps storage; fast download in subsequent stages without re-downloading from external sources
- **Test splitting** — distribute test files across multiple agents; `System.JobPositionInPhase` and `System.TotalJobsInPhase` identify each shard
- **Publish test results** — sends test XML to Azure DevOps for display in Tests tab; must use `condition: always()` so failures are visible
- **restoreKeys** — fallback cache keys tried in order when the exact key misses; enables partial cache hits

## Checklist
- [ ] Dependencies cached (npm/pip/nuget) — cache key includes lockfile, not just package name?
- [ ] Independent jobs running in parallel (lint, typecheck, unit tests, docker build)?
- [ ] Build artifact published once and downloaded in deploy stages (not rebuilding)?
- [ ] Test results published with `condition: always()` (visible in Tests tab even on failure)?
- [ ] Code coverage published and trending visible in Coverage tab?
- [ ] Large test suites split across parallel agents using `strategy.parallel`?
- [ ] Pipeline timeline reviewed to identify the critical path (slowest chain of stages)?

## Key Outputs
- Pipeline runtime reduced (target: less than 10 minutes for build and unit test stage)
- Test results visible in Azure DevOps Tests tab with pass/fail history
- Code coverage trending visible in Coverage tab over time
- Single build artifact reused across all deployment environments (identical binary)

## Output Format
- 🔴 **Critical** — rebuilding application in every deploy stage (slow builds, inconsistent binary), test results not published (failures invisible in UI), `npm install` instead of `npm ci` (non-deterministic)
- 🟡 **Warning** — no caching configured (reinstalling all dependencies on every run), all validation jobs sequential when they can run in parallel, cache key not including lockfile (cache never invalidates)
- 🟢 **Suggestion** — split large test suites across 4+ parallel agents, add code coverage threshold gate (fail if drops below 80%), review pipeline timeline to find the critical path bottleneck

## Anti-Patterns
- `npm install` instead of `npm ci` (ignores lockfile, produces non-deterministic installs)
- Missing `condition: always()` on PublishTestResults (coverage data missing when tests fail — least useful time)
- Downloading full source code in deploy stage and recompiling (defeats the purpose of build artifacts)
- Cache key not including lockfile — cache never invalidates when `package.json` changes
- Publishing artifacts to both drop location AND pipeline artifact (redundant, slows pipeline)
- Setting `maxParallel` too high — can exceed available parallel job slots and cause queuing

## Integration
- `ado-pipeline-design` — the pipeline structure to optimize; parallelism requires well-separated stages
- `ado-pipeline-security` — do not cache credential files or secrets alongside dependencies
