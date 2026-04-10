---
name: claude-memory
description: Use when leveraging Claude Code's auto-memory system — understanding what Claude saves to memory, writing good memory entries manually, structuring the memory directory, and using memory for project continuity across sessions.
---

# Claude Memory

## Overview

Claude Code has a built-in memory system that persists context across sessions. Without it, every session starts cold — Claude has no knowledge of past decisions, your preferences, or what was built last week. With a well-managed memory directory, Claude picks up exactly where you left off: knowing your role, your stack, your conventions, and the current state of the project.

## When to Use

- Claude keeps forgetting important context between sessions
- Starting a new session and want to pick up exactly where you left off
- Building a system where Claude accumulates knowledge over time
- Managing what Claude should and shouldn't remember

## Core Jobs

### 1. How Claude Code Memory Works

Claude Code has an auto-memory system in `~/.claude/projects/[project-hash]/memory/`:

```
~/.claude/
  CLAUDE.md                    ← global instructions (always loaded)
  projects/
    [project-hash]/
      memory/
        MEMORY.md              ← index of all memory files (always loaded)
        user_profile.md        ← who the user is, preferences
        project_context.md     ← what the project is about
        feedback_*.md          ← corrections and learned preferences
        reference_*.md         ← external resources and links
```

Claude loads `MEMORY.md` on every session start and follows pointers to load relevant memory files. Keep the index concise — it is always loaded in full.

### 2. Memory Types

| Type | What to store | When auto-saved |
|------|-------------|-----------------|
| `user` | Role, skills, preferences, communication style | When user shares personal context |
| `project` | Goals, decisions, current work, deadlines | When project state changes |
| `feedback` | Corrections, do/don't preferences | When user corrects Claude |
| `reference` | External URLs, tool locations, docs | When user mentions external resources |

### 3. Writing Good Memory Entries Manually

```markdown
---
name: user-coding-style
description: User's coding preferences and style requirements
type: user
---

User: Kien, Vietnamese communication preferred
Role: Solo AI builder, primarily Python + TypeScript
Experience: Senior, minimal explanation needed
Style: Direct, concise, no over-engineering
Key preference: Always use uv for Python package management, never pip
Test preference: pytest with fixtures, no mocking external services
```

Good memory entries are specific, actionable, and focused on preferences that change Claude's behavior. Avoid storing code snippets or file contents — those change and go stale.

### 4. Memory Index (MEMORY.md)

Keep the index concise — it is loaded every session and truncated if too long:

```markdown
# Memory Index

- [User profile](user_profile.md) — Kien, solo AI builder, Python/TS
- [Project: magic-powers](project_magic_powers.md) — Claude Code plugin, v1.9.0
- [Preferences](feedback_coding.md) — uv not pip, direct comms, no over-engineering
```

**Rule:** Keep MEMORY.md under 200 lines or later lines get cut off at load time.

### 5. Project Continuity Pattern

At the end of significant sessions, update memory explicitly:

```markdown
# project_context.md update (after a major session)

## Current State (updated 2026-04-08)
- Completed: MCP setup for postgres, github integrations
- In progress: Hook system for auto-testing on edit
- Blocked: Waiting for staging DB credentials from ops
- Next session: Wire up Stop hook to enforce pytest passing
```

This replaces the need to re-explain project state at the start of every session.

## Key Concepts

- **Auto-memory** — Claude Code automatically saves important context to `~/.claude/projects/[hash]/memory/`
- **MEMORY.md** — always-loaded index file; must stay under 200 lines
- **Memory types** — user (preferences), project (state), feedback (corrections), reference (links)
- **Memory staleness** — memories about code can go stale; always verify before acting on code-specific memories

## Checklist

- [ ] MEMORY.md index exists and is under 200 lines?
- [ ] User profile memory set (role, communication style, key tools)?
- [ ] Project context memory updated when major decisions are made?
- [ ] Feedback memories added after correcting Claude's mistakes?
- [ ] Memory files verified as current (not stale from months ago)?

## Key Outputs

- Memory directory structure with appropriate files per type
- MEMORY.md index with concise pointers to each memory file
- Project continuity entries capturing current state after major sessions

## Output Format

- 🔴 **Critical** — no memory system (Claude restarts cold every session), MEMORY.md over 200 lines (truncated at load)
- 🟡 **Warning** — stale memories about code that no longer exists, no feedback memories (Claude repeats same mistakes)
- 🟢 **Suggestion** — add project memory after major architectural decisions, add user memory for communication preferences, update "Current State" after complex sessions

## Anti-Patterns

- Storing code snippets in memory (code changes; reference files instead)
- MEMORY.md over 200 lines (truncated at load time — later entries are invisible)
- No feedback memories (Claude will repeat the same mistakes you've already corrected)
- Memory entries that say "as of [old date]" but were never updated — stale context misleads Claude

## Integration

- Use with `claude-md-authoring` (CLAUDE.md = instructions; memory = accumulated context — they complement each other)
- Use with `claude-project-settings` (memory location is configured alongside other project settings)
- Agent: `@technical-writer` can help draft well-structured memory entries for complex projects
