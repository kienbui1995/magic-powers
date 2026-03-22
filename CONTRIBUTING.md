# Contributing to Magic Powers

Thanks for your interest! Here's how to add agents, skills, or improve existing ones.

## Adding an Agent

Create `agents/your-agent-name.md` with this template:

```markdown
---
name: your-agent-name
description: "When to use this agent — be specific about triggers."
model: haiku|sonnet|opus
emoji: 🎯
vibe: one-word-personality
tools: Read, Grep, Glob, Bash
skills:
  - magic-powers:relevant-skill
---

You are a [role description].

When invoked:
1. First action
2. Second action
3. Output format
```

### Model Selection Guide

| Model | Cost | Use for |
|-------|------|---------|
| `haiku` | $ | Reviews, checks, documentation — read-only tasks |
| `sonnet` | $$ | Implementation, debugging, analysis — balanced tasks |
| `opus` | $$$ | Architecture, complex reasoning — deep thinking tasks |

### Tools

- Read-only agents: `tools: Read, Grep, Glob`
- Full-access agents: `tools: Read, Grep, Glob, Bash`

## Adding a Skill

Create `skills/your-skill-name/SKILL.md`:

```markdown
# Your Skill Name

## When to Use
Describe triggers for this skill.

## Process
1. Step one
2. Step two

## Rules
- Rule one
- Rule two
```

## Pull Request Guidelines

1. One agent or skill per PR
2. Include `emoji` and `vibe` in agent frontmatter
3. Keep agents generic — no hardcoded tech stacks
4. Test with `bash scripts/convert.sh all` to verify multi-tool output
5. Update README agent count if adding agents

## Code Style

- Agent files: lowercase-kebab-case.md
- Skill dirs: lowercase-kebab-case/SKILL.md
- Keep instructions concise — prefer lists over paragraphs
- Use model routing: expensive models only for tasks that need them
