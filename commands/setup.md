---
description: "Personalize magic-powers for this project — detect stack, choose role & priority, install optional features (hooks, MCP, stack-specific skills)"
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
> 1. 🚀 Ship nhanh
> 2. ✅ Chất lượng cao
> 3. 💰 Tiết kiệm cost

## Step 4: Optional Features
Ask the user which optional features to install. Show checkboxes with recommendations based on their priority:

> **Optional features** (cài vào `.claude/` của project):
>
> **Hooks:**
> - [ ] 🛡️ Safety guard — block ghi file nguy hiểm (.env, secrets, node_modules) ← **recommended**
> - [ ] 🔍 Auto-lint — chạy linter sau mỗi lần edit file ← recommended nếu "Chất lượng cao"
> - [ ] 🧪 Auto-test — chạy test liên quan sau code change ← recommended nếu "Chất lượng cao"
>
> **MCP Servers:**
> - [ ] 🎨 Stitch Design — generate UI designs (cần STITCH_API_KEY) ← show nếu detect frontend
> - [ ] 📚 Context7 — fetch latest library docs tự động
>
> **Stack-specific:**
> - [ ] 📋 Project conventions skill — coding rules dựa trên stack detected
> - [ ] 🏗️ Stack-aware agents — architect & debugger biết stack của bạn
>
> Chọn số (vd: 1,2,6,7) hoặc "all" / "skip":

## Step 5: Generate Files

### Always generate: CLAUDE.md
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

### If Safety guard selected:
Create `.claude/hooks/hooks.json` with PreToolUse hook:
```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": ".claude/hooks/safety-guard.sh \"$CLAUDE_FILE_PATH\"",
            "async": false
          }
        ]
      }
    ]
  }
}
```
Copy safety-guard.sh from `${CLAUDE_PLUGIN_ROOT}/hooks/optional/safety-guard.sh` to `.claude/hooks/safety-guard.sh` and make executable.

### If Auto-lint selected:
Add PostToolUse entry to `.claude/hooks/hooks.json`:
```json
{
  "matcher": "Write|Edit",
  "hooks": [
    {
      "type": "command",
      "command": ".claude/hooks/auto-lint.sh \"$CLAUDE_FILE_PATH\"",
      "async": true
    }
  ]
}
```
Copy auto-lint.sh from `${CLAUDE_PLUGIN_ROOT}/hooks/optional/auto-lint.sh` to `.claude/hooks/auto-lint.sh` and make executable.

### If Auto-test selected:
Add PostToolUse entry to `.claude/hooks/hooks.json`:
```json
{
  "matcher": "Write|Edit",
  "hooks": [
    {
      "type": "command",
      "command": ".claude/hooks/auto-test.sh \"$CLAUDE_FILE_PATH\"",
      "async": true
    }
  ]
}
```
Copy auto-test.sh from `${CLAUDE_PLUGIN_ROOT}/hooks/optional/auto-test.sh` to `.claude/hooks/auto-test.sh` and make executable.

### If Stitch Design MCP selected:
Add to `.claude/settings.json`:
```json
{
  "mcpServers": {
    "stitch-design": {
      "command": "node",
      "args": ["${CLAUDE_PLUGIN_ROOT}/scripts/stitch.mjs", "serve"]
    }
  }
}
```
Remind user to set `STITCH_API_KEY` environment variable.

### If Context7 MCP selected:
Add to `.claude/settings.json`:
```json
{
  "mcpServers": {
    "context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp@latest"]
    }
  }
}
```

### If Project conventions selected:
Create `.claude/skills/project-conventions/SKILL.md` with:
- Detected language, framework, database
- Rules: match existing code style, follow framework conventions, use parameterized queries if DB detected

### If Stack-aware agents selected:
Create `.claude/agents/` with architect.md and debugger.md that include stack-specific context in their prompts.

## Step 6: Confirm
Show summary of everything generated:
```
✅ Setup complete!

Generated:
  📄 CLAUDE.md (role: Backend, priority: Quality)
  🛡️ .claude/hooks/safety-guard.sh
  🔍 .claude/hooks/auto-lint.sh
  📋 .claude/skills/project-conventions/SKILL.md
  🏗️ .claude/agents/architect.md, debugger.md

Run /setup again anytime to reconfigure.
```
