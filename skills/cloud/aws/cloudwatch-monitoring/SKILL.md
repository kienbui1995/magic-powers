---
name: cloudwatch-monitoring
description: Use when setting up AWS observability with CloudWatch metrics, logs, alarms, dashboards, X-Ray tracing, or CloudWatch Synthetics canaries. Covers monitoring domains across DEA-C01, DVA-C02, and DOP-C02 exams.
---

# Amazon CloudWatch Monitoring

## When to Use
- Setting up metrics, alarms, and dashboards for AWS services
- Building custom metrics from application logs using metric filters
- Implementing distributed tracing with AWS X-Ray
- Creating synthetic monitors with CloudWatch Synthetics
- Designing event-driven operations with CloudWatch Alarms + SNS/Lambda
- Preparing for AWS DEA-C01, DVA-C02, or DOP-C02 exams

## Core Jobs

### 1. CloudWatch Metrics

| Metric Type | Cost | Resolution | Examples |
|-------------|------|-----------|---------|
| **Standard metrics** | Free | 1-minute minimum | EC2 CPU, RDS connections, Lambda invocations |
| **Detailed monitoring** | Paid | 1-minute (EC2) | EC2 per-instance metrics at 1-minute granularity |
| **Custom metrics** | Paid | 1-second (high-resolution) to 1-minute | Application-specific (order count, queue depth) |
| **Embedded metrics format** | Paid | 1-second possible | Log structured metrics extracted automatically |

**Key concepts**:
- **Namespace**: logical container for metrics (e.g., `AWS/EC2`, `MyApp/Orders`)
- **Dimensions**: key-value pairs that identify the specific metric source (InstanceId, FunctionName)
- **Statistics**: Average, Sum, Minimum, Maximum, SampleCount, Percentile (p99, p95)
- **Period**: aggregation window (60s, 300s, 3600s)
- Metrics retained: 1-second → 3 hours; 1-minute → 15 days; 5-minute → 63 days; 1-hour → 15 months

### 2. CloudWatch Logs

**Structure**:
- **Log group** → **Log streams** → log events
- Log group: named container (e.g., `/aws/lambda/my-function`)
- Log stream: sequence of events from a single source (e.g., one Lambda instance)
- Retention: 1 day to 10 years (default: never expire — must set retention policy)

**Metric filters**:
- Extract metrics from log content using filter patterns
- Pattern syntax: `[ERROR]`, `{$.statusCode = 500}` (JSON), `"Exception"`
- Create CloudWatch metric from filter → alarm → SNS/Lambda pipeline

**CloudWatch Logs Insights**:
- Interactive SQL-like query language for log analysis
- Cross-log-group queries
- Key commands: `fields`, `filter`, `stats`, `sort`, `limit`, `parse`
- Pre-saved queries available for AWS service logs (Lambda, VPC Flow Logs, CloudTrail)

### 3. CloudWatch Alarms

| Alarm Type | Threshold Definition | Best For |
|------------|---------------------|---------|
| **Static threshold** | Fixed value (> 80%) | Predictable thresholds (CPU, queue depth) |
| **Anomaly detection** | ML-based band (± N std deviations) | Variable metrics without fixed expected value |
| **Composite alarms** | AND/OR combination of multiple alarms | Reduce alert fatigue; only alert when multiple signals |
| **Metric math alarms** | Alarm on derived metric expressions | Custom ratios, rates, combined metrics |

**Alarm states**: OK → ALARM → INSUFFICIENT_DATA (not enough data points)

**Actions**:
- Auto Scaling: scale-out/in policies
- SNS: notify email/SMS/HTTP endpoint
- EC2: stop, terminate, reboot, recover
- Systems Manager OpsItem: create incident ticket
- Lambda: via SNS subscription

**Composite alarms example** (reduce noise):
```
ALARM("CPUHigh") AND ALARM("MemoryHigh") → PagerDuty alert
ALARM("CPUHigh") alone → Slack notification only
```

### 4. CloudWatch Logs Insights Queries

Common patterns for exam and real-world use:

```
# Find error count per Lambda function
fields @timestamp, @message
| filter @message like /ERROR/
| stats count() as errorCount by bin(1h)
| sort @timestamp desc

# Top 10 slowest requests
fields @timestamp, @duration
| sort @duration desc
| limit 10

# Parse custom log format
parse @message "* * * *" as requestId, statusCode, latency, path
| filter statusCode = "500"
```

### 5. AWS X-Ray Distributed Tracing

- Traces requests across microservices, Lambda functions, and AWS services
- **Trace**: end-to-end request lifecycle (collection of segments)
- **Segment**: one service's contribution to the trace (with subsegments)
- **Subsegment**: granular operations within a segment (DB call, external HTTP call)
- **Service map**: visual topology of services and their dependencies with latency/error rates

**Sampling rules**:
- Default: 5% of requests + 1 request/second minimum (avoid high-volume trace costs)
- Custom sampling rules: define by service name, URL path, host, HTTP method
- Reservoir = guaranteed fixed-rate; rate = percentage of remaining traffic

**X-Ray SDK integration**:
- Instrument AWS SDK calls automatically (DynamoDB, S3, SQS, etc.)
- Annotate with custom key-value pairs (for filtering traces)
- Add metadata for debugging (not indexed, not searchable)

**X-Ray Daemon**: runs as sidecar collecting segments and sending to X-Ray service (batch UDP).

### 6. CloudWatch Synthetics (Canaries)

- Node.js or Python scripts that simulate user interactions
- Run on schedule (e.g., every 5 minutes) or one-time
- Check: API availability, UI flows, broken links, visual regression
- Canary blueprints: API canary, heartbeat monitor, broken link checker, visual monitoring
- Results stored in S3; CloudWatch metrics generated per canary run

### 7. Container and Lambda Insights

| Feature | For | What It Adds |
|---------|-----|-------------|
| **Container Insights** | EKS, ECS | CPU, memory, network per pod/task; Kubernetes events |
| **Lambda Insights** | Lambda | Cold start time, memory used, init duration, extension overhead |
| **Application Signals** | Applications | SLI/SLO tracking; request success rate, latency, volume |

## Key Concepts

- **CloudWatch Agent** — installed on EC2/on-prem to collect OS-level metrics (memory, disk) and logs (not available by default)
- **Embedded Metrics Format (EMF)** — structured JSON logs with `_aws` metadata; CloudWatch extracts metrics automatically; no separate PutMetricData call
- **Metric math** — perform arithmetic on metrics (e.g., ErrorRate = Errors / Invocations × 100)
- **CloudWatch Contributor Insights** — analyze log data to identify top contributors (e.g., top 10 IPs causing 4xx errors)
- **CloudWatch Evidently** — A/B testing and feature flagging (launch features to % of users)
- **CloudWatch RUM** — Real User Monitoring for web applications (client-side performance)

## Checklist

- [ ] CloudWatch Agent installed for OS-level metrics (memory, disk — not included by default)?
- [ ] Log group retention policy set (not "never expire")?
- [ ] Metric filters created for critical error patterns in application logs?
- [ ] Composite alarms used to reduce alert fatigue (alert only when multiple signals fire)?
- [ ] X-Ray tracing enabled for Lambda functions and API Gateway?
- [ ] Custom sampling rules defined for X-Ray (avoid tracing 100% of high-volume requests)?
- [ ] Container Insights enabled for EKS/ECS clusters?
- [ ] Synthetics canaries monitoring critical API endpoints and user flows?

## Output Format

- 🔴 **Critical** — no alarms on critical service metrics; log groups with "never expire" retention accumulating indefinitely; X-Ray not enabled for production microservices
- 🟡 **Warning** — memory/disk metrics missing (CloudWatch Agent not installed); composite alarms not used (too many individual alerts); default X-Ray sampling rate too high (100% on high-volume service)
- 🟢 **Suggestion** — Anomaly detection alarms for variable metrics; CloudWatch Logs Insights for ad-hoc log analysis; Lambda Insights for cold start investigation

## Exam Tips

- **Custom metrics = 1-second resolution possible** (high-resolution); standard metrics = 1-minute minimum
- **Metric filters on log groups → CloudWatch metric → alarm → SNS → Lambda** — classic event-driven ops pipeline; memorize this chain
- **CloudWatch Logs Insights** = SQL-like queries on logs; fast cross-log-group analysis without Athena
- **X-Ray sampling** = reduces trace volume; default 5% + 1 req/sec minimum; can configure per path/service
- **Composite alarms** = combine multiple alarms with AND/OR logic; reduces alert fatigue (only page when CPU AND memory high)
- **Container Insights** = ECS/EKS metrics (not enabled by default — must enable); **Lambda Insights** = Lambda performance metrics (cold starts, memory usage)
- **CloudWatch Agent required** for EC2 memory and disk metrics — these are NOT available without the agent
- **Anomaly detection** = ML baseline based on historical data; alarms fire when metric deviates beyond expected band
