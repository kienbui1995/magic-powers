---
name: ado-security-policies
description: Use when configuring Azure DevOps security — security groups and permissions, branch policies, PR policies, audit log review, and org/project-level security governance.
---

# ADO Security & Policies

## When to Use
- Setting up security groups and permission inheritance
- Configuring branch protection policies (required reviewers, builds, etc.)
- Reviewing audit logs for security incidents
- Implementing PR quality policies
- Least-privilege access design for projects

## Core Jobs

### 1. Security Groups & Permissions
```bash
# List security groups in project
az devops security group list --project MyProject --output table

# Add member to group
az devops security group membership add \
  --group-id $GROUP_DESCRIPTOR \
  --member-id user@company.com

# Create custom group
az devops security group create \
  --name "Release Managers" \
  --description "Can approve production releases" \
  --project MyProject
```

**Built-in groups (project level):**
| Group | Default permissions |
|-------|-------------------|
| Contributors | Read/write code, create PRs, run pipelines |
| Readers | Read-only access |
| Project Administrators | Full project control |
| Build Administrators | Manage pipelines and agent pools |
| Release Managers | Manage release pipelines |

**Principle: Use groups, not individuals.** Assign permissions to groups, add users to groups.

### 2. Branch Policies
Configure via UI: Repos → Branches → branch name → Branch policies

**Critical policies for protected branches (main/release):**
```yaml
# Key settings to enable:
Require minimum number of reviewers: 2
  Allow requestors to approve: false  # no self-approval
  Reset votes on new pushes: true
Check for linked work items: true     # traceability
Check for comment resolution: true
Limit merge strategies: Squash merge only  # clean history
Require a successful build: true
  Pipeline: [your CI pipeline]
  Trigger: Automatic on every push
```

**Bypass permissions:** Grant "Bypass policies when completing pull requests" ONLY to Release Managers group.

### 3. PR Policies
```bash
# Get policy list for a repo
az repos policy list --branch main --repository MyRepo --project MyProject --output table
```

**Useful policy types:**
- `Minimum number of reviewers` — prevents self-merge
- `Required reviewer` — force specific team review (security team, architects)
- `Work item linking` — mandatory traceability
- `Build` — CI must pass before merge
- `Comment resolution` — all PR comments must be resolved

### 4. Audit Log Review
```bash
# Get audit log (last 7 days)
az devops audit log query \
  --start-time "2026-04-01" \
  --end-time "2026-04-12" \
  --output table

# Export to file
az devops audit log query \
  --start-time "2026-04-01" \
  --output json > audit-log.json
```

**Key events to monitor:**
- `Security.ModifyPermission` — permission changes
- `Git.RefUpdatePoliciesBypassed` — branch policy bypass
- `PipelineRun.AccessSecureFile` / `PipelineRun.AccessVariableGroup` — sensitive resource access
- `Extension.Installed` / `Extension.Disabled` — marketplace changes

## Key Concepts
- **Security descriptor** — unique identifier for a security group
- **Inheritance** — child permissions inherit from parent (project → team → user); explicit deny overrides
- **Branch policy** — server-side enforcement on protected branches; cannot be bypassed without explicit grant
- **Bypass policy** — privilege allowing specific users/groups to merge without meeting policies; audit carefully
- **Audit log** — org-level activity log; 90-day retention for basic, longer with streaming to SIEM

## Checklist
- [ ] Main/release branches have branch policies enabled?
- [ ] Self-approval disabled (requestors cannot approve own PRs)?
- [ ] CI build required before merge on protected branches?
- [ ] Audit log streaming configured (SIEM or Azure Monitor)?
- [ ] Bypass policy granted to named group (not individuals, not Contributors)?
- [ ] No direct permission assignments to individuals (groups only)?

## Key Outputs
- Branch policies configured on all protected branches
- Security groups aligned to least-privilege roles
- Audit log export schedule for compliance
- PR quality policies consistently applied

## Output Format
- 🔴 **Critical** — no branch policies on main (anyone can push directly), bypass policy granted to Contributors, audit log not monitored
- 🟡 **Warning** — self-approval allowed, no required build on PRs, permissions assigned to individuals not groups
- 🟢 **Suggestion** — stream audit logs to Azure Monitor, add Required Reviewer policy for security-sensitive paths, enable work item linking for traceability

## Anti-Patterns
- Granting bypass policy to broad groups (defeats the purpose of branch policies)
- Setting minimum reviewers to 1 with self-approval allowed (= no real review)
- No audit log monitoring (security incidents go undetected)
- Permission sprawl — too many groups with overlapping permissions

## Integration
- `ado-organization` — org-level security settings (AAD, guest access)
- `ado-api-cli` — automate security group membership and policy configuration
