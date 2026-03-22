---
name: open-source-project
description: Use when setting up, maintaining, or growing an open source project — covers docs, community, licensing, and launch
---

# Open Source Project

## When to Use
When creating a new OSS repo, onboarding contributors, launching publicly, or managing community.

## 1. Repo Setup Checklist
- [ ] README — what it does, install, quickstart, screenshot/demo
- [ ] LICENSE — choose one (see Licensing below)
- [ ] CONTRIBUTING.md — how to contribute, dev setup, PR process
- [ ] CODE_OF_CONDUCT.md — Contributor Covenant or similar
- [ ] CHANGELOG.md — Keep a Changelog format
- [ ] `.github/ISSUE_TEMPLATE/` — bug report + feature request
- [ ] `.github/PULL_REQUEST_TEMPLATE.md` — what changed, why, how to test
- [ ] `.github/FUNDING.yml` — if accepting sponsors
- [ ] CI — lint + test on every PR

## 2. Licensing
- **MIT** — do whatever you want, just keep the copyright. Most permissive.
- **Apache 2.0** — like MIT but with patent protection. Good for libraries.
- **GPL 3.0** — copyleft, derivatives must also be GPL. Good for tools you want to stay open.
- **Check dependencies** — run `license-checker`, `pip-licenses`, or `cargo-license` to ensure compatibility
- Rule: don't mix GPL dependencies into MIT projects

## 3. Community Building
- Write a "Good First Issue" label guide — tag easy issues for newcomers
- Respond to issues/PRs within 48h (even if just "thanks, will review soon")
- Create a CONTRIBUTORS.md or use all-contributors bot
- Discussion channels: GitHub Discussions, Discord, or just Issues
- Write an ARCHITECTURE.md so contributors understand the codebase fast

## 4. Launch & Marketing
- **Before launch**: 10+ stars from friends, clean README with demo/screenshot
- **Hacker News**: title = what it does (not the name). Post Show HN. Best time: Tuesday-Thursday 8-10am EST
- **Reddit**: find the right subreddit (r/programming, r/webdev, r/selfhosted...). Be genuine, not salesy.
- **Product Hunt**: prep tagline + description + first comment (founder story). Launch Tuesday-Thursday.
- **Twitter/X**: thread format — problem → solution → demo → link. Tag relevant people.
- **Build in public**: share progress, decisions, metrics. People root for transparent builders.

## 5. Release Management
- Semantic versioning: MAJOR.MINOR.PATCH
- Tag releases in git: `git tag v1.0.0`
- Write release notes: what's new, breaking changes, migration guide
- Pre-1.0: breaking changes OK. Post-1.0: follow semver strictly.
- Automate: GitHub Actions for publish on tag push

## 6. Maintenance
- Triage issues weekly — label, assign, close stale
- Dependabot or Renovate for dependency updates
- Security: enable GitHub security advisories
- Burnout prevention: set expectations in README ("maintained in spare time", response time)
