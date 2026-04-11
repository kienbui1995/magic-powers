---
description: "Run a structured development workflow (feature/bugfix/refactor/research/incident). Usage: /workflow [type] \"task description\" — type auto-detected if omitted."
---

Invoke @workflow-orchestrator with the task.

Usage examples:
  /workflow feature "add OAuth login with Google"
  /workflow bugfix "users can't log in after password reset"
  /workflow refactor "clean up the auth module — too many responsibilities"
  /workflow research "evaluate pgvector vs Pinecone for our use case"
  /workflow "implement rate limiting"   ← type auto-detected from description

The orchestrator will:
1. Confirm or auto-detect template type (feature/bugfix/refactor/research/incident)
2. Show phase plan with agents and models before executing
3. Execute phases in sequence — correct model per phase
4. Give user opportunity to redirect between phases
5. Save progress snapshots after each major phase via @workflow-session

Pass the task description as the argument. Template type is optional — orchestrator infers from keywords (add/implement → feature, fix/bug → bugfix, refactor/clean → refactor, research/evaluate → research, urgent/outage → incident).
