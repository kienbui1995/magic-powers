---
name: cloud-iam
description: Use when configuring GCP IAM roles, service accounts, org policies, Workload Identity Federation, or least-privilege access. Covers GCP Security Engineer domain: Configuring access (~22-28%) and DevOps domain: Org management (~20%).
---

# Cloud IAM

## When to Use
- Designing access control for GCP resources
- Configuring service accounts and Workload Identity Federation
- Setting org policies for compliance
- Preparing for GCP Professional Cloud Security or DevOps Engineer exam

## Core Jobs

### 1. IAM Role Types
| Type | Description | Example |
|------|-------------|---------|
| **Basic** | Project-wide: Owner, Editor, Viewer | roles/editor |
| **Predefined** | Service-specific, fine-grained | roles/bigquery.dataViewer |
| **Custom** | User-defined combination of permissions | custom/myRole |
- Always prefer **predefined** over basic; use **custom** only when predefined is too broad

### 2. Service Account Best Practices
- One service account per workload (not shared across services)
- Grant only required roles (least privilege)
- No service account keys if possible — use Workload Identity instead
- Rotate keys every 90 days if keys are required
- Disable unused service accounts

### 3. Resource Hierarchy + IAM Inheritance
- Organization → Folder → Project → Resource
- IAM policies are inherited down the hierarchy
- Lower levels can only ADD permissions, not remove inherited ones
- Grant at lowest level possible (project or resource, not org)
- Use **folders** to group projects by team/environment

### 4. Org Policies
- **Org Policy Service** — enforces guardrails across all projects in org
- Common policies: `constraints/compute.requireShieldedVm`, `constraints/iam.disableServiceAccountKeyCreation`
- Policies applied at org/folder/project level; inherited by children

### 5. Workload Identity Federation
- Allow external identities (AWS, GitHub Actions, Azure AD) to access GCP without keys
- External token → exchanged for short-lived GCP credentials via STS
- Eliminates need for long-lived service account keys for CI/CD and cross-cloud

### 6. IAM Conditions
- Add attribute-based conditions to IAM bindings
- Examples: `request.time < timestamp`, `resource.name.startsWith("projects/prod")`
- Use for time-bound access, environment-specific access

## Key Concepts
- **Principal** — who (user, service account, group, domain, allUsers)
- **Permission** — what action (`bigquery.tables.get`)
- **Role** — collection of permissions
- **Policy binding** — {principal: role} attached to a resource
- **Deny policy** — explicitly denies (overrides allow)

## Checklist
- [ ] Least privilege applied (predefined > basic roles)?
- [ ] Service accounts are per-workload (not shared)?
- [ ] No service account keys (use Workload Identity or metadata server)?
- [ ] IAM conditions used for time-bound or environment access?
- [ ] Org policies enforce guardrails at org/folder level?
- [ ] IAM audit logs (Cloud Audit Logs) enabled?

## Output Format
- 🔴 **Critical** — `roles/owner` or `roles/editor` on service accounts, service account keys committed to code
- 🟡 **Warning** — shared service accounts across services, no org policies for guardrails
- 🟢 **Suggestion** — Workload Identity Federation instead of SA keys for CI/CD

## Exam Tips
- Basic roles (Owner/Editor/Viewer) → avoid; use predefined for least privilege
- Service account keys = high risk; prefer Workload Identity or metadata server credentials
- IAM is inherited from parent → grant at lowest appropriate level
- **Deny policies** = explicitly deny overrides all allows (use for guaranteed denial)
- Org Policy ≠ IAM; Org Policy = what CAN be done (guardrails); IAM = who CAN do it
- `allUsers` / `allAuthenticatedUsers` = public access; audit carefully
