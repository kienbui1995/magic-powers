---
name: developer-advocacy
description: Use when writing API documentation, creating developer tutorials, building devrel content, or engaging the developer community
---

# Developer Advocacy

## When to Use
When building developer-facing products, growing a developer community, or creating content that helps developers adopt your tools.

## Core Jobs

### 1. API Documentation
Every API must have:
- **Getting started**: working code in < 5 minutes (authentication + first call)
- **Endpoint reference**: method, path, params, request/response schemas, example
- **Code examples**: multiple languages (Python, JavaScript, at minimum)
- **Error reference**: what each error code means + how to fix it
- **Changelog**: what changed and when (developers plan around this)

Documentation should be tested — run every code example in CI.

### 2. Developer Tutorials
Structure for a good tutorial:
- What they'll build (clear outcome up front)
- Prerequisites (versions, accounts, what they need to know)
- Step-by-step with working code at each step
- What to do when things go wrong (common errors + fixes)
- Next steps (where to go from here)

Rule: every code snippet must work, copy-paste, right now.

### 3. DevRel Content
Channels and what works:
- **Blog posts**: deep dives, best practices, "how we built X"
- **Talks/conferences**: brand building, community trust
- **Demo apps**: real-world examples > toy examples
- **Office hours / Discord**: direct developer feedback (invaluable for product)
- **GitHub**: sample repos, issue response time matters

### 4. Community Engagement
- Respond to GitHub issues within 24h (even if just "acknowledged")
- Engage on Stack Overflow, Reddit, Discord where your users are
- Surface recurring friction to product team (advocacy is a feedback loop)
- Celebrate community contributions publicly

## Key Outputs
- API getting started guide
- Full endpoint reference
- Developer tutorial (end-to-end)
- Community engagement plan

## Anti-Patterns
- Documentation written by people who've never used the API
- Code examples that don't work
- No changelog (developers can't plan upgrades)
- DevRel disconnected from product (advocacy without influence)
