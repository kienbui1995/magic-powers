# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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

[0.3.0]: https://github.com/kienbui1995/magic-powers/compare/v0.2.1...v0.3.0
[0.2.1]: https://github.com/kienbui1995/magic-powers/compare/v0.2.0...v0.2.1
[0.2.0]: https://github.com/kienbui1995/magic-powers/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/kienbui1995/magic-powers/releases/tag/v0.1.0
