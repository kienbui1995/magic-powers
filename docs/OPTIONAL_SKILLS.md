# Optional Skills Catalog

Browse and install skills with `/install-skills`. Install recommended packs during `/setup`.

## How It Works

Skills live in `magic-powers/skills/`. When installed, they're copied to `.claude/skills/<name>/SKILL.md` in your project and auto-loaded into every Claude session — no manual invocation needed.

## Categories

### 🎯 Product (6 skills)
| Skill | Install Name | Description |
|-------|-------------|-------------|
| User Story Writing | `user-story-writing` | Write user stories with acceptance criteria |
| Roadmap Planning | `roadmap-planning` | Quarterly planning, ICE/MoSCoW prioritization |
| Stakeholder Communication | `stakeholder-communication` | Status updates, exec presentations |
| Product Metrics | `product-metrics` | Define KPIs, measure product health |
| Competitive Analysis | `competitive-analysis` | Research competitors, position features |
| Feedback Synthesis | `feedback-synthesis` | Synthesize user feedback into actionable insights |

### 📊 Data/ML (9 skills)
| Skill | Install Name | Description |
|-------|-------------|-------------|
| Data Pipeline Design | `data-pipeline-design` | ETL/ELT patterns, streaming vs batch |
| Data Quality | `data-quality` | Validate and test data pipelines |
| Data Modeling | `data-modeling` | Schema design for analytics |
| ML Experiment Tracking | `ml-experiment-tracking` | Experiment management, reproducibility |
| Model Evaluation | `model-evaluation` | Metrics, bias detection, validation |
| Feature Engineering | `feature-engineering` | Feature selection, transformation patterns |
| MLOps Deployment | `mlops-deployment` | Model serving, canary/shadow releases |
| Model Monitoring | `model-monitoring` | Drift detection, retraining triggers |
| Training Pipeline | `training-pipeline` | Orchestration, versioning |

### ⚙️ Platform/SRE (6 skills)
| Skill | Install Name | Description |
|-------|-------------|-------------|
| SLO/SLI Design | `slo-sli-design` | Define SLOs, SLIs, error budgets |
| Capacity Planning | `capacity-planning` | Load projections, scaling decisions |
| Chaos Engineering | `chaos-engineering` | Resilience testing patterns |
| On-Call Runbook | `on-call-runbook` | Write actionable runbooks |
| Cloud Cost Review | `cloud-cost-review` | Rightsizing, reserved instances, waste |
| Performance Benchmarking | `performance-benchmarking` | Measure baselines, compare before/after |

### 🎨 Design/UX (4 skills)
| Skill | Install Name | Description |
|-------|-------------|-------------|
| UX Audit | `ux-audit` | Heuristic evaluation of existing UX |
| Design System Audit | `design-system-audit` | Component consistency, token review |
| User Research | `user-research` | Interview guides, usability testing |
| Design Handoff | `design-handoff` | Specs, assets, developer communication |

### 👥 Team Processes (9 skills)
| Skill | Install Name | Description |
|-------|-------------|-------------|
| Sprint Planning | `sprint-planning` | Backlog refinement, capacity, sprint goals |
| Sprint Retrospective | `sprint-retrospective` | Formats, actionable outcomes |
| Team Onboarding | `team-onboarding` | Dev env setup, codebase intro, first PR |
| ADR Writing | `adr-writing` | Architecture Decision Records |
| Incident Postmortem | `incident-postmortem` | Blameless postmortem, follow-ups |
| Tech Debt Triage | `tech-debt-triage` | Prioritize, track, allocate time |
| Knowledge Transfer | `knowledge-transfer` | Documentation, pairing, handoffs |
| Experiment Tracking | `experiment-tracking` | A/B tests, hypothesis management |
| Support Playbook | `support-playbook` | Triage support tickets, escalation paths |

### 📣 Marketing (8 skills)
| Skill | Install Name | Description |
|-------|-------------|-------------|
| Content Strategy | `content-strategy` | Content calendar, audience targeting, formats |
| SEO Optimization | `seo-optimization` | On-page SEO, keyword strategy, technical SEO |
| Social Media Planning | `social-media-planning` | Platform-specific strategy, scheduling |
| Growth Hacking | `growth-hacking` | Viral loops, activation, retention experiments |
| Email Marketing | `email-marketing` | Drip campaigns, segmentation, copywriting |
| Analytics Reporting | `analytics-reporting` | Marketing metrics, attribution, dashboards |
| Brand Voice | `brand-voice` | Tone guidelines, messaging consistency |
| Launch Planning | `launch-planning` | GTM strategy, launch checklist, coordination |

### 💼 Sales (5 skills)
| Skill | Install Name | Description |
|-------|-------------|-------------|
| Discovery Call | `discovery-call` | Qualification framework, pain discovery, MEDDIC |
| Proposal Writing | `proposal-writing` | Structure, pricing, value proposition |
| Pipeline Management | `pipeline-management` | Stage definitions, hygiene, forecasting |
| Sales Coaching | `sales-coaching` | Call review, objection handling, ramp plans |
| Deal Strategy | `deal-strategy` | Multi-stakeholder navigation, negotiation |

### 🧪 Testing (5 skills)
| Skill | Install Name | Description |
|-------|-------------|-------------|
| API Contract Testing | `api-contract-testing` | Schema validation, breaking change detection |
| Performance Testing | `performance-testing` | Load testing, profiling, bottleneck analysis |
| Accessibility Audit | `accessibility-audit` | WCAG compliance, assistive tech testing |
| Test Strategy | `test-strategy` | Coverage plan, risk-based testing, pyramid |
| Quality Gates | `quality-gates` | Definition of done, release criteria |

### 🎮 Game Dev (5 skills)
| Skill | Install Name | Description |
|-------|-------------|-------------|
| Game Design Doc | `game-design-doc` | GDD structure, mechanics, player loops |
| Level Design | `level-design` | Flow, pacing, challenge curves |
| Narrative Design | `narrative-design` | Story structure, branching dialogue, lore |
| Game Audio | `game-audio` | Sound design brief, music direction |
| Technical Art | `technical-art` | Shader brief, performance budgets, LOD strategy |

### 🌐 Spatial Computing (3 skills)
| Skill | Install Name | Description |
|-------|-------------|-------------|
| XR Interface Design | `xr-interface-design` | XR UX patterns, interaction modes |
| Spatial UX | `spatial-ux` | 3D layout, depth cues, comfort guidelines |
| visionOS Patterns | `visionos-patterns` | visionOS spatial design conventions |

### 🔬 Specialist (7 skills)
| Skill | Install Name | Description |
|-------|-------------|-------------|
| Legal Compliance | `legal-compliance` | GDPR, CCPA, SOC2, HIPAA review |
| Financial Modeling | `financial-modeling` | Unit economics, forecasting, projections |
| Developer Advocacy | `developer-advocacy` | API docs, tutorials, devrel content |
| Solutions Architecture | `solutions-architecture` | Pre-sales architecture, integration design |
| Blockchain Audit | `blockchain-audit` | Smart contract review, web3 security |
| HR & People Ops | `hr-people-ops` | Hiring, performance reviews, culture |
| Technical Documentation | `technical-documentation` | API docs, runbooks, user guides |

## Role → Recommended Packs

| Role | Recommended Skill Packs |
|------|------------------------|
| Solo Builder | Product + Platform/SRE |
| Frontend Developer | Design/UX + Testing |
| Backend Developer | Platform/SRE + Testing |
| Product Manager | Product + Team Processes |
| Team Lead | Team Processes + Product |
| Data Scientist / ML Engineer | Data/ML |
| Data Engineer | Data/ML + Platform/SRE |
| SRE / Platform Engineer | Platform/SRE + Team Processes |
| Product Designer | Design/UX + Product |
| Marketer / Growth | Marketing |
| Sales / BD | Sales + solutions-architecture |
| Game Developer | Game Dev |
