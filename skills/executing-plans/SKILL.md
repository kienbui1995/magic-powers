---
name: executing-plans
description: Use when you have a written implementation plan to execute in a separate session with review checkpoints
---

# Executing Plans

Load plan, review critically, execute all tasks, report when complete.

**Announce at start:** "I'm using the executing-plans skill to implement this plan."

**Note:** If subagents are available, use magic-powers:subagent-driven-development instead — higher quality through fresh context per task.

## The Process

### Step 1: Load and Review Plan
1. Read plan file
2. Review critically — identify questions or concerns
3. If concerns: raise with user before starting
4. If no concerns: create TodoWrite and proceed

### Step 2: Execute Tasks

For each task:
1. Mark as in_progress
2. Follow each step exactly
3. Run verifications as specified
4. Mark as completed

### Step 3: Complete Development

After all tasks verified:
- Use magic-powers:finishing-a-development-branch
- Verify tests, present options, execute choice

## When to Stop

**STOP immediately when:**
- Hit a blocker (missing dependency, test fails, unclear instruction)
- Plan has critical gaps
- Verification fails repeatedly

**Ask for clarification rather than guessing.**

## Remember
- Review plan critically first
- Follow plan steps exactly
- Don't skip verifications
- Stop when blocked, don't guess
- Never start implementation on main/master without explicit user consent

## Integration
- **magic-powers:using-git-worktrees** — set up isolated workspace before starting
- **magic-powers:writing-plans** — creates the plan this skill executes
- **magic-powers:finishing-a-development-branch** — complete development after all tasks
