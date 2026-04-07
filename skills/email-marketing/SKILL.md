---
name: email-marketing
description: Use when designing email campaigns, building drip sequences, segmenting lists, or improving deliverability
---

# Email Marketing

## When to Use
When building email as a growth, activation, or retention channel — newsletters, drip campaigns, or transactional email.

## Core Jobs

### 1. List Segmentation
Never send the same email to your whole list:
- By lifecycle stage: lead → trial → paid → churned
- By behavior: opened last 3 emails vs never opens
- By company size: SMB vs enterprise
- By role: developer vs manager vs executive

More targeted = higher open rates, lower unsubscribes.

### 2. Drip Sequence Design
Structure for trial/onboarding sequence:
- Day 0: Welcome + one immediate action to take
- Day 1: Core use case #1 (with example or tutorial)
- Day 3: Core use case #2
- Day 5: Social proof (customer story)
- Day 7: "Have you tried X?" (feature prompt if not activated)
- Day 10: Case study + conversion CTA

Each email: one goal, one CTA. Not four things at once.

### 3. Copywriting Principles
- **Subject line**: specific > vague. "How [Company] reduced churn by 23%" > "Check out our new feature"
- **First line**: matters for preview text. Make it useful immediately.
- **Body**: short paragraphs, one idea each. Under 200 words is ideal.
- **CTA**: one button, action-oriented ("Start your free trial"), contrasting color

### 4. Deliverability
Technical setup:
- SPF, DKIM, DMARC records configured
- Dedicated sending domain (not shared IP pool)
- Warm up new domain gradually (start 50/day, ramp over 4–6 weeks)
- Clean list: remove bounces immediately, unsubscribes < 24h

Maintain: open rate > 20%, unsubscribe rate < 0.5%, spam rate < 0.08%

## Key Outputs
- Drip sequence (email copy + timing)
- Segmentation strategy
- Deliverability technical setup checklist
- Campaign performance report

## Anti-Patterns
- Same email to entire list (spray and pray)
- Email subject lines as "Newsletter #47"
- No unsubscribe mechanism (CAN-SPAM/GDPR violation)
- Buying email lists (destroys deliverability)
