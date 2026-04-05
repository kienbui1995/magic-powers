---
name: accessibility-compliance
description: Use when implementing or reviewing accessibility - WCAG compliance, screen reader support, keyboard navigation, a11y testing
---

# Accessibility Compliance

## Overview

Accessibility isn't optional — it's a legal requirement in many jurisdictions and affects ~15% of users. Build it in from the start, not as an afterthought.

## When to Use

- Building new UI components
- Reviewing existing interfaces for a11y
- Fixing accessibility audit findings
- Setting up automated a11y testing

## WCAG 2.1 Quick Reference (Level AA)

### Perceivable
- **Color contrast** — 4.5:1 for normal text, 3:1 for large text
- **Alt text** — all images have descriptive alt (or `alt=""` for decorative)
- **Captions** — video has captions, audio has transcripts
- **Don't rely on color alone** — use icons, patterns, or text too

### Operable
- **Keyboard navigable** — all interactive elements reachable via Tab
- **Focus visible** — clear focus indicator (never `outline: none` without replacement)
- **Skip links** — "Skip to main content" link at top
- **No keyboard traps** — user can always Tab away from any element

### Understandable
- **Labels** — every form input has a visible `<label>`
- **Error messages** — clear, specific, associated with the field
- **Consistent navigation** — same layout across pages
- **Language** — `<html lang="en">` set correctly

### Robust
- **Semantic HTML** — use `<button>`, `<nav>`, `<main>`, not `<div onclick>`
- **ARIA when needed** — `aria-label`, `aria-expanded`, `role` for custom widgets
- **Valid HTML** — passes W3C validator

## Testing Checklist

```bash
# Automated
npx axe-core     # or browser extension
npx pa11y http://localhost:3000

# Manual
- Tab through entire page — can you reach everything?
- Screen reader test (VoiceOver/NVDA) — does it make sense?
- Zoom to 200% — does layout break?
- Disable CSS — is content still readable?
```

## Common Fixes

| Issue | Fix |
|-------|-----|
| Missing alt text | Add descriptive `alt` attribute |
| Low contrast | Increase to 4.5:1 ratio minimum |
| No focus styles | Add `:focus-visible` styles |
| Click-only interactions | Add keyboard handlers (`onKeyDown`) |
| `<div>` as button | Replace with `<button>` |
| Missing form labels | Add `<label htmlFor="...">` |

## Integration

- **magic-powers:ci-cd-pipeline** — add axe-core to CI pipeline
- **magic-powers:requesting-code-review** — include a11y in review checklist
