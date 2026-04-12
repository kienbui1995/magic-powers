---
name: ado-organization
description: Use when setting up or managing Azure DevOps organizations and projects — project creation, team structure, user management, billing, extensions, and org-level settings.
---

# ADO Organization & Project Administration

## When to Use
- Creating new Azure DevOps organization or project
- Onboarding new teams or users
- Managing billing, parallel jobs, storage limits
- Installing/managing extensions from Marketplace
- Configuring org-level policies (SSO, AAD integration, IP allowlist)

## Core Jobs

### 1. Organization Setup & AAD Integration
```bash
# Connect org to Azure Active Directory
az devops admin banner update --message "AAD integration required" --type info
# AAD connection done via Azure portal: Settings → AAD → Connect
# After: users must sign in with AAD credentials
```
Key settings:
- **AAD connection**: Org Settings → Azure Active Directory → Connect — single sign-on, conditional access
- **Guest access**: disable for security-sensitive orgs (Org Settings → Policies → Allow public projects)
- **SSH auth policy**: disable if org mandates PAT/AAD only

### 2. Project Creation & Configuration
```bash
# Create project
az devops project create \
  --name "MyProject" \
  --organization https://dev.azure.com/MyOrg \
  --process Agile \
  --visibility private

# List projects
az devops project list --organization https://dev.azure.com/MyOrg --output table
```
Process templates: **Agile** (user stories/tasks), **Scrum** (product backlog items/sprints), **CMMI** (formal change management), **Basic** (simplest, issues/tasks)

Choose process at creation — migration between processes is complex and partially supported.

### 3. Team Management
```bash
# Create team
az devops team create --name "Platform Team" --project MyProject

# Add member to team
az devops team member add \
  --team "Platform Team" \
  --members user@company.com \
  --project MyProject

# List team members
az devops team member list --team "Platform Team" --project MyProject --output table
```
Teams inherit permissions from project; additional permissions can be granted explicitly.

### 4. User Management & Licensing
```bash
# Add user to org
az devops user add \
  --email-id user@company.com \
  --license-type express \
  --org https://dev.azure.com/MyOrg

# Update license
az devops user update \
  --user user@company.com \
  --license-type stakeholder \
  --org https://dev.azure.com/MyOrg

# Remove user
az devops user remove --user user@company.com --org https://dev.azure.com/MyOrg
```
License types: **Basic** (most features), **Basic + Test Plans** (includes Azure Test Plans), **Stakeholder** (free, limited), **Visual Studio subscriber** (auto-detected)

### 5. Billing & Parallel Jobs
- Parallel jobs: paid jobs for faster CI/CD (1 free Microsoft-hosted + 1 free self-hosted)
- Check usage: Org Settings → Billing → Parallel jobs
- Storage: 2 GB free per org + 2 GB per user for Artifacts

### 6. Extensions Management
```bash
# Install extension
az devops extension install \
  --extension-id SonarSource.sonarcloud \
  --publisher-id SonarSource \
  --org https://dev.azure.com/MyOrg

# List installed
az devops extension list --org https://dev.azure.com/MyOrg --output table
```

## Key Concepts
- **Organization** — top-level container; has billing, AAD connection, global policies
- **Project** — isolated workspace with Repos, Boards, Pipelines, Artifacts
- **Team** — group within a project with its own board area, sprint, and notifications
- **Process template** — defines work item types and workflows (chosen at project creation)
- **Stakeholder** — free license with read access to boards and limited features
- **Parallel jobs** — number of CI/CD pipelines that can run simultaneously

## Checklist
- [ ] AAD connected (not using MSA for enterprise)?
- [ ] Guest access disabled or scoped?
- [ ] Public projects disabled (for private/internal orgs)?
- [ ] Users on correct license tier (Stakeholder for non-developers)?
- [ ] Process template chosen correctly at project creation?
- [ ] Billing configured with cost alerts?

## Key Outputs
- Project created with correct process template and visibility
- Teams configured with members and area assignments
- Users added with appropriate license tiers
- Org connected to AAD with SSO

## Output Format
- 🔴 **Critical** — public project visibility on private org, no AAD integration for enterprise, admin using personal MSA
- 🟡 **Warning** — all users on Basic license (check if Stakeholder suffices for non-devs), no billing alerts
- 🟢 **Suggestion** — use CLI for bulk user management, document process template choice rationale

## Anti-Patterns
- Changing process template after projects have work items (complex migration)
- Giving all users Basic license when Stakeholder covers their needs (unnecessary cost)
- Not connecting to AAD (no SSO, no conditional access, harder offboarding)
- Creating too many top-level projects (prefer teams within projects for related work)

## Integration
- `ado-security-policies` — configure org-level security after project creation
- `ado-api-cli` — automate user management and project provisioning at scale
