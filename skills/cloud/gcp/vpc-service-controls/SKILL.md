---
name: vpc-service-controls
description: Use when configuring VPC Service Controls perimeters to protect GCP services from data exfiltration, or designing access levels for conditional access. Covers GCP Security Engineer domain: Securing communications and boundary protection (~18-24%) and Ensuring data protection (~23%).
---

# VPC Service Controls

## When to Use
- Preventing data exfiltration from BigQuery, GCS, or other GCP services
- Designing security perimeters for sensitive data
- Configuring access levels for context-aware access
- Preparing for GCP Professional Cloud Security Engineer exam

## Core Jobs

### 1. VPC-SC Concepts
- **Service Perimeter** — defines a trusted boundary around GCP resources
- Resources INSIDE the perimeter can communicate freely
- Access from OUTSIDE requires an **access level** or **ingress/egress rules**
- Applies to: BigQuery, Cloud Storage, Pub/Sub, Bigtable, Spanner, and more

### 2. Service Perimeter Design
- One perimeter per security boundary (e.g., production data)
- Projects assigned to a perimeter
- Services restricted within the perimeter (list of restricted services)
- **Bridge perimeters** — allow communication between two perimeters

### 3. Access Levels (Context-Aware Access)
- Define conditions for EXTERNAL access to perimeter
- Conditions: IP range, device compliance, user identity, geographic region
- Example: allow access from corporate VPN IP range only

### 4. Ingress / Egress Rules
- **Ingress rules** — allow specific external principals/services INTO the perimeter
- **Egress rules** — allow specific data flows OUT of the perimeter
- Use for: allowing Cloud Build to access perimeter, allowing specific service accounts

### 5. Dry Run Mode
- Apply perimeter in "dry run" (report-only) mode first
- Violations logged to Cloud Audit Logs but NOT blocked
- Use to validate perimeter design before enforcing
- Switch to enforced mode once violations are understood

## Key Concepts
- **Data exfiltration** — unauthorized copying of data to external destinations
- **VPC-SC bridge** — allows two separate perimeters to communicate
- **Restricted VIP** — API endpoint (`199.36.153.8/30`) that enforces VPC-SC
- **Perimeter types** — regular (enforced) vs bridge

## Checklist
- [ ] Dry run mode enabled before enforcing perimeter?
- [ ] Access levels defined for legitimate external access?
- [ ] Ingress/egress rules configured for CI/CD and admin access?
- [ ] Restricted VIP (`restricted.googleapis.com`) configured for API access?
- [ ] Audit logs reviewed for violations before enforcement?
- [ ] Bridge perimeter set up if two perimeters need to communicate?

## Output Format
- 🔴 **Critical** — perimeter enforced without dry run testing (breaks production access)
- 🟡 **Warning** — no access levels for legitimate external principals, missing ingress rules for CI/CD
- 🟢 **Suggestion** — dry run first, then incremental enforcement per service

## Exam Tips
- VPC-SC = **data exfiltration prevention** (NOT network-level security like firewall rules)
- Always test with **dry run mode** before enforcing — avoids breaking legitimate access
- VPC-SC works at the API level (controls who calls BigQuery/GCS APIs)
- Access levels = context-aware conditions for external access (IP, device, identity)
- `restricted.googleapis.com` = VIP that enforces VPC-SC for API calls from VMs
- Bridge perimeter = two perimeters that need to share data (e.g., dev reads from prod)
