---
name: azure-ad-entra
description: Use when configuring Microsoft Entra ID (Azure AD), managing app registrations, setting up Conditional Access policies, implementing PIM for privileged access, or studying for AZ-500, SC-500, or AZ-305.
---

# Azure AD / Microsoft Entra ID

## When to Use
- Designing identity architecture for Azure solutions
- Configuring app registrations, service principals, and managed identities
- Implementing Conditional Access policies for Zero Trust
- Setting up PIM (Privileged Identity Management) for just-in-time access
- Managing Azure RBAC across subscriptions, resource groups, and resources
- Preparing for AZ-500 (Azure Security), SC-500 (Cloud Security), or AZ-305 (Architect) exam

## Core Jobs

### 1. Identity Types
| Identity | Description | Use Case |
|----------|-------------|---------|
| **User** | Human identity with credentials | Employee sign-in |
| **Group** | Collection of users/service principals | RBAC assignment at scale |
| **Service Principal** | App identity in a tenant; auto-created with App Registration | Application-to-Azure auth |
| **System-assigned Managed Identity** | Identity tied to Azure resource lifecycle | VM, Function App, AKS accessing other Azure services |
| **User-assigned Managed Identity** | Standalone identity; reusable across resources | Shared identity for multiple resources |
| **B2B Guest** | External user federated with their own IdP | Partner/vendor access |
| **B2C Customer** | Consumer identity (social, custom) via Entra B2C | Customer-facing apps |

### 2. App Registrations vs Enterprise Applications
| Concept | App Registration | Enterprise Application |
|---------|-----------------|----------------------|
| Location | Tenant where app is defined | Every tenant where app is used |
| Purpose | Define app identity, permissions, redirect URIs | Consent record; user/group assignment |
| Relation | One app registration → one or more enterprise apps | Auto-created in tenant when app is used |

- **App registration**: defines `client_id`, secret/certificate, API permissions (delegated vs application)
- **Enterprise app (Service Principal)**: where you assign users/groups for SSO; where you see sign-in logs
- **Delegated permission**: app acts on behalf of signed-in user (requires user consent or admin consent)
- **Application permission**: app acts as itself with no user context (background services; requires admin consent)

### 3. Managed Identities
| Type | Lifecycle | Reuse | Best For |
|------|-----------|-------|---------|
| **System-assigned** | Deleted with resource | Cannot reuse | Simple single-resource scenarios |
| **User-assigned** | Independent | Reusable across resources | Shared identity, pre-authorization, AKS Workload Identity |

- Assign RBAC role to Managed Identity on target resource (e.g., `Storage Blob Data Contributor`)
- In code: use `DefaultAzureCredential` — automatically picks up Managed Identity token in Azure
- No credentials, no rotation, no secrets to manage

### 4. Conditional Access
- Requires: **Entra ID P1** (basic CA) or **P2** (risk-based CA with Identity Protection)
- Policy structure: **Signal** → **Decision** → **Controls**
  - Signals: user/group, application, location (IP/named location), device compliance, sign-in risk, user risk
  - Decisions: Allow, Block, Require controls
  - Controls: MFA, compliant device, hybrid Azure AD join, approved app, terms of use
- Common policies:
  - Require MFA for all users accessing Azure portal
  - Block access from non-compliant countries (named location)
  - Require compliant device for access to sensitive apps
- **Report-only mode**: evaluate policy impact without enforcing (test before apply)

### 5. PIM (Privileged Identity Management)
- Requires: **Entra ID P2**
- **Eligible roles**: user must activate to use; defines max duration + approval workflow
- **Active roles**: always active; only for break-glass or automation scenarios
- Activation flow: user requests activation → optional MFA + justification → optional approval → role active for defined period
- **PIM for Azure resources**: Just-in-time Owner/Contributor on subscriptions/resource groups
- **Access reviews**: periodic review of role assignments; auto-remove if not confirmed
- Audit: all PIM activations logged; alertable in Sentinel

### 6. Azure RBAC
| Scope Level | Example |
|-------------|---------|
| **Management Group** | All subscriptions in organization |
| **Subscription** | All resource groups in subscription |
| **Resource Group** | All resources in resource group |
| **Resource** | Single resource (e.g., one storage account) |

- Built-in roles: `Owner` (full + can grant access), `Contributor` (full except access mgmt), `Reader` (read-only)
- Custom roles: define specific actions (`Microsoft.Storage/storageAccounts/read`)
- **Deny assignments**: explicit deny overrides allow; used in Azure Blueprints/Managed Applications
- Role assignment takes ~2 minutes to propagate; retries are normal during testing

## Key Concepts
- **Managed Identity** — keyless identity for Azure resources; no credentials; RBAC-based authorization
- **Conditional Access** — policy engine: if signal matches, apply control (MFA, block, device check)
- **PIM** — just-in-time privileged access; eligible roles activated on demand with justification
- **App registration** — defines your application's identity in Entra ID; client_id, secrets, API permissions
- **B2B** — external user collaboration; federated with guest's own IdP; distinct from B2C (customers)
- **RBAC deny** — deny assignment overrides role-based allow; created by Blueprints/Managed Apps
- **DefaultAzureCredential** — Azure SDK credential chain; uses Managed Identity automatically in Azure

## Checklist
- [ ] Managed Identity used instead of service principal with secret for Azure-to-Azure auth?
- [ ] User-assigned Managed Identity when identity needs to be reused across multiple resources?
- [ ] Conditional Access policy in report-only mode before enforcement?
- [ ] PIM configured for all privileged roles (subscription Owner, Global Admin)?
- [ ] App registration permissions set to minimum required (delegated vs application correctly chosen)?
- [ ] RBAC assigned at resource group scope (not subscription) for least-privilege?
- [ ] Access reviews scheduled for privileged role assignments?

## Output Format
- 🔴 **Critical** — service principal with password secret used where Managed Identity is possible
- 🔴 **Critical** — application permissions granted without admin consent (will fail at runtime)
- 🟡 **Warning** — Conditional Access applied without report-only testing first (may lock out users)
- 🟡 **Warning** — Global Admin role permanently active (use PIM eligible assignment instead)
- 🟢 **Suggestion** — use user-assigned Managed Identity when multiple resources need the same Azure access

## Exam Tips
- **Managed Identity = no credentials to manage** — system-assigned tied to resource lifecycle; user-assigned reusable across resources
- **Conditional Access = requires Entra ID P1** — MFA enforcement, compliant device requirement, named location blocking
- **PIM = requires Entra ID P2** — eligible roles activated on-demand with justification and optional approval
- **App registration = defines permissions** — delegated (on behalf of user) vs application (app as itself); application permissions require admin consent
- **B2B = external users with their own IdP** — federated; distinct from B2C (consumer identity platform for customers)
- **RBAC deny assignments = deny overrides allow** — used in Azure Blueprints and Managed Applications to lock down resources
