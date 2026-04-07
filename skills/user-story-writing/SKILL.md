---
name: user-story-writing
description: Use when writing user stories, acceptance criteria, or breaking epics into shippable slices
---

# User Story Writing

## When to Use
When translating requirements or product ideas into structured stories that dev teams can estimate and build.

## Core Jobs

### 1. Write the Story
Format: **As a** [user type], **I want** [action], **so that** [benefit]
- Be specific about the user type — not "user" but "free-tier customer" or "admin"
- The action should be observable behavior, not implementation detail
- The benefit connects to a business or user outcome

### 2. Define Acceptance Criteria
Use Given/When/Then for testable criteria:
- **Given** [starting context]
- **When** [action taken]
- **Then** [expected outcome]
Write 3–6 criteria per story. Each must be independently verifiable.

### 3. Size and Split
- Story should be completable in 1–3 days of dev work
- If larger: split by user type, happy path vs edge cases, or CRUD operation
- Never split by layer (frontend/backend) — that's a task, not a story

### 4. Definition of Done
Include in every story:
- [ ] Acceptance criteria pass
- [ ] Unit tests written
- [ ] Code reviewed
- [ ] Deployed to staging

## Key Outputs
- User story with role/action/benefit
- 3–6 Given/When/Then acceptance criteria
- Story sizing estimate (S/M/L or points)
- DoD checklist

## Anti-Patterns
- Stories written from system perspective ("The system shall...") — rewrite from user perspective
- Acceptance criteria that can't be tested
- Stories too large to complete in a sprint
- No benefit stated — if you can't explain why, don't build it
