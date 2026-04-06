---
name: brainstorming
description: "You MUST use this before any creative work - creating features, building components, adding functionality, or modifying behavior. Explores user intent, requirements and design before implementation."
---

# Brainstorming Ideas Into Designs

Turn ideas into fully formed designs through collaborative dialogue. Understand context, ask questions one at a time, present design, get approval.

<HARD-GATE>
Do NOT invoke any implementation skill, write any code, scaffold any project, or take any implementation action until you have presented a design and the user has approved it. This applies to EVERY project regardless of perceived simplicity.
</HARD-GATE>

## Anti-Pattern: "This Is Too Simple To Need A Design"

Every project goes through this process. "Simple" projects are where unexamined assumptions cause the most wasted work. The design can be short for truly simple projects, but you MUST present it and get approval.

## Checklist

Create a task for each item and complete in order:

1. **Explore project context** — check files, docs, recent commits
2. **Offer visual companion** (if topic involves visual questions) — this is its own message, not combined with a clarifying question. See Visual Companion section below.
3. **Assess scope** — if multiple independent subsystems, flag immediately and decompose into sub-projects before going deeper
4. **Ask clarifying questions** — one at a time, understand purpose/constraints/success criteria
5. **Propose 2-3 approaches** — with trade-offs and your recommendation
6. **Present design** — in sections scaled to complexity, get user approval after each section
7. **Write design doc** — save to `docs/specs/YYYY-MM-DD-<topic>-design.md` and commit
8. **Spec self-review** — quick inline check for placeholders, contradictions, ambiguity, scope (see below)
9. **User reviews written spec** — ask user to review before proceeding
10. **Transition** — invoke magic-powers:writing-plans skill

**The terminal state is invoking writing-plans.** Do NOT invoke any other implementation skill.

## The Process

**Understanding the idea:**
- Check current project state first (files, docs, recent commits)
- Before asking detailed questions, assess scope: if the request describes multiple independent subsystems (e.g., "build a platform with chat, file storage, billing, and analytics"), flag this immediately. Don't spend questions refining details of a project that needs to be decomposed first.
- If the project is too large for a single spec, help the user decompose into sub-projects: what are the independent pieces, how do they relate, what order should they be built? Then brainstorm the first sub-project through the normal design flow.
- Ask questions one at a time, prefer multiple choice when possible
- Only one question per message
- Focus on: purpose, constraints, success criteria

**Exploring approaches:**
- Propose 2-3 different approaches with trade-offs
- Lead with your recommended option and explain why

**Presenting the design:**
- Present design in sections scaled to their complexity
- Ask after each section whether it looks right
- Cover: architecture, components, data flow, error handling, testing

**Design for isolation and clarity:**
- Break the system into smaller units with one clear purpose, well-defined interfaces, testable independently
- For each unit: what does it do, how do you use it, what does it depend on?
- Smaller, well-bounded units are easier to reason about and edit reliably

**Working in existing codebases:**
- Explore current structure before proposing changes. Follow existing patterns.
- Include targeted improvements where existing code has problems affecting the work
- Don't propose unrelated refactoring

## After the Design

**Documentation:**
- Write spec to `docs/specs/YYYY-MM-DD-<topic>-design.md`
- User preferences for spec location override this default
- Commit the design document

**Spec Self-Review:**
After writing the spec, look at it with fresh eyes:

1. **Placeholder scan:** Any "TBD", "TODO", incomplete sections? Fix them.
2. **Internal consistency:** Do sections contradict each other? Does architecture match feature descriptions?
3. **Scope check:** Focused enough for a single implementation plan, or needs decomposition?
4. **Ambiguity check:** Could any requirement be interpreted two ways? Pick one and make it explicit.

Fix any issues inline. No need to re-review — just fix and move on.

**User Review Gate:**
> "Spec written and committed to `<path>`. Please review and let me know if you want changes before we start the implementation plan."

Wait for user approval. Then invoke magic-powers:writing-plans.

## Visual Companion

A browser-based companion for showing mockups, diagrams, and visual options during brainstorming.

**Offering the companion:** When you anticipate visual questions (mockups, layouts, diagrams), offer it once:
> "Some of what we're working on might be easier to show visually in a browser — mockups, diagrams, comparisons. Want to try it? (Requires opening a local URL)"

**This offer MUST be its own message.** Do not combine with other content. Wait for response. If declined, proceed text-only.

**Per-question decision:** Even after acceptance, decide FOR EACH QUESTION whether to use browser or terminal:
- **Use browser** for visual content — mockups, wireframes, layout comparisons, architecture diagrams
- **Use terminal** for text content — requirements questions, conceptual choices, tradeoff lists, scope decisions

## Model Routing

This skill is best run by the **architect agent** (Opus) for complex projects. For simple features, default Sonnet is fine.

## Key Principles

- **One question at a time** — don't overwhelm
- **Multiple choice preferred** — easier to answer
- **YAGNI ruthlessly** — remove unnecessary features
- **Explore alternatives** — always 2-3 approaches
- **Incremental validation** — present, get approval, move on
- **Scope early** — decompose large projects before diving deep
