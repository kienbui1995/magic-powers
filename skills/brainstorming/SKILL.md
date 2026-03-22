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
2. **Ask clarifying questions** — one at a time, understand purpose/constraints/success criteria
3. **Propose 2-3 approaches** — with trade-offs and your recommendation
4. **Present design** — in sections scaled to complexity, get user approval after each section
5. **Write design doc** — save to `docs/specs/YYYY-MM-DD-<topic>-design.md` and commit
6. **Spec review loop** — dispatch reviewer subagent to check spec; fix issues and re-dispatch until approved (max 3 iterations, then surface to human)
7. **User reviews written spec** — ask user to review before proceeding
8. **Transition** — invoke magic-powers:writing-plans skill

## Model Routing

This skill is best run by the **architect agent** (Opus) for complex projects. For simple features, default Sonnet is fine. The spec review in step 6 should use the **reviewer agent** (Haiku) — fast and cheap.

## The Process

**Understanding the idea:**
- Check current project state first (files, docs, recent commits)
- Assess scope: if multiple independent subsystems, flag immediately and decompose into sub-projects
- Ask questions one at a time, prefer multiple choice when possible
- Focus on: purpose, constraints, success criteria

**Exploring approaches:**
- Propose 2-3 approaches with trade-offs
- Lead with your recommendation and reasoning

**Presenting the design:**
- Present design in sections scaled to complexity
- Ask after each section whether it looks right
- Cover: architecture, components, data flow, error handling, testing
- Design for isolation: smaller units with clear boundaries and well-defined interfaces

**Working in existing codebases:**
- Explore current structure before proposing changes. Follow existing patterns.
- Include targeted improvements where existing code has problems affecting the work
- Don't propose unrelated refactoring

## After the Design

**Documentation:**
- Write spec to `docs/specs/YYYY-MM-DD-<topic>-design.md`
- User preferences for spec location override this default
- Commit the design document

**Spec Review Loop:**
1. Dispatch reviewer subagent with spec path and review context
2. If issues found: fix, re-dispatch, repeat until approved
3. Max 3 iterations, then surface to human

**User Review Gate:**
> "Spec written and committed to `<path>`. Please review before we proceed to implementation planning."

Wait for user approval. Then invoke magic-powers:writing-plans.

## Key Principles

- **One question at a time** — don't overwhelm
- **Multiple choice preferred** — easier to answer
- **YAGNI ruthlessly** — remove unnecessary features
- **Explore alternatives** — always 2-3 approaches
- **Incremental validation** — present, get approval, move on
