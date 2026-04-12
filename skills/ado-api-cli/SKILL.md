---
name: ado-api-cli
description: Use when automating Azure DevOps operations — az devops CLI, REST API calls, PAT management, service principal automation, webhooks, and scripting repeatable ADO administrative tasks.
---

# ADO REST API & CLI Automation

## When to Use
- Automating project provisioning (new team → create project, teams, areas, iterations)
- Bulk operations (add users, update permissions, create work items from CSV)
- Integrating ADO with external systems via webhooks or REST API
- Building governance scripts (audit policy compliance, report on inactive users)
- CI/CD automation scripts that interact with ADO APIs

## Core Jobs

### 1. az devops CLI Setup
```bash
# Install
pip install azure-cli
az extension add --name azure-devops

# Configure defaults
az devops configure \
  --defaults organization=https://dev.azure.com/MyOrg project=MyProject

# Authenticate
export AZURE_DEVOPS_EXT_PAT="your-pat-token"
# OR: az login (uses AAD auth)
```

### 2. PAT Management
**Create PAT (via UI):** User Settings → Personal Access Tokens → New Token

PAT scope best practices:
| Scope | Use case |
|-------|---------|
| Code (Read) | Clone repos in CI |
| Build (Read & Execute) | Trigger pipelines |
| Work Items (Read & Write) | Update work items from scripts |
| Full Access | Admin scripts — minimize lifetime (7 days) |

```bash
# List PATs via API
curl -u ":$PAT" \
  "https://vssps.dev.azure.com/MyOrg/_apis/tokens/pats?api-version=7.1-preview.1"
```

**PAT security:**
- Never commit PATs to repos — use secrets manager
- Set expiry date (max 1 year, prefer 90 days)
- Use service principal instead of PAT for long-running automation

### 3. REST API Usage
```bash
# Base URL pattern
BASE="https://dev.azure.com/MyOrg/MyProject/_apis"
AUTH=$(echo -n ":$PAT" | base64)

# List projects
curl -H "Authorization: Basic $AUTH" \
  "https://dev.azure.com/MyOrg/_apis/projects?api-version=7.1"

# Create work item
curl -X POST \
  -H "Authorization: Basic $AUTH" \
  -H "Content-Type: application/json-patch+json" \
  "https://dev.azure.com/MyOrg/MyProject/_apis/wit/workitems/\$User%20Story?api-version=7.1" \
  -d '[{"op":"add","path":"/fields/System.Title","value":"New feature"}]'

# Get pipeline runs
curl -H "Authorization: Basic $AUTH" \
  "$BASE/_apis/pipelines/1/runs?api-version=7.1"
```

### 4. Webhooks & Service Hooks
```bash
# Create webhook for pull request events
az devops service-endpoint webhooks create \
  --name "MyWebhook" \
  --url "https://myapp.com/webhook" \
  --project MyProject
```

**Common service hook events:**
- `git.push` — code pushed to branch
- `git.pullrequest.created` — PR opened
- `build.complete` — pipeline finished
- `workitem.created` / `workitem.updated` — work item changes

### 5. Python SDK Automation
```python
from azure.devops.connection import Connection
from msrest.authentication import BasicAuthentication

credentials = BasicAuthentication('', PAT)
connection = Connection(base_url=f'https://dev.azure.com/{ORG}', creds=credentials)

# Get clients
wit_client = connection.clients.get_work_item_tracking_client()
build_client = connection.clients.get_build_client()

# Create work item programmatically
from azure.devops.v7_1.work_item_tracking.models import JsonPatchOperation
patch = [JsonPatchOperation(op='add', path='/fields/System.Title', value='Bug: Login fails')]
wit_client.create_work_item(patch, project='MyProject', type='Bug')
```

Install: `pip install azure-devops`

## Key Concepts
- **PAT (Personal Access Token)** — short-lived credentials for API access; tied to user
- **Service principal** — AAD app identity for automated, user-independent access
- **REST API version** — always specify `api-version` (e.g., `7.1`); avoid `api-version=preview` in production
- **WIQL** — Work Item Query Language; use in `wit_client.query_by_wiql()`
- **Service hook** — outbound webhook from ADO to external systems on events

## Checklist
- [ ] Using service principal (not PAT) for production automation?
- [ ] PATs have minimum required scopes?
- [ ] PAT expiry dates set (90 days recommended)?
- [ ] API calls specify explicit api-version?
- [ ] Secrets stored in Azure Key Vault (not hardcoded)?
- [ ] Webhook payloads validated with shared secret?

## Key Outputs
- Automation scripts for common provisioning tasks
- Service hooks configured for integration with external systems
- PAT rotation schedule documented
- Python/bash scripts for bulk ADO operations

## Output Format
- 🔴 **Critical** — PATs committed to repos, Full Access PAT used for automation, no expiry on PATs
- 🟡 **Warning** — using PAT instead of service principal for long-running automation, no api-version specified in REST calls
- 🟢 **Suggestion** — use azure-devops Python SDK instead of raw REST calls, store scripts in `.azuredevops/` folder in repo

## Anti-Patterns
- Using personal Full Access PAT in CI/CD scripts (breaks on user offboarding)
- Hardcoding PATs in scripts (security incident waiting to happen)
- Polling ADO API in a loop (use webhooks/service hooks instead)
- Not specifying api-version (breaking changes when Microsoft updates API)

## Integration
- `ado-organization` — automate project/team provisioning
- `ado-pipelines-ops` — automate service connection and variable group creation
- `ado-security-policies` — automate security group membership and policy configuration
