# ✨ Magic Powers

[![npm version](https://img.shields.io/npm/v/magic-powers)](https://www.npmjs.com/package/magic-powers)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue)](LICENSE)
[![Tools](https://img.shields.io/badge/tools-9-green)](README.md#multi-tool-support)
[![Agents](https://img.shields.io/badge/agents-11-purple)](README.md#10-agents-by-division)
[![Website](https://img.shields.io/badge/website-magic--powers.pmai.space-orange)](https://magic-powers.pmai.space)

**[magic-powers.pmai.space](https://magic-powers.pmai.space)** — A Claude Code plugin with cost-optimized model routing, 24 workflow skills, 11 specialized agents, and Stitch + Pencil design integration. Also works with Cursor, Copilot, Aider, Windsurf, Gemini CLI, Codex, Kiro, and OpenCode.

## Why Magic Powers?

Claude Code defaults to using the most expensive model for everything. Magic Powers routes tasks to the right model — **~75% cost reduction** with no quality loss on routine tasks.

## Install

```bash
# Claude Code (recommended)
/plugin install github:your-username/magic-powers

# All other tools — npx (auto-detects your tool)
npx magic-powers@latest

# Or with curl
curl -fsSL https://raw.githubusercontent.com/kienbui1995/magic-powers/main/scripts/get.sh | bash
```

The installer auto-detects Cursor, Windsurf, Kiro, Codex, OpenCode, Gemini CLI, and Claude Code from your environment.

### Codex

```bash
git clone https://github.com/your-username/magic-powers.git
cd magic-powers && bash scripts/install.sh
# Select option 7 — Codex
```

Installs 11 agent skills to `~/.codex/skills/` and `AGENTS.md` to `~/.codex/AGENTS.md`. Restart Codex after installing.

Invoke skills explicitly with `$magic-<name>` (e.g. `$magic-architect`, `$magic-debugger`), or just describe your task and Codex picks the right one.

### Kiro

```bash
git clone https://github.com/your-username/magic-powers.git
cd magic-powers && bash scripts/install.sh
# Select option 8 — Kiro
```

Installs 11 agent steering files to `.kiro/steering/`. Each file uses `inclusion: auto` — Kiro automatically loads the right agent when your task matches. Also available as slash commands (e.g. `/magic-architect`, `/magic-debugger`).

## 10 Agents by Division

### 🔧 Engineering

| Agent | Emoji | Model | Purpose |
|-------|-------|-------|---------|
| `architect` | 🏗️ | Opus | Brainstorming, system design, planning |
| `debugger` | 🐛 | Sonnet | Systematic debugging with full tool access |
| `database-optimizer` | 🗄️ | Sonnet | Schema review, query optimization, migrations |
| `sre` | 🔧 | Sonnet | Infrastructure, deployment, reliability |
| `git-workflow` | 🌿 | Sonnet | Branch strategy, commits, release workflows |

### 🎨 Design

| Agent | Emoji | Model | Purpose |
|-------|-------|-------|---------|
| `ui-designer` | 🎨 | Sonnet | Frontend design with Stitch SDK |

### 👀 Review & Quality

| Agent | Emoji | Model | Purpose |
|-------|-------|-------|---------|
| `reviewer` | 👀 | Haiku | Fast code review (read-only) |
| `security-reviewer` | 🛡️ | Haiku | Security audit, vulnerability scanning |
| `technical-writer` | 📝 | Haiku | Documentation, READMEs, ADRs, changelogs |

### 📣 Product & Growth

| Agent | Emoji | Model | Purpose |
|-------|-------|-------|---------|
| `product-strategist` | 📣 | Sonnet | Feature prioritization, PRDs, launch planning |
| `copywriter` | ✍️ | Haiku | Landing pages, marketing copy, announcements |

### Cost by Model

| Model | Agents | Cost |
|-------|--------|------|
| Opus | 1 (architect) | $$$$$ |
| Sonnet | 6 (debugger, db-optimizer, sre, git-workflow, ui-designer, product-strategist) | $$ |
| Haiku | 4 (reviewer, security-reviewer, technical-writer, copywriter) | $ |

## 24 Skills

**Core Workflow:** `using-magic-powers` · `brainstorming` · `writing-plans` · `executing-plans`

**Planning:** `spec-driven-development`

**Development:** `test-driven-development` · `systematic-debugging` · `verification-before-completion`

**Collaboration:** `requesting-code-review` · `receiving-code-review` · `subagent-driven-development` · `dispatching-parallel-agents`

**Git:** `using-git-worktrees` · `finishing-a-development-branch`

**Review:** `security-review` · `database-optimization` · `infrastructure-review` · `technical-writing`

**Meta:** `writing-skills` · `open-source-project` · `product-strategy`

**Unique:** `cost-aware-routing` · `design-with-stitch` · `design-with-pencil`

## Multi-Tool Support

| Tool | Format | Install |
|------|--------|---------|
| Claude Code | Plugin (native) | `/plugin install github:user/magic-powers` |
| Cursor | `.mdc` rules | `bash scripts/install.sh` → select Cursor |
| GitHub Copilot | Agent `.md` files | `bash scripts/install.sh` → select Copilot |
| Aider | `CONVENTIONS.md` | `bash scripts/install.sh` → select Aider |
| Windsurf | `.windsurfrules` | `bash scripts/install.sh` → select Windsurf |
| Gemini CLI | Skills | `bash scripts/install.sh` → select Gemini |
| Codex | Skills + `AGENTS.md` | `bash scripts/install.sh` → select Codex |
| Kiro | Steering files | `bash scripts/install.sh` → select Kiro |
| OpenCode | `AGENTS.md` | `bash scripts/install.sh` → select OpenCode |

## Stitch Design Integration

```bash
# Requires STITCH_API_KEY environment variable
node scripts/stitch.mjs generate <projectId> "A dashboard with sidebar"
node scripts/stitch.mjs get-html <projectId> <screenId>
```

## Examples

See [`examples/`](examples/) for real-world scenarios:
- [Feature Development](examples/01-feature-development.md) — full lifecycle with cost breakdown
- [Production Debugging](examples/02-production-debugging.md) — incident response
- [Database Review](examples/03-database-review.md) — schema + security review
- [UI Design with Stitch](examples/04-ui-design-with-stitch.md) — design-to-code

## vs. Superpowers

| Feature | Superpowers | Magic Powers |
|---------|-------------|--------------|
| Skills | 14 | 16 |
| Agents | 1 | 10 |
| Model routing | ❌ | ✅ Opus/Sonnet/Haiku |
| Cost optimization | ❌ | ✅ ~75% reduction |
| Design tools | ❌ | ✅ Google Stitch SDK |
| Multi-tool | ❌ | ✅ 9 tools |
| Examples | ❌ | ✅ 4 scenarios |

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for release history.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for how to add agents and skills.

## License

MIT — see [LICENSE](LICENSE).

## Credits

Inspired by [superpowers](https://github.com/obra/superpowers) by Jesse Vincent and [agency-agents](https://github.com/msitarzewski/agency-agents) by Mike Sitarzewski.
