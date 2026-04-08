---
name: fabric-governance
description: Use when configuring Microsoft Fabric workspace security, sensitivity labels, item-level permissions, endorsement, domain management, or row-level security in semantic models. Covers DP-700 governance and security domain.
---

# Fabric Governance

## When to Use
- Configuring workspace roles and item-level permissions in Microsoft Fabric
- Applying sensitivity labels from Microsoft Purview to Fabric items
- Setting up endorsement (Promoted or Certified) for data quality signaling
- Designing domain structure and workspace organization for enterprise Fabric deployment
- Implementing row-level security (RLS) in semantic models
- Preparing for Microsoft Fabric Data Engineer Associate (DP-700) exam

## Core Jobs

### 1. Workspace Roles
| Role | Permissions |
|------|-------------|
| **Admin** | Full control: manage membership, delete workspace, publish apps, all Contributor actions |
| **Member** | Create/edit/delete items, share items, manage item permissions, all Contributor actions |
| **Contributor** | Create/edit/delete items in workspace; cannot share or manage membership |
| **Viewer** | Read and view items; cannot create or edit; no access to underlying data by default |

- Workspace roles apply to **ALL items** in the workspace — no item-level granularity at this level
- Use **item-level permissions** for selective sharing outside the workspace

### 2. Item-Level Permissions
- Share specific Fabric items (Lakehouse, Semantic Model, Report) with users outside the workspace
- Lakehouse item permissions:
  - **Read** — view metadata; cannot query data
  - **ReadData** — read data via SQL analytics endpoint or Spark
  - **ReadAll** — read all files/tables including via OneLake APIs
  - **Write** — modify Lakehouse data (for Pipelines, Dataflows writing to Lakehouse)
- Semantic model: share with Build permission to allow report creation
- Useful pattern: share Gold layer Lakehouse SQL endpoint with BI team without workspace access

### 3. OneLake Data Access Roles (Preview)
- Grant read access to **specific folders** within OneLake (sub-Lakehouse level)
- Define custom roles with path-based access (e.g., `/Tables/orders` but not `/Tables/hr_data`)
- Enables fine-grained data access without exposing entire Lakehouse
- Replaces older OneLake ACL-based access in newer Fabric experiences

### 4. Sensitivity Labels
- Source: **Microsoft Purview Information Protection** labels (e.g., Public, Confidential, Highly Confidential)
- Apply to Fabric items: Semantic Models, Reports, Lakehouses, Dataflows
- **Label inheritance** (downstream propagation):
  - Dataset/Semantic model with label → exported reports and dashboards inherit the label
  - Higher sensitivity wins when items have conflicting labels
- Labels control: encryption, access restrictions, watermarking (enforced by Purview policy)
- Tenant admin must enable label inheritance in Fabric Admin portal

### 5. Endorsement
| Level | Who can apply | Meaning |
|-------|---------------|---------|
| **Promoted** | Workspace admin or Member | Trusted within workspace; team-level signal |
| **Certified** | Designated certifier (tenant setting) | Organization-wide trusted; highest quality signal |

- Endorsement appears on item cards in Fabric workspace and Power BI service
- Certified = must be explicitly enabled by tenant admin; certifiers assigned per domain
- Endorsed items surface higher in search results

### 6. Domain Management
- **Domain** = organizational grouping of workspaces (e.g., Finance, Marketing, HR)
- Workspaces can belong to **one domain** at a time
- **Domain admin** role: manage domain settings; assign workspaces to domain
- Domain-level settings: default sensitivity labels, certification policy, delegate certifiers
- Use domains for: decentralized governance, business unit ownership, cross-workspace search scoping

### 7. Row-Level Security (RLS)
- Defined in **Semantic Model** (not Lakehouse or Warehouse directly)
- DAX filter expressions restrict rows based on `USERPRINCIPALNAME()` or role membership
- Example: `[Region] = LOOKUPVALUE(UserRegion[Region], UserRegion[Email], USERPRINCIPALNAME())`
- RLS roles assigned to Entra ID users or groups
- Dynamic RLS: single role with DAX expression; static RLS: separate roles per group
- RLS does NOT apply when querying Lakehouse SQL analytics endpoint directly (only in semantic model)

## Key Concepts
- **Workspace roles** — Admin > Member > Contributor > Viewer; apply to all items in workspace
- **Item permissions** — selective sharing of individual items with users outside workspace
- **Sensitivity label** — Purview-based classification; flows downstream to reports and exports
- **Endorsement** — Promoted (workspace-level trust) or Certified (org-level trust)
- **Domain** — logical grouping of workspaces; governance boundary for enterprise Fabric
- **RLS** — row-level security in semantic model; restricts data rows per user identity
- **OneLake data access role** — path-based access control within OneLake storage

## Checklist
- [ ] Workspace roles assigned with least privilege (Viewer for read-only consumers)?
- [ ] Item-level permissions used for sharing with users outside the workspace?
- [ ] Sensitivity labels applied to Semantic Models and Lakehouses containing sensitive data?
- [ ] Certified endorsement configured for organization-wide trusted datasets?
- [ ] Domains created to group workspaces by business unit or data domain?
- [ ] RLS implemented in Semantic Model for user-specific data filtering?
- [ ] OneLake data access roles configured for sub-Lakehouse folder-level control?

## Output Format
- 🔴 **Critical** — Viewer-role users accessing Lakehouse SQL endpoint without explicit ReadData permission (Viewer does not auto-grant data read)
- 🔴 **Critical** — RLS defined in Lakehouse (not supported); RLS only works in Semantic Model layer
- 🟡 **Warning** — sharing workspace access when item-level sharing would provide least-privilege access
- 🟡 **Warning** — sensitivity labels not propagating to exported reports (check tenant label inheritance setting)
- 🟢 **Suggestion** — implement Certified endorsement on Gold layer semantic models to guide BI users to trusted data

## Exam Tips
- **Workspace roles apply to ALL items** — Contributor can create/edit items but CANNOT share or manage workspace membership
- **Item permissions for selective sharing** — share specific Lakehouse or Semantic Model with users without granting workspace access
- **Sensitivity labels flow downstream** — labeled semantic model → labeled reports and dashboards; higher sensitivity wins
- **Certified endorsement = tenant admin must enable** — requires explicit configuration; certifiers are designated users per domain
- **OneLake data access roles** — grant read access to specific OneLake folders (sub-Lakehouse level); newer, more granular than workspace roles
- **Domain = one workspace belongs to one domain** — workspaces cannot be in multiple domains; use for organizational governance boundaries
