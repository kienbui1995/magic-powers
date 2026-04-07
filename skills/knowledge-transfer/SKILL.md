---
name: knowledge-transfer
description: Use when handing off a system, preparing someone to own a codebase, or ensuring knowledge doesn't live in one person's head
---

# Knowledge Transfer

## When to Use
When a team member is leaving, changing roles, or when critical knowledge is concentrated in one person (bus factor = 1).

## Core Jobs

### 1. Identify What Needs Transfer
Map the knowledge:
- Systems owned: what does this person know that nobody else does?
- Undocumented processes: what do they do manually that isn't written down?
- Tribal knowledge: decisions made without ADRs, vendor relationships, historical context
- Access and credentials: what do they control?

### 2. Structured Handoff Sessions
For each area:
- **Walkthrough session**: they show, new owner drives (not watch)
- **Q&A session**: new owner has had 1 week with docs, asks questions
- **Shadow session**: new owner handles it, original provides safety net
- **Solo session**: new owner is on their own, original is available async

### 3. Documentation Artifacts
Produce per system/area:
- Architecture overview (1-pager: what it does, how it works, key components)
- Operational runbook (how to keep it running, common issues)
- Decision log (why it's built this way — the ADRs or equivalent)
- Access inventory (what credentials, where stored, how to rotate)

### 4. Knowledge Transfer Checklist
- [ ] All systems have a named new owner
- [ ] Runbooks written and reviewed by new owner
- [ ] Access transferred (not just shared — actual ownership)
- [ ] 30-day support period agreed (original available for questions)
- [ ] Knowledge gaps identified and addressed before departure

## Key Outputs
- Knowledge map (what → who knows it)
- Handoff documentation per system
- Session recordings (if permitted)
- 30-day support plan

## Anti-Patterns
- Documentation dump without walkthrough sessions
- Assuming new owner will "figure it out"
- Knowledge transfer the week before departure (not enough time)
- Bus factor not tracked — discovering the problem after the person leaves
