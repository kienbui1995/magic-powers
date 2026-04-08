---
name: iam-security
description: Use when designing IAM policies, troubleshooting access denied errors, implementing SCPs, permission boundaries, cross-account roles, or using IAM Access Analyzer. Covers AWS SCS-C02, SAP-C02, and DVA-C02 identity domains.
---

# AWS IAM Security

## When to Use
- Designing IAM roles, policies, and permission structures
- Troubleshooting `AccessDenied` errors in AWS
- Implementing multi-account permission guardrails with SCPs
- Using permission boundaries for delegated administration
- Setting up cross-account access with IAM roles
- Using IAM Access Analyzer to identify external resource exposure
- Preparing for AWS SCS-C02, SAP-C02, or DVA-C02 exams

## Core Jobs

### 1. IAM Policy Types

| Policy Type | Attached To | Purpose |
|-------------|------------|---------|
| **Identity policy** | IAM user, group, role | Grant permissions to the principal |
| **Resource policy** | AWS resource (S3, KMS, Lambda, etc.) | Grant/deny access from specific principals |
| **SCP (Service Control Policy)** | AWS Organizations OU or account | Set maximum permissions for member accounts |
| **Permission boundary** | IAM user or role | Maximum permissions for that IAM entity |
| **Session policy** | AssumeRole call | Limit permissions for a specific session |
| **ACL** | S3, VPC (legacy) | Cross-account resource access (legacy; avoid) |

**Key insight**: Multiple policy types can apply simultaneously. The effective permissions = intersection of what ALL applicable policies allow.

### 2. Policy Evaluation Logic

**Evaluation order** (AWS processes in this order):

1. **Explicit DENY** — from ANY policy in the evaluation context → immediately DENY (overrides everything)
2. **SCP** — if in AWS Organizations, SCP must ALLOW the action (default deny if no SCP allows)
3. **Resource-based policy** — check if the resource policy allows the principal
4. **IAM permission boundary** — the boundary must allow the action
5. **Identity policy** — the attached identity policy must allow the action
6. **Session policy** — the session policy must allow the action

**Simplified rule**: Explicit DENY wins → then all remaining policies must ALLOW → any missing allow = implicit DENY.

**Cross-account access**: Both the identity policy in Account A (allow sts:AssumeRole) AND either the role's trust policy in Account B must allow the access. Resource policies in Account B alone can grant access to Account A principals for some services (S3, KMS, SQS).

### 3. Roles vs Users

| Aspect | IAM Role | IAM User |
|--------|---------|---------|
| Credentials | Temporary (STS-issued, 1–12h) | Long-term access keys |
| Identity | Assumed by any trusted principal | Fixed individual |
| Best for | Services, cross-account, federated access | Break-glass admin, legacy CLI |
| Key rotation | Automatic (STS expiry) | Manual (must rotate) |
| Recommendation | Always prefer roles | Minimize users; use SSO instead |

**Use roles for**:
- EC2 instances accessing S3, DynamoDB (instance profile)
- Lambda functions (execution role)
- Cross-account access (assume role in another account)
- Federated access (SAML, OIDC, AWS SSO/Identity Center)

### 4. SCPs (Service Control Policies)

- Applied to AWS Organizations OUs or individual accounts
- Act as a guardrail — set the **maximum permissions** for all principals in scope
- SCPs do NOT grant permissions; they restrict what can be granted by IAM policies
- Default: `FullAWSAccess` SCP applied to root (allows everything); tighten by adding deny SCPs

**SCP deny strategy** (preferred):
```json
{
  "Effect": "Deny",
  "Action": ["ec2:TerminateInstances"],
  "Resource": "*",
  "Condition": {"StringNotEquals": {"aws:RequestedRegion": ["us-east-1", "us-west-2"]}}
}
```

**SCP allow-list strategy**: remove `FullAWSAccess` and explicitly allow only approved services. Stronger but more management overhead.

**SCPs apply to**: all IAM users and roles in the account (including root user's service calls). SCPs do NOT apply to the management (root) account of the Organization.

### 5. Permission Boundaries

- Set the **maximum permissions** for a specific IAM user or role
- Used for **delegated administration**: allow team leads to create roles but only within approved boundary
- Identity policy AND permission boundary must BOTH allow an action (intersection)
- Boundary does NOT grant permissions alone — it only limits what identity policies CAN grant

**Example**: Developer creates Lambda execution roles, but cannot escalate beyond their own permissions:
```json
{
  "Effect": "Allow",
  "Action": ["iam:CreateRole", "iam:AttachRolePolicy"],
  "Resource": "*",
  "Condition": {"StringEquals": {"iam:PermissionsBoundary": "arn:aws:iam::ACCOUNT:policy/DevBoundary"}}
}
```

### 6. Cross-Account Access Pattern

1. **Account B** creates IAM role with trust policy allowing Account A principals:
```json
{
  "Principal": {"AWS": "arn:aws:iam::ACCOUNT_A:role/app-role"},
  "Action": "sts:AssumeRole"
}
```
2. **Account A** grants its principal permission to `sts:AssumeRole` for the Account B role
3. Application calls `sts:AssumeRole` → receives temporary credentials for Account B role
4. Uses temporary credentials to make API calls in Account B

**ExternalId**: Required for third-party cross-account access (prevents confused deputy attacks). Third party provides ExternalId in AssumeRole call; role trust policy conditions on ExternalId.

### 7. IAM Access Analyzer

- Identifies resources shared with external principals (outside your account/organization)
- Analyzes: S3 buckets, KMS keys, IAM roles, Lambda functions, SQS queues, Secrets Manager secrets, SNS topics
- Types of analyzers: **Account** (external sharing from account) or **Organization** (cross-account within org)
- **Policy validation**: checks IAM policies for syntax errors and best practices
- **Policy generation**: analyze CloudTrail to generate least-privilege policy from actual usage
- Findings: Active, Archived, Resolved

## Key Concepts

- **Principal** — entity making the API call: IAM user, IAM role, AWS service, federated identity
- **Explicit DENY** — always wins, regardless of any other allow policy; used for guardrails
- **Implicit DENY** — default behavior; no allow = deny
- **Trust policy** — JSON policy attached to an IAM role defining who can assume it; separate from permission policies
- **IAM Identity Center (SSO)** — centralized access management for multiple AWS accounts; replaces per-account IAM users
- **ABAC (Attribute-Based Access Control)** — use tags to control access (`aws:ResourceTag/team` = `${aws:PrincipalTag/team}`)
- **Service-linked roles** — pre-defined by AWS service; cannot modify the trust policy; created automatically
- **Instance profile** — container for an IAM role attached to EC2 instances (EC2-specific mechanism)

## Checklist

- [ ] IAM users replaced with roles + IAM Identity Center (SSO) where possible?
- [ ] No long-term access keys on EC2/Lambda (use instance profiles and execution roles)?
- [ ] SCPs applied to restrict regions and services in member accounts?
- [ ] Permission boundaries configured for delegated admin scenarios?
- [ ] ExternalId required in trust policies for third-party cross-account roles?
- [ ] IAM Access Analyzer enabled to detect unexpected external resource sharing?
- [ ] Access policies follow least-privilege (generated from CloudTrail usage)?
- [ ] No wildcard (`*`) in Action or Resource in production policies?

## Output Format

- 🔴 **Critical** — long-term access keys on shared services/EC2 (should use instance profiles); overly permissive policies (`Action: "*"`, `Resource: "*"`); no SCPs in multi-account setup (no guardrails)
- 🟡 **Warning** — IAM users for programmatic access (prefer roles + Identity Center); no permission boundary for delegated role creation; IAM Access Analyzer not enabled
- 🟢 **Suggestion** — ABAC with resource tags for scalable access control; policy generation from CloudTrail for least-privilege; IAM policy simulation before deploying

## Exam Tips

- **Explicit DENY always wins** regardless of any allow — this is the most important IAM evaluation rule
- **SCP does NOT grant permissions**; it limits what member accounts CAN grant with their own IAM policies
- **Cross-account**: role in Account B + trust policy allowing Account A + `sts:AssumeRole` call from Account A
- **Permission boundary** = developer can only create roles within the boundary (delegation pattern without privilege escalation risk)
- **IAM Access Analyzer** = finds resources shared externally (S3, KMS, IAM roles, etc.); also validates policy syntax and generates least-privilege policies from CloudTrail
- **Service roles** (e.g., Lambda execution role) = created and managed by you; **service-linked roles** = pre-defined by AWS service, automatic creation, limited modification
- **SCPs apply to management account? NO** — SCPs do NOT apply to the AWS Organizations management (root) account itself
- **Session policies** (passed in `AssumeRole` call) = further restrict the role's permissions for that specific session only
