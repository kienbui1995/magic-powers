---
name: claude-project-settings
description: Use when configuring Claude Code for a project — .claude/settings.json structure, permission modes, model selection, tool allowlists/denylists, and team vs personal settings.
---

# Claude Project Settings

## Overview

`.claude/settings.json` is the control plane for Claude Code on a project. It defines what Claude can do, which model it uses, which external tools it can call, and what automation runs around its tool usage. Committing this file to the repo means everyone on the team gets the same Claude Code behavior — no individual configuration drift.

## When to Use

- Setting up Claude Code for a new project or team
- Restricting what Claude Code can do (security, safety)
- Configuring which model Claude uses by default
- Setting up team-wide permissions and hooks

## Core Jobs

### 1. Settings File Structure

```json
// .claude/settings.json (project-level, committed to repo)
{
  "model": "claude-sonnet-4-6",
  "permissions": {
    "allow": [
      "Bash(git *)",
      "Bash(npm run *)",
      "Bash(pytest *)",
      "Edit(*)",
      "Read(*)"
    ],
    "deny": [
      "Bash(rm -rf *)",
      "Bash(git push --force *)",
      "Bash(sudo *)"
    ]
  },
  "mcpServers": { },
  "hooks": { }
}
```

**Denylist overrides allowlist.** If a command matches both, it is denied.

### 2. Permission Modes

Claude Code has 4 permission modes (set per-session with `--permission-mode` flag):

| Mode | What Claude can do | Use for |
|------|-------------------|---------|
| `default` | Most things, asks for risky operations | Normal development |
| `acceptEdits` | Auto-accept file edits, asks for bash | Code generation tasks |
| `bypassPermissions` | Everything without asking | Trusted automation (CI) |
| `plan` | Read-only, only edits plan file | Planning sessions |

### 3. Model Selection

```json
{
  "model": "claude-sonnet-4-6"
}
```

Override per-session with `--model` flag or `/model` command in the Claude Code UI.

**Choosing the default model:**

| Model | Use for |
|-------|---------|
| `claude-haiku-4-5-20251001` | Fast, cost-sensitive tasks; simple code gen |
| `claude-sonnet-4-6` | Balanced — most projects, debugging, reviews |
| `claude-opus-4-6` | Complex reasoning, architecture, hard problems |

Set the default to what you use 80% of the time; escalate to Opus only when needed.

### 4. Team vs Personal Settings

**Commit to repo (`.claude/settings.json`):**
- MCP server configs (without secrets)
- Hooks configuration
- Permission allowlists/denylists
- Default model for project

**Personal only (`~/.claude/settings.json`):**
- Personal API keys
- Personal MCP servers (your local tools)
- Personal model preferences that override project defaults
- Anything that differs between team members

The rule: if everyone on the team should have it, commit it. If it's just you, put it in your global config.

### 5. Full Example: Web Project Settings

```json
{
  "model": "claude-sonnet-4-6",
  "permissions": {
    "allow": [
      "Bash(git *)",
      "Bash(npm *)",
      "Bash(pnpm *)",
      "Bash(pytest *)",
      "Bash(ruff *)",
      "Bash(docker compose *)",
      "Edit(*)",
      "Read(*)"
    ],
    "deny": [
      "Bash(rm -rf *)",
      "Bash(git push --force *)",
      "Bash(git reset --hard *)",
      "Bash(sudo *)",
      "Bash(curl * | bash *)"
    ]
  },
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": { "GITHUB_PERSONAL_ACCESS_TOKEN": "${GITHUB_TOKEN}" }
    }
  },
  "hooks": {
    "Stop": [{
      "hooks": [{
        "type": "command",
        "command": "bash .claude/hooks/enforce-done.sh"
      }]
    }]
  }
}
```

## Key Concepts

- **`.claude/settings.json`** — project configuration file; commit to repo for team consistency
- **Permission allowlist/denylist** — explicit allow/deny for tool calls; denylist always overrides allowlist
- **Permission mode** — session-level setting for how aggressively Claude asks for permission
- **`bypassPermissions`** — CI/automation mode; Claude does everything without asking; never use interactively

## Checklist

- [ ] `.claude/settings.json` committed to repo (without secrets)?
- [ ] Dangerous commands in denylist (rm -rf, force push, sudo)?
- [ ] Default model set appropriately for project complexity?
- [ ] MCP servers configured for team-needed external access?
- [ ] Hooks configured for project-specific automation?

## Key Outputs

- `.claude/settings.json`: complete project configuration
- Documented permission policy in CLAUDE.md: what's allowed and blocked, and why

## Output Format

- 🔴 **Critical** — no settings file (team uses different configs), API keys hardcoded in committed settings.json, `bypassPermissions` used for interactive sessions without audit trail
- 🟡 **Warning** — settings exist but not committed (personal config only, team gets nothing), no denylist for destructive operations
- 🟢 **Suggestion** — set `acceptEdits` mode for code generation tasks, configure default model for cost optimization, add common safe commands to allowlist to reduce interruptions

## Anti-Patterns

- Committing personal API keys or credentials in settings.json
- Using `bypassPermissions` for interactive sessions (only for trusted automation like CI)
- No denylist at all (Claude can accidentally run anything, including destructive operations)
- Team settings not committed (everyone configures differently, inconsistent behavior)

## Integration

- Use with `claude-hooks` (hooks configured in same file — see claude-hooks skill)
- Use with `claude-mcp-setup` (MCP servers configured in same file — see claude-mcp-setup skill)
- Use with `claude-md-authoring` (settings.json + CLAUDE.md together = complete Claude Code project config)
