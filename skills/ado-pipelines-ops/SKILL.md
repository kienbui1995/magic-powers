---
name: ado-pipelines-ops
description: Use when managing Azure DevOps pipeline infrastructure — self-hosted agent pools, service connections, variable groups, secure files, environments, approvals, and pipeline resource governance.
---

# ADO Pipelines Operations & Infrastructure

## When to Use
- Setting up self-hosted agent pools and registering agents
- Creating and managing service connections (Azure, GitHub, Docker, etc.)
- Managing variable groups and secure files (Library)
- Configuring deployment environments with approvals and checks
- Auditing and governing pipeline resource access

## Core Jobs

### 1. Agent Pool Management
```bash
# List agent pools
az pipelines agent pool list --org https://dev.azure.com/MyOrg --output table

# List agents in pool
az pipelines agent list \
  --pool-id 5 \
  --org https://dev.azure.com/MyOrg \
  --output table
```

**Self-hosted agent registration:**
```bash
# Download agent, then configure
./config.sh \
  --url https://dev.azure.com/MyOrg \
  --auth pat \
  --token $PAT \
  --pool "SelfHosted-Linux" \
  --agent "agent-01" \
  --unattended

# Install as service
sudo ./svc.sh install
sudo ./svc.sh start
```

**Agent pool types:**
- **Microsoft-hosted** — managed, fresh VM per job, no maintenance, costs per parallel job
- **Self-hosted** — your VMs, full control, pre-installed tools, behind firewall access, no per-minute cost
- **Scale set agents** — Azure VMSS auto-scales based on demand (best of both)

### 2. Service Connections
```bash
# Create Azure Resource Manager service connection
az devops service-endpoint azurerm create \
  --azure-rm-service-principal-id $SP_ID \
  --azure-rm-subscription-id $SUB_ID \
  --azure-rm-subscription-name "Production" \
  --azure-rm-tenant-id $TENANT_ID \
  --name "Azure-Production" \
  --project MyProject

# List service connections
az devops service-endpoint list --project MyProject --output table
```

**Service connection types and use cases:**
| Type | Use case |
|------|---------|
| Azure Resource Manager | Deploy to Azure (App Service, AKS, etc.) |
| Docker Registry | Push/pull container images |
| GitHub | Checkout private repos, trigger from GitHub |
| Kubernetes | Deploy to AKS/any cluster |
| Generic | Custom REST APIs, webhooks |

**Security:** Grant "Project Collection Build Service" only — not broad contributor access.

### 3. Library — Variable Groups & Secure Files
```bash
# Create variable group
az pipelines variable-group create \
  --name "Production-Config" \
  --variables ENV=prod DB_HOST=prod.db.company.com \
  --project MyProject

# Add secret variable
az pipelines variable-group variable create \
  --group-id 5 \
  --name "DB_PASSWORD" \
  --value "secret123" \
  --secret true \
  --project MyProject
```

**Link to Azure Key Vault:**
- Variable group → Link secrets from Azure Key Vault → select secrets
- Requires service connection with Key Vault access
- Secrets auto-refresh on pipeline run

### 4. Environments & Approvals
```bash
# Create environment
az pipelines environment create \
  --name "production" \
  --project MyProject
```

**Add approval check via UI:** Environment → Approvals and checks → Add → Approvals
- Set approvers, timeout (default 30 days), instructions
- Allow pipeline to self-approve: disable for prod

**Environment resources:** VMs and Kubernetes clusters can be registered as resources for deployment target tracking.

## Key Concepts
- **Agent pool** — collection of agents that can run pipeline jobs
- **Service connection** — authenticated connection to external service (Azure, Docker, GitHub)
- **Variable group** — shared variables across multiple pipelines (vs pipeline-specific variables)
- **Secure file** — binary files (certificates, provisioning profiles) stored encrypted
- **Environment** — logical target (dev/staging/prod) with history, approvals, and resource tracking
- **Scale set agents** — auto-scaling agent pool backed by Azure VMSS

## Checklist
- [ ] Self-hosted agents using service account (not personal user)?
- [ ] Service connections using service principal (not personal PAT)?
- [ ] Service principal has minimum required permissions only?
- [ ] Secrets in Key Vault-linked variable group (not hardcoded in pipeline)?
- [ ] Production environment has approval gates?
- [ ] Agent capabilities documented (for pool selection in pipeline YAML)?

## Key Outputs
- Agent pools registered and agents online
- Service connections created with least-privilege service principals
- Variable groups with Key Vault linking for secrets
- Environments with approvals for production

## Output Format
- 🔴 **Critical** — service connection using personal PAT (breaks on offboarding), no approval on production environment, secrets hardcoded in pipeline YAML
- 🟡 **Warning** — all pipelines using single service connection (no isolation), no environment resource tracking, variable groups without Key Vault
- 🟢 **Suggestion** — use scale set agents for variable workloads, link variable groups to Key Vault, add Exclusive Lock check for sequential deployments

## Anti-Patterns
- Service connections using personal user credentials (offboarding breaks pipelines)
- Granting service principal Owner role (least-privilege: Contributor on specific RG)
- Secrets in pipeline variables instead of Key Vault-linked variable groups
- No approval gates on production deployments
- Running pipeline agents as root/admin (security risk)

## Integration
- `ado-security-policies` — control who can create/modify service connections and pipeline resources
- `ado-api-cli` — automate service connection creation and variable group management
- `azure-devops-pipelines` — YAML authoring that consumes the infrastructure set up here
