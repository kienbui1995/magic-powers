# Optional Skills Expansion — Design Spec
**Date:** 2026-04-07
**Status:** Approved

## Overview

Expand magic-powers from a dev-focused plugin to a full-team AI workflow platform by adding ~67 optional skills across 11 categories (6+9+6+4+9+8+5+5+5+3+7=67), a new `/install-skills` command for browsing and installing skills, and enhanced `/setup` role coverage.

All new skills are optional — users choose what fits their role. Built-in skills (43 existing) remain unchanged.

## Goals

- Cover all professional roles: dev, product, data, marketing, sales, design, specialist, etc.
- Let users install only the skills relevant to their work
- Keep installation frictionless: `/setup` for quick role-based setup, `/install-skills` for browse-and-pick

## Skill Catalog (~67 new skills)

### 🎯 Product (6 skills) — lightweight
| Skill | Description |
|-------|-------------|
| `user-story-writing` | Write user stories with acceptance criteria |
| `roadmap-planning` | Quarterly planning, ICE/MoSCoW prioritization |
| `stakeholder-communication` | Status updates, exec presentations |
| `product-metrics` | Define KPIs, measure product health |
| `competitive-analysis` | Research competitors, position features |
| `feedback-synthesis` | Synthesize user feedback into actionable insights |

### 📊 Data/ML (9 skills) — lightweight
| Skill | Description |
|-------|-------------|
| `data-pipeline-design` | ETL/ELT patterns, streaming vs batch |
| `data-quality` | Validate and test data pipelines |
| `data-modeling` | Schema design for analytics (star schema, etc.) |
| `ml-experiment-tracking` | Experiment management, reproducibility |
| `model-evaluation` | Metrics, bias detection, validation |
| `feature-engineering` | Feature selection, transformation patterns |
| `mlops-deployment` | Model serving, canary/shadow releases |
| `model-monitoring` | Drift detection, retraining triggers |
| `training-pipeline` | Orchestration, versioning |

### ⚙️ Platform/SRE (6 skills) — lightweight
| Skill | Description |
|-------|-------------|
| `slo-sli-design` | Define SLOs, SLIs, error budgets |
| `capacity-planning` | Load projections, scaling decisions |
| `chaos-engineering` | Resilience testing patterns |
| `on-call-runbook` | Write actionable runbooks |
| `cloud-cost-review` | Rightsizing, reserved instances, waste |
| `performance-benchmarking` | Measure baselines, compare before/after |

### 🎨 Design/UX (4 skills) — lightweight
| Skill | Description |
|-------|-------------|
| `ux-audit` | Heuristic evaluation of existing UX |
| `design-system-audit` | Component consistency, token review |
| `user-research` | Interview guides, usability testing |
| `design-handoff` | Specs, assets, developer communication |

### 👥 Team Processes (9 skills) — detailed (checklist + process flow)
| Skill | Description |
|-------|-------------|
| `sprint-planning` | Backlog refinement, capacity, sprint goals |
| `sprint-retrospective` | Formats, actionable outcomes |
| `team-onboarding` | Dev env setup, codebase intro, first PR |
| `adr-writing` | Architecture Decision Records |
| `incident-postmortem` | Blameless postmortem, follow-ups |
| `tech-debt-triage` | Prioritize, track, allocate time |
| `knowledge-transfer` | Documentation, pairing, handoffs |
| `experiment-tracking` | A/B tests, hypothesis management |
| `support-playbook` | Triage support tickets, escalation paths |

### 📣 Marketing (8 skills) — lightweight
| Skill | Description |
|-------|-------------|
| `content-strategy` | Content calendar, audience targeting, formats |
| `seo-optimization` | On-page SEO, keyword strategy, technical SEO |
| `social-media-planning` | Platform-specific strategy, scheduling |
| `growth-hacking` | Viral loops, activation, retention experiments |
| `email-marketing` | Drip campaigns, segmentation, copywriting |
| `analytics-reporting` | Marketing metrics, attribution, dashboards |
| `brand-voice` | Tone guidelines, messaging consistency |
| `launch-planning` | GTM strategy, launch checklist, coordination |

### 💼 Sales (5 skills) — lightweight
| Skill | Description |
|-------|-------------|
| `discovery-call` | Qualification framework, pain discovery, MEDDIC |
| `proposal-writing` | Structure, pricing, value proposition |
| `pipeline-management` | Stage definitions, hygiene, forecasting |
| `sales-coaching` | Call review, objection handling, ramp plans |
| `deal-strategy` | Multi-stakeholder navigation, negotiation |

### 🧪 Testing (5 skills) — lightweight
| Skill | Description |
|-------|-------------|
| `api-contract-testing` | Schema validation, breaking change detection |
| `performance-testing` | Load testing, profiling, bottleneck analysis |
| `accessibility-audit` | WCAG compliance, assistive tech testing |
| `test-strategy` | Coverage plan, risk-based testing, pyramid |
| `quality-gates` | Definition of done, release criteria |

### 🎮 Game Dev (5 skills) — lightweight
| Skill | Description |
|-------|-------------|
| `game-design-doc` | GDD structure, mechanics, player loops |
| `level-design` | Flow, pacing, challenge curves |
| `narrative-design` | Story structure, branching dialogue, lore |
| `game-audio` | Sound design brief, music direction |
| `technical-art` | Shader brief, performance budgets, LOD strategy |

### 🌐 Spatial Computing (3 skills) — lightweight
| Skill | Description |
|-------|-------------|
| `xr-interface-design` | XR UX patterns, interaction modes |
| `spatial-ux` | 3D layout, depth cues, comfort guidelines |
| `visionos-patterns` | visionOS spatial design conventions |

### 🔬 Specialist (7 skills) — lightweight
| Skill | Description |
|-------|-------------|
| `legal-compliance` | Review code/docs/features for legal & regulatory requirements |
| `financial-modeling` | Unit economics, forecasting, financial projections |
| `developer-advocacy` | API docs, tutorials, devrel content, community engagement |
| `solutions-architecture` | Pre-sales architecture, integration design, technical proposals |
| `blockchain-audit` | Smart contract review, web3 security patterns |
| `hr-people-ops` | Hiring process, performance reviews, culture documentation |
| `technical-documentation` | API docs, runbooks, user guides, internal wikis |

**Total: ~67 new skills** (43 existing → ~110 total)

## Skill Depth

| Type | Depth | Format |
|------|-------|--------|
| Role skills (Product, Data, Marketing, Sales, etc.) | Lightweight | Short overview, core jobs, key outputs |
| Team Process skills (sprint, onboarding, postmortem, etc.) | Detailed | Checklist, process flow, examples |

## Implementation Phases

**Phase 1** (~41 skills — core professional roles):
Product, Data/ML, Platform/SRE, Design/UX, Team Processes, Specialist

**Phase 2** (~26 skills — extended domains):
Marketing, Sales, Testing, Game Dev, Spatial Computing

## `/install-skills` Command (new)

New file: `commands/install-skills.md`

Two-level browse flow:
1. Show 11 categories with skill count
2. User picks category → sees individual skills with 1-line descriptions
3. User picks skills (numbers, "all", or "back")
4. Claude copies selected skills from `${CLAUDE_PLUGIN_ROOT}/skills/<name>/SKILL.md` to `.claude/skills/<name>/SKILL.md` in the current project

Skills installed to `.claude/skills/` are auto-loaded into Claude's context every session — no manual invocation needed.

## `/setup` Enhancements

**Step 2 — Roles** expanded from 5 to 12:
```
 1. Solo Builder
 2. Frontend Developer
 3. Backend Developer
 4. Product Manager
 5. Team Lead
 6. Data Scientist / ML Engineer   ← new
 7. Data Engineer                  ← new
 8. SRE / Platform Engineer        ← new
 9. Product Designer               ← new
10. Marketer / Growth              ← new
11. Sales / BD                     ← new
12. Game Developer                 ← new
```

**Step 4 — Optional Features** adds a new "Optional Skills" section:
- Shows recommended skill pack for detected role (1-2 categories)
- Checkbox to install the pack
- Footer: "Browse all skill categories? Run /install-skills"

### Role → Recommended Pack Mapping
| Role | Recommended Packs |
|------|------------------|
| Solo Builder | Product, Platform/SRE |
| Frontend Developer | Design/UX, Testing |
| Backend Developer | Platform/SRE, Testing |
| Product Manager | Product, Team Processes |
| Team Lead | Team Processes, Product |
| Data Scientist / ML Engineer | Data/ML |
| Data Engineer | Data/ML, Platform/SRE |
| SRE / Platform Engineer | Platform/SRE, Team Processes |
| Product Designer | Design/UX, Product |
| Marketer / Growth | Marketing |
| Sales / BD | Sales, Specialist (solutions-architecture) |
| Game Developer | Game Dev |

## File Structure

```
magic-powers/
├── skills/
│   ├── (43 existing skills)
│   └── <67 new skill directories>/
│       └── SKILL.md
├── commands/
│   ├── setup.md          ← update: expand roles, add skill pack step
│   └── install-skills.md ← new
└── docs/
    └── OPTIONAL_SKILLS.md  ← skill catalog reference for users
```

## Install Mechanism

```
Plugin:  ~/.claude/plugins/.../magic-powers/skills/<name>/SKILL.md
                      ↓  /install-skills copies
Project: .claude/skills/<name>/SKILL.md  (auto-loaded each session)
```

Consistent with existing `/setup` pattern for `project-conventions` and `stack-aware-agents`.

## Success Criteria

- User can run `/install-skills` and install any skill in under 2 minutes
- `/setup` role recommendations cover 90%+ of common professional roles
- Each skill file is self-contained — no cross-dependencies required
- Phase 1 shipped before Phase 2 is started
