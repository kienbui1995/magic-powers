---
name: incident-postmortem
description: Use when writing a blameless postmortem after an incident, identifying root causes, and building follow-up action items
---

# Incident Postmortem

## When to Use
After any P1/P2 incident, or any incident that surprised the team, caused user impact, or revealed a systemic gap.

## Process Checklist

### Within 24h of Incident Resolution
- [ ] Incident timeline drafted (in chronological order)
- [ ] All participants have reviewed the timeline for accuracy
- [ ] Postmortem meeting scheduled (within 5 business days)

### Postmortem Meeting (60 min)
- [ ] Facilitator is not the incident owner (reduces defensiveness)
- [ ] Rules set: blameless, focus on systems not people
- [ ] Timeline walked through — add missing context
- [ ] 5 Whys applied to root cause(s)
- [ ] Action items drafted with owners

### Postmortem Document Template
```
# Postmortem: [Incident Title]

**Date:** YYYY-MM-DD
**Severity:** P1/P2
**Duration:** [start] → [end] ([total hours])
**User Impact:** [what users experienced, how many affected]
**Author(s):** [names]

## Summary
[2–3 sentences: what happened, what caused it, how it was resolved]

## Timeline
| Time (UTC) | Event |
|------------|-------|
| 14:00 | Alert fires: error rate > 5% |
| 14:05 | On-call acknowledges |
| 14:22 | Root cause identified |
| 14:35 | Mitigation applied |
| 14:40 | Error rate returns to baseline |
| 15:00 | Incident resolved |

## Root Cause Analysis (5 Whys)
[Walk the 5 Whys from symptom to root cause]

## What Went Well
[What worked — don't skip this section]

## What Went Poorly
[Gaps, surprises, things that slowed resolution]

## Action Items
| Item | Owner | Due |
|------|-------|-----|
| [specific fix] | @person | YYYY-MM-DD |
```

## Core Jobs
- Facilitate blameless analysis focused on systems
- Apply 5 Whys to find root cause (not just proximate cause)
- Produce 3–5 concrete action items with owners
- Share findings with wider team

## Key Outputs
- Postmortem document
- Action items added to sprint backlog
- Shared with wider team (learning culture)

## Anti-Patterns
- Blaming individuals ("the engineer who deployed...")
- Postmortem that lists symptoms but not root causes
- Action items with no owner or due date
- Not sharing the postmortem — others can't learn from it
