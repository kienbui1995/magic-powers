---
description: "Start a Claude Code working session — loads project memory, checks git state, outputs 3-line context brief. Run at the beginning of every session."
---

Invoke @workflow-session to initialize this working session.

The session agent will:
1. Load project memory from ~/.claude/projects/ (if exists)
2. Check git status and last 3 commits
3. Output a 3-line brief: last session summary / current git state / suggested next action

Speed priority: complete in under 30 seconds.
After the brief, wait for user direction.
