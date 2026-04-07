---
name: accessibility-audit
description: Use when auditing WCAG compliance, testing with assistive technologies, or fixing accessibility issues
---

# Accessibility Audit

## When to Use
When ensuring a web product is usable by people with disabilities — required for legal compliance and good UX for all users.

## Core Jobs

### 1. WCAG 2.1 Core Principles (POUR)
- **Perceivable**: can users perceive all content? (alt text, captions, color contrast)
- **Operable**: can users operate all UI? (keyboard nav, no seizure triggers, enough time)
- **Understandable**: is the UI clear? (readable language, predictable behavior, error messages)
- **Robust**: does it work across assistive technologies? (valid HTML, ARIA)

Target AA compliance as the standard (AAA is aspirational).

### 2. Automated Testing
Run first — catches ~30% of issues:
```bash
npx axe-cli https://yoursite.com
npx pa11y https://yoursite.com
```
Or in CI: integrate axe-core with Jest/Cypress.

Automated checks: missing alt text, low color contrast, missing form labels, invalid ARIA.

### 3. Manual Testing Checklist
- [ ] **Keyboard navigation**: Tab through every interactive element. Can you reach and activate all of them?
- [ ] **Skip links**: Is there a "Skip to main content" link?
- [ ] **Focus indicators**: Is focus visible on every interactive element?
- [ ] **Screen reader test**: VoiceOver (Mac/iOS), NVDA (Windows), TalkBack (Android)
  - Does every image have meaningful alt text?
  - Are form fields labeled?
  - Are dynamic content changes announced?
- [ ] **Color contrast**: 4.5:1 for normal text, 3:1 for large text
- [ ] **Zoom to 200%**: Does content reflow without horizontal scrolling?
- [ ] **Motion**: Does it respect `prefers-reduced-motion`?

### 4. Report and Prioritize
Per issue:
- WCAG criterion violated (e.g., 1.1.1 Non-text Content)
- Impact: Critical (blocks users) / Serious / Moderate / Minor
- Screenshot + code location
- Fix recommendation

## Key Outputs
- Automated test results
- Manual audit report
- Prioritized fix list (by impact)
- Regression test to prevent recurrence

## Anti-Patterns
- Relying only on automated testing (misses 70% of issues)
- Treating accessibility as a one-time audit
- "We'll add ARIA attributes" instead of fixing semantic HTML
- Not testing with actual screen reader users
