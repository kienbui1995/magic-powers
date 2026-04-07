---
name: financial-modeling
description: Use when building unit economics models, financial projections, or analyzing the business viability of a feature or product
---

# Financial Modeling

## When to Use
When evaluating whether a business decision makes financial sense — new product, pricing change, market expansion, or funding round preparation.

## Core Jobs

### 1. Unit Economics
For a SaaS or marketplace, calculate:
- **CAC** (Customer Acquisition Cost) = Total sales & marketing spend / New customers acquired
- **LTV** (Lifetime Value) = ARPU × Gross Margin % × Average Customer Lifetime
- **LTV:CAC Ratio** — healthy = 3:1 or better
- **Payback Period** = CAC / (ARPU × Gross Margin %) — target < 12 months

### 2. Revenue Projections
Build a bottoms-up model:
```
New MRR = New customers × ARPU
Expansion MRR = Existing customers × upsell rate × upsell ARPU
Churned MRR = Churning customers × their ARPU
Net New MRR = New + Expansion - Churned
```
3 scenarios: pessimistic, base, optimistic (vary growth rate assumption)

### 3. Cost Structure
Fixed: salaries, infrastructure, office
Variable: hosting (per user), payment processing fees, customer support cost per ticket
Model cost per unit at different scale points (100, 1K, 10K customers)

### 4. Break-Even Analysis
Break-even = Fixed costs / (Revenue per unit - Variable cost per unit)
When does the model become profitable at current growth rate?

### 5. Sensitivity Analysis
Identify the top 3 assumptions that most affect the outcome:
- If churn is 5% vs 10%: how does LTV change?
- If CAC is 2x: when does payback period exceed 18 months?
Show a sensitivity table for each key assumption.

## Key Outputs
- Unit economics dashboard (CAC, LTV, payback)
- 3-scenario revenue projection (12–24 months)
- Break-even analysis
- Sensitivity table on key assumptions

## Anti-Patterns
- Top-down TAM projections without bottoms-up validation
- Ignoring churn in LTV calculations
- Single-scenario models (no pessimistic case)
- Not stress-testing assumptions
