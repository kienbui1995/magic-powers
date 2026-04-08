---
name: azure-monitor
description: Use when setting up Azure observability with Log Analytics, configuring metric and log alerts, integrating Application Insights for APM, routing diagnostic logs, or studying for AZ-400 or AZ-305.
---

# Azure Monitor

## When to Use
- Setting up centralized logging and monitoring for Azure resources
- Querying logs with KQL in Log Analytics workspace
- Configuring metric alerts and log search alerts with action groups
- Integrating Application Insights for web application APM
- Routing resource diagnostic logs to Log Analytics, Storage, or Event Hub
- Preparing for Azure DevOps Engineer Expert (AZ-400) or AZ-305 exam

## Core Jobs

### 1. Azure Monitor Data Types and Sources
| Data Type | Description | Retention | Tool |
|-----------|-------------|-----------|------|
| **Metrics** | Numeric time-series (CPU %, request count) | 93 days | Metrics Explorer |
| **Logs** | Structured records (events, traces, exceptions) | 30 days default (configurable to 2 years) | Log Analytics |
| **Traces** | Distributed tracing across services | Application Insights | Application Insights |
| **Changes** | Resource configuration changes | Azure Resource Graph | Change Analysis |

- **Metrics** = lightweight, near-real-time; good for dashboards and threshold alerts
- **Logs** = rich structured data; query with KQL; better for investigation and custom alerting

### 2. Log Analytics Workspace
- Central store for all log data across Azure and on-premises
- **KQL (Kusto Query Language)** for querying:
  ```kql
  // Requests in last 1 hour, bucketed by 5 minutes
  requests
  | where timestamp > ago(1h)
  | summarize count() by bin(timestamp, 5m)
  | render timechart

  // Errors grouped by operation
  exceptions
  | where timestamp > ago(24h)
  | summarize count() by outerMessage
  | order by count_ desc
  ```
- **Workspace design**: one workspace per environment (or region) is common; cross-workspace queries supported
- **Table retention**: default 30 days; configure per-table (Basic logs = 30 days, cheap; Analytics logs = full KQL, more expensive)
- **Commitment tiers**: pay-per-GB (default) or commitment tier (e.g., 100 GB/day) for cost predictability

### 3. Application Insights
- **APM** = Application Performance Monitoring for web apps
- Tracks: HTTP requests, dependencies (SQL, HTTP), exceptions, custom events, page views, user flows
- Integration: SDK-based (add ApplicationInsights SDK) or auto-instrumentation (Azure App Service)
- Key features:
  - **Live Metrics**: real-time request and failure count
  - **Application Map**: visual dependency graph with failure rate per component
  - **Smart Detection**: ML-based anomaly detection on failure rate, response time
  - **Availability tests**: periodic synthetic requests from multiple regions
- **Sampling**: reduces telemetry volume; adaptive (auto-adjusts) or fixed-rate; does not affect metrics

### 4. Diagnostic Settings
- Every Azure resource can emit **platform logs** and **metrics** via Diagnostic Settings
- Destinations (one or more per resource):
  - **Log Analytics workspace** — for KQL querying and alerting
  - **Storage Account** — for archival (compliance, long-term)
  - **Event Hub** — for streaming to SIEM or external monitoring (Sentinel, Splunk)
- Log categories vary by resource (e.g., Storage: StorageRead, StorageWrite, StorageDelete)
- **Activity Log** = subscription-level audit log (who did what, when); auto-available; route to workspace for querying

### 5. Alerts
| Alert Type | Based On | Good For |
|------------|----------|---------|
| **Metric alert** | Metric threshold or dynamic baseline | CPU > 80%, response time spike |
| **Log search alert** | KQL query result count or value | Error count, specific log pattern |
| **Activity Log alert** | Azure resource operation | "VM deleted", "policy assignment changed" |
| **Smart Detection** | ML anomaly (App Insights) | Automatic failure rate anomaly |

- **Action groups**: reusable set of notification/automation actions (email, SMS, webhook, Logic App, Function, ITSM)
- **Alert processing rules**: suppress alerts during maintenance windows; route to different action groups
- Alert states: Fired → Acknowledged → Resolved

### 6. Workbooks
- Interactive parameterized dashboards combining metrics, logs, and visualizations
- Template gallery: available for common services (AKS, App Service, Storage)
- Share with team; supports time range parameters, subscription/resource filters
- Use for: operational dashboards, cost analysis, security posture reports

## Key Concepts
- **Azure Monitor** — platform umbrella; collects metrics + logs; powers alerts, dashboards, Application Insights
- **Log Analytics** — log store + KQL query engine; workspace-based; central for all resource logs
- **Application Insights** — APM component of Azure Monitor; SDK or auto-instrumentation; requests, dependencies, exceptions
- **Diagnostic settings** — must configure per resource to route platform logs to Log Analytics/Storage/Event Hub
- **Action group** — reusable notification target for alerts (email, webhook, Logic App)
- **KQL** — Kusto Query Language; `| where`, `| summarize`, `| project`, `| render`; same as Sentinel and Fabric

## Checklist
- [ ] Log Analytics workspace created and diagnostic settings configured for critical resources?
- [ ] Application Insights integrated for all web applications (SDK or auto-instrumentation)?
- [ ] Metric alerts configured for key health indicators (CPU, memory, response time, error rate)?
- [ ] Log search alert for application errors (exceptions > threshold per 5 minutes)?
- [ ] Activity Log routed to Log Analytics for audit and alerting on resource changes?
- [ ] Action group configured with appropriate notification channels (email, Teams webhook)?
- [ ] Alert processing rules created to suppress alerts during planned maintenance?

## Output Format
- 🔴 **Critical** — no diagnostic settings configured on critical resources (logs not collected; blind to failures)
- 🔴 **Critical** — no alerts on application error rate (failures go undetected until user reports)
- 🟡 **Warning** — Log Analytics on pay-per-GB without commitment tier for predictable high-volume ingestion
- 🟡 **Warning** — Application Insights sampling disabled on high-traffic app (cost overrun risk)
- 🟢 **Suggestion** — enable Smart Detection in Application Insights for automatic anomaly alerting

## Exam Tips
- **Azure Monitor = platform; Log Analytics = log store; Application Insights = APM** — they are layered: Application Insights sits on top of Azure Monitor; Log Analytics is the storage engine
- **KQL `| where TimeGenerated > ago(1h) | summarize count() by bin(TimeGenerated, 5m)`** — standard pattern for time-bucketed log analysis
- **Diagnostic settings = must configure per resource** — not automatic; each resource needs its own diagnostic setting to route logs to Log Analytics
- **Alert processing rules** — suppress alerts during maintenance windows or route to different action groups; separate from alert rules
- **Application Insights sampling** — reduces telemetry volume; adaptive (auto) or fixed rate; does NOT affect metrics count (only detailed records)
- **Log Analytics workspace** — centralize logs from multiple subscriptions; cross-workspace queries possible with `union workspace("ws2").TableName`
