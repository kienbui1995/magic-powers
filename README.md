# ✨ Magic Powers

A Claude Code plugin with cost-optimized model routing, 22 workflow skills, 11 specialized agents, and Google Stitch design integration. Also works with Cursor, Copilot, Aider, Windsurf, and Gemini CLI.

## Why Magic Powers?

Claude Code defaults to using the most expensive model for everything. Magic Powers routes tasks to the right model — **~75% cost reduction** with no quality loss on routine tasks.

## Install

```bash
# Claude Code (recommended)
/plugin install github:your-username/magic-powers

# Other tools
git clone https://github.com/your-username/magic-powers.git
cd magic-powers && bash scripts/install.sh
```

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

### Cost by Model

| Model | Agents | Cost |
|-------|--------|------|
| Opus | 1 (architect) | $$$$$ |
| Sonnet | 5 (debugger, db-optimizer, sre, git-workflow, ui-designer) | $$ |

## 16 Skills

**Core Workflow:** `using-magic-powers` · `brainstorming` · `writing-plans` · `executing-plans`

**Development:** `test-driven-development` · `systematic-debugging` · `verification-before-completion`

**Collaboration:** `requesting-code-review` · `receiving-code-review` · `subagent-driven-development` · `dispatching-parallel-agents`

**Git:** `using-git-worktrees` · `finishing-a-development-branch`

**Review:** `security-review` · `database-optimization` · `infrastructure-review` · `technical-writing`

**Meta:** `writing-skills`

**Unique:** `cost-aware-routing` · `design-with-stitch`

## Multi-Tool Support

| Tool | Format | Install |
|------|--------|---------|
| Claude Code | Plugin (native) | `/plugin install github:user/magic-powers` |
| Cursor | `.mdc` rules | `bash scripts/install.sh` → select Cursor |
| GitHub Copilot | Agent `.md` files | `bash scripts/install.sh` → select Copilot |
| Aider | `CONVENTIONS.md` | `bash scripts/install.sh` → select Aider |
| Windsurf | `.windsurfrules` | `bash scripts/install.sh` → select Windsurf |
| Gemini CLI | Skills | `bash scripts/install.sh` → select Gemini |

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
| Multi-tool | ❌ | ✅ 6 tools |
| Examples | ❌ | ✅ 4 scenarios |

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for how to add agents and skills.

## License

MIT — see [LICENSE](LICENSE).

## Credits

Inspired by [superpowers](https://github.com/obra/superpowers) by Jesse Vincent and [agency-agents](https://github.com/msitarzewski/agency-agents) by Mike Sitarzewski.
