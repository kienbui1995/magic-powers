# Claude Code Workflow Optimization Division — Design Spec

**Date:** 2026-04-11
**Status:** Approved
**Priority pain points:** D (model routing), E (workflow templates), A (session boundary)

---

## Problem

Three recurring pain points when working with Claude Code daily:

1. **Session boundary (A)** — Every new session starts cold. Claude re-learns project conventions, forgets decisions made, loses context on what was being built. Context re-establishment takes 5-10 minutes per session.

2. **Workflow templates (E)** — Each task type (feature, bugfix, refactor) requires figuring out the right sequence of steps, which agents to invoke, and in what order. No consistent, repeatable workflow.

3. **Model cost awareness (D)** — No guidance on when to use Opus vs Sonnet vs Haiku for a given task. Default: use whatever model is running, often over-paying for simple tasks or under-powering complex ones.

---

## Solution

**Claude Code Workflow Division** — 3 agents + 3 commands + 3 skills that together form a workflow optimization layer on top of Claude Code.

### Approach: Hybrid (Commands kick-off, Agents execute)

Users invoke `/session-start`, `/session-end`, `/workflow` as entry points. These trigger specialized agents that handle execution. No need to remember agent names for daily use — commands are the interface.

---

## Division Structure

```
magic-powers/
├── agents/workflow/
│   ├── orchestrator.md      # @orchestrator (Sonnet)
│   ├── session.md           # @session (Haiku)
│   └── model-advisor.md     # @model-advisor (Haiku)
│
├── commands/
│   ├── session-start.md     # /session-start
│   ├── session-end.md       # /session-end
│   └── workflow.md          # /workflow [type] "task"
│
└── skills/
    ├── workflow-templates/SKILL.md
    ├── session-lifecycle/SKILL.md
    └── model-selection-guide/SKILL.md
```

---

## Agents

### `@orchestrator` (Sonnet)

**Purpose:** Receives task + selects template + dispatches agents in correct sequence with correct models.

**Skills:** `workflow-templates`, `model-selection-guide`, `dispatching-parallel-agents`, `subagent-driven-development`

**Behavior:**
1. Parse task → infer or confirm template type
2. Load template → phases with agent + model assignment per phase
3. Dispatch each phase with isolated context (no session history leak)
4. Track progress via TodoWrite
5. Call @session snapshot after each major phase
6. Report completion with summary

**Template → Phase mapping:**

| Template | Phases | Models |
|----------|--------|--------|
| `feature` | plan → implement → test → review | Opus→Sonnet→Sonnet→Haiku |
| `bugfix` | reproduce → diagnose → fix → verify | Sonnet→Sonnet→Sonnet→Haiku |
| `refactor` | analyze → plan → implement → review | Opus→Sonnet→Sonnet→Haiku |
| `research` | gather → synthesize → document | Sonnet→Opus→Haiku |
| `incident` | triage → hotfix → postmortem | Sonnet→Sonnet→Haiku |

**Auto-detection from task description:**
- Contains "add/implement/build/create" → feature
- Contains "fix/broken/error/bug/failing" → bugfix
- Contains "clean/refactor/improve/simplify" → refactor
- Contains "research/investigate/understand/explore" → research
- Contains "down/outage/urgent/production" → incident

---

### `@session` (Haiku)

**Purpose:** Single responsibility — session lifecycle management. Start, end, snapshot.

**Skills:** `session-lifecycle`, `claude-memory`, `claude-project-settings`

**`/session-start` behavior:**
1. Read `~/.claude/projects/[hash]/memory/MEMORY.md` index
2. Load relevant memory files (project context, recent decisions, feedback)
3. Check `git status` + last 3 commits for recent work context
4. Review project `CLAUDE.md` for current conventions
5. Output 3-line session brief:
   ```
   Last session: [what was done]
   Current state: [git branch, uncommitted changes]
   Suggested next: [what MEMORY says is pending]
   ```

**`/session-end` behavior:**
1. Summarize work done this session (3-5 concrete bullets)
2. Extract decisions made → write to memory (project type)
3. Extract conventions learned → update feedback memory if new
4. If uncommitted work → create WIP commit or flag for user
5. Update MEMORY.md index
6. Output: "Session saved. Next: /session-start to resume."

**Snapshot (called mid-workflow by orchestrator):**
1. Write current task progress to session memory (ephemeral)
2. Record which phases complete, which pending
3. Ensure resumability if session ends unexpectedly

---

### `@model-advisor` (Haiku)

**Purpose:** Analyze any task description → recommend model tier with reasoning + cost estimate.

**Skills:** `model-selection-guide`

**Input:** Free-text task description

**Output format:**
```
Recommended: claude-sonnet-4-6
Reason: Implementation task — needs code generation quality, not deep reasoning
Estimated cost: ~$0.02-0.05 per task
Alternative: claude-haiku-4-5 if speed > quality acceptable
Escalate to Opus if: task involves architecture decisions or complex tradeoffs
```

**Decision tree:**
- Design / architecture / tradeoffs / "should we" → **Opus**
- Implement / code / build / debug complex / explain deeply → **Sonnet**
- Review / check / classify / format / summarize / simple extraction → **Haiku**
- Default (unclear) → **Sonnet** (safe middle ground)

**Cascade pattern:** If user selects Haiku and output quality is insufficient → suggest escalating to Sonnet. Never auto-escalate without user awareness.

---

## Commands

### `/session-start`

```
Invoke @session to initialize this working session:
1. Load project memory and recent context from ~/.claude/projects/
2. Check git status and last 3 commits
3. Review CLAUDE.md conventions
4. Output a 3-line session brief (last session / current state / suggested next)

Speed priority: complete in under 30 seconds. No long analysis.
```

### `/session-end`

```
Invoke @session to properly close this session:
1. Summarize completed work (3-5 bullets, concrete and specific)
2. Update project memory with decisions, new context, blockers found
3. If uncommitted changes exist: create WIP commit with message "wip: [summary]"
   or ask user preference
4. Update MEMORY.md index
5. Output closing summary and next-session entry point

Output ends with: "Session closed. Resume with /session-start"
```

### `/workflow [type] "[task]"`

```
Invoke @orchestrator to execute the named workflow template.

Usage:
  /workflow feature "add OAuth login with Google"
  /workflow bugfix "users can't log in after password reset"
  /workflow refactor "clean up the auth module — too many responsibilities"
  /workflow research "evaluate pgvector vs Pinecone for our use case"
  /workflow          "implement rate limiting"   ← type auto-detected

@orchestrator will:
1. Confirm template selection (or ask if ambiguous)
2. Show phases + model plan before executing
3. Execute phases in sequence, dispatching subagents per phase
4. Save snapshot after each phase
5. Report completion with what was done

User can interrupt between phases by responding to the phase completion message.
```

---

## Skills

### `workflow-templates`

Covers:
- 5 template definitions with phase sequences, agents, models per phase
- Auto-detection criteria from task description keywords
- Parallel vs sequential dispatch decision per phase
- Phase completion criteria (what does "plan phase done" mean?)
- Template customization patterns (how to extend a template)

### `session-lifecycle`

Covers:
- Session start checklist (what to load, what to check, what to output)
- Session end checklist (what to save, where, what format)
- Memory file structure for sessions (project context, decisions, conventions)
- 3-line context brief format specification
- Mid-session snapshot triggers (after major phases, on user request, before risky operations)
- Context handoff protocol between sessions
- WIP commit format (`wip: [summary]`)

### `model-selection-guide`

Covers:
- Decision tree: task description → model tier (Haiku/Sonnet/Opus)
- Cost estimates per model tier (approximate $/task)
- Escalation triggers (when cheap model output is insufficient)
- Cascade patterns (try Haiku → evaluate → escalate to Sonnet if needed)
- Per-phase model defaults by template type
- Anti-patterns (using Opus for everything, using Haiku for architecture)

---

## Install

```
/install-skills → Category 18: Claude Code Workflow
```

Or installed by default as part of `/setup` for all users (recommended for all roles).

---

## Success Criteria

- `/session-start` completes in <30 seconds with useful context brief
- `/workflow feature "X"` runs end-to-end without user needing to manually invoke agents
- `@model-advisor "review this PR"` correctly recommends Haiku (not Opus)
- `/session-end` then `/session-start` → Claude has enough context to continue without re-explanation
- User never needs to manually specify which model to use for standard tasks
