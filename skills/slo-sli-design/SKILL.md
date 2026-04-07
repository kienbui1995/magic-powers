---
name: slo-sli-design
description: Use when defining service level objectives, SLIs, or error budgets for reliability engineering
---

# SLO/SLI Design

## When to Use
When establishing reliability targets for a service, creating error budgets, or setting up the measurement framework for SRE practices.

## Core Jobs

### 1. Define SLIs (Service Level Indicators)
SLI = the metric that measures user experience quality.
Good SLIs:
- **Availability**: % of requests that succeed (HTTP 2xx/3xx)
- **Latency**: % of requests faster than threshold (e.g., P95 < 200ms)
- **Error rate**: % of requests that return errors
- **Throughput**: requests per second served
- **Durability**: % of data readable after write

Bad SLIs: CPU usage, memory (these are symptoms, not user experience).

### 2. Set SLOs (Service Level Objectives)
SLO = target for the SLI over a time window.
Examples:
- "99.9% of requests succeed" (availability)
- "P95 latency < 200ms" (latency)
- "99.95% of writes are durable" (durability)

How to set the target:
- Start with what users actually need, not what's technically achievable
- Check historical performance — set target slightly better than current P75
- Different tiers: 99.9% for free, 99.95% for paid, 99.99% for enterprise

### 3. Calculate Error Budget
Error Budget = 1 - SLO
- 99.9% SLO = 0.1% budget = 43.8 minutes/month
- Spend error budget on: deployments, experiments, planned maintenance
- When budget depleted: freeze feature work, focus on reliability

### 4. Create the SLO Dashboard
Track:
- Current SLI value (rolling 30-day window)
- Error budget remaining (%)
- Budget burn rate (are you on track to exhaust it?)
- Alerting: burn rate > 2x normal = page on-call

## Key Outputs
- SLI definitions per service
- SLO targets with rationale
- Error budget calculation
- SLO dashboard (Grafana template)

## Anti-Patterns
- 100% SLO target (unachievable, no room for deployments)
- Using infrastructure metrics (CPU) as SLIs
- SLOs not tied to user experience
- No error budget policy (who decides how to spend it?)
