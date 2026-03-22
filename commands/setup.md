---
description: "Personalize magic-powers for this project — detect stack, choose role & priority, generate agents & skills"
---

Run the magic-powers setup wizard for this project. Follow these steps exactly:

## Step 1: Scan Project
Detect the tech stack by checking these files:
- `package.json` → look for next, react, vue, express, fastify
- `tsconfig.json` → TypeScript
- `requirements.txt` or `pyproject.toml` → Python, look for fastapi, django, flask
- `go.mod` → Go
- `Cargo.toml` → Rust
- `Gemfile` → Ruby
- `docker-compose.yml` → look for postgres, mysql, mongo, redis

Report what you found: language, framework, database.

## Step 2: Ask Role
Ask the user:
> What's your role?
> 1. Solo Builder (full stack, làm hết)
> 2. Frontend Developer
> 3. Backend Developer
> 4. Product Manager
> 5. Team Lead

## Step 3: Ask Priority
Ask the user:
> Priority?
> 1. Ship nhanh
> 2. Chất lượng cao
> 3. Tiết kiệm cost

## Step 4: Generate Files

Based on answers, create these files:

### CLAUDE.md
Generate with:
- Detected stack info
- Recommended agents based on role:
  - Solo Builder: architect, debugger, reviewer, ui-designer, product-strategist, sre, copywriter
  - Frontend: ui-designer, reviewer, architect, copywriter
  - Backend: architect, debugger, database-optimizer, sre, reviewer, security-reviewer
  - Product Manager: product-strategist, copywriter, technical-writer, architect
  - Team Lead: architect, reviewer, product-strategist, sre, git-workflow
- Model guide based on priority:
  - Speed: "Prefer Haiku for quick tasks. Use Sonnet only when reasoning matters."
  - Quality: "Use full review pipeline: @reviewer → @security-reviewer before every commit."
  - Cost: "Start with Haiku agents. Escalate to Sonnet/Opus only when stuck."
- Project conventions from detected stack

### .claude/skills/project-conventions/SKILL.md
Generate a skill with:
- Detected language, framework, database
- Rules: match existing code style, follow framework conventions, use parameterized queries if DB detected

### .claude/agents/ (stack-specific overrides)
If a stack was detected, create overrides for key agents (architect, debugger) that include stack-specific context in their prompts. Copy the base agent format but add the detected tech stack to the system prompt.

## Step 5: Confirm
Show the user what was generated and remind them they can run `/setup` again anytime to reconfigure.
