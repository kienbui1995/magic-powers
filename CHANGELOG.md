# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.6.0] — 2026-04-10

### Added
- 🤖 **AI Division** — 3 specialized AI agents + 2 new skills
  - `@ai-engineer` — LLM integration, RAG, agentic AI, eval harness, LLMOps
  - `@ai-product` — AI UX design, streaming, fallbacks, reliability, responsible AI
  - `@ai-evaluator` — eval infrastructure, CI/CD for AI, golden datasets, regression detection
  - New skill: `ai-harness` — 3-layer eval pipeline, golden datasets, CI integration, A/B prompt testing
  - New skill: `ai-product-design` — AI UX patterns, streaming, error handling, responsible AI disclosure

### Changed
- Version bumped from 1.5.0 to 1.6.0

---

## [1.5.0] — 2026-04-10

### Added
- 🧩 **Browser Extension Division** — 1 agent + 9 skills for Chrome/Firefox extension development and publishing
  - Agent: `browser-extension-developer` (MV3, content scripts, APIs, UI, security, cross-browser, testing, publishing)
  - Skills: manifest-v3, content-scripts, extension-apis, extension-ui, extension-security, cross-browser-compat, extension-testing, chrome-store-publishing, firefox-publishing
  - `/install-skills` category 14; `/setup` surfaces for Frontend Dev and Solo Builder roles

### Changed
- Version bumped from 1.4.2 to 1.5.0

---

## [1.4.1] — 2026-04-09

### Fixed
- Updated plugin.json and marketplace.json metadata with accurate agent/skill counts
- Updated using-magic-powers skill to document Cloud and Amplitude divisions

---

## [1.4.0] — 2026-04-09

### Added
- 📊 **Amplitude Division** — 5 agents + 26 skills powered by Amplitude MCP server
  - Agents: `amplitude-analyst`, `amplitude-experimenter`, `amplitude-engineer`, `amplitude-ux-researcher`, `amplitude-ai-monitor`
  - 26 skills adapted from [Amplitude mcp-marketplace](https://github.com/amplitude/mcp-marketplace)
  - `/install-skills` extended with Amplitude Division (category 13)
  - Skills cover: charts, dashboards, briefings, A/B experiments, instrumentation, session replay, error diagnosis, AI quality monitoring
- 🔧 `validate-skills.sh` extended to validate amplitude skill schema (## MCP Tools required)

### Changed
- Version bumped from 1.3.0 to 1.4.0

---

## [1.3.0] — 2026-04-08

### Added
- ☁️ **AWS Division** — 7 agents + 14 skills aligned to AWS Professional/Associate certs
  - Agents: `aws-data-engineer` (DEA-C01), `aws-cloud-developer` (DVA-C02), `aws-network-engineer` (ANS-C01), `aws-ml-engineer` (MLA-C01), `aws-devops-engineer` (DOP-C02), `aws-security-engineer` (SCS-C02), `aws-solutions-architect` (SAP-C02, Opus)
  - Skills: glue-etl, kinesis-streaming, redshift-optimization, s3-best-practices, dynamodb-design, cloudwatch-monitoring, lake-formation-governance, lambda-serverless, iam-security, codepipeline-cicd, vpc-networking, eks-kubernetes, guardduty-security, sagemaker-mlops
- ☁️ **Azure Division** — 7 agents + 14 skills aligned to Azure Associate/Expert certs (2025-2026 updated)
  - Agents: `azure-data-engineer` (DP-700), `azure-cloud-developer` (AI-200), `azure-network-engineer` (AZ-700), `azure-ai-engineer` (AI-102), `azure-devops-engineer` (AZ-400), `azure-security-engineer` (SC-500), `azure-solutions-architect` (AZ-305, Opus)
  - Skills: fabric-lakehouse, dataflow-gen2, fabric-pipelines, eventstreams, fabric-governance, fabric-monitoring, azure-functions, aks-kubernetes, azure-ad-entra, azure-networking, azure-devops-pipelines, azure-monitor, microsoft-sentinel, azure-openai
- `/install-skills` Cloud Divisions now supports AWS (option 2) and Azure (option 3)

### Changed
- Version bumped from 1.2.0 to 1.3.0

---

## [1.2.0] — 2026-04-08

### Added
- ☁️ **Cloud Divisions** — GCP Professional certification-aligned agents and skills
  - 7 GCP agents: `gcp-data-engineer`, `gcp-cloud-developer`, `gcp-network-engineer`, `gcp-ml-engineer`, `gcp-devops-engineer`, `gcp-security-engineer`, `gcp-cloud-architect`
  - 14 GCP skills mapped to official exam domains (GCP-PDE, Cloud Developer, Network Engineer, ML Engineer, DevOps Engineer, Security Engineer, Cloud Architect)
  - `/install-skills` extended with Cloud Divisions category (12)
  - `agents/cloud/CLOUD_DIVISION.md` framework for adding more cloud providers (AWS, Azure coming soon)
- 🔧 `validate-skills.sh` updated to skip namespace directories

### Changed
- Version bumped from 1.1.0 to 1.2.0

### Certification targets aligned to 2025-2026 exam guides
- GCP-PDE: cloud.google.com/learn/certification/data-engineer
- AWS MLA-C01 (new, replaces retiring MLS-C01 March 2026)
- Azure DP-700 (new, replaces retired DP-203)

## [1.0.0] - 2026-04-06

### Added

- **11 slash commands** — `/brainstorming`, `/plan`, `/review`, `/debug`, `/security-scan`, `/db-review`, `/deploy`, `/pr`, `/refactor`, `/tdd` (built-in, auto with plugin install)
- **Built-in vs Optional architecture** — core features auto-install, optional features via `/setup`
- **Optional hooks** — safety guard (block dangerous writes), auto-lint (PostToolUse), auto-test (PostToolUse)
- **Optional MCP servers** — Stitch Design, Context7 (installed via `/setup`)
- **marketplace.json** — enables `plugin marketplace add kienbui1995/magic-powers` install flow
- **plugin.json component declarations** — commands, agents, hooks paths for proper plugin discovery

### Changed

- **Brainstorming skill** — merged improvements from Superpowers: Visual Companion, scope decomposition, spec self-review inline, design for isolation
- **Writing-plans skill** — added No Placeholders section, self-review (spec coverage, placeholder scan, type consistency), file structure mapping
- **Executing-plans skill** — added batch execution with review checkpoints, when to revisit earlier steps
- **Verification skill** — added regression test red-green pattern, requirements checklist, agent delegation verification
- **`/setup` command** — now includes Step 4 optional features menu (hooks, MCP, stack-specific skills/agents)

## [0.9.3] - 2026-04-05

### Fixed

- CI: run `convert.sh all` before sync audit (integrations/ is gitignored)
- CI: remove integrations/ from security-audit.yml paths trigger

## [0.9.2] - 2026-04-05

### Fixed

- Security audit: replace `\s` with POSIX `[[:space:]]` for CI grep compatibility

## [0.9.1] - 2026-04-05

### Added

- Model routing guide (`docs/MODEL_ROUTING.md`) — CCR + OpenRouter setup for 80-95% cost savings
- skills.sh install support (`npx skills add kienbui1995/magic-powers`)
- 4 new CI audit scripts: quality, sync, link, version — all gate release
- Full audit suite: 5 audits, 333 files, 95 cross-refs, 5 integrations

### Fixed

- Security audit: `grep -P` → `grep -E` for CI compatibility

## [0.9.0] - 2026-04-05

### Added

- **19 new skills** (24 → 43 total), organized by market demand:
  - **Development:** `refactoring`, `api-design`, `performance-optimization`, `environment-setup`
  - **DevOps:** `ci-cd-pipeline`, `docker-containerization`, `incident-response`, `dependency-management`
  - **Security & Auth:** `authentication-patterns`, `accessibility-compliance`
  - **Collaboration:** `pr-workflow`, `caching-strategy`
  - **AI Engineering (new category):** `prompt-engineering`, `rag-architecture`, `agentic-ai-patterns`, `llm-evaluation`, `ai-safety-guardrails`, `llm-observability`, `mvp-rapid-development`
- **Security audit v2** — 14 checks based on Snyk ToxicSkills study (2026)
  - 6 critical: hardcoded secrets, dangerous shell, prompt injection, env exfiltration, sensitive path writes, crypto wallet patterns
  - 8 warning: broad file access, data exfiltration, eval/exec, encoded payloads, malicious package install, network recon, obfuscated strings, permissive instructions
  - Scans skills, agents, integrations, hooks, and commands (238 files)
- `SECURITY.md` — security policy documenting all 14 audit checks
- Security audit badge in README
- Security audit blocks npm publish — CI runs audit before release

### Changed

- Positioning: "Built for AI startups shipping fast with small teams"
- README: 43 Skills section with AI Engineering category
- All integrations synced: 54 files (11 agents + 43 skills) across all 9 tools
- package.json: description, keywords (`agentic-ai`, `llm`, `rag`), SECURITY.md in files
- CI: `publish.yml` now requires `security-audit` job to pass before npm publish
- `security-audit.yml` scope expanded to integrations, hooks, commands

## [0.8.2] - 2026-03-24

### Fixed

- Landing page badge version updated to v0.8.1
- Landing page Skills nav anchor updated to `#24-skills`
- Landing page skill count updated to 24

## [0.8.1] - 2026-03-24

### Changed

- README: update skill count 23 → 24, section header 16 → 24 Skills
- README: add `spec-driven-development` (Planning), `design-with-pencil`, `open-source-project`, `product-strategy`

## [0.8.0] - 2026-03-24

### Added

- `spec-driven-development` skill — 3-phase workflow (requirements → design → tasks) with explicit approval gates before writing code
- Privacy Policy at [magic-powers.pmai.space/privacy](https://magic-powers.pmai.space/privacy/)

## [0.7.0] - 2026-03-24

### Added

- `design-with-pencil` skill — workflow for using Pencil MCP canvas (install, design, iterate, generate code, sync bi-directionally)
- `ui-designer` agent now references both Pencil and Stitch with guidance on when to use each

## [0.6.1] - 2026-03-24

### Added

- Landing page at [magic-powers.pmai.space](https://magic-powers.pmai.space)
- Website badge in README
- Updated plugin.json homepage to magic-powers.pmai.space

## [0.6.0] - 2026-03-24

### Added

- All 8 tools now receive **both** 11 agents and 22 skills (33 total)
- Kiro: `using-magic-powers` steering file uses `inclusion: always` — loads every session (session hook equivalent)
- OpenCode: 3 workflow commands installed to `~/.config/opencode/commands/`: `/magic-review`, `/magic-debug`, `/magic-plan`

### Changed

- Aider: `CONVENTIONS.md` now has separate Agents and Skills sections
- Windsurf: `.windsurfrules` now has separate Agents and Skills sections

## [0.5.0] - 2026-03-24

### Added

- OpenCode support: `AGENTS.md` installable to `~/.config/opencode/`
- GitHub Actions: auto-publish to npm on git tag push
- README: npm version, license, tools, agents badges
- README: Product & Growth agent section (product-strategist, copywriter)
- README: fix Cost by Model table to reflect all 11 agents

## [0.4.0] - 2026-03-24

### Added

- `scripts/get.sh` — one-liner installer via `curl | bash`, no manual clone needed
- Auto-detect tool in `install.sh` — detects Kiro, Cursor, Windsurf, Codex, Gemini CLI, Claude Code from environment and skips the menu

## [0.3.1] - 2026-03-24

### Added

- Kiro installation instructions to README

## [0.3.0] - 2026-03-23

### Added

- Kiro support: 11 steering files installable to `.kiro/steering/`
- `convert_kiro()` in `scripts/convert.sh` — generates steering files with `inclusion: auto` frontmatter
- Option 8 in `scripts/install.sh` — installs steering files for Kiro

## [0.2.1] - 2026-03-23

### Added

- CHANGELOG.md
- Link to CHANGELOG from README

## [0.2.0] - 2026-03-23

### Added

- Codex support: 11 agent skills installable to `~/.codex/skills/`
- Codex support: `AGENTS.md` template for `~/.codex/AGENTS.md`
- `convert_codex()` in `scripts/convert.sh` — generates Codex skills and AGENTS.md
- Option 7 in `scripts/install.sh` — installs skills and AGENTS.md for Codex

## [0.1.0] - 2026-03-23

### Added

- Initial release
- 11 specialized agents: architect, debugger, reviewer, security-reviewer, database-optimizer, sre, git-workflow, ui-designer, technical-writer, product-strategist, copywriter
- 16 workflow skills covering planning, TDD, debugging, code review, git, security, database, infra, and design
- Cost-optimized model routing: Opus / Sonnet / Haiku by task type (~75% cost reduction)
- Google Stitch SDK integration for UI design generation
- Multi-tool support: Claude Code (native plugin), Cursor, GitHub Copilot, Aider, Windsurf, Gemini CLI

[0.9.3]: https://github.com/kienbui1995/magic-powers/compare/v0.9.2...v0.9.3
[0.9.2]: https://github.com/kienbui1995/magic-powers/compare/v0.9.1...v0.9.2
[0.9.1]: https://github.com/kienbui1995/magic-powers/compare/v0.9.0...v0.9.1
[0.9.0]: https://github.com/kienbui1995/magic-powers/compare/v0.8.2...v0.9.0
[0.8.2]: https://github.com/kienbui1995/magic-powers/compare/v0.8.1...v0.8.2
[0.8.1]: https://github.com/kienbui1995/magic-powers/compare/v0.8.0...v0.8.1
[0.8.0]: https://github.com/kienbui1995/magic-powers/compare/v0.7.0...v0.8.0
[0.7.0]: https://github.com/kienbui1995/magic-powers/compare/v0.6.1...v0.7.0
[0.6.1]: https://github.com/kienbui1995/magic-powers/compare/v0.6.0...v0.6.1
[0.6.0]: https://github.com/kienbui1995/magic-powers/compare/v0.5.1...v0.6.0
[0.5.0]: https://github.com/kienbui1995/magic-powers/compare/v0.4.0...v0.5.0
[0.4.0]: https://github.com/kienbui1995/magic-powers/compare/v0.3.1...v0.4.0
[0.3.1]: https://github.com/kienbui1995/magic-powers/compare/v0.3.0...v0.3.1
[0.3.0]: https://github.com/kienbui1995/magic-powers/compare/v0.2.1...v0.3.0
[0.2.1]: https://github.com/kienbui1995/magic-powers/compare/v0.2.0...v0.2.1
[0.2.0]: https://github.com/kienbui1995/magic-powers/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/kienbui1995/magic-powers/releases/tag/v0.1.0
