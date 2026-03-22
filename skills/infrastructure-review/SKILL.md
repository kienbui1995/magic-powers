---
name: infrastructure-review
description: Use when reviewing deployments, CI/CD, monitoring, scaling, or incident response configurations
---

# Infrastructure Review

## When to Use
When reviewing deployment configs, CI/CD pipelines, monitoring setup, scaling strategies, or incident response.

## Checklist

### Deployment
- [ ] Health checks configured
- [ ] Graceful shutdown handling
- [ ] Rolling deployment (zero downtime)
- [ ] Rollback procedure documented
- [ ] Resource limits set (CPU, memory)

### Monitoring & Alerting
- [ ] Application metrics exported (latency, errors, throughput)
- [ ] Alerts on error rate spike and latency P99
- [ ] Log aggregation configured
- [ ] Uptime monitoring on critical endpoints

### Reliability
- [ ] Retry logic with exponential backoff
- [ ] Circuit breakers on external dependencies
- [ ] Timeouts on all network calls
- [ ] Graceful degradation when dependencies fail

### CI/CD
- [ ] Tests run before deploy
- [ ] Linting and type checking in pipeline
- [ ] Secrets injected from CI, not committed
- [ ] Deploy requires approval for production

## Incident Response Template
1. **Detect** — what alert fired?
2. **Assess** — impact scope (users, data, revenue)
3. **Mitigate** — rollback, feature flag, or hotfix
4. **Resolve** — root cause fix
5. **Review** — blameless postmortem within 48h
