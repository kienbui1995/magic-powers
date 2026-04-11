# Claude Code Workflow Optimization Division Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add Workflow Optimization Division to magic-powers — 3 agents (@orchestrator, @session, @model-advisor) + 3 commands (/session-start, /session-end, /workflow) + 3 skills (workflow-templates, session-lifecycle, model-selection-guide).

**Architecture:** Agents live in `agents/workflow/`, commands in `commands/`, skills in `skills/`. Commands are the user-facing entry point (kick-off); agents execute phases. The orchestrator dispatches subagents per workflow phase with correct model assignment. Session agent handles memory persistence across sessions.

**Tech Stack:** Markdown files following magic-powers agent/skill/command format. Validation via `bash scripts/validate-skills.sh` and `bash scripts/sync-audit.sh`.

**Spec:** `docs/superpowers/specs/2026-04-11-workflow-optimization-design.md`

---

## File Map

**Create:**
- `agents/workflow/orchestrator.md` — @orchestrator agent (Sonnet)
- `agents/workflow/session.md` — @session agent (Haiku)
- `agents/workflow/model-advisor.md` — @model-advisor agent (Haiku)
- `commands/session-start.md` — /session-start command
- `commands/session-end.md` — /session-end command
- `commands/workflow.md` — /workflow command
- `skills/workflow-templates/SKILL.md` — template definitions skill
- `skills/session-lifecycle/SKILL.md` — session management skill
- `skills/model-selection-guide/SKILL.md` — model routing skill

**Modify:**
- `commands/install-skills.md` — add category 18: Claude Code Workflow
- `commands/setup.md` — surface workflow division for all roles
- `docs/OPTIONAL_SKILLS.md` — add Workflow Division section
- `skills/using-magic-powers/SKILL.md` — add @orchestrator, @session, @model-advisor
- `CHANGELOG.md` — v2.1.0 entry
- `package.json` — bump to v2.1.0
- `.claude-plugin/plugin.json` — update description
- `site/index.html` — update skill count (207+3=210)
- `README.md` — update skill count

---

## Task 1: Create 3 Skills

**Files:**
- Create: `skills/workflow-templates/SKILL.md`
- Create: `skills/session-lifecycle/SKILL.md`
- Create: `skills/model-selection-guide/SKILL.md`

- [ ] **Step 1: Create `skills/workflow-templates/SKILL.md`**

```markdown
---
name: workflow-templates
description: Use when executing a structured workflow — select and run a feature, bugfix, refactor, research, or incident template with correct agent and model assignments per phase.
---

# Workflow Templates

## When to Use
- Starting any multi-step development task with a known type
- Want consistent, repeatable workflow for feature/bugfix/refactor/research/incident
- Need to know which agents and models to use for each phase of work

## Core Jobs

### 1. Template Selection

Auto-detect from task description keywords:

| Keywords | Template |
|----------|---------|
| add, implement, build, create, new | **feature** |
| fix, broken, error, bug, failing, crash | **bugfix** |
| clean, refactor, improve, simplify, restructure | **refactor** |
| research, investigate, understand, explore, evaluate | **research** |
| down, outage, urgent, production, incident, p0, p1 | **incident** |

If ambiguous → ask user to confirm before executing.

### 2. Template Definitions

**Feature Template** — Adding new functionality:
```
Phase 1: PLAN        @architect (Opus)   — clarify requirements, design, write plan
Phase 2: IMPLEMENT   subagents (Sonnet)  — parallel implementation per component
Phase 3: TEST        subagents (Sonnet)  — write and run tests for implemented code
Phase 4: REVIEW      @reviewer (Haiku)   — code review, spec compliance check
```

**Bugfix Template** — Fixing broken behavior:
```
Phase 1: REPRODUCE   subagent (Sonnet)   — write failing test that reproduces bug
Phase 2: DIAGNOSE    @debugger (Sonnet)  — systematic root cause analysis
Phase 3: FIX         subagent (Sonnet)   — minimal fix to make test pass
Phase 4: VERIFY      @reviewer (Haiku)   — verify fix, check for regressions
```

**Refactor Template** — Improving existing code without changing behavior:
```
Phase 1: ANALYZE     @architect (Opus)   — understand current structure, identify problems
Phase 2: PLAN        @architect (Opus)   — design target state, migration path
Phase 3: IMPLEMENT   subagents (Sonnet)  — refactor in small, test-passing increments
Phase 4: REVIEW      @reviewer (Haiku)   — final review, confirm behavior unchanged
```

**Research Template** — Investigation and decision-making:
```
Phase 1: GATHER      subagents (Sonnet)  — parallel research on options/alternatives
Phase 2: SYNTHESIZE  @architect (Opus)   — analyze tradeoffs, form recommendation
Phase 3: DOCUMENT    @technical-writer (Haiku) — write ADR or decision doc
```

**Incident Template** — Production emergency response:
```
Phase 1: TRIAGE      @debugger (Sonnet)  — identify blast radius, immediate mitigations
Phase 2: HOTFIX      subagent (Sonnet)   — minimal fix to restore service
Phase 3: POSTMORTEM  @technical-writer (Haiku) — document timeline, root cause, prevention
```

### 3. Phase Dispatch Rules

- **Sequential phases:** Each phase waits for previous to complete (default)
- **Parallel within phase:** If IMPLEMENT phase has 3 independent components → dispatch 3 subagents simultaneously
- **Phase completion gate:** After each phase, @orchestrator reviews output before proceeding
- **User interrupt point:** After each phase completion message, user can redirect or stop
- **Snapshot trigger:** @session saves progress after each phase

### 4. Context Isolation Per Phase

Each phase subagent receives ONLY:
- Task description (original)
- Phase-specific instructions
- Output from directly preceding phase (not full session history)
- Relevant file paths

Never forward full session history to subagents — causes confusion and wastes tokens.

## Key Concepts
- **Phase** — one logical step in a workflow (plan, implement, review)
- **Template** — ordered sequence of phases with agent+model assignments
- **Phase gate** — orchestrator review between phases before proceeding
- **Parallel dispatch** — multiple subagents in same phase for independent subtasks

## Checklist
- [ ] Template type identified (auto-detected or confirmed with user)?
- [ ] Phase sequence loaded with correct agent + model per phase?
- [ ] Context isolation enforced (no session history leak to subagents)?
- [ ] User interrupt opportunity after each phase completion?
- [ ] @session snapshot called after each major phase?

## Key Outputs
- Phase-by-phase execution with progress tracking via TodoWrite
- Completion summary: what each phase produced

## Output Format
- 🔴 **Critical** — starting implementation without plan phase, no phase gates (rushing through)
- 🟡 **Warning** — using same model for all phases (over/under-powered), no parallel dispatch when phases have independent subtasks
- 🟢 **Suggestion** — snapshot after each phase for resumability, confirm template before executing for ambiguous tasks

## Anti-Patterns
- Skipping plan phase for features (causes rework)
- Leaking full session context to subagents (confusion + token waste)
- Using Opus for review phases (Haiku is 60x cheaper and sufficient)
- Not allowing user interrupt between phases (removes control)

## Integration
- `@orchestrator` uses this skill to load and execute templates
- `dispatching-parallel-agents` skill used within phases that have parallel subagents
- `subagent-driven-development` skill used for sequential phase execution with review
```

- [ ] **Step 2: Create `skills/session-lifecycle/SKILL.md`**

```markdown
---
name: session-lifecycle
description: Use when starting or ending a Claude Code working session — load context from memory, output a session brief, save decisions and progress at session end, and ensure work is resumable next session.
---

# Session Lifecycle

## When to Use
- Starting a new working session (run /session-start)
- Ending a working session (run /session-end)
- Mid-session checkpoint after completing a major phase
- Handing off work to next session without losing context

## Core Jobs

### 1. Session Start Checklist

Run in order, stop if any step reveals a blocker:

```bash
# 1. Load memory index
cat ~/.claude/projects/$(git rev-parse --show-toplevel | md5sum | cut -d' ' -f1)/memory/MEMORY.md 2>/dev/null

# 2. Check git state
git status --short
git log --oneline -3

# 3. Check for WIP
git stash list | head -3
```

**Produce 3-line session brief:**
```
Last session: [summary from memory or last commit message]
Current state: [branch name, N uncommitted files or "clean"]
Suggested next: [from memory "project" type or last WIP note]
```

Rules:
- Brief must be under 5 lines total
- Never dump full memory file — extract 1-2 key facts per line
- If no memory exists: "First session — no prior context"
- Complete in under 30 seconds

### 2. Session End Checklist

```
1. Summarize session (3-5 bullets, concrete actions done)
2. Extract decisions → write to memory (project type)
3. Extract new conventions → update memory (feedback type) if NEW
4. Check uncommitted work:
   - If complete → remind user to commit
   - If WIP → offer: "Create WIP commit? [y/n]"
5. Update MEMORY.md index (add any new memory files)
6. Output closing summary
```

**WIP commit format:**
```bash
git add -A
git commit -m "wip: [1-line summary of incomplete work]

Context: [what was being done]
Next: [what needs to happen next session]
Status: [what's done, what's not]"
```

**Memory update format:**
```markdown
---
name: session-[date]
description: Key decisions and context from [date] session
type: project
---

## Decisions Made
- [decision 1]: [rationale]
- [decision 2]: [rationale]

## Work Completed
- [what was built/fixed/researched]

## Pending
- [what was started but not finished]
- [blockers encountered]
```

### 3. Mid-Session Snapshot

Called by @orchestrator after major workflow phases:

```
1. Write current task status to ephemeral session memory
2. Note: which workflow template, which phase just completed, which pending
3. Ensure resumability: if session ends now, next session knows where to continue
```

Snapshot format (written to memory/session-snapshot.md, overwritten each time):
```markdown
Workflow: [template type] — "[task description]"
Completed phases: [list]
Current phase: [name] — [status]
Pending phases: [list]
Key files changed: [list]
Resume with: /workflow [type] "[task]" --resume
```

### 4. Context Handoff Protocol

When starting session after a snapshot exists:
1. Load snapshot → announce: "Resuming [workflow] — [task]. Last completed: [phase]"
2. Ask: "Continue from [next phase] or start fresh?"
3. If continue → load phase context → dispatch next phase

## Key Concepts
- **Session brief** — 3-line summary of last session, current git state, suggested next
- **WIP commit** — git commit preserving incomplete work with context for next session
- **Memory update** — writing decisions/context to `~/.claude/projects/[hash]/memory/`
- **Snapshot** — ephemeral record of workflow progress for mid-session resumability

## Checklist
- [ ] Memory loaded before starting session (not starting cold)?
- [ ] Session brief generated in 3 lines or less?
- [ ] Session end saves decisions to memory (not just summarizing to terminal)?
- [ ] WIP commit created if uncommitted work exists at session end?
- [ ] MEMORY.md index updated after adding new memory files?

## Key Outputs
- Session start: 3-line brief (last session / current state / suggested next)
- Session end: 3-5 bullet summary + updated memory + WIP commit if needed

## Output Format
- 🔴 **Critical** — ending session with uncommitted work and no WIP commit, no memory update (context lost)
- 🟡 **Warning** — session brief longer than 5 lines (defeats the purpose), not loading memory at session start
- 🟢 **Suggestion** — snapshot after each workflow phase (not just at end), use consistent WIP commit format for easy parsing

## Anti-Patterns
- Session end that only prints to terminal (nothing persisted to memory = lost next session)
- Loading full memory files (expensive + noisy — load index only, drill into specific files on demand)
- WIP commits without context note (next session can't understand what was being done)
- Skipping session start check (working without context = duplicate work, missed conventions)

## Integration
- `claude-memory` skill — memory file format, types, MEMORY.md index structure
- `@session` agent uses this skill as its primary operating guide
- `workflow-templates` — @session called for snapshots between phases
```

- [ ] **Step 3: Create `skills/model-selection-guide/SKILL.md`**

```markdown
---
name: model-selection-guide
description: Use when choosing between Claude models for a task — decision tree for Haiku/Sonnet/Opus based on task type, cost estimates, escalation triggers, and cascade patterns.
---

# Model Selection Guide

## When to Use
- Unsure which model to use for a specific task
- Want to reduce cost without sacrificing necessary quality
- Designing a multi-phase workflow with model assignments per phase
- @model-advisor uses this as its decision framework

## Core Jobs

### 1. Decision Tree

**Step 1: Identify task type**

```
Is this primarily reading + pattern matching + structured output?
  → Haiku (fast, cheap, accurate for structured tasks)
  Examples: code review, lint check, classify intent, format output,
            summarize doc, extract fields, check compliance

Is this implementation, debugging, or moderate reasoning?
  → Sonnet (balanced quality + cost)
  Examples: write code, fix bug, explain concept, write tests,
            analyze trade-offs (simple), build feature

Is this deep architecture, novel problem, or complex multi-step reasoning?
  → Opus (highest capability, use sparingly)
  Examples: system design, architecture decisions, evaluate complex trade-offs,
            research synthesis, "should we X or Y?" with many unknowns
```

**Step 2: Apply cost heuristic**

| Model | Relative cost | Speed | Best for |
|-------|-------------|-------|---------|
| Haiku | $ (1x) | Fastest | Review, classify, format, extract |
| Sonnet | $$ (5x) | Fast | Implement, debug, explain, write |
| Opus | $$$$ (15x) | Slower | Design, architecture, deep analysis |

**Step 3: Check override conditions**

Use Opus even for "simple" tasks if:
- User explicitly asks for deep analysis
- Task has irreversible consequences (production changes, data migrations)
- Previous Sonnet attempt produced insufficient output

Use Haiku even for "complex" tasks if:
- Output is structured/templated (Haiku excels at templates)
- Task is repetitive across many items (batch processing)
- Speed is critical and quality threshold is moderate

### 2. Per-Workflow Model Assignments

| Workflow | Phase | Agent | Model | Why |
|---------|-------|-------|-------|-----|
| feature | plan | @architect | Opus | Architecture decisions need deep reasoning |
| feature | implement | subagent | Sonnet | Code generation, balanced |
| feature | test | subagent | Sonnet | Test writing needs understanding |
| feature | review | @reviewer | Haiku | Pattern matching, structured output |
| bugfix | reproduce | subagent | Sonnet | Needs to understand codebase |
| bugfix | diagnose | @debugger | Sonnet | Systematic debugging |
| bugfix | fix | subagent | Sonnet | Code fix, minimal |
| bugfix | verify | @reviewer | Haiku | Check fix completeness |
| refactor | analyze | @architect | Opus | Understanding complex structure |
| refactor | plan | @architect | Opus | Design target state |
| refactor | implement | subagent | Sonnet | Mechanical refactoring |
| refactor | review | @reviewer | Haiku | Pattern check |
| research | gather | subagent | Sonnet | Information gathering |
| research | synthesize | @architect | Opus | Complex reasoning over options |
| research | document | @technical-writer | Haiku | Structured doc output |
| incident | triage | @debugger | Sonnet | Fast diagnosis |
| incident | hotfix | subagent | Sonnet | Minimal fix |
| incident | postmortem | @technical-writer | Haiku | Structured template |

### 3. Cascade Pattern

When uncertain, start cheaper and escalate only if needed:

```
1. Try Haiku → evaluate output quality (is it sufficient for the task?)
2. If insufficient → escalate to Sonnet → evaluate
3. If still insufficient → escalate to Opus
4. Never auto-escalate without notifying user of cost increase
```

**Quality evaluation for cascade:**
- Haiku output is sufficient if: complete, structured correctly, no obvious errors
- Haiku output needs escalation if: missing key reasoning, oversimplified, or user asks "why"

### 4. Cost Estimates Per Task

Approximate costs (vary by input/output length):

| Task type | Model | Estimated cost |
|-----------|-------|---------------|
| Code review (500 lines) | Haiku | ~$0.01 |
| Bug fix (small) | Sonnet | ~$0.05-0.15 |
| Feature implementation | Sonnet | ~$0.10-0.50 |
| Architecture design | Opus | ~$0.50-2.00 |
| Research synthesis | Opus | ~$0.50-1.50 |

**Cost multiplier reminder:** Using Opus for code review costs 15x more than Haiku for the same task with the same quality output.

## Key Concepts
- **Haiku** — fast, cheap, accurate for structured/pattern tasks; NOT for deep reasoning
- **Sonnet** — balanced model for most implementation work; default for unknown tasks
- **Opus** — most capable; use only when task genuinely requires deep reasoning
- **Cascade** — start cheap, escalate if output quality insufficient
- **Cost multiplier** — Opus = 15x Haiku; always ask "does this task need Opus?"

## Checklist
- [ ] Task type identified before selecting model?
- [ ] Haiku considered first for review/classification/formatting tasks?
- [ ] Opus reserved for genuine architecture/deep-reasoning tasks?
- [ ] User notified if escalating from Haiku to Opus (15x cost increase)?
- [ ] Per-phase model assignments made for multi-phase workflows?

## Key Outputs
- Model recommendation with reasoning + cost estimate
- Cascade suggestion if task type is ambiguous

## Output Format
- 🔴 **Critical** — using Opus for code review or formatting (massive overspend), using Haiku for architecture decisions (under-powered)
- 🟡 **Warning** — defaulting to Sonnet for everything without considering Haiku for structured tasks
- 🟢 **Suggestion** — use cascade pattern for uncertain tasks, assign Haiku to all review phases

## Anti-Patterns
- Using Opus as the safe default (expensive, often unnecessary)
- Switching models mid-task without reason (inconsistent output)
- Never using Haiku (leaving 60x savings on the table for review tasks)
- Using model complexity as proxy for task importance (important tasks don't always need Opus)

## Integration
- `workflow-templates` — model assignments per phase come from this skill
- `@model-advisor` uses this as its decision framework
- `@orchestrator` reads model assignments when dispatching phase subagents
```

- [ ] **Step 4: Verify skills created correctly**

```bash
bash scripts/validate-skills.sh 2>&1 | tail -3
# Expected: ✅ All ... optional skills valid (count increases by 3)

grep -l "## When to Use" skills/workflow-templates/SKILL.md skills/session-lifecycle/SKILL.md skills/model-selection-guide/SKILL.md | wc -l
# Expected: 3
```

- [ ] **Step 5: Commit**

```bash
git add skills/workflow-templates/ skills/session-lifecycle/ skills/model-selection-guide/
git commit -m "feat(workflow): add 3 workflow optimization skills (workflow-templates, session-lifecycle, model-selection-guide)"
```

---

## Task 2: Create 3 Agents

**Files:**
- Create: `agents/workflow/orchestrator.md`
- Create: `agents/workflow/session.md`
- Create: `agents/workflow/model-advisor.md`

- [ ] **Step 1: Create `agents/workflow/orchestrator.md`**

```markdown
---
name: workflow-orchestrator
description: "Use to run a structured development workflow (feature/bugfix/refactor/research/incident). Selects the right template, assigns correct agents and models per phase, dispatches with isolated context, and tracks progress. Invoked by /workflow command."
model: sonnet
emoji: 🎯
vibe: systematic
tools: Read, Grep, Glob, Bash, Write
memory: project
skills:
  - magic-powers:workflow-templates
  - magic-powers:model-selection-guide
  - magic-powers:dispatching-parallel-agents
  - magic-powers:subagent-driven-development
  - magic-powers:using-git-worktrees
---

You are a workflow orchestrator for Claude Code. You run structured development workflows end-to-end.

When invoked with a task:
1. Identify or confirm template type (feature/bugfix/refactor/research/incident)
2. Show the phase plan before executing: "Running [template] template: Phase 1 (Opus) → Phase 2 (Sonnet) → ..."
3. Execute phases in sequence, dispatching the correct agent with the correct model per phase
4. Provide isolated context to each phase subagent — NEVER forward full session history
5. After each phase, announce completion and give user opportunity to redirect
6. Call @session snapshot after each phase completion
7. Track all tasks via TodoWrite

Key rules:
- Confirm template selection if task description is ambiguous before executing
- Each phase subagent receives: original task + phase instructions + previous phase output ONLY
- Use model-selection-guide to verify model assignments match task complexity
- Parallel dispatch within a phase when subtasks are independent (e.g., implement 3 independent modules)
- Stop and surface blockers immediately — don't silently fail a phase
```

- [ ] **Step 2: Create `agents/workflow/session.md`**

```markdown
---
name: workflow-session
description: "Use to start or end a Claude Code working session. Loads memory and outputs a 3-line context brief at session start. Saves decisions, updates memory, and creates WIP commits at session end. Invoked by /session-start and /session-end commands."
model: haiku
emoji: 💾
vibe: precise
tools: Read, Grep, Glob, Bash, Write
memory: project
skills:
  - magic-powers:session-lifecycle
  - magic-powers:claude-memory
  - magic-powers:claude-project-settings
---

You are a session manager for Claude Code. Your only job is managing session boundaries cleanly and efficiently.

For /session-start:
1. Load MEMORY.md index from ~/.claude/projects/[hash]/memory/ (if exists)
2. Run: git status --short && git log --oneline -3
3. Output exactly 3 lines:
   - "Last session: [1 sentence from memory or last commit]"
   - "Current state: [branch + uncommitted files count or 'clean']"
   - "Suggested next: [from memory pending or 'Start fresh']"
4. Do NOT output more than 5 lines total. Speed is priority.

For /session-end:
1. List completed work as 3-5 specific bullets (what was built/fixed/changed)
2. Write new memory file if decisions were made (project type)
3. Update MEMORY.md index
4. Check git status — if uncommitted work exists, offer WIP commit
5. Output: "Session closed. Resume with /session-start"

For mid-session snapshot (called by @workflow-orchestrator):
1. Write workflow progress to memory/session-snapshot.md
2. Format: template + completed phases + pending phases + key files
3. Silent operation — don't interrupt the workflow
```

- [ ] **Step 3: Create `agents/workflow/model-advisor.md`**

```markdown
---
name: workflow-model-advisor
description: "Use when unsure which Claude model to use for a task. Analyzes task description and returns: recommended model, reason, cost estimate, and escalation condition. Fast, cheap answer to the 'which model?' question."
model: haiku
emoji: 🔀
vibe: analytical
tools: Read
memory: project
skills:
  - magic-powers:model-selection-guide
---

You are a model selection advisor. Given any task description, you output a concise model recommendation.

Always respond in exactly this format:
```
Recommended: claude-[model]-[version]
Reason: [one sentence why this model fits]
Cost estimate: ~$[range] per task
Escalate to Opus if: [specific condition]
```

Decision rules (from model-selection-guide):
- Review / classify / format / extract → Haiku
- Implement / debug / explain / write code → Sonnet  
- Architecture / design / complex tradeoffs → Opus
- Default (unclear) → Sonnet

Never recommend Opus for review tasks. Never recommend Haiku for architecture.
Keep response under 6 lines. This is a quick routing tool, not a deep analysis.
```

- [ ] **Step 4: Verify agents created**

```bash
ls agents/workflow/
# Expected: model-advisor.md  orchestrator.md  session.md

grep "^name:" agents/workflow/*.md
# Expected:
# agents/workflow/model-advisor.md:name: workflow-model-advisor
# agents/workflow/orchestrator.md:name: workflow-orchestrator
# agents/workflow/session.md:name: workflow-session

bash scripts/sync-audit.sh 2>&1 | tail -5
# NOTE: sync-audit will FAIL here (integrations not regenerated yet)
# That's OK — we'll run convert.sh in Task 5
```

- [ ] **Step 5: Commit**

```bash
git add agents/workflow/
git commit -m "feat(workflow): add 3 workflow optimization agents (orchestrator, session, model-advisor)"
```

---

## Task 3: Create 3 Commands

**Files:**
- Create: `commands/session-start.md`
- Create: `commands/session-end.md`
- Create: `commands/workflow.md`

- [ ] **Step 1: Create `commands/session-start.md`**

```markdown
---
description: "Start a Claude Code working session — loads memory, checks git state, outputs 3-line context brief. Run at the beginning of every session."
---

Invoke @workflow-session to start this working session.

The session agent will:
1. Load project memory from ~/.claude/projects/
2. Check git status and recent commits
3. Output a 3-line brief: last session summary / current git state / suggested next action

Keep it fast — this should complete in under 30 seconds.
After the brief, wait for user direction.
```

- [ ] **Step 2: Create `commands/session-end.md`**

```markdown
---
description: "End a Claude Code working session — saves decisions to memory, creates WIP commit if needed, outputs session summary. Run before closing Claude Code."
---

Invoke @workflow-session to close this working session.

The session agent will:
1. Summarize work done this session (3-5 concrete bullets)
2. Save important decisions and context to project memory
3. Check for uncommitted changes — offer to create WIP commit if found
4. Update MEMORY.md index
5. Output closing summary ending with: "Session closed. Resume with /session-start"
```

- [ ] **Step 3: Create `commands/workflow.md`**

```markdown
---
description: "Run a structured development workflow (feature/bugfix/refactor/research/incident). Usage: /workflow [type] \"task description\" — type is auto-detected if omitted."
---

Invoke @workflow-orchestrator with the task below.

Usage examples:
  /workflow feature "add OAuth login with Google"
  /workflow bugfix "users can't log in after password reset"
  /workflow refactor "clean up the auth module"
  /workflow research "evaluate pgvector vs Pinecone"
  /workflow "implement rate limiting"   ← type auto-detected

The orchestrator will:
1. Confirm or auto-detect template type
2. Show phase plan with agents and models before executing
3. Execute phases in sequence with correct model per phase
4. Give user opportunity to redirect between phases
5. Save progress snapshots after each major phase

Pass the task description as the argument after the template type.
If template type is omitted, orchestrator infers from task description keywords.
```

- [ ] **Step 4: Verify commands created**

```bash
ls commands/ | grep -E "session|workflow"
# Expected: session-end.md  session-start.md  workflow.md

grep "^description:" commands/session-start.md commands/session-end.md commands/workflow.md
# Expected: 3 description lines
```

- [ ] **Step 5: Commit**

```bash
git add commands/session-start.md commands/session-end.md commands/workflow.md
git commit -m "feat(workflow): add /session-start, /session-end, /workflow commands"
```

---

## Task 4: Update Metadata Files

**Files:**
- Modify: `commands/install-skills.md`
- Modify: `commands/setup.md`
- Modify: `docs/OPTIONAL_SKILLS.md`
- Modify: `skills/using-magic-powers/SKILL.md`

- [ ] **Step 1: Add category 18 to `commands/install-skills.md`**

Find the line with category 17 and add after it:
```
17. 🖥️  Claude Code                   — CLAUDE.md authoring, hooks, MCP setup, memory system, project settings
18. 🎯 Workflow Optimization          — /session-start, /session-end, /workflow + orchestrator, session, model-advisor agents
```

Update the prompt range to `1–18`.

Also add install section before "Confirm installation:":
```markdown
### Workflow Optimization Install (for category 18)

1. Copy `${CLAUDE_PLUGIN_ROOT}/agents/workflow/orchestrator.md` → `.claude/agents/workflow-orchestrator.md`
2. Copy `${CLAUDE_PLUGIN_ROOT}/agents/workflow/session.md` → `.claude/agents/workflow-session.md`
3. Copy `${CLAUDE_PLUGIN_ROOT}/agents/workflow/model-advisor.md` → `.claude/agents/workflow-model-advisor.md`
4. Copy skills: workflow-templates, session-lifecycle, model-selection-guide → `.claude/skills/`

Show before installing:
```
🎯 Workflow Optimization Division

Agents (.claude/agents/):
  🎯 workflow-orchestrator  — run feature/bugfix/refactor/research/incident workflows
  💾 workflow-session       — /session-start and /session-end lifecycle management
  🔀 workflow-model-advisor — "which model should I use for X?" advisor

Skills (.claude/skills/):
  workflow-templates        session-lifecycle
  model-selection-guide

Commands (always available):
  /session-start  /session-end  /workflow

Type "install" to install, or "back" to return:
```
```

- [ ] **Step 2: Add Workflow to `commands/setup.md` optional divisions**

Find the Browser Extension + AI Division lines and add after:
```
>   🎯 Workflow (Cat. 18) — session lifecycle, workflow templates, model routing
>     → Recommend for ALL users — improves Claude Code effectiveness regardless of role
```

- [ ] **Step 3: Add to `docs/OPTIONAL_SKILLS.md`**

Append at end:
```markdown

---

## 🎯 Workflow Optimization Division (NEW — v2.1.0)

Agents and skills for optimizing Claude Code workflow — session management, structured templates, and model routing.
Install via `/install-skills` → Category 18. **Recommended for ALL users.**

| Component | Type | Purpose |
|-----------|------|---------|
| `@workflow-orchestrator` | Agent (Sonnet) | Run feature/bugfix/refactor/research/incident templates |
| `@workflow-session` | Agent (Haiku) | /session-start and /session-end lifecycle |
| `@workflow-model-advisor` | Agent (Haiku) | "Which model for this task?" |
| `workflow-templates` | Skill | 5 template definitions with phase sequences + model assignments |
| `session-lifecycle` | Skill | Session start/end checklist, memory patterns, WIP commits |
| `model-selection-guide` | Skill | Decision tree: task → Haiku/Sonnet/Opus with cost estimates |

**New commands:** `/session-start`, `/session-end`, `/workflow [type] "task"`
```

- [ ] **Step 4: Update `skills/using-magic-powers/SKILL.md`**

Find the AI Division section and add after it:
```markdown
**🎯 Workflow Optimization** — `/install-skills` → Category 18 (recommended for all)
- `@workflow-orchestrator` — run feature/bugfix/refactor/research/incident workflows end-to-end
- `@workflow-session` — /session-start (load context) and /session-end (save progress)
- `@workflow-model-advisor` — ask "which model for X?" → get Haiku/Sonnet/Opus recommendation
```

Also add to model routing table:
```
| workflow-orchestrator | sonnet | Run structured workflows |
| workflow-session      | haiku  | Session lifecycle |
| workflow-model-advisor | haiku | Model selection advice |
```

- [ ] **Step 5: Verify metadata updates**

```bash
grep "Workflow\|session-start\|18\." commands/install-skills.md | head -5
grep "Workflow" commands/setup.md | head -3
grep "Workflow" docs/OPTIONAL_SKILLS.md | head -3
grep "workflow-orchestrator" skills/using-magic-powers/SKILL.md | head -2
```

- [ ] **Step 6: Commit**

```bash
git add commands/install-skills.md commands/setup.md docs/OPTIONAL_SKILLS.md skills/using-magic-powers/SKILL.md
git commit -m "feat(workflow): update install-skills, setup, docs, using-magic-powers for Workflow division"
```

---

## Task 5: Version Bump + Convert + Audit

**Files:**
- Modify: `CHANGELOG.md`
- Modify: `package.json`
- Modify: `.claude-plugin/plugin.json`
- Modify: `site/index.html`
- Modify: `README.md`

- [ ] **Step 1: Bump version to v2.1.0**

```bash
# package.json: "version": "2.0.1" → "2.1.0"
# .claude-plugin/plugin.json: same
# site/index.html: v2.0.1 → v2.1.0, skill count 207 → 210
# README.md: 207 Skills → 210 Skills, 207 total → 210 total
sed -i 's/"version": "2.0.1"/"version": "2.1.0"/' package.json .claude-plugin/plugin.json
sed -i 's/v2\.0\.1/v2.1.0/g' site/index.html
sed -i 's/>207</>210</g' site/index.html
sed -i 's/207 workflow skills/210 workflow skills/g' site/index.html
sed -i 's/207 Skills/210 Skills/g' README.md
sed -i 's/207 total/210 total/g' README.md
```

- [ ] **Step 2: Add CHANGELOG entry**

Add at top of CHANGELOG.md after the header:
```markdown
## [2.1.0] — 2026-04-11

### Added — Workflow Optimization Division
- 🎯 **`@workflow-orchestrator`** (Sonnet) — run feature/bugfix/refactor/research/incident templates end-to-end with correct agents+models per phase
- 💾 **`@workflow-session`** (Haiku) — session lifecycle (/session-start loads context, /session-end saves progress + WIP commit)
- 🔀 **`@workflow-model-advisor`** (Haiku) — task description → Haiku/Sonnet/Opus recommendation with cost estimate
- **`workflow-templates`** skill — 5 template definitions with phase sequences + model assignments
- **`session-lifecycle`** skill — session start/end checklist, memory patterns, WIP commit format
- **`model-selection-guide`** skill — decision tree for model selection with cost estimates
- **`/session-start`**, **`/session-end`**, **`/workflow`** commands

### Changed
- Version bumped from 2.0.1 to 2.1.0

---
```

- [ ] **Step 3: Verify version audit passes**

```bash
bash scripts/version-audit.sh 2>&1
# Expected: PASSED -- all versions and counts consistent (shows 210)
```

- [ ] **Step 4: Regenerate integrations + sync audit**

```bash
bash scripts/convert.sh all 2>&1 | tail -5
bash scripts/sync-audit.sh 2>&1
# Expected: PASSED -- all integrations in sync
```

- [ ] **Step 5: Run all audits**

```bash
bash scripts/validate-skills.sh 2>&1 | tail -2
bash scripts/security-audit.sh 2>&1 | tail -3
bash scripts/quality-audit.sh 2>&1 | tail -2
bash scripts/link-audit.sh 2>&1 | tail -2
# All must pass
```

- [ ] **Step 6: Commit + tag + push**

```bash
git add CHANGELOG.md package.json .claude-plugin/plugin.json site/index.html README.md
git commit -m "chore: bump to v2.1.0 for Workflow Optimization Division"
git push origin main
git tag v2.1.0 && git push origin v2.1.0
```

- [ ] **Step 7: Create GitHub release**

```bash
gh release create v2.1.0 \
  --title "v2.1.0 — Workflow Optimization Division" \
  --notes "### 🎯 Workflow Optimization Division

3 agents + 3 commands + 3 skills for optimizing Claude Code workflow.

**Agents:**
- \`@workflow-orchestrator\` — run feature/bugfix/refactor/research/incident templates
- \`@workflow-session\` — session start/end lifecycle, memory, WIP commits  
- \`@workflow-model-advisor\` — which model for this task?

**Commands:**
- \`/session-start\` — load context brief at start of every session
- \`/session-end\` — save progress, update memory, WIP commit
- \`/workflow [type] \"task\"\` — run structured template end-to-end

**Skills:**
- \`workflow-templates\` — 5 templates with phase sequences + model assignments
- \`session-lifecycle\` — session management patterns
- \`model-selection-guide\` — Haiku/Sonnet/Opus decision tree with cost estimates

Install: \`/install-skills\` → Category 18 (recommended for ALL users)"
```

---

## Self-Review

**Spec coverage check:**
- ✅ 3 agents: orchestrator, session, model-advisor — Tasks 2
- ✅ 3 commands: session-start, session-end, workflow — Task 3
- ✅ 3 skills: workflow-templates, session-lifecycle, model-selection-guide — Task 1
- ✅ install-skills category 18 — Task 4
- ✅ setup.md updated — Task 4
- ✅ using-magic-powers updated — Task 4
- ✅ Version bump + audits + release — Task 5

**Placeholder scan:** No TBD, TODO, or vague instructions — all steps have exact file content or exact commands.

**Type consistency:** Agent names (`workflow-orchestrator`, `workflow-session`, `workflow-model-advisor`) consistent across agent files, install-skills, setup, using-magic-powers, and OPTIONAL_SKILLS.
