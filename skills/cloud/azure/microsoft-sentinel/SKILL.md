---
name: microsoft-sentinel
description: Use when implementing Microsoft Sentinel as SIEM/SOAR, configuring data connectors, building analytics rules, managing incidents, automating response with playbooks, or studying for SC-500 (Cloud and AI Security Engineer) or AZ-500.
---

# Microsoft Sentinel

## When to Use
- Implementing cloud-native SIEM for threat detection in Azure environments
- Connecting data sources via Sentinel data connectors
- Writing KQL analytics rules to detect security threats
- Investigating and managing security incidents
- Automating threat response with Logic App playbooks
- Preparing for SC-500 (Cloud and AI Security Engineer) or AZ-500 exam

## Core Jobs

### 1. Architecture: Sentinel on Log Analytics
- **Microsoft Sentinel** = cloud-native SIEM/SOAR built on **Log Analytics workspace**
- All data ingested into Sentinel is stored as **Log Analytics tables** (queryable with KQL)
- Key tables: `SecurityEvent`, `SigninLogs`, `AzureActivity`, `CommonSecurityLog`, `Syslog`, `OfficeActivity`
- Workspace design: dedicate a Log Analytics workspace to Sentinel (separate from monitoring workspace)
- Multi-workspace Sentinel: query across workspaces with workspace manager

### 2. Data Connectors
| Connector Type | Examples | Cost |
|----------------|---------|------|
| **Azure-native** | Entra ID, Azure Activity, Defender for Cloud, Microsoft 365 | Free ingestion |
| **Microsoft 365 Defender** | Defender for Endpoint, Office 365, Teams | Free ingestion |
| **Partner connectors** | Palo Alto, Cisco, Fortinet (via CEF/Syslog) | Log Analytics ingestion cost |
| **REST API** | Custom applications, ITSM, threat intelligence | Log Analytics ingestion cost |
| **Syslog / CEF** | Linux syslog, network devices | Log Analytics ingestion cost |

- **CEF (Common Event Format)**: standardized syslog format; Sentinel parses into structured fields
- Connector setup: enable connector → configure source → data flows into workspace tables

### 3. Analytics Rules
| Rule Type | How it Works | Customizable |
|-----------|--------------|-------------|
| **Scheduled** | KQL query runs on schedule (every 5 min to every 24h) | Yes (KQL, threshold, grouping) |
| **Near-real-time (NRT)** | KQL query runs every ~1 minute; low latency | Yes |
| **Microsoft Security** | Forward alerts from Defender products as incidents | Partially (filter by severity) |
| **Fusion** | ML correlation of multi-stage attack signals | No (always-enabled ML) |
| **Anomaly** | ML baseline behavior; detect deviations | Partially (threshold tuning) |

- Scheduled rule anatomy: KQL query → alert grouping → incident creation → tactics/techniques mapping
- MITRE ATT&CK mapping: tag rules with tactics (Initial Access, Lateral Movement) and techniques (T1078)
- **Alert grouping**: group multiple alerts into one incident by entity (account, IP, host)

### 4. Incidents
- **Incident** = auto-created from analytics rule alerts (one or more alerts grouped)
- Incident lifecycle: New → Active → Closed (True Positive / False Positive / Benign)
- **Investigation graph**: visual entity relationship map; pivot from incident to related entities
- **Entity pages**: timeline of activity for specific user, IP, or host
- Triage workflow:
  1. Review incident details (severity, entities, alerts, evidence)
  2. Run investigation graph
  3. Check related incidents and bookmarks
  4. Assign to analyst; add comments
  5. Close with classification

### 5. Workbooks
- Visual dashboards built on Sentinel data (Log Analytics tables)
- Built-in workbooks: Azure AD Sign-in logs, Azure Activity, Defender for Cloud alerts
- **MITRE ATT&CK workbook**: visualize coverage of analytics rules across tactics and techniques
- Custom workbooks: combine KQL queries with charts, grids, and parameters
- Use for: executive security dashboard, SOC analyst daily overview, compliance reporting

### 6. Playbooks (Logic Apps)
- **Playbook** = Logic App triggered by Sentinel alert or incident; automated response
- Common automations:
  - Block user in Entra ID (disable account)
  - Isolate VM from network (Defender for Endpoint response action)
  - Create ITSM ticket (ServiceNow, Jira)
  - Send Teams/email notification to SOC
  - Enrich incident with threat intelligence (VirusTotal lookup)
- Trigger options: **Incident trigger** (on incident creation) or **Alert trigger** (on each alert)
- Use Incident trigger when you need access to all grouped alerts; Alert trigger for per-alert automation

### 7. UEBA (User Entity Behavior Analytics)
- Establishes behavioral baseline per user and host
- Detects anomalies: unusual sign-in location, abnormal data access volume, atypical process execution
- UEBA insights appear on Entity pages and in Investigation graph
- Enriches incidents with behavior score (anomaly level)
- Requires enabling UEBA in Sentinel settings; syncs Entra ID user data

## Key Concepts
- **Sentinel** — cloud-native SIEM/SOAR; built on Log Analytics; all data in KQL-queryable tables
- **Data connector** — integrates log source into Sentinel workspace tables
- **Analytics rule** — KQL query that fires alerts and creates incidents when threat pattern matches
- **Incident** — grouped alerts with investigation context; assigned to analyst; closed with classification
- **Playbook** — Logic App automated response; triggered by alert or incident
- **Fusion** — always-enabled ML rule correlating multi-stage attack signals across products
- **MITRE ATT&CK** — threat framework; map rules to tactics/techniques to measure detection coverage

## Checklist
- [ ] Dedicated Log Analytics workspace created for Sentinel (separate from operational monitoring)?
- [ ] Azure-native connectors enabled (Entra ID, Azure Activity, Defender for Cloud) as baseline?
- [ ] Analytics rules created for high-priority scenarios (impossible travel, mass download, privilege escalation)?
- [ ] MITRE ATT&CK workbook reviewed to identify detection coverage gaps?
- [ ] Incident triage workflow defined (severity SLA, assignment process, closure classification)?
- [ ] Playbooks created for top 3 incident types (user block, VM isolation, ticket creation)?
- [ ] UEBA enabled and behavioral baselines established?

## Output Format
- 🔴 **Critical** — no analytics rules enabled (Sentinel ingests data but generates no alerts)
- 🔴 **Critical** — Fusion rule disabled (only way to detect ML-correlated multi-stage attacks)
- 🟡 **Warning** — too many rules with low threshold generating alert fatigue (tune alert grouping)
- 🟡 **Warning** — no playbook for high-severity incidents (manual response only; slow reaction time)
- 🟢 **Suggestion** — map all analytics rules to MITRE ATT&CK; use MITRE workbook to find coverage gaps

## Exam Tips
- **Sentinel is built on Log Analytics workspace** — all ingested data stored as Log Analytics tables; KQL is the query language throughout
- **Analytics rules generate alerts → incidents** — tune grouping window and entity grouping to reduce alert fatigue while maintaining fidelity
- **Playbooks = Logic Apps triggered by Sentinel** — automate: block user in Entra ID, isolate VM via Defender API, create ITSM ticket
- **Azure-native connectors are free; 3rd-party connectors incur Log Analytics ingestion cost** — plan data volume carefully for cost management
- **Fusion rule = ML-based multi-stage attack detection** — cannot be customized; always enabled; correlates low-severity signals into high-confidence incidents
- **MITRE ATT&CK mapping in analytics rules** — tracks detection coverage across tactics and techniques; use MITRE workbook to visualize gaps
