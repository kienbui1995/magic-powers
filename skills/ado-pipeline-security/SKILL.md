---
name: ado-pipeline-security
description: Use when hardening Azure Pipelines security — YAML pipeline permissions, fork build security, resource authorization, secret scanning, protected resources, and preventing pipeline-based attacks.
---

# ADO Pipeline Security

## When to Use
- Reviewing pipeline security before production use
- Hardening pipelines against secret exfiltration
- Configuring fork PR build security for open source repos
- Auditing which pipelines can access service connections
- Implementing least-privilege pipeline permissions
- Responding to a pipeline security incident or audit finding

## Core Jobs

### 1. Secret Management in Pipelines
```yaml
# WRONG — secret visible in logs even with masking in some scenarios
- script: echo "Password is $(DB_PASSWORD)"

# WRONG — secret visible in process list on the agent
- script: myapp --connection-string "$(ConnectionString)"

# CORRECT — pass as environment variable (masked in logs, not in process list)
- script: dotnet ef database update
  env:
    ConnectionStrings__Default: $(ConnectionString)  # masked in logs

# CORRECT — use az keyvault to fetch at runtime (never stored in pipeline)
- task: AzureKeyVault@2
  inputs:
    azureSubscription: Azure-ServiceConnection
    KeyVaultName: myapp-keyvault
    SecretsFilter: 'db-password,api-key'
    RunAsPreJob: true   # fetch before all jobs in the stage
```

**Secret hygiene rules:**
- Secrets from Key Vault-linked variable groups are auto-masked in logs
- Never pass secrets as command-line arguments (visible in `ps aux` on agent)
- Use environment variables to inject secrets into processes
- Enable "Audit" on secret variable groups to track access in the audit log
- Mark variables as secret in the pipeline UI — they cannot be printed even accidentally

### 2. Fork Build Security
```yaml
# For public repos — fork PRs can modify pipeline YAML (attacker-controlled)
# Restrict via Organization Settings → Pipelines → Settings:
#   "Limit variables that can be set at queue time": enabled
#   "Protect access to repositories in YAML pipelines": enabled
#   "Disable creating classic build pipelines": enabled (YAML only, auditable)

# PR trigger with fork safety
pr:
  autoCancel: true       # cancel old PR builds when new commit pushed (no resource waste)
  branches:
    include: [main]
```

**Fork PR security settings (Project Settings → Pipelines → Settings):**
- **"Comment required before running pipeline for outside contributors"** — manual maintainer review before fork PR pipeline runs; prevents malicious pipelines from auto-executing
- **Limit secrets to forks** — forks cannot access service connections or variable group secrets (enforced by default, do not disable)
- **"No access"** for fork contributions to sensitive variable groups — verify in Library → variable group → Pipeline permissions

### 3. Resource Authorization (Least-Privilege Service Connections)
```yaml
# Reference service connection in pipeline — ADO prompts for authorization on first run
# This is the expected security flow — do not skip by granting "all pipelines"
steps:
  - task: AzureWebApp@1
    inputs:
      azureSubscription: Azure-Production-ServiceConnection   # authorized pipeline-by-pipeline
      appName: myapp-prod
```

**Restrict service connection access (Azure DevOps UI):**
```
Project Settings → Service connections → [connection name] → Security
→ Remove "Allow access to all pipelines"
→ Add only specific pipelines that legitimately need this connection
```

**Service connection best practices:**
- Use service principal with minimum required RBAC role (e.g. `Contributor` on one resource group, not subscription)
- Rotate service principal credentials on a schedule (or use federated credentials — no secret to rotate)
- Never use personal account credentials in service connections (leaves when employee departs)
- Production service connections: authorize only 1-2 specific release pipelines, never "all pipelines"

### 4. YAML Pipeline Isolation
```yaml
# Container jobs — isolate pipeline job from agent host
jobs:
  - job: Build
    pool:
      vmImage: ubuntu-latest
    container: mcr.microsoft.com/dotnet/sdk:8.0   # runs in container, isolated from host
    steps:
      - script: dotnet build

# Deploy job — don't check out source code (not needed, reduces attack surface)
- stage: Deploy
  jobs:
    - deployment: DeployProd
      environment: production
      strategy:
        runOnce:
          deploy:
            steps:
              - checkout: none   # explicitly skip source checkout
              - download: current
                artifact: drop
              - task: AzureWebApp@1
```

### 5. Pipeline YAML Security Review
```yaml
# Red flags to look for in pipeline YAML review:

# 1. Inline scripts with sensitive operations (check for hardcoded values)
- script: |
    export API_KEY=abc123   # WRONG — hardcoded secret

# 2. Overly permissive chmod
- script: chmod -R 777 /app   # WRONG — unnecessary broad permissions

# 3. curl | bash patterns (supply chain risk)
- script: curl https://example.com/install.sh | bash   # WRONG — unverified code execution

# 4. Publishing artifacts that may contain secrets
- task: PublishPipelineArtifact@1
  inputs:
    targetPath: $(Build.SourcesDirectory)   # WRONG — may include .env files
    artifactName: source                    # publish only the built output, not source

# CORRECT — publish only the build output directory
- task: PublishPipelineArtifact@1
  inputs:
    targetPath: $(Build.ArtifactStagingDirectory)
    artifactName: drop
```

### 6. Audit & Compliance Checks
```bash
# List all service connections in project
az devops service-endpoint list \
  --project MyProject \
  --org https://dev.azure.com/MyOrg \
  --output table

# List all pipelines (to review which have access to sensitive connections)
az pipelines list \
  --project MyProject \
  --org https://dev.azure.com/MyOrg \
  --output table

# Show pipeline YAML for review
az pipelines show \
  --id 5 \
  --project MyProject \
  --org https://dev.azure.com/MyOrg

# Review audit log for service connection usage
az devops audit query \
  --org https://dev.azure.com/MyOrg \
  --start-time "2024-01-01T00:00:00" \
  --output table
```

## Key Concepts
- **Secret masking** — Azure DevOps automatically replaces secret variable values with `***` in pipeline logs; only works if variable is marked secret
- **Fork security** — contributors on forked repos can modify pipeline YAML; the fork pipeline runs with access to the fork's YAML, treat as untrusted code
- **Resource authorization** — a pipeline must be explicitly authorized to use service connections, agent pools, variable groups, and environments; first use triggers authorization prompt
- **Container jobs** — run pipeline job inside a Docker container for filesystem isolation from the host agent
- **Protected resources** — service connections, agent pools, variable groups, secure files, and environments with access controls configured
- **Federated credentials** — service principal authentication without a client secret; uses OIDC token from Azure DevOps (no credential to rotate or leak)

## Checklist
- [ ] No secrets hardcoded in pipeline YAML variables (use Key Vault-linked variable groups)?
- [ ] Secrets passed as environment variables to processes (not command-line arguments)?
- [ ] Fork PR builds require maintainer comment approval before running?
- [ ] Production service connections restricted to specific named pipelines (not "all pipelines")?
- [ ] Pipeline YAML stored in repo and version-controlled (auditable history)?
- [ ] `checkout: none` in deploy jobs (source code not needed at deploy time)?
- [ ] Service connections use service principal (not personal account or admin credentials)?
- [ ] No `curl | bash` patterns in pipeline scripts (supply chain risk)?

## Key Outputs
- Pipeline security review report covering secrets, permissions, fork settings, and resource authorization
- Production service connections restricted to authorized pipelines only
- Fork PR security configured to require maintainer approval before pipeline execution
- Container jobs implemented for build isolation where agent trust is a concern

## Output Format
- 🔴 **Critical** — secrets hardcoded in YAML or echoed to logs, production service connections accessible to all pipelines, fork PRs running without maintainer approval on public repos
- 🟡 **Warning** — service connections using personal account PATs instead of service principal, no periodic review of pipeline resource authorization, `curl | bash` patterns in scripts
- 🟢 **Suggestion** — use container jobs for build isolation, implement federated credentials to eliminate secret rotation, audit pipeline permissions on a quarterly schedule

## Anti-Patterns
- `echo $(SECRET_VARIABLE)` in scripts — even with masking, some debug log modes can reveal values
- "Allow all pipelines" on production service connections — any new pipeline immediately gets production access
- Classic build pipelines for new work — not version-controlled, not reviewable via PR, harder to audit
- Storing pipeline artifacts that include source code alongside build outputs (may contain sensitive config)
- Using the same service connection for dev and production (blast radius of leaked credential includes production)

## Integration
- `ado-pipeline-design` — security principles applied to the pipeline structure designed there
- `ado-pipelines-ops` — service connection setup with least-privilege RBAC roles
- `ado-security-policies` — branch policies and organization security settings that complement pipeline security
