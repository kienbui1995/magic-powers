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
