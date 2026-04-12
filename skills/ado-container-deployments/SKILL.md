---
name: ado-container-deployments
description: Use when implementing container CI/CD on Azure DevOps — Docker image builds with caching, pushing to Azure Container Registry, deploying to AKS with Helm or kubectl, and image promotion across environments.
---

# ADO Container Deployments

## When to Use
- Building and pushing Docker images via Azure Pipelines
- Deploying containers to AKS or Azure Container Apps
- Implementing image promotion (dev image tag → staging tag → prod tag on same digest)
- Setting up Helm chart deployments via pipelines
- Managing multi-stage Docker builds in CI
- Adding vulnerability scanning to container pipelines

## Core Jobs

### 1. Docker Build & Push to ACR
```yaml
variables:
  acrName: myregistry
  imageRepository: myapp
  tag: $(Build.BuildId)
  acrLoginServer: $(acrName).azurecr.io

stages:
  - stage: Build
    jobs:
      - job: BuildAndPush
        pool:
          vmImage: ubuntu-latest
        steps:
          # Login to ACR using service connection (not admin credentials)
          - task: Docker@2
            displayName: Login to ACR
            inputs:
              command: login
              containerRegistry: ACR-ServiceConnection

          # Build with layer caching pulled from registry
          - task: Docker@2
            displayName: Build image
            inputs:
              command: build
              repository: $(acrLoginServer)/$(imageRepository)
              tags: |
                $(tag)
                latest
              arguments: >
                --cache-from $(acrLoginServer)/$(imageRepository):latest
                --build-arg BUILDKIT_INLINE_CACHE=1

          # Push image and cache layers
          - task: Docker@2
            displayName: Push image
            inputs:
              command: push
              repository: $(acrLoginServer)/$(imageRepository)
              tags: |
                $(tag)
                latest

          # Output the image tag for use in deploy stages
          - script: echo "##vso[task.setvariable variable=imageTag;isOutput=true]$(tag)"
            name: setImageTag
```

### 2. Deploy to AKS with kubectl and KubernetesManifest
```yaml
- stage: Deploy_Dev
  dependsOn: Build
  variables:
    imageTag: $[stageDependencies.Build.BuildAndPush.outputs['setImageTag.imageTag']]
  jobs:
    - deployment: DeployAKS
      environment: dev.myapp-namespace   # format: environment-name.kubernetes-namespace
      strategy:
        runOnce:
          deploy:
            steps:
              - checkout: none   # not needed for deploy

              - task: KubernetesManifest@1
                displayName: Deploy to AKS
                inputs:
                  action: deploy
                  kubernetesServiceConnection: AKS-Dev-ServiceConnection
                  namespace: myapp
                  manifests: |
                    kubernetes/deployment.yaml
                    kubernetes/service.yaml
                    kubernetes/ingress.yaml
                  containers: |
                    $(acrLoginServer)/$(imageRepository):$(imageTag)
                  # KubernetesManifest automatically substitutes image tag in manifests
```

### 3. Helm Deployments
```yaml
- task: HelmDeploy@0
  displayName: Helm upgrade --install
  inputs:
    connectionType: Kubernetes Service Connection
    kubernetesServiceEndpoint: AKS-Dev-ServiceConnection
    namespace: myapp
    command: upgrade
    chartType: FilePath
    chartPath: helm/myapp
    releaseName: myapp
    overrideValues: |
      image.repository=$(acrLoginServer)/$(imageRepository)
      image.tag=$(imageTag)
      replicaCount=2
      resources.requests.memory=256Mi
    install: true         # install if release does not exist yet
    waitForExecution: true
    arguments: --atomic --timeout 5m   # auto-rollback if deploy fails within 5 minutes
```

### 4. Image Promotion Across Environments
```yaml
# Core principle: build once, promote the same image digest across environments
# Never rebuild the image for staging or production — different build = untested binary

stages:
  - stage: Build
    jobs:
      - job: Build
        steps:
          - task: Docker@2
            inputs:
              command: buildAndPush
              repository: $(acrLoginServer)/$(imageRepository)
              tags: $(Build.BuildId)

  - stage: Promote_Staging
    dependsOn: Build
    jobs:
      - job: PromoteToStaging
        steps:
          # Retag for staging — same image digest, new tag, no rebuild
          - task: AzureCLI@2
            inputs:
              azureSubscription: Azure-ServiceConnection
              scriptType: bash
              scriptLocation: inlineScript
              inlineScript: |
                az acr import \
                  --name $(acrName) \
                  --source $(acrLoginServer)/$(imageRepository):$(Build.BuildId) \
                  --image $(imageRepository):staging-$(Build.BuildId) \
                  --force

  - stage: Promote_Production
    dependsOn: Promote_Staging
    condition: and(succeeded(), eq(variables['Build.SourceBranch'], 'refs/heads/main'))
    jobs:
      - deployment: PromoteToProduction
        environment: production   # human approval gate configured here
        strategy:
          runOnce:
            deploy:
              steps:
                - task: AzureCLI@2
                  inputs:
                    azureSubscription: Azure-ServiceConnection
                    scriptType: bash
                    scriptLocation: inlineScript
                    inlineScript: |
                      # Tag with both versioned and stable tags
                      az acr import \
                        --name $(acrName) \
                        --source $(acrLoginServer)/$(imageRepository):staging-$(Build.BuildId) \
                        --image $(imageRepository):prod-$(Build.BuildId) \
                        --image $(imageRepository):latest-stable \
                        --force
```

### 5. Container Vulnerability Scanning
```yaml
# Scan image for CVEs before deploying to any environment
- task: AzureCLI@2
  displayName: Check Defender for Containers findings
  inputs:
    azureSubscription: Azure-ServiceConnection
    scriptType: bash
    scriptLocation: inlineScript
    inlineScript: |
      # Query Security Center for image scan results
      az security assessment list \
        --filter "name eq 'Container image vulnerability scan'" \
        --query "[?contains(resourceDetails.id, '$(acrName)')]" \
        --output table

# Using Trivy (open source — runs as pipeline step, no external service)
- script: |
    docker pull aquasec/trivy:latest
    docker run --rm \
      -v /var/run/docker.sock:/var/run/docker.sock \
      aquasec/trivy:latest image \
      --exit-code 1 \
      --severity HIGH,CRITICAL \
      --ignore-unfixed \
      $(acrLoginServer)/$(imageRepository):$(Build.BuildId)
  displayName: Scan image with Trivy
  # exit-code 1 fails the pipeline if HIGH or CRITICAL CVEs found
```

### 6. Azure Container Apps Deployment
```yaml
# For Container Apps (simpler alternative to AKS for stateless workloads)
- task: AzureCLI@2
  displayName: Deploy to Container Apps
  inputs:
    azureSubscription: Azure-ServiceConnection
    scriptType: bash
    scriptLocation: inlineScript
    inlineScript: |
      az containerapp update \
        --name myapp \
        --resource-group myapp-rg \
        --image $(acrLoginServer)/$(imageRepository):$(Build.BuildId) \
        --set-env-vars "APP_VERSION=$(Build.BuildId)"

      # Wait for deployment to complete and check health
      az containerapp revision list \
        --name myapp \
        --resource-group myapp-rg \
        --query "[0].{Name:name,Replicas:properties.replicas,Active:properties.active}" \
        --output table
```

## Key Concepts
- **ACR (Azure Container Registry)** — Azure-native private registry; integrates with AKS natively via managed identity; no credentials needed when both in same subscription
- **KubernetesManifest task** — deploys K8s manifests with automatic image tag substitution; tracks deployments in ADO environments
- **Image promotion** — retag same image digest for different environments using `az acr import`; ensures identical bits are tested and deployed
- **`--atomic` Helm flag** — automatically rolls back a Helm release if deployment fails within the timeout; critical for production stability
- **Environment namespace format** — `environment: dev.myapp-namespace` tracks deployments at Kubernetes namespace granularity in ADO environments tab
- **BuildKit inline cache** — stores Docker layer cache in the registry itself using `--build-arg BUILDKIT_INLINE_CACHE=1`; subsequent builds reuse layers without a separate cache registry

## Checklist
- [ ] Docker builds use `--cache-from` for registry-based layer caching?
- [ ] ACR service connection uses managed identity or service principal (not ACR admin account)?
- [ ] Image promotion used across environments (retag, not rebuild) — same digest guaranteed?
- [ ] Helm deployments use `--atomic` flag for automatic rollback on failure?
- [ ] Container image scanned for HIGH/CRITICAL CVEs before deploying to production?
- [ ] AKS deployments use `KubernetesManifest` task for ADO environment tracking?
- [ ] `checkout: none` in deploy jobs (source code not needed to deploy an image)?

## Key Outputs
- Docker build pipeline with registry-based layer caching and ACR push in one stage
- Helm or kubectl deployment to AKS with ADO environment deployment tracking
- Image promotion pipeline (build once in CI, promote digest across dev/staging/prod)
- Trivy or Defender vulnerability scan as a quality gate before production deployment

## Output Format
- 🔴 **Critical** — using ACR admin account in service connection (single set of credentials, hard to rotate), no vulnerability scan before production, rebuilding the image for each environment (different binary than what was tested)
- 🟡 **Warning** — no Docker layer caching configured (full rebuild on every run, slow), Helm deployed without `--atomic` (partially failed releases left in broken state with no auto-rollback)
- 🟢 **Suggestion** — use `--cache-from` for 50-80% faster Docker builds on unchanged layers, add Trivy scan as quality gate to catch CVEs before they reach production, use `az acr import` for image promotion to guarantee immutable image across environments

## Anti-Patterns
- Using ACR admin username and password in service connection — a single non-rotatable credential with full registry access
- Rebuilding the Docker image for staging and production instead of promoting the dev image — the binary in production has never been tested
- Helm deploy without `--atomic` — a failed upgrade leaves the release in a partially updated state with no automatic recovery
- Pulling `:latest` tag from registry in deployment manifests — non-deterministic, a new image push during deployment can cause split-brain clusters
- Running vulnerability scans only locally before push, not in the pipeline — bypassed by any developer

## Integration
- `ado-pipeline-design` — structure the container build and deploy pipeline with proper stage dependencies
- `ado-release-management` — add approval gates and Azure Monitor checks to container deployment stages
- `ado-pipeline-security` — harden ACR service connection permissions and scan images for vulnerabilities
- `ado-pipelines-ops` — create service connections for ACR and AKS with appropriate RBAC roles
