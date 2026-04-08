---
name: security-command-center
description: Use when configuring Security Command Center, reviewing security findings, setting up threat detection, or managing compliance posture on GCP. Covers GCP Security Engineer domain: Managing operations (~16-22%).
---

# Security Command Center

## When to Use
- Reviewing security posture across GCP projects
- Setting up threat detection for cloud resources
- Responding to security findings
- Preparing for GCP Professional Cloud Security Engineer exam

## Core Jobs

### 1. SCC Tiers
| Tier | Features |
|------|---------|
| **Standard** | Security Health Analytics (basic), Web Security Scanner (basic) |
| **Premium** | All standard + Event Threat Detection, Container Threat Detection, Virtual Machine Threat Detection, Compliance monitoring |
| **Enterprise** | All premium + multi-cloud (AWS/Azure), SecOps integration |

### 2. Key Detection Services
- **Security Health Analytics** — detects misconfigurations (open firewall, public buckets, disabled MFA)
- **Event Threat Detection** — detects threats in Cloud Logging (brute force, crypto mining, data exfiltration)
- **Container Threat Detection** — runtime threats in GKE (reverse shell, malicious binary execution)
- **Web Security Scanner** — scans App Engine/Cloud Run/GKE for web vulnerabilities

### 3. Findings Management
- **Finding** — a security issue detected by SCC (misconfiguration or threat)
- **Severity** — CRITICAL, HIGH, MEDIUM, LOW
- **State** — ACTIVE (open), INACTIVE (resolved or muted)
- **Muting** — suppress known-acceptable findings (e.g., test environment intentional configs)
- Route findings to Pub/Sub → Cloud Functions for automated remediation

### 4. Compliance Monitoring (Premium)
- Built-in compliance dashboards: CIS, NIST, PCI-DSS, ISO 27001
- Shows which controls are passing/failing
- Export compliance reports for auditors

### 5. Automated Remediation
- Route CRITICAL/HIGH findings to Pub/Sub notification channel
- Cloud Function subscribes and takes automated action (e.g., remove public bucket ACL)
- Always log remediation actions to Cloud Audit Logs

## Key Concepts
- **Attack path simulation** — shows how an attacker could pivot from internet to sensitive data
- **Toxic combination** — SCC finding where multiple conditions together = high risk
- **Security marks** — custom labels on resources for SCC filtering/exclusion
- **Posture** — security configuration baseline applied across org/folders/projects

## Checklist
- [ ] SCC Premium enabled for threat detection?
- [ ] Finding notifications routed to Pub/Sub for automated response?
- [ ] CRITICAL/HIGH findings reviewed within SLA?
- [ ] Mute rules documented and justified (not used to hide real issues)?
- [ ] Compliance dashboard reviewed for relevant framework (CIS, PCI-DSS)?
- [ ] Security marks used to exclude non-applicable resources?

## Output Format
- 🔴 **Critical** — CRITICAL severity findings unactioned, no SCC notifications configured
- 🟡 **Warning** — using Standard tier (no Event/Container Threat Detection), no compliance monitoring
- 🟢 **Suggestion** — automated remediation via Pub/Sub→Functions for common findings

## Exam Tips
- SCC Standard = free; Premium = paid (Event/Container Threat Detection requires Premium)
- Security Health Analytics = misconfiguration; Event Threat Detection = active threats in logs
- Muting findings ≠ fixing them; only mute known-acceptable deviations
- Route findings to Pub/Sub → automate remediation (don't just notify, act)
- Compliance dashboard shows control status (passing/failing) against frameworks
- SCC findings + Cloud Audit Logs = complete picture of security posture + activity
