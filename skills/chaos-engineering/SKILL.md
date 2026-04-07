---
name: chaos-engineering
description: Use when designing resilience tests, planning chaos experiments, or validating failure recovery
---

# Chaos Engineering

## When to Use
When proactively testing system resilience by injecting controlled failures before they happen in production.

## Core Jobs

### 1. Define the Steady State
Before injecting chaos, define what "normal" looks like:
- Key metrics: error rate, latency, throughput, business KPI
- These must remain within bounds during the experiment
- If they leave bounds: experiment failed → learn why

### 2. Hypothesize
"We believe the system can tolerate [failure] because [reason]."
Examples:
- "We believe losing one DB replica won't affect P99 latency because we have read replicas with failover."
- "We believe a 500ms network delay between service A and B won't cause cascading failures because we have timeouts."

### 3. Design the Experiment
- **Scope**: start small (one instance, not all)
- **Blast radius**: what's the worst case if wrong?
- **Duration**: 5–30 minutes (enough to see impact)
- **Rollback**: how do you stop the experiment instantly?
- **Approval**: who needs to know before you run this?

Common experiments:
- Kill random pod/instance
- Inject network latency (50ms, 200ms, 1s)
- Fill disk to 95%
- CPU stress test (one node at 90%)
- DNS failure for dependency
- Terminate DB connection pool

### 4. Run and Observe
- Run during business hours (not 3am — you need to react)
- Watch the steady state metrics in real-time
- Stop immediately if unexpected impact
- Document what happened

### 5. Learn and Improve
- Did hypothesis hold? If yes: expand scope
- If no: fix the gap, don't run same experiment until fixed

## Key Outputs
- Chaos experiment plan (hypothesis + scope + rollback)
- Steady state dashboard
- Experiment results report
- Remediation items

## Anti-Patterns
- Running chaos in production before running in staging
- No rollback plan
- Chaos without observability (can't see what's happening)
- Running multiple experiments simultaneously
