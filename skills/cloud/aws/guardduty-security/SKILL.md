---
name: guardduty-security
description: Use when setting up AWS GuardDuty threat detection, managing findings, automating incident response, configuring multi-account setups, or understanding GuardDuty vs Inspector vs Security Hub. Covers AWS SCS-C02 detection and response domain.
---

# AWS GuardDuty Security

## When to Use
- Enabling and configuring AWS GuardDuty for threat detection
- Understanding and triaging GuardDuty finding types
- Automating incident response to GuardDuty findings via EventBridge + Lambda
- Managing GuardDuty across multiple AWS accounts (Organization integration)
- Distinguishing GuardDuty from Inspector, Macie, and Security Hub
- Preparing for AWS Certified Security Specialty (SCS-C02) exam

## Core Jobs

### 1. GuardDuty Data Sources

GuardDuty continuously analyzes these sources for threats:

| Data Source | What It Detects | Enabled By Default |
|-------------|----------------|-------------------|
| **AWS CloudTrail management events** | API call anomalies, suspicious CLI/console activity | Yes |
| **AWS CloudTrail S3 data events** | Suspicious S3 object access patterns | Optional (S3 Protection) |
| **VPC Flow Logs** | Network anomalies, port scanning, crypto mining traffic | Yes |
| **DNS logs** | DNS-based data exfiltration, C2 communication | Yes (EC2 only, via AWS DNS resolver) |
| **EKS audit logs** | Suspicious Kubernetes API activity, privilege escalation | Optional (EKS Protection) |
| **ECS runtime** | Container-level threat detection | Optional (ECS Runtime Monitoring) |
| **Lambda network activity** | Suspicious outbound network calls from Lambda | Optional (Lambda Protection) |
| **RDS login events** | Brute force, anomalous authentication | Optional (RDS Protection) |
| **Malware Protection** | Malware in EC2 EBS volumes or uploaded S3 objects | Optional |

GuardDuty does NOT require you to enable VPC Flow Logs or CloudTrail separately — it accesses these directly without storing logs in your account.

### 2. Finding Types

**Format**: `ThreatPurpose:ResourceAffected/ThreatFamilyName.DetectionMechanism!Artifact`

| Category | Example Finding | Meaning |
|----------|----------------|---------|
| **Reconnaissance** | `Recon:EC2/PortProbeUnprotectedPort` | Port scanning on EC2 |
| **Backdoor** | `Backdoor:EC2/C&CActivity.B` | EC2 communicating with known C2 server |
| **CryptoCurrency** | `CryptoCurrency:EC2/BitcoinTool.B` | EC2 mining cryptocurrency |
| **UnauthorizedAccess** | `UnauthorizedAccess:EC2/SSHBruteForce` | SSH brute force attempts |
| **UnauthorizedAccess** | `UnauthorizedAccess:IAMUser/TorIPCaller` | API calls from Tor exit node |
| **Stealth** | `Stealth:IAMUser/CloudTrailLoggingDisabled` | CloudTrail disabled (cover tracks) |
| **Policy** | `Policy:S3/BucketPublicAccessGranted` | S3 bucket made public |
| **Execution** | `Execution:EC2/MaliciousFile` | Malware detected on EC2 |
| **Exfiltration** | `Exfiltration:S3/ObjectRead.Unusual` | Unusual volume of S3 reads |
| **PenTest** | `PenTest:IAMUser/KaliLinux` | API calls from Kali Linux machine |

**Finding severity**:
- 🔴 **High (7.0–8.9)**: Active threat, immediate action required
- 🟡 **Medium (4.0–6.9)**: Suspicious activity, investigate
- 🟢 **Low (1.0–3.9)**: Informational, monitor

### 3. Multi-Account Management

**Administrator account** = central visibility and control:
- Sees findings from ALL member accounts
- Can enable/disable GuardDuty for member accounts
- Member accounts CANNOT disable GuardDuty themselves
- Single GuardDuty administrator account across Organization

**Setup via AWS Organizations (recommended)**:
1. Designate GuardDuty administrator account (Security/Audit account)
2. Auto-enable for all current + future member accounts
3. All findings flow to administrator account

**Manual invitation method** (non-Organizations):
- Administrator sends invitation to member account; member accepts

**Suppression rules**: Filter known-safe findings by account, region, resource type, or finding type. Suppressions apply to future findings. Suppressed findings still stored but not active.

### 4. Automated Incident Response

**Pattern**: GuardDuty finding → EventBridge rule → Lambda/SNS/SQS → automated action

```
GuardDuty finding
    ↓
EventBridge rule (filter by severity, finding type)
    ↓
SNS topic → email/Slack notification
Lambda function → automated remediation
    ↓
Actions: block IP via NACL, isolate SG, disable IAM key, snapshot EBS
```

**EventBridge rule for high-severity findings**:
```json
{
  "source": ["aws.guardduty"],
  "detail-type": ["GuardDuty Finding"],
  "detail": {
    "severity": [{"numeric": [">=", 7.0]}]
  }
}
```

**Common automated responses**:
- Crypto mining finding → block outbound traffic to mining pool IPs via NACL
- Compromised IAM key → disable access key via `iam:UpdateAccessKey`
- Malicious EC2 → isolate by replacing SG with deny-all forensic SG
- C2 communication → isolate EC2 to forensic VPC, take EBS snapshot for analysis

### 5. S3 Protection and Malware Protection

**S3 Protection**:
- Analyzes CloudTrail S3 data events for unusual access patterns
- Detects: unusual API callers, access from new geographic locations, high-volume data exfiltration
- Enable per-account (not enabled by default even when GuardDuty is enabled)

**Malware Protection for EC2**:
- Scans EBS volumes attached to EC2 when GuardDuty detects suspicious activity
- Creates EBS snapshot, attaches to GuardDuty-managed scanner instance
- Does not impact running instance performance

**Malware Protection for S3**:
- Scans objects uploaded to S3 (on new object uploads)
- Creates prefixed/tagged findings for malicious objects

### 6. Suppression vs Archiving

| Action | Effect | Use When |
|--------|--------|---------|
| **Suppress** | Future matching findings not shown in active list | Known-safe activity that generates noise |
| **Archive** | Mark individual finding as reviewed/resolved | Investigated finding; not a real threat |
| **Trust IP list** | IP addresses that GuardDuty never generates findings for | Your pen test IP ranges, internal scanners |
| **Threat IP list** | IP addresses that GuardDuty always flags | Known bad IPs specific to your environment |

## Key Concepts

- **Threat intelligence feeds** — GuardDuty uses AWS-curated threat intelligence (known bad IPs, domains, hashes) + custom lists
- **Anomaly detection** — ML-based baselines; alerts on deviations from normal behavior (new geographic access, unusual API patterns)
- **Finding retention** — findings retained for 90 days by default; archive to S3 via EventBridge for longer retention
- **GuardDuty delegated administrator** — in AWS Organizations, designate specific account to manage GuardDuty for all accounts
- **Runtime Monitoring** — installs lightweight security agent on EC2/ECS/EKS to detect runtime threats (file access, process execution, network activity)
- **Cross-region** — GuardDuty is regional; enable in every region where you have resources; aggregate via Security Hub

## Checklist

- [ ] GuardDuty enabled in ALL AWS regions (threats don't respect regional boundaries)?
- [ ] Multi-account: GuardDuty administrator account designated in AWS Organizations?
- [ ] S3 Protection enabled (not on by default)?
- [ ] EKS Protection enabled for Kubernetes workloads?
- [ ] EventBridge rules configured to route high-severity findings to incident response?
- [ ] Suppression rules documented and reviewed (know what you're filtering out)?
- [ ] Custom threat IP list added for known external threat feeds?
- [ ] Trust IP list includes pen test IP ranges (to avoid false positives during authorized tests)?

## Output Format

- 🔴 **Critical** — GuardDuty disabled in active regions; high-severity finding (CryptoCurrency, Backdoor, UnauthorizedAccess) with no response; member accounts able to disable GuardDuty (not using Organizations)
- 🟡 **Warning** — S3 Protection not enabled (S3 threats not detected); no automated response for medium/high findings; suppression rules too broad (hiding real threats)
- 🟢 **Suggestion** — Security Hub integration to aggregate GuardDuty + Inspector + Macie findings; Runtime Monitoring for deep container/EC2 threat visibility; Detective for investigation of GuardDuty findings

## Exam Tips

- **GuardDuty = threat detection (behavioral anomalies)**; **Inspector = vulnerability scanning (CVEs, network exposure)**; **Macie = PII/sensitive data discovery in S3** — different tools, different purposes
- **GuardDuty does NOT block traffic**; use Lambda + NACL/SG for automated blocking in response to findings
- **Multi-account**: administrator account sees all member account findings; members cannot disable GuardDuty (when enrolled via Organizations)
- **CryptoCurrency finding** = EC2 communicating with known cryptocurrency mining infrastructure (one of the most common exam questions)
- **EventBridge integration** = route findings to SIEM, ticketing system (Jira), Slack, or Lambda automation — this is the standard response pattern
- **Suppression rules ≠ fixing the threat** — only suppress after confirming finding is definitely not a real threat (e.g., authorized pen test activity)
- **S3 Protection must be enabled separately** — enabling GuardDuty does NOT automatically enable S3 data event analysis
- **DNS logs**: GuardDuty only analyzes DNS queries going through AWS DNS resolver (Route 53 Resolver); custom DNS servers on EC2 bypass this
