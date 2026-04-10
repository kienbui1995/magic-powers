---
name: vibe-coding
description: Use when rapidly prototyping AI products — going from idea to working demo in 4-8 hours using AI-assisted development tools (Cursor, Bolt, v0, Lovable), knowing when to vibe vs spec, and transitioning prototypes to production.
---

# Vibe Coding

## When to Use

- Testing a new product idea before committing to build it properly
- Need a demo/MVP to validate with users this week (not this month)
- Exploring multiple UI approaches quickly
- Prototype exists, need to decide whether to productionize it

## Core Jobs

### 1. Vibe Coding vs Spec-Driven: When to Use Each

| Situation | Use Vibe Coding | Use Spec-Driven |
|-----------|----------------|-----------------|
| New idea, unvalidated | ✅ — test in hours | ❌ — too slow |
| Validated idea, building for real | ❌ — too fragile | ✅ — solid foundation |
| Throwaway prototype | ✅ | ❌ |
| Production feature | ❌ | ✅ |
| UI exploration (which layout?) | ✅ | ❌ |
| Complex backend logic | ❌ | ✅ |
| Time pressure, low stakes | ✅ | ❌ |
| High stakes (payments, security) | ❌ | ✅ |

**Rule of thumb:** Vibe for validation, spec for production. The switch happens when users start paying.

### 2. The 4-Hour AI Product Prototype Stack

Tools that let one person ship a working demo in an afternoon:

```
Frontend (30 min):
  v0.dev → describe UI in natural language → copy Next.js components
  OR Bolt.new → describe full app → working app with auth + DB

AI integration (30 min):
  Cursor → "Add Claude API call to this component"
  Provide: system prompt + user input → streaming response

Auth + Database (0 min with Supabase):
  Bolt.new includes Supabase by default
  OR: use Clerk (auth) + Supabase (DB) — 2 env vars, done

Deployment (5 min):
  Vercel → connect GitHub → auto-deploy
  Custom domain: $12/year on Namecheap

Total time to "share this link with users": 2-4 hours
```

### 3. Effective Prompting for Vibe Coding Tools

How to get 10x better results from Bolt/v0/Cursor:

**For Bolt.new (full app generation):**
```
Describe in ONE paragraph:
"Build a [type] app for [ICP] that lets them [core action].
Use Next.js, Supabase for auth + DB, Tailwind for styling.
The main page shows [key feature]. Include [specific functionality].
Keep it simple — no admin panel, no complex settings."

Include:
✅ The primary user action (what they do most)
✅ The data model (what gets stored)
✅ The tech stack (prevents mismatch)
❌ Don't include: edge cases, nice-to-haves, complex flows
```

**For v0.dev (UI generation):**
```
"Design a [component name] for a [product type].
Style: clean, professional, [color scheme]
Shows: [key information]
Actions user can take: [list 2-3 max]
Similar to: [reference product] but for [your niche]"

Iterate with: "Make the [element] more prominent" / "Add [feature] to this"
```

**For Cursor (feature addition to existing code):**
```
@file.tsx "Add a [feature] to this component.
When user [trigger], it should [action].
Use [existing pattern from codebase] as reference.
Keep it minimal — only what's needed for this use case."
```

### 4. Prototype-to-Production Checklist

Know when to throw away the vibe prototype and rebuild properly:

**Stop vibing when:**
- First paying customer (now it matters if it breaks)
- >100 users/day (reliability becomes real)
- Data loss would be catastrophic (switch to proper DB migrations)
- You're extending the prototype for the 5th time (rewrite is faster)
- Team member needs to understand the code (vibe code is unreadable)

**Rewrite signals:**
```
Prototype is ready to throw away when:
✅ Problem is validated (people pay)
✅ Core UX flow is understood (user testing done)
✅ Data model is stable (won't change much)
✅ Performance issues can't be fixed by tweaking prompt

Rewrite with:
- Spec-driven development skill (write spec first)
- TDD (now reliability matters)
- Proper architecture (not Bolt-generated spaghetti)
```

### 5. Vibe Coding Productivity Patterns

Getting the most out of AI-assisted development as a solo builder:

**Daily workflow:**
```
Morning (2 hours):
  - Cursor: implement yesterday's validated ideas
  - Commit working state before starting new feature

Afternoon (2 hours):
  - User calls / testing with real people
  - Note what to build next based on what broke

Evening (30 min):
  - Bolt/v0: prototype tomorrow's new feature idea
  - Don't build it for real yet — just see if it's feasible
```

**Avoiding vibe coding traps:**
- Commit every working state (vibe code breaks suddenly)
- Test with real data early (AI-generated test data hides real bugs)
- Screenshot UI before it changes (vibe tools regenerate differently each time)
- Keep AI context fresh (paste error messages, not just "fix this")

## Key Concepts

- **Vibe coding** — natural language-driven development using AI tools; fast but fragile
- **Bolt.new** — generates full-stack apps (Next.js + Supabase) from description
- **v0.dev** — generates UI components from description; exports to React
- **Cursor** — AI code editor with codebase context; best for iterating existing code
- **Prototype debt** — technical debt specifically from vibe-generated code; inevitable and intentional
- **Rewrite trigger** — the moment vibe prototype should be rebuilt properly (first paying user)

## Checklist

- [ ] Vibe coding used only for unvalidated ideas (not production features)?
- [ ] Prototype committed to git before each iteration (can rollback)?
- [ ] Tested with real user data, not just AI-generated examples?
- [ ] Clear trigger defined for when to rewrite (first paying user = default)?
- [ ] Deployment pipeline set up (Vercel auto-deploy from GitHub)?
- [ ] Not spending >1 week on a single vibe prototype without user feedback?

## Key Outputs

- Working prototype URL (shareable with target users for feedback)
- Vibe-to-spec handoff notes: what the prototype proved, data model decisions
- Rewrite decision: build properly or kill the idea

## Output Format

- 🔴 **Critical** — vibing production code with paying users, no git commits during vibe sessions, extending prototype past its useful life
- 🟡 **Warning** — spending >1 week on unvalidated prototype, testing with fake data only, no deployment pipeline
- 🟢 **Suggestion** — use v0 for UI exploration before committing to layout, Bolt for new feature ideas, Cursor for iterating existing code

## Anti-Patterns

- Vibing production features (reliability matters when users pay)
- Not committing prototypes to git (can't rollback when AI breaks something)
- Showing vibe prototypes to investors as production-ready (be honest about tech debt)
- Extending vibe prototype indefinitely (at some point, rewrite is faster)
- Using Bolt for complex logic (good for UI + basic CRUD, not complex business logic)

## Integration

- Use with `mvp-rapid-development` for transitioning prototype to real product
- Use with `spec-driven-development` when rewriting vibe prototype properly
- Use with `ai-product-validation` — vibe a landing page in 2 hours to test demand
- Agent: `@solo-ai-builder` decides vibe vs spec based on validation stage
