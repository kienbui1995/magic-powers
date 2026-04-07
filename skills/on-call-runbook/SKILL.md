---
name: on-call-runbook
description: Use when writing runbooks for on-call engineers, documenting incident response steps, or creating operational playbooks
---

# On-Call Runbook Writing

## When to Use
When documenting how to respond to alerts, investigate incidents, or operate a system at 3am with no context.

## Core Jobs

### 1. Runbook Structure
Every runbook should have:
```
# Alert: [Alert Name]

## Severity
[P1/P2/P3] — [impact if this fires]

## Symptoms
- What does the user experience?
- Which metrics are affected?

## Immediate Actions (first 5 minutes)
1. Acknowledge the alert
2. [Specific command to run first]
3. [Decision point: if X, go to section A; if Y, go to section B]

## Investigation Steps
1. Check [dashboard link] — look for [what to look for]
2. Run: `[exact command]`
3. Check logs: `[exact log query]`

## Common Causes and Fixes
### Cause: [specific cause]
Fix: [exact steps]

### Cause: [another cause]
Fix: [exact steps]

## Escalation
If not resolved in 30 minutes, escalate to: [person/team + how]

## Post-Incident
- Create incident ticket in [system]
- Run postmortem if P1/P2
```

### 2. Write for 3am You
- Exact commands, not "check the logs" — provide the grep
- Dashboard links embedded (not "check Grafana")
- Decision trees, not prose
- No jargon that requires context
- Assume nothing — spell out every step

### 3. Test the Runbook
- Have a new team member follow it during a drill
- Time it: can they triage in < 5 minutes?
- Update anywhere they got stuck

### 4. Keep It Current
- Review quarterly or after every P1
- Runbooks that don't get used in incidents are probably outdated
- Link runbooks in the alerting system (PagerDuty, OpsGenie)

## Key Outputs
- Alert-specific runbooks (one per alert)
- Service operational guide
- Escalation matrix

## Anti-Patterns
- Runbooks written for people who already know the system
- Prose instead of numbered steps + commands
- No links to dashboards/logs
- Runbooks that haven't been tested
