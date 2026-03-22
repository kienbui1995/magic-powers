---
name: writing-skills
description: Use when creating new skills, editing existing skills, or verifying skills work before deployment
---

# Writing Skills

## Overview

Writing skills IS Test-Driven Development applied to process documentation.

Write test cases (pressure scenarios with subagents), watch them fail (baseline behavior), write the skill, watch tests pass (agents comply), refactor (close loopholes).

**Core principle:** If you didn't watch an agent fail without the skill, you don't know if the skill teaches the right thing.

## What is a Skill?

A **skill** is a reference guide for proven techniques, patterns, or tools.

**Skills are:** Reusable techniques, patterns, tools, reference guides.
**Skills are NOT:** Narratives about how you solved a problem once.

## Skill File Format

```markdown
---
name: my-skill-name
description: When to use this skill - triggers automatic activation
---

# Skill Title

## Overview
What this skill teaches and why.

## When to Use
Specific triggers.

## The Process
Step-by-step instructions.

## Integration
Related skills.
```

## TDD for Skills

### RED: Write a Pressure Test
Create a scenario that tests whether an agent follows the desired behavior WITHOUT the skill.

```bash
claude -p "Fix this failing test" --model haiku
# Observe: Does it investigate root cause? Or just guess?
```

### GREEN: Write the Skill
Write SKILL.md that teaches the behavior you want.

### REFACTOR: Close Loopholes
Test edge cases. Agents will find creative ways to skip steps. Add guardrails.

## Key Principles

- **Description is the trigger** — write it carefully, it determines when the skill activates
- **Be specific** — vague instructions get vague compliance
- **Include anti-patterns** — show what NOT to do
- **Test with subagents** — they're the harshest test of skill clarity
- **Keep it focused** — one skill, one topic

## Skill Locations

- **Plugin skills:** `skills/<name>/SKILL.md` (distributed with plugin)
- **User skills:** `~/.claude/skills/<name>/SKILL.md` (personal)
- **Project skills:** `.claude/skills/<name>/SKILL.md` (per-project)
