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
cat ~/.claude/projects/[project-hash]/memory/MEMORY.md 2>/dev/null || echo "No memory yet"

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
name: session-[YYYY-MM-DD]
description: Key decisions and context from [date] session
type: project
---

## Decisions Made
- [decision]: [rationale]

## Work Completed
- [what was built/fixed/researched]

## Pending
- [what was started but not finished]
```

### 3. Mid-Session Snapshot

Called by @workflow-orchestrator after major workflow phases:

```
1. Write current task status to memory/session-snapshot.md (overwrite each time)
2. Record: workflow template, phases completed, phases pending, key files changed
3. Silent operation — don't interrupt the workflow
```

Snapshot format:
```markdown
Workflow: [template type] — "[task description]"
Completed phases: [list]
Current phase: [name] — [status]
Pending phases: [list]
Key files changed: [list]
```

### 4. Context Handoff Protocol

When starting session and snapshot exists:
1. Load snapshot → announce: "Resuming [workflow] — [task]. Last completed: [phase]"
2. Ask: "Continue from [next phase] or start fresh?"
3. If continue → load phase context → dispatch next phase

**Non-resumable phases (restart from beginning of template):**
- Incident template: triage + hotfix phases must run atomically — if session ended mid-phase, restart from triage to ensure correct diagnosis
- Any phase where partial execution could leave the system in an inconsistent state

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
- 🟢 **Suggestion** — snapshot after each workflow phase (not just at end), use consistent WIP commit format

## Anti-Patterns
- Session end that only prints to terminal (nothing persisted to memory = lost next session)
- Loading full memory files at session start (expensive + noisy — load index only)
- WIP commits without context note (next session can't understand what was being done)
- Skipping session start check (working without context = duplicate work, missed conventions)

## Integration
- `claude-memory` skill — memory file format, types, MEMORY.md index structure
- `@workflow-session` agent uses this skill as its primary operating guide
- `workflow-templates` — @workflow-session called for snapshots between phases
