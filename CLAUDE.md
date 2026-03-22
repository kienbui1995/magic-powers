# CLAUDE.md — Magic Powers Plugin Guidance

This file helps Claude Code understand how to use the magic-powers plugin effectively in your project.

## Model Routing

Use the right model for the task to optimize cost:

| Task | Agent | Model | Why |
|------|-------|-------|-----|
| Architecture, design | `@architect` | Opus | Deep reasoning needed |
| Debugging, infra | `@debugger`, `@sre` | Sonnet | Balance of speed + quality |
| Reviews, docs | `@reviewer`, `@technical-writer` | Haiku | Fast, pattern-matching tasks |

## Quick Start

```
# Architecture decisions
@architect Design a caching layer for our API

# Debug production issues
@debugger Investigate why /api/users returns 500

# Code review before commit
@reviewer Review my recent changes

# Security audit
@security-reviewer Audit the auth module

# Database optimization
@database-optimizer Review our schema and slow queries

# Write documentation
@technical-writer Write API docs for the payments module
```

## Skills

Skills are auto-loaded by agents. Key workflows:
- **TDD**: `test-driven-development` — red/green/refactor cycle
- **Debugging**: `systematic-debugging` — binary search for root cause
- **Planning**: `writing-plans` → `executing-plans` — structured implementation
- **Git**: `using-git-worktrees` → `finishing-a-development-branch`

## Cost Tips

- Start with Haiku agents for quick tasks, escalate to Sonnet/Opus only when needed
- Use `@reviewer` (Haiku) before `@architect` (Opus) to catch simple issues cheaply
- Batch related questions into single agent calls
