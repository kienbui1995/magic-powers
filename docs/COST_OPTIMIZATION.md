# Cost Optimization Analysis

## Problem

Claude Code on Vertex AI defaults to using the most expensive model (Opus) for everything — brainstorming, coding, debugging, and code review all use the same model.

## Real-World Cost Data

Based on actual usage across 6 projects (FastAPI + Next.js + PostgreSQL + LangGraph):

| Project | Opus Cost | Sonnet Cost | Haiku Cost | Total |
|---------|-----------|-------------|------------|-------|
| Project A (RAG/AI) | $467.35 | — | $0.58 | $467.94 |
| Project B (AI Assistant) | $133.14 | $0.08 | $0.64 | $133.86 |
| Project C (Full-stack SaaS) | $99.34 | $6.47 | — | $105.81 |
| Project D (B2B Platform) | $69.58 | — | $0.86 | $70.44 |
| Project E (Healthcare) | $14.14 | $2.46 | — | $16.60 |
| Project F (Misc) | $9.53 | — | $1.26 | $10.79 |
| **Total** | **$793.08** | **$9.01** | **$3.34** | **$805.44** |

**98.5% of cost was Opus** — even for simple tasks like code review.

## Solution: Model Routing via Subagents

| Task | Agent | Model | Price (input/output per 1M) |
|------|-------|-------|-----------------------------|
| Brainstorming, planning | architect | Opus | $5.00 / $25.00 |
| Coding, implementation | Main session | Sonnet | $3.00 / $15.00 |
| Debugging | debugger | Sonnet | $3.00 / $15.00 |
| Code review, verification | reviewer | Haiku | $0.25 / $1.25 |
| UI/UX design + code | ui-designer | Sonnet | $3.00 / $15.00 |

## Estimated Savings

- Coding (bulk of tokens): Opus → Sonnet = **~40% cheaper**
- Code review: Opus → Haiku = **~95% cheaper**
- Brainstorming stays on Opus (worth the cost for deep reasoning)
- **Overall: ~50% reduction** ($805 → ~$400 for same workload)
