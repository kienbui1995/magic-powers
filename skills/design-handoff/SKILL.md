---
name: design-handoff
description: Use when preparing designs for developer implementation, writing specs, or managing the design-to-code workflow
---

# Design Handoff

## When to Use
When designs are ready for implementation and need to be communicated clearly to developers.

## Core Jobs

### 1. Prepare the Design File
Before handing off:
- [ ] All components use design system tokens (no magic numbers)
- [ ] All states covered: default, hover, active, disabled, error, empty, loading
- [ ] Responsive breakpoints annotated (mobile, tablet, desktop)
- [ ] Edge cases shown (long text, empty states, error states)
- [ ] Assets exported and named (SVGs, icons, images)

### 2. Write the Spec
Per component or screen:
- **Spacing**: exact px/rem values for padding, margin, gaps
- **Typography**: font size, weight, line height, letter spacing
- **Colors**: token names (not hex) — "primary-500", not "#3B82F6"
- **Interactions**: hover states, animation timing, transition easing
- **Behavior**: what happens on click/tap, keyboard interaction

### 3. Communicate Edge Cases
Write a short note per complex component:
- What is the max content length? What happens at overflow?
- What if the list is empty?
- What if the image fails to load?

### 4. Stay Available During Implementation
- Answer questions same day (blocking developers = wasted time)
- Review implementation against designs before PR merge
- Document any dev-agreed deviations from spec

## Key Outputs
- Annotated design file (Figma/Sketch link)
- Component spec document
- Edge case documentation
- Exported assets

## Anti-Patterns
- Handing off without covering all states
- Specs that say "matches design" instead of actual values
- No responsive designs for a responsive product
- Disappearing during implementation
