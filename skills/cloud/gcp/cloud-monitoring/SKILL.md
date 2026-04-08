---
name: cloud-monitoring
description: Use when setting up Cloud Monitoring dashboards, alerting policies, log-based metrics, distributed tracing, or building SLO/SLI frameworks. Covers GCP DevOps Engineer domain: Troubleshooting (~25%) and Optimizing performance (~12%).
---

# Cloud Monitoring

## When to Use
- Setting up observability for GCP services
- Designing SLO/SLI framework and error budgets
- Troubleshooting production issues with logs and traces
- Preparing for GCP Professional Cloud DevOps Engineer exam

## Core Jobs

### 1. Observability Stack
| Tool | Purpose |
|------|---------|
| **Cloud Monitoring** | Metrics, dashboards, alerting, uptime checks |
| **Cloud Logging** | Log ingestion, storage, search, routing |
| **Error Reporting** | Auto-groups errors from logs; shows frequency/trend |
| **Cloud Trace** | Distributed tracing; latency analysis across services |
| **Cloud Profiler** | CPU and memory profiling for production code |

### 2. SLO/SLI Design
- **SLI** — what you measure (e.g., % of requests < 200ms)
- **SLO** — target for the SLI (e.g., 99.9% of requests < 200ms)
- **Error budget** — allowed failures = 1 - SLO (e.g., 0.1% = 43.8 min/month)
- Create SLOs in Cloud Monitoring with time-series data
- Alert on **error budget burn rate** (not raw error rate)

### 3. Alerting Policies
- **Condition** — metric threshold, absence, or rate of change
- **Notification channels** — email, PagerDuty, Slack, Pub/Sub, Cloud Functions
- **Alert duration** — condition must be true for N minutes before firing
- Avoid alert fatigue: alert on symptoms (slow SLO burn) not causes (high CPU)

### 4. Log-Based Metrics
- Create custom metrics from log entries matching a filter
- Counter metric: count occurrences of matching log entries
- Distribution metric: extract numeric value from log field (e.g., latency)
- Use for: custom application metrics without SDK instrumentation

### 5. Uptime Checks
- HTTP/HTTPS/TCP checks from multiple global locations
- Alert if check fails from N locations
- Use for: external SLA monitoring, health check dashboards

## Key Concepts
- **Workspace** — Cloud Monitoring scope; can monitor multiple projects
- **Log sink** — route logs to BigQuery/GCS/Pub/Sub for long-term storage/analysis
- **Log exclusions** — reduce logging costs by excluding verbose/low-value logs
- **Structured logging** — JSON logs; query specific fields in Log Explorer

## Checklist
- [ ] SLO defined for each user-facing service?
- [ ] Alerts on error budget burn rate (not raw metrics)?
- [ ] Log-based metrics for custom application events?
- [ ] Uptime checks configured for external endpoints?
- [ ] Log sinks to BigQuery for audit/compliance logs?
- [ ] Traces enabled for all services in a request path?

## Output Format
- 🔴 **Critical** — no alerting on user-facing SLOs, no structured logging (hard to query)
- 🟡 **Warning** — alerts on CPU/memory (causes) instead of latency/errors (symptoms)
- 🟢 **Suggestion** — error budget burn rate alerts, Cloud Profiler for production optimization

## Exam Tips
- SLI = metric; SLO = target; Error budget = 1 - SLO (allowed downtime)
- Alert on **burn rate** (how fast error budget is consumed) not raw error rate
- Log-based metrics = create Cloud Monitoring metrics from log entries (no SDK needed)
- Cloud Trace = distributed tracing; find slow span in a microservice call chain
- Error Reporting auto-detects exceptions from logs (no explicit integration usually needed)
- LOG_ID filter = filter specific audit log types in Cloud Logging
