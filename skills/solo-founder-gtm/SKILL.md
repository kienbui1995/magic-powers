---
name: solo-founder-gtm
description: Use when building go-to-market as a solo founder — distribution playbook for <5 hours/week, AI-powered personalized outreach, community leverage (Twitter/Reddit/ProductHunt/IndieHackers), and sales-led loops for early traction.
---

# Solo Founder GTM

## When to Use

- Product is ready but nobody knows about it
- Spending full time building, zero time on distribution
- Don't have budget or team for paid marketing
- First 100 users → how to get them
- Building audience/distribution before product (ideally)

## Core Jobs

### 1. The Solo GTM Constraint

You have 5 hours/week for GTM. Spend them wisely:

```
Distribution channel priority for solo AI builder:

Week 1-4 (0 users):     Niche communities, warm outreach, direct conversations
Week 5-12 (1-100):      Content creation, productized distribution, referral loops
Month 3-6 (100-1000):   Scale what's working, one paid channel test
Month 6+ (1000+):       Automate winning channels, add second channel
```

**Don't do:** Paid ads (too early), PR (too slow), cold content (no audience yet)
**Do:** Direct outreach, community presence, founder-led content

### 2. AI-Powered Outreach at Scale

Use AI to write personalized outreach, without spending hours:

```python
# Prompt for Claude to generate 20 personalized cold DMs
prompt = """
I'm reaching out to [job title] at [company stage] companies about [problem].

For each of these 5 people, write a personalized DM (3 sentences max):
- Reference something specific about them (recent post, company news, role)
- Connect it to the problem I solve
- One clear ask (15-min call, feedback, try the tool)

People:
1. [Name] - [LinkedIn URL or description]
2. ...

Tone: conversational, curious, not salesy. No "I hope this message finds you well."
"""
```

**Weekly outreach system:**
- Monday: Claude drafts 20 personalized DMs from LinkedIn search
- Tuesday-Thursday: Send 5-7/day (not spammy), track responses
- Friday: Follow up with interested, analyze what messaging worked

**Expected results:** 5-15% response rate, 3-8% meeting rate on personalized outreach.

### 3. Community Distribution Playbook

Top communities for solo AI builder, with specific tactics:

**Twitter/X (highest leverage for AI tools):**
- Post problem/solution content daily (2 minutes with AI drafting)
- Build-in-public threads get organic reach (5-10x more than product posts)
- Engage with [niche] + AI thought leaders (reply-first strategy)
- Tweet formula: "I spent [X hours] on [painful task]. Now I do it in [Y minutes]. Here's how:"

**Reddit (highest intent traffic for tools):**
- Find 3-5 niche subreddits where your ICP is (r/[industry], r/[role])
- Lurk 2 weeks, learn the culture, then participate genuinely
- Answer questions helpfully — mention your tool only when directly relevant
- "I made a thing" posts work when you're a community member first
- One successful Reddit post = 500-2000 targeted visitors

**Indie Hackers:**
- Post milestone updates ("From 0 to $1k MRR") — high engagement
- Comment on others' posts (build relationships → they share your launches)
- Post product: genuine community, early adopters willing to try new tools

**Product Hunt:**
- Day 1 launch (midnight Pacific) matters
- Prepare: 50+ hunter relationships before launch, collect upvotes-day commitments
- Submit: strong tagline (outcome-first), GIF/video demo, hunter with followers
- Expected: 3,000-10,000 visitors day 1 → 100-500 signups if landing page converts

### 4. Sales-Led Loop (First 10 Paying Customers)

For first 10 customers, sell manually — don't automate yet:

```
Week 1: Identify 50 people in your ICP (LinkedIn search, Twitter followers, community)
Week 2: Reach out personally to 20 (use AI-drafted personalized DMs)
Week 3: Demo call + configure tool for their specific use case
Week 4: Follow up, convert to paid, ask for referrals

Conversion funnel:
50 outreach → 10 conversations → 5 demos → 2-3 paying customers
```

**What to learn from manual sales:**
- Exact language customers use to describe the problem (steal for marketing copy)
- Which use cases convert (focus product on those)
- Real objections ("why not just use ChatGPT?") and how to answer them
- Who refers → that's your real ICP

### 5. Build-in-Public for Compound Distribution

Document your journey publicly — this is organic distribution that compounds:

```
Tweet formats that perform well:
- "Day 30: [metric] → [metric]. Here's what I learned:"
- "I almost gave up on [product] until [turning point]. Story:"
- "[Counterintuitive insight] about building AI products as a solo founder:"
- "Launched [feature]. First user said: [quote]. Changed my thinking:"
```

**Build-in-public schedule (30 min/week):**
- Monday: 1 insight tweet from the week's learning
- Wednesday: Product update or milestone (with numbers)
- Friday: Behind-the-scenes or process thread (5 tweets)

## Key Concepts

- **Build-in-public** — documenting journey publicly; creates organic audience + distribution
- **Sales-led loop** — manually sell to first 10-20 customers to learn, then automate
- **Community presence** — being genuinely helpful in niche communities before promoting
- **Productized outreach** — systematized personalized outreach using AI, runs 5h/week
- **Distribution-first** — building audience before product; hardest but highest-leverage

## Checklist

- [ ] Primary distribution channel chosen (Twitter OR Reddit OR community — pick one first)?
- [ ] ICP location identified — which 3 communities do they live in?
- [ ] Outreach system set up — 20 personalized DMs/week with AI?
- [ ] Product Hunt launch planned (not day-of) with hunter relationships built?
- [ ] Build-in-public content calendar (30 min/week minimum)?
- [ ] First 10 customers acquired through manual sales-led loop?
- [ ] Referral ask scripted — "Who else do you know who has this problem?"?

## Key Outputs

- GTM plan: primary channel, weekly time budget, 90-day targets
- Outreach template: personalized DM system with AI workflow
- Community presence plan: which 3 subreddits/communities to be active in
- Content calendar: 30 min/week posting schedule with formats

## Output Format

- 🔴 **Critical** — no distribution system (product exists, nobody knows), starting with paid ads before organic works, posting only product updates (no value content)
- 🟡 **Warning** — distributing on too many channels at once (spread thin), skipping manual sales-led phase (miss learning), building in private (no audience)
- 🟢 **Suggestion** — start build-in-public today (don't wait for v1), pick ONE community and go deep before expanding, use AI to batch weekly outreach in 2 hours

## Anti-Patterns

- Waiting until "product is ready" to start distribution (start day 1)
- Trying all channels simultaneously (depth > breadth for solos)
- Product Hunt launch with no preparation (do it right or don't do it)
- Generic outreach ("I think you'd love my product") — AI personalizes this cheaply
- Building audience then not capturing emails (always capture email)

## Integration

- Use after `ai-product-positioning` (positioning drives all messaging)
- Use with `launch-planning` for coordinated Product Hunt launch
- Use with `content-strategy` for content calendar execution
- Agent: `@solo-ai-builder` designs and reviews the GTM system
