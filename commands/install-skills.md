---
description: "Browse and install optional skills from magic-powers into your project"
---

Browse and install optional skill packs from the magic-powers library into your current project.

## Step 1: Show Category Menu

Display the 11 skill categories:

```
🎯 Optional Skills Library — magic-powers

Choose a category to browse:

 1. Product (6 skills)               — user stories, roadmaps, stakeholder comms
 2. Data/ML (9 skills)               — pipelines, experiments, MLOps
 3. Platform/SRE (6 skills)          — SLOs, capacity, chaos engineering
 4. Design/UX (4 skills)             — UX audit, design systems, user research
 5. Team Processes (9 skills)        — sprints, ADRs, postmortems, onboarding
 6. Marketing (8 skills)             — content, SEO, growth, email, launch
 7. Sales (5 skills)                 — discovery, proposals, pipeline, coaching
 8. Testing (5 skills)               — contracts, performance, accessibility
 9. Game Dev (5 skills)              — GDD, level design, narrative, audio
10. Spatial Computing (3 skills)     — XR, spatial UX, visionOS
11. Specialist (7 skills)            — legal, finance, devrel, solutions arch
12. ☁️  Cloud Divisions              — GCP, AWS, Azure professional cert agents + skills
13. 📊 Amplitude Division            — Product analytics, experimentation, session replay, AI monitoring

Enter number (1–13), "all" to see all skills at once, or "done" to exit:
```

## Step 2: Show Skills in Selected Category

When user picks a number, show the skills in that category:

**1. Product:**
```
 1. user-story-writing       — Write user stories with acceptance criteria
 2. roadmap-planning         — Quarterly planning, ICE/MoSCoW prioritization
 3. stakeholder-communication — Status updates, exec presentations
 4. product-metrics          — Define KPIs, measure product health
 5. competitive-analysis     — Research competitors, position features
 6. feedback-synthesis       — Synthesize user feedback into actionable insights
```

**2. Data/ML:**
```
 1. data-pipeline-design     — ETL/ELT patterns, streaming vs batch
 2. data-quality             — Validate and test data pipelines
 3. data-modeling            — Schema design for analytics (star schema, etc.)
 4. ml-experiment-tracking   — Experiment management, reproducibility
 5. model-evaluation         — Metrics, bias detection, validation
 6. feature-engineering      — Feature selection, transformation patterns
 7. mlops-deployment         — Model serving, canary/shadow releases
 8. model-monitoring         — Drift detection, retraining triggers
 9. training-pipeline        — Orchestration, versioning
```

**3. Platform/SRE:**
```
 1. slo-sli-design           — Define SLOs, SLIs, error budgets
 2. capacity-planning        — Load projections, scaling decisions
 3. chaos-engineering        — Resilience testing patterns
 4. on-call-runbook          — Write actionable runbooks
 5. cloud-cost-review        — Rightsizing, reserved instances, waste
 6. performance-benchmarking — Measure baselines, compare before/after
```

**4. Design/UX:**
```
 1. ux-audit                 — Heuristic evaluation of existing UX
 2. design-system-audit      — Component consistency, token review
 3. user-research            — Interview guides, usability testing
 4. design-handoff           — Specs, assets, developer communication
```

**5. Team Processes:**
```
 1. sprint-planning          — Backlog refinement, capacity, sprint goals
 2. sprint-retrospective     — Formats, actionable outcomes
 3. team-onboarding          — Dev env setup, codebase intro, first PR
 4. adr-writing              — Architecture Decision Records
 5. incident-postmortem      — Blameless postmortem, follow-ups
 6. tech-debt-triage         — Prioritize, track, allocate time
 7. knowledge-transfer       — Documentation, pairing, handoffs
 8. experiment-tracking      — A/B tests, hypothesis management
 9. support-playbook         — Triage support tickets, escalation paths
```

**6. Marketing:**
```
 1. content-strategy         — Content calendar, audience targeting, formats
 2. seo-optimization         — On-page SEO, keyword strategy, technical SEO
 3. social-media-planning    — Platform-specific strategy, scheduling
 4. growth-hacking           — Viral loops, activation, retention experiments
 5. email-marketing          — Drip campaigns, segmentation, copywriting
 6. analytics-reporting      — Marketing metrics, attribution, dashboards
 7. brand-voice              — Tone guidelines, messaging consistency
 8. launch-planning          — GTM strategy, launch checklist, coordination
```

**7. Sales:**
```
 1. discovery-call           — Qualification framework, pain discovery, MEDDIC
 2. proposal-writing         — Structure, pricing, value proposition
 3. pipeline-management      — Stage definitions, hygiene, forecasting
 4. sales-coaching           — Call review, objection handling, ramp plans
 5. deal-strategy            — Multi-stakeholder navigation, negotiation
```

**8. Testing:**
```
 1. api-contract-testing     — Schema validation, breaking change detection
 2. performance-testing      — Load testing, profiling, bottleneck analysis
 3. accessibility-audit      — WCAG compliance, assistive tech testing
 4. test-strategy            — Coverage plan, risk-based testing, pyramid
 5. quality-gates            — Definition of done, release criteria
```

**9. Game Dev:**
```
 1. game-design-doc          — GDD structure, mechanics, player loops
 2. level-design             — Flow, pacing, challenge curves
 3. narrative-design         — Story structure, branching dialogue, lore
 4. game-audio               — Sound design brief, music direction
 5. technical-art            — Shader brief, performance budgets, LOD strategy
```

**10. Spatial Computing:**
```
 1. xr-interface-design      — XR UX patterns, interaction modes
 2. spatial-ux               — 3D layout, depth cues, comfort guidelines
 3. visionos-patterns        — visionOS spatial design conventions
```

**11. Specialist:**
```
 1. legal-compliance         — GDPR, CCPA, SOC2, HIPAA review
 2. financial-modeling       — Unit economics, forecasting, projections
 3. developer-advocacy       — API docs, tutorials, devrel content
 4. solutions-architecture   — Pre-sales architecture, integration design
 5. blockchain-audit         — Smart contract review, web3 security
 6. hr-people-ops            — Hiring, performance reviews, culture
 7. technical-documentation  — API docs, runbooks, user guides
```

**12. Cloud Divisions:**
```
Choose a cloud provider:

  1. GCP — 7 agents + 14 skills (Professional Cloud certs)
  2. AWS — 7 agents + 14 skills (AWS Professional/Associate certs)
  3. Azure — 7 agents + 14 skills (Azure Associate/Expert certs)
  A. All clouds — 21 agents + 42 skills

Enter number (1-3):
```

If user selects GCP (1), show:

```
GCP Division — Professional Cloud Certifications

Agents (installed to .claude/agents/):
  📊 gcp-data-engineer      — Professional Data Engineer (GCP-PDE)
  💻 gcp-cloud-developer    — Professional Cloud Developer
  🌐 gcp-network-engineer   — Professional Cloud Network Engineer
  🤖 gcp-ml-engineer        — Professional Machine Learning Engineer
  ⚙️  gcp-devops-engineer    — Professional Cloud DevOps Engineer
  🔒 gcp-security-engineer  — Professional Cloud Security Engineer
  🏗️  gcp-cloud-architect    — Professional Cloud Architect (Opus model)

Skills (installed to .claude/skills/):
  bigquery-optimization     dataflow-pipeline
  pubsub-messaging          cloud-storage
  data-quality-validation   vertex-ai-mlops
  cloud-run-functions       gke-kubernetes
  cloud-iam                 cloud-build-deploy
  cloud-networking          vpc-service-controls
  cloud-monitoring          security-command-center

Type "install" to install GCP Division, or "back" to return:
```

If user selects AWS (2), show:

```
AWS Division — AWS Professional/Associate Certifications

Agents (installed to .claude/agents/):
  📊 aws-data-engineer         — Data Engineer Associate (DEA-C01)
  💻 aws-cloud-developer       — Developer Associate (DVA-C02)
  🌐 aws-network-engineer      — Advanced Networking Specialty (ANS-C01)
  🤖 aws-ml-engineer           — ML Engineer Associate (MLA-C01)
  ⚙️  aws-devops-engineer       — DevOps Engineer Professional (DOP-C02)
  🔒 aws-security-engineer     — Security Specialty (SCS-C02)
  🏗️  aws-solutions-architect   — Solutions Architect Professional (SAP-C02, Opus)

Skills (installed to .claude/skills/):
  glue-etl                  kinesis-streaming
  redshift-optimization     s3-best-practices
  dynamodb-design           cloudwatch-monitoring
  lake-formation-governance lambda-serverless
  iam-security              codepipeline-cicd
  vpc-networking            eks-kubernetes
  guardduty-security        sagemaker-mlops

Type "install" to install AWS Division, or "back" to return:
```

If user selects Azure (3), show:

```
Azure Division — Azure Associate/Expert Certifications

Agents (installed to .claude/agents/):
  📊 azure-data-engineer       — Fabric Data Engineer (DP-700)
  💻 azure-cloud-developer     — AI Cloud Developer (AI-200)
  🌐 azure-network-engineer    — Network Engineer Associate (AZ-700)
  🤖 azure-ai-engineer         — AI Engineer Associate (AI-102)
  ⚙️  azure-devops-engineer     — DevOps Engineer Expert (AZ-400)
  🔒 azure-security-engineer   — Cloud & AI Security (SC-500)
  🏗️  azure-solutions-architect — Solutions Architect Expert (AZ-305, Opus)

Skills (installed to .claude/skills/):
  fabric-lakehouse          dataflow-gen2
  fabric-pipelines          eventstreams
  fabric-governance         fabric-monitoring
  azure-functions           aks-kubernetes
  azure-ad-entra            azure-networking
  azure-devops-pipelines    azure-monitor
  microsoft-sentinel        azure-openai

Type "install" to install Azure Division, or "back" to return:
```

Then prompt:
```
Enter skill numbers (e.g. 1,3,5), "all" to install all in this category, or "back" to return:
```

## Step 3: Install Selected Skills

For each selected skill:
1. Check if `${CLAUDE_PLUGIN_ROOT}/skills/<name>/SKILL.md` exists
2. Create `.claude/skills/<name>/` in the current project directory if needed
3. Copy SKILL.md to `.claude/skills/<name>/SKILL.md`

If skill already installed, show `(already installed)` and skip.

### Cloud Division Install (for category 12)

For each selected cloud provider:
1. Copy agent files from `${CLAUDE_PLUGIN_ROOT}/agents/cloud/<provider>/` to `.claude/agents/`
   - Create `.claude/agents/` directory in current project if needed
2. Copy skill files from `${CLAUDE_PLUGIN_ROOT}/skills/cloud/<provider>/*/SKILL.md` to `.claude/skills/<skill-name>/SKILL.md`
   - Create each `.claude/skills/<skill-name>/` directory as needed

If already installed, show `(already installed)` and skip.

Confirm:
```
✅ Installed GCP Division to current project:

  Agents (.claude/agents/):
    📊 gcp-data-engineer.md
    💻 gcp-cloud-developer.md
    🌐 gcp-network-engineer.md
    🤖 gcp-ml-engineer.md
    ⚙️  gcp-devops-engineer.md
    🔒 gcp-security-engineer.md
    🏗️  gcp-cloud-architect.md

  Skills (.claude/skills/):
    📋 bigquery-optimization/   📋 dataflow-pipeline/
    📋 pubsub-messaging/        📋 cloud-storage/
    📋 data-quality-validation/ 📋 vertex-ai-mlops/
    📋 cloud-run-functions/     📋 gke-kubernetes/
    📋 cloud-iam/               📋 cloud-build-deploy/
    📋 cloud-networking/        📋 vpc-service-controls/
    📋 cloud-monitoring/        📋 security-command-center/

Use @gcp-data-engineer, @gcp-cloud-architect, etc. to invoke cloud agents.
Invoke @gcp-data-engineer in your project to start using GCP Data Engineer assistance.
```
```

### Amplitude Division Install (for category 13)

**Requires:** Amplitude MCP server configured (see `agents/amplitude/AMPLITUDE_DIVISION.md` for setup).

1. Copy agent files from `${CLAUDE_PLUGIN_ROOT}/agents/amplitude/` (excluding AMPLITUDE_DIVISION.md) to `.claude/agents/`
2. Copy skill files from `${CLAUDE_PLUGIN_ROOT}/skills/amplitude/*/SKILL.md` to `.claude/skills/<skill-name>/SKILL.md`

Show agent+skill list before installing:
```
📊 Amplitude Division — Product Analytics (Requires Amplitude MCP)

Agents (.claude/agents/):
  📈 amplitude-analyst        — Charts, dashboards, daily/weekly briefings
  🧪 amplitude-experimenter   — A/B tests, opportunities, user journeys
  🔧 amplitude-engineer       — Instrumentation, event taxonomy, tracking specs
  🔍 amplitude-ux-researcher  — Session replay, error diagnosis, UX audit
  🤖 amplitude-ai-monitor     — AI/LLM quality, topics, session investigation

Skills (.claude/skills/):
  create-chart            analyze-chart
  create-dashboard        analyze-dashboard
  daily-brief             weekly-brief
  what-would-lenny-do     analyze-experiment
  discover-opportunities  compare-user-journeys
  analyze-account-health  analyze-feedback
  diff-intake             discover-event-surfaces
  discover-analytics-patterns  instrument-events
  add-analytics-instrumentation  taxonomy
  debug-replay            replay-ux-audit
  diagnose-errors         monitor-reliability
  analyze-ai-topics       investigate-ai-session
  monitor-ai-quality      review-agent-insights

Type "install" to install, or "back" to return:
```

Confirm installation:
```
✅ Installed 3 skills to .claude/skills/:

  📋 .claude/skills/data-pipeline-design/SKILL.md
  📋 .claude/skills/ml-experiment-tracking/SKILL.md
  📋 .claude/skills/model-evaluation/SKILL.md

These skills are now auto-loaded into every Claude session in this project.

Browse another category or type "done" to exit:
```

## Notes
- Skills installed to `.claude/skills/` are auto-loaded by Claude every session — no manual invocation needed
- User can install from multiple categories before typing "done"
- "all" at the skill list installs everything in that category
- "all" at the category menu shows all 67 skills in one list (for power users)
- Browse all skill categories with `/install-skills`; install role packs quickly with `/setup`
