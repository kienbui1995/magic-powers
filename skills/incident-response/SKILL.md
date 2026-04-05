---
name: incident-response
description: Use when handling production incidents - outage triage, root cause analysis, communication, postmortem writing
---

# Incident Response

## Overview

When production breaks, speed and structure matter. Follow the process — panic and ad-hoc fixes make things worse.

## When to Use

- Production outage or degradation
- Customer-reported critical bugs
- Security incidents
- Writing postmortems after resolution

## Incident Phases

### Phase 1: Triage (first 5 minutes)
1. **Assess severity** — who's affected, how badly?
2. **Communicate** — post in incident channel: what's broken, who's looking
3. **Assign roles** — Incident Commander (IC), communicator, investigators

| Severity | Impact | Response |
|----------|--------|----------|
| SEV1 | Full outage, all users | All hands, exec notification |
| SEV2 | Major feature broken | On-call team + backup |
| SEV3 | Minor degradation | On-call investigates |

### Phase 2: Mitigate (stop the bleeding)
- **Rollback** — if recent deploy, revert first, investigate later
- **Feature flag** — disable the broken feature
- **Scale** — if capacity issue, add resources
- **Redirect** — route traffic away from broken component

**Goal: restore service ASAP. Root cause comes later.**

### Phase 3: Investigate
- Check monitoring dashboards, logs, recent deploys
- Narrow down: when did it start? What changed?
- Use `systematic-debugging` skill for structured investigation

### Phase 4: Resolve & Verify
- Apply fix
- Monitor for 15-30 minutes
- Confirm metrics return to normal
- Update status page

### Phase 5: Postmortem (within 48 hours)

```markdown
## Incident Postmortem: [Title]
**Date:** YYYY-MM-DD | **Duration:** X hours | **Severity:** SEV-N

### Summary
One paragraph: what happened, impact, resolution.

### Timeline
- HH:MM — First alert
- HH:MM — IC assigned
- HH:MM — Root cause identified
- HH:MM — Fix deployed
- HH:MM — All clear

### Root Cause
What actually broke and why.

### Action Items
- [ ] [P0] Immediate fix to prevent recurrence
- [ ] [P1] Monitoring improvement
- [ ] [P2] Process improvement
```

## Rules

- **Blameless** — postmortems focus on systems, not people
- **Rollback first** — don't debug in production if you can revert
- **Communicate early and often** — silence is worse than "we're investigating"
- **One IC** — someone owns the incident, others support

## Integration

- **magic-powers:systematic-debugging** — structured investigation during Phase 3
- **magic-powers:technical-writing** — write clear postmortem
- **magic-powers:infrastructure-review** — prevent recurrence
