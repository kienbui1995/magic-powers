---
name: mvp-rapid-development
description: Use when building MVPs fast with a small team - lean startup for AI products, feature prioritization, ship-fast patterns, iteration cycles
---

# MVP Rapid Development

## Overview

For small AI startup teams: ship the smallest thing that tests your hypothesis. Perfect is the enemy of shipped.

## When to Use

- Starting a new AI product from zero
- Deciding what to build first with limited resources
- Feeling stuck in "building mode" without shipping
- Prioritizing features for a 2-4 person team

## The MVP Formula

```
1. What's the ONE problem you solve?
2. What's the SMALLEST thing that proves it works?
3. Build THAT. Ship it. Measure.
4. Iterate or pivot based on data.
```

## Week-by-Week Playbook (4-week MVP)

| Week | Focus | Deliverable |
|------|-------|-------------|
| 1 | Problem + solution validation | 10 user interviews, core hypothesis |
| 2 | Core feature build | Working prototype of ONE feature |
| 3 | Polish + deploy | Deployed, usable by real users |
| 4 | Measure + iterate | Usage data, feedback, next iteration |

## Feature Prioritization (ICE Score)

```
Score = Impact × Confidence × Ease

Impact:     How much does this move the needle? (1-10)
Confidence: How sure are we it works? (1-10)
Ease:       How fast can we build it? (1-10)
```

Build highest ICE score first. Ruthlessly cut everything else.

## AI MVP Shortcuts

| Instead of... | Ship this first |
|---------------|----------------|
| Custom fine-tuned model | Prompt engineering + GPT-4 API |
| Full RAG pipeline | Simple prompt with pasted context |
| Multi-agent system | Single agent with tools |
| Custom embeddings | OpenAI embeddings + Pinecone |
| Real-time streaming | Batch processing + polling |
| Custom auth | Clerk/Auth0/Supabase Auth |
| Custom UI | Shadcn/UI + Next.js template |

## Small Team Rules

1. **One feature at a time** — no parallel feature development with <4 people
2. **Deploy daily** — if you're not deploying, you're accumulating risk
3. **Cut scope, not corners** — fewer features done well > many features done poorly
4. **Use managed services** — Vercel, Supabase, Pinecone, not self-hosted
5. **AI for internal tools too** — use Claude/GPT to write docs, tests, scripts
6. **Measure one metric** — pick ONE number that matters this week

## When to Stop MVPing

- You have 100+ active users → time to invest in quality
- Users are paying → time to invest in reliability
- You're losing users to bugs → time to invest in stability

## Integration

- **magic-powers:spec-driven-development** — spec the MVP before building
- **magic-powers:product-strategy** — prioritize what to build
- **magic-powers:prompt-engineering** — start with prompts, not code
- **magic-powers:environment-setup** — fast project bootstrap
