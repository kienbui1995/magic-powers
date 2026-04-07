---
name: cloud-cost-review
description: Use when auditing cloud spend, rightsizing instances, reviewing reserved instance coverage, or finding cost optimization opportunities
---

# Cloud Cost Review

## When to Use
When cloud bills are growing faster than expected, before quarterly planning, or as a regular monthly hygiene practice.

## Core Jobs

### 1. Understand the Bill
Break down by:
- Service (EC2, RDS, S3, data transfer, etc.)
- Team/project (via tags)
- Environment (prod vs dev vs staging)
- Region

Tools: AWS Cost Explorer, GCP Billing, Azure Cost Management

### 2. Find Quick Wins

**Idle Resources** (high impact, easy):
- Instances with CPU < 5% for 14+ days
- Unattached EBS volumes
- Load balancers with no traffic
- Old snapshots (> 90 days)
- Unused Elastic IPs

**Rightsizing** (medium effort):
- Oversized instances: P95 CPU < 30% → downsize one tier
- Tool: AWS Compute Optimizer, GCP Recommender

**Reserved Instances / Savings Plans**:
- Workloads running > 8 months/year → commit for 30–40% savings
- 1-year no-upfront = best flexibility vs savings balance

**Data Transfer**:
- Same-region between services: often free
- Cross-region / egress: expensive — co-locate services
- S3 to EC2 in same region: free

### 3. Tag Everything
Without tags, you can't attribute costs. Enforce:
- `project`, `team`, `environment`, `owner`
- Budget alerts per tag value

### 4. Set Budgets and Alerts
- Monthly budget per service and team
- Alert at 80% and 100% of budget
- Anomaly detection for sudden spikes

## Key Outputs
- Cost breakdown report (service + team + env)
- Top 10 optimization opportunities with estimated savings
- Reserved instance / savings plan recommendation
- Tagging compliance report

## Anti-Patterns
- Reviewing costs quarterly instead of monthly (surprise bills)
- No tagging → can't attribute costs
- Optimizing dev environments instead of prod (wrong ROI)
- Buying reserved instances for workloads that scale down seasonally
