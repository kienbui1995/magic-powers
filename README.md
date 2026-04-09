# ✨ Magic Powers

[![npm version](https://img.shields.io/npm/v/magic-powers)](https://www.npmjs.com/package/magic-powers)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue)](LICENSE)
[![Security Audit](https://img.shields.io/badge/security_audit-passing-brightgreen)](SECURITY.md)
[![Tools](https://img.shields.io/badge/tools-9-green)](README.md#multi-tool-support)
[![Agents](https://img.shields.io/badge/agents-11-purple)](README.md#11-agents-by-division)
[![Commands](https://img.shields.io/badge/commands-12-blue)](README.md#12-slash-commands)
[![Website](https://img.shields.io/badge/website-magic--powers.pmai.space-orange)](https://magic-powers.pmai.space)

**[magic-powers.pmai.space](https://magic-powers.pmai.space)** — A Claude Code plugin with cost-optimized model routing, 43 built-in skills + 67 optional skills + 42 cloud division skills (187 total), 11 specialized agents, 12 slash commands, and optional hooks/MCP integration. Built for all professional roles — dev, product, data, marketing, sales, design, and more. Also works with Cursor, Copilot, Aider, Windsurf, Gemini CLI, Codex, Kiro, and OpenCode.

## Why Magic Powers?

Claude Code defaults to using the most expensive model for everything. Magic Powers routes tasks to the right model — **~75% cost reduction** with no quality loss on routine tasks.

For actual API-level savings, combine with [Claude Code Router or OpenRouter](docs/MODEL_ROUTING.md) for **80-95% cost reduction**.

## Install

```bash
# Claude Code — marketplace (recommended)
/plugin marketplace add kienbui1995/magic-powers
/plugin install magic-powers@magic-powers

# skills.sh (works with 43+ agents)
npx skills add kienbui1995/magic-powers

# All other tools — npx (auto-detects your tool)
npx magic-powers@latest

# Or with curl
curl -fsSL https://raw.githubusercontent.com/kienbui1995/magic-powers/main/scripts/get.sh | bash
```

The installer auto-detects Cursor, Windsurf, Kiro, Codex, OpenCode, Gemini CLI, and Claude Code from your environment.

### Codex

```bash
git clone https://github.com/kienbui1995/magic-powers.git
cd magic-powers && bash scripts/install.sh
# Select option 7 — Codex
```

### Kiro

```bash
git clone https://github.com/kienbui1995/magic-powers.git
cd magic-powers && bash scripts/install.sh
# Select option 8 — Kiro
```

## Built-in vs Optional

Magic Powers uses a two-tier architecture:

### Built-in (auto with plugin install)

Everything works out of the box — no setup required:

- **12 slash commands** — `/brainstorming`, `/plan`, `/review`, `/debug`, `/deploy`, etc.
- **11 agents** — architect, debugger, reviewer, ui-designer, etc.
- **43 built-in skills** — brainstorming, TDD, debugging, security review, etc.
- **SessionStart hook** — auto-loads skill routing on every session

### Optional (via `/setup`)

Run `/setup` to personalize for your project. Detects your stack, asks your role & priority, then offers:

| Feature | Type | Description |
|---------|------|-------------|
| 🛡️ Safety guard | Hook | Block writes to `.env`, secrets, `node_modules` |
| 🔍 Auto-lint | Hook | Run linter after every file edit |
| 🧪 Auto-test | Hook | Run related tests after code changes |
| 🎨 Stitch Design | MCP | Generate UI designs (needs `STITCH_API_KEY`) |
| 📚 Context7 | MCP | Fetch latest library docs automatically |
| 📋 Project conventions | Skill | Coding rules based on detected stack |
| 🏗️ Stack-aware agents | Agent | Architect & debugger with stack context |
| 📦 Optional skill packs | Skills | 67 role-specific skills across 11 categories |

Optional features install to `.claude/` in your project — they don't affect the global plugin.

### Optional Skills (67 skills, 11 categories)

Browse and install with `/install-skills`. Quick role-based install during `/setup`.

| Category | Skills | Who it's for |
|----------|--------|-------------|
| 🎯 Product | 6 | Product managers, founders |
| 📊 Data/ML | 9 | Data scientists, ML engineers |
| ⚙️ Platform/SRE | 6 | SRE, platform, DevOps |
| 🎨 Design/UX | 4 | Product designers, UX researchers |
| 👥 Team Processes | 9 | Team leads, eng managers |
| 📣 Marketing | 8 | Marketers, growth engineers |
| 💼 Sales | 5 | Sales, BD, account executives |
| 🧪 Testing | 5 | QA engineers, SDETs |
| 🎮 Game Dev | 5 | Game designers, developers |
| 🌐 Spatial Computing | 3 | XR/AR/VR, visionOS developers |
| 🔬 Specialist | 7 | Legal, finance, devrel, solutions arch |

See [docs/OPTIONAL_SKILLS.md](docs/OPTIONAL_SKILLS.md) for the full catalog.

### ☁️ Cloud Divisions (42 skills, 21 agents)

Professional certification-aligned agents for GCP, AWS, and Azure. `/install-skills` → Category 12.

| Division | Agents | Certifications |
|----------|--------|---------------|
| GCP | 7 | Professional Data Engineer, Cloud Developer, Network, ML, DevOps, Security, Architect |
| AWS | 7 | Data Engineer (DEA-C01), Developer, Networking, ML Engineer (MLA-C01), DevOps, Security, Solutions Architect |
| Azure | 7 | Fabric Data Engineer (DP-700), AI Developer (AI-200), Network, AI Engineer, DevOps, Security (SC-500), Architect |

```
/install-skills → 12 → GCP / AWS / Azure
@gcp-data-engineer  Design a BigQuery streaming pipeline
@aws-solutions-architect  Review our multi-account architecture
@azure-ai-engineer  Build a RAG system with Azure OpenAI
```

### 📊 Amplitude Division (26 skills, 5 agents)

Product analytics agents powered by the Amplitude MCP server. `/install-skills` → Category 13.
**Requires:** [Amplitude MCP](https://github.com/amplitude/mcp-server-guide) configured.

| Agent | Role |
|-------|------|
| `@amplitude-analyst` | Charts, dashboards, daily/weekly briefings |
| `@amplitude-experimenter` | A/B tests, opportunity discovery, user journeys |
| `@amplitude-engineer` | Analytics instrumentation, event taxonomy |
| `@amplitude-ux-researcher` | Session replay, error diagnosis, UX audit |
| `@amplitude-ai-monitor` | AI/LLM quality, topic analysis, session investigation |

Skills ported from [amplitude/mcp-marketplace](https://github.com/amplitude/mcp-marketplace).

## 12 Slash Commands

| Command | Skill | Purpose |
|---------|-------|---------|
| `/setup` | — | Personalize plugin, install optional features (12 roles) |
| `/install-skills` | — | Browse and install optional skills by category |
| `/brainstorming` | brainstorming | Explore ideas → design → spec → approval |
| `/plan` | writing-plans | Break feature into implementation steps |
| `/review` | requesting-code-review | Quick code review for bugs & issues |
| `/debug` | systematic-debugging | Reproduce → isolate → fix → verify |
| `/security-scan` | security-review | Scan for vulnerabilities & auth issues |
| `/db-review` | database-optimization | Schema, queries, indexes, migrations |
| `/deploy` | ci-cd-pipeline | Deployment readiness checklist |
| `/pr` | pr-workflow | Prepare changes for pull request |
| `/refactor` | refactoring | Improve structure, reduce complexity |
| `/tdd` | test-driven-development | Red → green → refactor cycle |

## 11 Agents by Division

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

## 187 Skills

**Core Workflow:** `using-magic-powers` · `brainstorming` · `writing-plans` · `executing-plans`

**Planning:** `spec-driven-development` · `mvp-rapid-development`

**Development:** `test-driven-development` · `systematic-debugging` · `verification-before-completion` · `refactoring` · `api-design` · `performance-optimization` · `environment-setup`

**DevOps:** `ci-cd-pipeline` · `docker-containerization` · `incident-response` · `dependency-management`

**Collaboration:** `requesting-code-review` · `receiving-code-review` · `subagent-driven-development` · `dispatching-parallel-agents` · `pr-workflow`

**Git:** `using-git-worktrees` · `finishing-a-development-branch`

**Security & Auth:** `security-review` · `authentication-patterns` · `accessibility-compliance`

**Infrastructure:** `database-optimization` · `infrastructure-review` · `caching-strategy`

**AI Engineering:** `prompt-engineering` · `rag-architecture` · `agentic-ai-patterns` · `llm-evaluation` · `ai-safety-guardrails` · `llm-observability`

**Review & Docs:** `technical-writing`

**Meta:** `writing-skills` · `open-source-project` · `product-strategy`

**Unique:** `cost-aware-routing` · `design-with-stitch` · `design-with-pencil`

## Multi-Tool Support

| Tool | Format | Install |
|------|--------|---------|
| Claude Code | Plugin (native) | `/plugin marketplace add kienbui1995/magic-powers` |
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
| Skills | 14 | 43 |
| Agents | 1 | 11 |
| Commands | 0 | 11 |
| Model routing | ❌ | ✅ Opus/Sonnet/Haiku |
| Cost optimization | ❌ | ✅ ~75% reduction |
| Optional hooks | ❌ | ✅ Safety, lint, test |
| Design tools | ❌ | ✅ Google Stitch SDK |
| Multi-tool | ❌ | ✅ 9 tools |
| Built-in/Optional arch | ❌ | ✅ |

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for release history.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for how to add agents and skills.

## License

MIT — see [LICENSE](LICENSE).

## Credits

Inspired by [superpowers](https://github.com/obra/superpowers) by Jesse Vincent and [agency-agents](https://github.com/msitarzewski/agency-agents) by Mike Sitarzewski.
