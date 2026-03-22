---
name: dispatching-parallel-agents
description: Use when facing 2+ independent tasks that can be worked on without shared state or sequential dependencies
---

# Dispatching Parallel Agents

## Overview

Delegate tasks to specialized agents with isolated context. Each agent gets precisely crafted instructions — never your session history.

**Core principle:** One agent per independent problem domain. Let them work concurrently.

## When to Use

**Use when:**
- 2+ independent tasks (different subsystems, different bugs)
- No shared state between tasks
- Each can be understood without context from others

**Don't use when:**
- Failures are related (fix one might fix others)
- Need to understand full system state
- Agents would interfere with each other (same files)

## The Pattern

### 1. Identify Independent Domains

Group by what's broken:
- Domain A: Authentication flow
- Domain B: Data processing pipeline
- Domain C: UI rendering

Each domain is independent — fixing auth doesn't affect rendering.

### 2. Create Focused Agent Tasks

Each agent gets:
- **Specific problem** — one domain only
- **Relevant files** — only what they need
- **Expected outcome** — what "fixed" looks like
- **Constraints** — don't touch other domains

### 3. Dispatch with Model Routing

| Task Type | Agent | Why |
|-----------|-------|-----|
| Bug investigation | debugger (Sonnet) | Systematic debugging, full tools |
| Code review | reviewer (Haiku) | Fast, cheap, read-only |
| Architecture question | architect (Opus) | Deep reasoning |
| Implementation | (default subagent) | Sonnet, balanced |

### 4. Collect and Integrate Results

After all agents complete:
- Review each agent's changes
- Check for conflicts
- Run full test suite
- Use magic-powers:verification-before-completion

## Anti-Patterns

| Pattern | Problem |
|---------|---------|
| Dumping full session context | Agents get confused, waste tokens |
| Overlapping file scope | Merge conflicts |
| Too many agents at once | Hard to coordinate |
| Not reviewing results | Agents can make mistakes |

## Integration

- **magic-powers:subagent-driven-development** — sequential task execution with review
- **magic-powers:systematic-debugging** — each agent uses this for bug investigation
