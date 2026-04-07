---
name: sprint-planning
description: Use when facilitating sprint planning, refining the backlog, calculating team capacity, or setting sprint goals
---

# Sprint Planning

## When to Use
At the start of each sprint to align the team on what to build and why.

## Process Checklist

### Pre-Planning (day before)
- [ ] Backlog groomed — top items have acceptance criteria and estimates
- [ ] Previous sprint velocity calculated (avg of last 3 sprints)
- [ ] Team capacity confirmed (who's out? on-call? support rotation?)
- [ ] Product goal for this sprint drafted

### The Planning Meeting (2 hours max for 2-week sprint)

**Part 1: Why (30 min)**
- PO presents sprint goal — the one outcome this sprint delivers
- Team asks clarifying questions
- Goal is agreed (not just "ship features", but "users can complete checkout")

**Part 2: What (60 min)**
- Pull from top of backlog until capacity is reached
- Capacity = velocity × (available dev-days / sprint-days)
- Each story: confirm understanding of acceptance criteria
- If unclear: clarify now or push to next sprint

**Part 3: How (30 min)**
- Break stories into tasks (optional, but recommended for complex stories)
- Identify dependencies between tickets
- Flag risks: what could go wrong?

### Capacity Calculation
```
Available dev-days = (team_size × sprint_days) - PTO - meetings - support_rotation
Capacity = (available_dev_days / sprint_days) × historical_velocity
```

### Sprint Goal Formula
"By the end of this sprint, [user type] will be able to [capability], which enables [business outcome]."

## Core Jobs
- Calculate team capacity accurately
- Define a clear sprint goal (not just a list of tickets)
- Commit to a realistic sprint backlog
- Surface risks before the sprint starts

## Key Outputs
- Sprint goal (one sentence)
- Sprint backlog (committed stories)
- Capacity breakdown
- Risk log

## Anti-Patterns
- No sprint goal — just a list of tickets
- Committing to 100% capacity (no buffer for unknowns)
- Adding tickets during the sprint without removing others
- Planning stories that aren't ready (no acceptance criteria)
