---
name: ai-product-positioning
description: Use when defining how an AI product stands out — defensibility assessment, outcome-based messaging, feature vs product decision, competitive moat design, and positioning for a specific niche.
---

# AI Product Positioning

## When to Use

- Writing landing page copy that doesn't convert
- Users say "oh that's like ChatGPT" — commoditized perception
- Choosing between multiple product directions
- Deciding what to emphasize in marketing
- Building an AI product and wondering if it's defensible

## Core Jobs

### 1. Feature vs Product Decision

Critical strategic decision with huge implications:

| Dimension | AI Feature | AI Product |
|-----------|-----------|-----------|
| Core value | Enhancement to existing workflow | Solves a standalone problem |
| Business model | Bundled with main product | Standalone subscription |
| Marketing | "Now with AI" | "The AI for [specific problem]" |
| Retention | Tied to main product | Must be independently indispensable |
| Risk | Low (bundled) | High (must acquire users) |
| Upside | Limited | Unlimited |

**Test:** Can users pay for JUST the AI capability, separately from everything else? If yes → product. If no → feature.

### 2. Defensibility Assessment

Rate your moat across 4 dimensions (0-3 each):

```
Data moat (0-3):
  0 = any user can get same results from ChatGPT
  1 = you use industry-specific data users provide
  2 = you collect data across ALL users that improves the product
  3 = proprietary dataset nobody else has access to

Workflow moat (0-3):
  0 = one-off use, no workflow integration
  1 = part of existing workflow but easily replaced
  2 = deeply embedded, switching costs >1 day
  3 = critical path — production breaks without it

Trust moat (0-3):
  0 = any AI can do this, no personalization
  1 = remembers user preferences
  2 = knows user's industry/company context deeply
  3 = irreplaceable knowledge of user's specific situation

Niche moat (0-3):
  0 = generic tool for everyone
  1 = vertical focus (marketing tools)
  2 = specific role (CMO tools)
  3 = specific workflow for specific person (CMO weekly report)

Score: 0-4 = thin wrapper (high risk), 5-8 = defensible, 9-12 = strong moat
```

### 3. Outcome-Based Messaging

Move from feature language to outcome language:

```
Feature language (weak):          Outcome language (strong):
"Uses GPT-4 to analyze..."        "Save 3 hours per week on..."
"AI-powered document search"      "Find any clause in your 500-page contract in 10 seconds"
"Automates report generation"     "Get your Monday board report done in 15 minutes, not 3 hours"
"Multi-agent AI assistant"        "Your AI team that never sleeps — replies to leads while you do"
```

**Messaging formula:**
```
[Specific person] who [does specific thing] can now [achieve outcome] in [time/effort saved]
without [painful part of current process].
```

**Test your messaging:**
- Show 3 people your headline for 5 seconds, hide it, ask: "What does this do?"
- If they can't explain it correctly → too vague or too feature-focused
- If they say "Oh I need that" → you nailed it

### 4. ICP Sharpening

The narrower your ICP, the stronger your positioning:

```
Too broad:  "For businesses using AI"
Better:     "For marketing teams using AI"
Best:       "For B2B SaaS CMOs who write weekly board decks"
Brilliant:  "For B2B SaaS CMOs at Series A-B companies who present to board monthly"
```

**Narrowing exercise:**
1. Who gets the most value? (job title, company stage, industry)
2. Who has the highest urgency? (paying for workarounds = high urgency)
3. Who is easiest to reach? (online community, conference, LinkedIn group)
4. Who will refer others? (tight-knit communities amplify word-of-mouth)

### 5. Competitive Positioning Map

Find the white space competitors don't occupy:

```
Positioning axes (pick 2 that matter most to your ICP):
- Speed ↔ Thoroughness
- Ease of use ↔ Customization
- Cheap ↔ Premium
- General ↔ Specialized
- Self-serve ↔ Human-assisted

Plot: Where are competitors? Where is the gap?
Position in the gap your ICP values most.
```

## Key Concepts

- **Category creation** — define a new category ("AI board deck generator") rather than competing in existing one
- **Hair-on-fire problem** — problem so urgent users will try anything; ideal target
- **Specificity premium** — the more specific your positioning, the higher price you can charge
- **Moat score** — 0-12 rating of defensibility across data/workflow/trust/niche dimensions
- **Outcome language** — describes user's life after using product, not product's features

## Checklist

- [ ] Feature vs product decision made explicitly?
- [ ] Moat score calculated (target ≥5)?
- [ ] Landing page headline uses outcome language (not feature language)?
- [ ] ICP narrowed to specific job title + company stage + industry?
- [ ] Competitive positioning map completed — white space identified?
- [ ] Headline tested with 3+ strangers (5-second test)?
- [ ] "Why not just use ChatGPT?" answered clearly?

## Key Outputs

- Positioning statement: "[ICP] who [problem] can now [outcome] without [pain]"
- Moat score: 0-12 with breakdown by dimension and improvement plan
- Competitive map: where you sit vs. alternatives, white space claim
- Headline + tagline: outcome-first, ICP-specific, passes 5-second test

## Output Format

- 🔴 **Critical** — moat score <4 (easily cloned), generic ICP ("for businesses"), feature language on landing page
- 🟡 **Warning** — moat score 4-6 (vulnerable), ICP still too broad, messaging tests poorly with strangers
- 🟢 **Suggestion** — sharpen ICP to specific workflow, add data collection to increase moat score, test 3 different headlines with target users

## Anti-Patterns

- Positioning for everyone (results in positioning for no one)
- "Better ChatGPT" positioning (you can't win on general capability)
- Feature list as the headline (users buy outcomes, not features)
- Copying competitor positioning (me-too = commoditized)
- Ignoring moat — building something OpenAI will add in 6 months

## Integration

- Use after `ai-product-validation` (validated problem → now position clearly)
- Use with `solo-founder-gtm` (positioning drives all GTM messaging)
- Use with `ai-product-monetization` (stronger moat → higher price ceiling)
- Agent: `@solo-ai-builder` runs positioning analysis before writing landing page copy
