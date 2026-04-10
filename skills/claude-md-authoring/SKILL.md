---
name: claude-md-authoring
description: Use when writing or improving CLAUDE.md files — project context that Claude Code reads every session, global vs project rules, what to include for maximum AI effectiveness, and memory-aware documentation patterns.
---

# CLAUDE.md Authoring

## Overview

CLAUDE.md is the most powerful lever for making Claude Code effective on your project. It's read at the start of every session — think of it as the briefing document Claude reads before doing any work. A well-written CLAUDE.md means Claude follows your conventions without being asked, and a missing or stale one means Claude reinvents conventions every session.

## When to Use

- Starting a new project and want Claude Code to understand context from day 1
- Claude keeps asking the same questions or making the same mistakes
- Onboarding Claude Code to an existing codebase
- Wanting Claude to follow specific conventions consistently

## Core Jobs

### 1. CLAUDE.md Hierarchy

Claude Code reads files in priority order:

```
1. ~/.claude/CLAUDE.md          (global — applies to all projects)
2. /project/CLAUDE.md           (project root — main project context)
3. /project/subdir/CLAUDE.md    (subdirectory — specific area rules)
```

Higher priority overrides lower. Use global for personal preferences, project for team conventions.

### 2. What to Put in CLAUDE.md

**High-value content:**

```markdown
# Project: [Name]

## What This Is
[2-3 sentences: what the project does, who uses it, tech stack]

## Architecture
[Key architectural decisions Claude should know: monorepo, microservices, etc.]
- API: FastAPI on port 8000, PostgreSQL via SQLAlchemy
- Frontend: Next.js 14 App Router, Tailwind CSS, shadcn/ui
- Auth: Clerk (not custom auth — never implement auth yourself)

## Conventions
- Python: use `ruff` for formatting, type hints required on all functions
- Commits: conventional commits (feat:, fix:, chore:)
- Never use print() — always use the logger: `from app.core.logger import logger`

## Do Not
- Never modify migrations directly — always use `alembic revision --autogenerate`
- Never commit .env files
- Never use synchronous DB calls in async functions

## Current Focus
[Optional: what's being built right now, context for current sprint]
```

**Low-value content (don't include):**
- File-by-file documentation (Claude reads the code)
- Obvious conventions (PEP8, etc.)
- History of decisions (use ADRs for that)
- Todo lists (use task management tools)

### 3. Global CLAUDE.md (~/.claude/CLAUDE.md)

Personal preferences that apply across all projects:

```markdown
## My Preferences
- I'm [role] working primarily in [languages]
- Communication style: concise, direct, minimal explanation unless asked
- When in doubt, ask before making large changes
- Always run tests before declaring done

## Tools I Use
- Package manager: uv (Python), pnpm (Node)
- Formatter: ruff (Python), prettier (JS/TS)
- Testing: pytest (Python), vitest (JS/TS)

## Workflow
- Read existing code patterns before suggesting new approaches
- Prefer editing existing files over creating new ones
- Commit frequently with conventional commit messages
```

### 4. Dynamic CLAUDE.md Updates

Update CLAUDE.md as the project evolves:
- After major architectural decisions: document the "why"
- After Claude makes a repeated mistake: add a "Do Not" rule
- After onboarding: add what was confusing (to help future Claude sessions)
- Before a sprint: add "Current Focus" section

## Key Concepts

- **CLAUDE.md** — markdown file Claude Code reads at session start for project context
- **Global CLAUDE.md** — `~/.claude/CLAUDE.md` — personal preferences across all projects
- **Project CLAUDE.md** — `/project/CLAUDE.md` — shared team conventions
- **Subdirectory CLAUDE.md** — `/subdir/CLAUDE.md` — area-specific rules (e.g., `/frontend/CLAUDE.md`)

## Checklist

- [ ] Project CLAUDE.md exists in repo root?
- [ ] Tech stack and key dependencies documented?
- [ ] Critical "Do Not" rules added (the things Claude gets wrong)?
- [ ] Current focus/sprint context updated (not stale)?
- [ ] Global CLAUDE.md configured with personal preferences?
- [ ] Conventions documented with examples (not just rules)?

## Key Outputs

- Project CLAUDE.md: architecture, conventions, do-nots, current focus
- Global CLAUDE.md: personal preferences, tools, workflow style

## Output Format

- 🔴 **Critical** — no CLAUDE.md (Claude reinvents conventions each session), CLAUDE.md outdated by months
- 🟡 **Warning** — CLAUDE.md too generic (no project-specific content), missing "Do Not" rules for known pitfalls
- 🟢 **Suggestion** — add subdirectory CLAUDE.md for complex areas (frontend/, api/), update "Current Focus" weekly

## Anti-Patterns

- Copying generic CLAUDE.md templates without project-specific content
- Documenting things Claude can read from the code (file structure, imports)
- "Current Focus" section that's 3 months old (stale context is worse than no context)
- No "Do Not" section (the most valuable part — captures hard-learned lessons)

## Integration

- Use with `claude-project-settings` for complete Claude Code configuration
- Use with `claude-hooks` (document hook behaviors in CLAUDE.md so team understands them)
- Agent: `@architect` helps write the architecture section of CLAUDE.md
