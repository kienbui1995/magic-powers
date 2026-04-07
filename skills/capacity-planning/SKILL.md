---
name: capacity-planning
description: Use when projecting infrastructure needs, planning for traffic growth, or making scaling decisions
---

# Capacity Planning

## When to Use
When you need to ensure infrastructure can handle current load, planned growth, or traffic spikes without over-provisioning.

## Core Jobs

### 1. Measure Current Baselines
For each service, measure:
- **Throughput**: requests/sec at P50, P95 traffic
- **Latency**: P50, P95, P99 response time
- **Resource utilization**: CPU%, memory%, disk I/O, network
- **Saturation point**: at what RPS does P99 latency degrade?
- **Headroom**: current utilization vs saturation point

### 2. Model Growth
- Historical traffic growth rate (last 3–6 months)
- Planned initiatives that will change load (new features, marketing campaigns)
- Seasonality (peak hours, days, months)
- Project 3 months and 12 months forward

### 3. Calculate Required Capacity
```
Required instances = (Peak RPS × Avg latency) / (1000ms × CPU cores × target utilization)
```
Target utilization: 60–70% CPU at peak (leave headroom for spikes and rolling deploys)

### 4. Make Scaling Decisions
Options:
- **Vertical scaling**: larger instances (fast, expensive, limits)
- **Horizontal scaling**: more instances (preferred, needs stateless design)
- **Auto-scaling**: HPA on Kubernetes, ASGs on AWS (set based on CPU or custom metric)
- **Caching**: reduce load on DB/API (often 10x more cost-effective than scaling)

### 5. Plan for Spikes
- Load test at 2x expected peak before major launches
- Pre-scale before known events (product launches, marketing campaigns)
- Circuit breakers to shed load gracefully

## Key Outputs
- Current baseline measurements
- 3-month and 12-month capacity projections
- Scaling recommendation with cost estimate
- Load test results

## Anti-Patterns
- Planning based on average load, not peak
- No load testing before major launches
- Scaling CPU-bound services horizontally without profiling
- Over-provisioning permanently for spikes that last hours
