---
name: ai-product-monetization
description: Use when pricing an AI product — choosing between usage-based/hybrid/outcome pricing, calculating unit economics, protecting margins against LLM cost, and setting prices that reflect value without losing customers.
---

# AI Product Monetization

## When to Use

- Launching a new AI product and need to set pricing
- Current pricing isn't converting or margins are negative
- Users churning at paywall — wrong price or wrong model
- LLM costs growing faster than revenue
- Moving from free to paid (when and how)

## Core Jobs

### 1. AI Product Pricing Models

| Model | Structure | Best for | Risk |
|-------|-----------|---------|------|
| **Flat subscription** | $X/month | Predictable use, simple product | Undercharging heavy users |
| **Usage-based** | $X per [action] | Variable usage, API-like | Surprise bills → churn |
| **Hybrid** | Flat tier + overage | Most AI products (2025 dominant) | Complexity |
| **Outcome-based** | % of value created | High-value workflows (legal, finance) | Hard to measure |
| **Freemium** | Free tier + paid | Consumer tools, high viral coefficient | High LLM cost on free |

**2025 data:** Hybrid pricing (flat + overage) used by 41% of AI companies (up from 27%). Pure seat-based dropped from 21% → 15%.

### 2. LLM Cost Accounting (The Hidden Trap)

AI products have fundamentally different economics than SaaS:

```
Traditional SaaS:     80-90% gross margins
AI product:           50-60% gross margins (baseline)
AI product + caching: 65-75% gross margins (optimized)

Cost per active user calculation:
  Average queries/day: 20
  Tokens per query: 2,000 input + 500 output
  Model: Claude Sonnet ($3/1M input, $15/1M output)
  Daily cost: (20 × 2000 × $3/1M) + (20 × 500 × $15/1M)
            = $0.12 + $0.15 = $0.27/user/day
            = $8.10/user/month in LLM costs alone

  Minimum price for 50% margin: $8.10 × 2 = $16.20/month
  Minimum price for 60% margin: $8.10 × 2.5 = $20.25/month
```

**Run this calculation for YOUR product before setting any price.**

### 3. Pricing Psychology for Solos

```
Anchoring: Show 3 plans, middle plan is "Most Popular"
  Basic: $15/month (loss leader)
  Pro: $49/month ← "Most Popular" ← anchor to this
  Team: $149/month (makes Pro feel cheap)

Value anchoring (connect price to value saved):
  "At $49/month, that's $1.63/day — less than your morning coffee.
   If it saves you 2 hours/week, you're paying $0.40/hour for a senior analyst."

Free trial vs freemium:
  Free trial: 14 days full access, then convert → higher conversion, lower CAC
  Freemium: free forever with limits → lower conversion, higher viral, higher LLM cost
  Solo builder recommendation: 14-day trial first, add freemium only after PMF
```

### 4. Unit Economics Targets

```
For a solo AI business to be sustainable:

  CAC (Customer Acquisition Cost): < $50 for self-serve B2C
                                   < $200 for self-serve B2B
  LTV/CAC ratio: > 3x in year 1
  Payback period: < 6 months
  Gross margin: > 50% (baseline), > 65% (healthy)

  Example healthy unit economics:
    Price: $49/month
    LLM cost: $12/month (25% of revenue)
    Gross margin: 75%
    Churn: 5%/month
    LTV: $49 / 0.05 = $980
    CAC: $35 (organic, community)
    LTV/CAC: 28x ← excellent
```

### 5. Freemium Conversion Optimization

If using freemium, design the paywall deliberately:

```
Paywall design principles:
1. Users hit limit AFTER experiencing value (not before)
2. Limit is usage-based (queries, documents, seats) not time-based
3. Free tier covers ~20% of what a paying user needs
4. Show clear value message at paywall: "You've saved X hours this month.
   Upgrade to keep going."

Aha moment → paywall distance:
  Short distance (5-10 min) → low paywall friction
  Long distance (3+ sessions) → high paywall friction but better retention

Solo recommendation: Design for 30-minute time to value.
  Onboarding → First success → "Want more?" → paywall
```

## Key Concepts

- **Gross margin** — revenue minus direct costs (LLM API, hosting); target >50% for AI
- **LTV/CAC ratio** — lifetime value vs acquisition cost; >3x = healthy, >10x = exceptional
- **Hybrid pricing** — flat monthly fee + usage overage for heavy users; 2025 dominant model
- **Payback period** — months to recover CAC from margin; <6 months = healthy
- **Value anchoring** — connecting price to concrete time/money saved to reduce friction
- **Free tier LLM cost** — free users cost real money; design free tier to minimize API calls

## Checklist

- [ ] LLM cost per active user calculated (by model, average usage)?
- [ ] Gross margin target set (>50% baseline, >65% healthy)?
- [ ] Pricing model chosen (hybrid recommended for most AI products)?
- [ ] Three pricing tiers with clear differentiation?
- [ ] Unit economics calculated (LTV, CAC, payback, LTV/CAC)?
- [ ] Free trial (14 days) or freemium designed with paywall at value moment?
- [ ] Value anchoring in pricing page ("saves X hours = costs $Y")?

## Key Outputs

- LLM cost model: cost per user/month at different usage levels
- Pricing tiers: 3 tiers with feature differentiation and price rationale
- Unit economics: LTV, CAC, gross margin, payback period targets
- Freemium/trial design: limit structure, paywall moment, value message

## Output Format

- 🔴 **Critical** — no LLM cost accounting (margins negative), single price with no tier (lost upsell), paywall before user sees value (conversion killer)
- 🟡 **Warning** — gross margin <50% (unsustainable), no value anchoring on pricing page, free tier burning money with no conversion path
- 🟢 **Suggestion** — add usage-based overage to flat plan (capture heavy users), A/B test price with 10% of traffic, add "most popular" badge to middle tier

## Anti-Patterns

- Setting price based on competitor without calculating own LLM cost
- Single price point (loses money on heavy users, overcharges light users)
- Freemium before PMF (burns money on free users before knowing what to optimize)
- Ignoring gross margin (revenue growing, losing money = worse with scale)
- Pricing too low "to get users" (trains users to expect low price, hard to raise)

## Integration

- Use with `ai-product-positioning` (stronger moat = higher price ceiling)
- Use with `llm-cost-optimization` to improve gross margins
- Use with `model-routing` to reduce per-user LLM cost
- Agent: `@solo-ai-builder` reviews pricing before launch and after first churn spike
