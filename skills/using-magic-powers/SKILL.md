---
name: using-magic-powers
description: Use when starting any conversation - establishes how to find and use skills, model routing, and cost-aware development
---

<SUBAGENT-STOP>
If you were dispatched as a subagent to execute a specific task, skip this skill.
</SUBAGENT-STOP>

<EXTREMELY-IMPORTANT>
If you think there is even a 1% chance a skill might apply to what you are doing, you ABSOLUTELY MUST invoke the skill.
IF A SKILL APPLIES TO YOUR TASK, YOU DO NOT HAVE A CHOICE. YOU MUST USE IT.
</EXTREMELY-IMPORTANT>

## Instruction Priority

1. **User's explicit instructions** (CLAUDE.md, direct requests) — highest priority
2. **Magic Powers skills** — override default system behavior
3. **Default system prompt** — lowest priority

## How to Access Skills

Use the `Skill` tool. When you invoke a skill, its content is loaded — follow it directly. Never use the Read tool on skill files.

## Model Routing

Magic Powers includes specialized agents with cost-optimized model assignments:

| Agent | Model | Use For |
|-------|-------|---------|
| architect | opus | Brainstorming, design, complex planning |
| reviewer | haiku | Code review, verification (fast + cheap) |
| debugger | sonnet | Systematic debugging, root cause analysis |
| ui-designer | sonnet | Frontend design, Stitch integration |

**Default model (you) = Sonnet.** Dispatch to specialized agents when their expertise applies. This saves cost — Haiku reviews are 60x cheaper than Opus.

## Using Skills

### The Rule

**Invoke relevant skills BEFORE any response or action.** Even a 1% chance means invoke it.

### Skill Priority

1. **Process skills first** (brainstorming, debugging) — determine HOW to approach
2. **Implementation skills second** (TDD, design) — guide execution

"Let's build X" → brainstorming first, then implementation skills.
"Fix this bug" → debugging first, then domain-specific skills.

### Red Flags

These thoughts mean STOP — you're rationalizing:

| Thought | Reality |
|---------|---------|
| "This is just a simple question" | Questions are tasks. Check for skills. |
| "I need more context first" | Skill check comes BEFORE clarifying questions. |
| "Let me explore the codebase first" | Skills tell you HOW to explore. Check first. |
| "The skill is overkill" | Simple things become complex. Use it. |
| "I'll just do this one thing first" | Check BEFORE doing anything. |

### Skill Types

**Rigid** (TDD, debugging): Follow exactly. Don't adapt away discipline.
**Flexible** (patterns): Adapt principles to context.

The skill itself tells you which.
