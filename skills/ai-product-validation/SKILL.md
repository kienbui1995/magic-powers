---
name: ai-product-validation
description: Use when deciding whether to build an AI product — rapid problem validation, market discovery, early user interviews, and demand signals BEFORE writing any code. Prevents the #1 solo founder failure mode.
---

# AI Product Validation

## When to Use

- Have an AI product idea but haven't started building yet
- Mid-build and not sure if anyone actually wants this
- Considering pivoting an existing product to add AI
- Want to test multiple ideas quickly before committing to one

## Core Jobs

### 1. The Validation-First Mindset

80% of solo AI products fail because founders build before validating. The goal: find 10 people who WANT to pay you before you write code.

```
Wrong order (most builders):          Right order (validation-first):
Idea → Build → Launch → Crickets      Idea → Validate → Build → Launch → Users
```

**Minimum validation bar before building:**
- ≥10 people explicitly say "I would pay $X/month for this"
- ≥3 people willing to pre-pay or join beta waitlist
- Problem occurs ≥weekly for your target user (frequency = retention)
- You can reach these users repeatedly (distribution)

### 2. Problem Discovery with AI (1-2 days)

Use Claude to research whether the problem exists at scale:

```
Prompt: "Search Reddit, Twitter, and forums for complaints about [problem area].
Find posts where people express frustration, ask for tools, or describe workarounds.
Summarize: frequency of complaint, exact language used, what solutions people try."
```

**Where to look:**
- Reddit: r/[industry], r/entrepreneur, r/SideProject, r/ChatGPT — search pain keywords
- Twitter/X: search `"I wish there was a tool that"`, `"frustrated with"`, `"someone should build"`
- Hacker News: `ask.hn` threads, "who is hiring" for tool needs
- Indie Hackers: product discussions, what people request

**Signal vs noise:**
- 🟢 Signal: "I pay $X/month for [workaround] that's terrible" — they're already paying
- 🟢 Signal: Multiple people describe same pain in same words independently
- 🔴 Noise: "That would be cool" — no commitment, no urgency
- 🔴 Noise: One loud person — n=1 isn't validation

### 3. The 5-Interview Sprint (2-3 days)

Talk to 5 real humans before building anything. Use AI to find them:

```python
# Use Claude to draft outreach for each channel
outreach_dm = """Hi [name], I saw your post about [specific pain].

I'm researching this problem and would love 15 minutes to understand
your workflow. No pitch — I'm deciding whether to build a tool.

Would next [day/time] work?"""
```

**Interview script (15 minutes):**
1. "Tell me about the last time you had to [do the painful thing]" — open, no leading
2. "How do you handle it now?" — discover workarounds = current willingness to pay
3. "How often does this happen?" — frequency determines retention ceiling
4. "What would make this a 10x better experience?" — don't ask for features, ask for outcomes
5. "If a tool solved this perfectly, what would you pay for it?" — the real test

**Killer questions:**
- "Have you looked for a tool that does this?" (if yes: why didn't you use it?)
- "Would you pay $[price] right now for early access?" (ask directly)

### 4. Landing Page Demand Test (1 day)

Build a landing page in 2 hours with Bolt/v0, validate with fake door:

```
Page structure:
1. Headline: "[Outcome] for [ICP] — 10x faster"
2. 3 bullet benefits (outcomes, not features)
3. Email capture: "Join waitlist — first 50 users get 50% off"
4. No build required — just measure demand

Success: >5% conversion on targeted traffic
Failure: <1% conversion → wrong problem or wrong audience
```

**Drive traffic cheaply:**
- Post in relevant subreddits: "I'm building X for Y, who's interested?" (check rules)
- Share in Indie Hackers #projects
- Tweet with problem description + survey link
- DM 20 people from your interview list

### 5. Competitive Moat Check

Before building, run the moat test:

```
Defensibility matrix:
- Who are the 3 biggest competitors? (search "alternatives to X")
- What do users complain about in their reviews? (G2, Capterra, App Store)
- Could OpenAI/Anthropic just add this to ChatGPT? (if yes, find a niche)
- What would you have that they don't? (data / workflow / trust / niche)
```

**Pass criteria for moat:**
- You're targeting a specific niche they ignore (lawyers, HR teams, small restaurants)
- You'd have domain-specific data they can't replicate
- Your users need workflow integration that general tools won't build

## Key Concepts

- **Fake door test** — landing page with no product behind it; measures real demand signal
- **Problem frequency** — how often the pain occurs; daily = high retention ceiling
- **Willingness to pay** — current spend on workarounds or direct dollar commitment
- **ICP (Ideal Customer Profile)** — the specific person type who has this problem most acutely
- **Distribution** — can you reach more of these people? Without distribution, validation is pointless

## Checklist

- [ ] ≥10 people confirmed they have this problem (not just "that sounds cool")?
- [ ] ≥3 people offered to pre-pay or join beta?
- [ ] Conducted ≥5 real interviews (not surveys)?
- [ ] Competitive moat identified — what you have that ChatGPT/Copilot won't build?
- [ ] Distribution channel identified — where do target users hang out?
- [ ] Problem occurs ≥weekly for target user?
- [ ] Landing page tested with real traffic (not just friends)?

## Key Outputs

- Validation summary: evidence for/against building (quotes, numbers, commitments)
- ICP definition: who exactly has this problem, at what frequency
- Moat hypothesis: why this isn't just a ChatGPT feature
- Decision: Build / Pivot / Kill — with evidence

## Output Format

- 🔴 **Critical** — building without any user conversations; nobody in interviews said they'd pay; direct competitor does this for free
- 🟡 **Warning** — only friends validated (biased); 5 interviews but no payment commitment; problem is "nice to have" not frequent
- 🟢 **Suggestion** — pre-collect emails before building; run fake door test to measure demand; use AI to scale customer discovery

## Anti-Patterns

- Building based on "I have this problem" (n=1 is not validation)
- Surveys instead of conversations (surveys get polite lies, interviews get truth)
- Asking "would you use this?" instead of "would you pay for this?" (different answers)
- Validating with friends/family (too supportive, not your ICP)
- Building for 3 months then validating (validate in 1-2 weeks, build in weeks not months)

## Integration

- Use with `ai-product-positioning` (once validated, position clearly)
- Use with `mvp-rapid-development` (validated? now build fast)
- Use with `vibe-coding` (use vibe tools to build fake-door landing page in 2 hours)
- Agent: `@solo-ai-builder` starts every new product idea with this skill
