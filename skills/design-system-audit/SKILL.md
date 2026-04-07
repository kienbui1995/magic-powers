---
name: design-system-audit
description: Use when reviewing component consistency, design token coverage, or the health of a design system
---

# Design System Audit

## When to Use
When a codebase has grown organically and consistency has degraded, before adopting a design system, or as a quarterly consistency check.

## Core Jobs

### 1. Inventory Components
Catalog what exists:
- UI component inventory: buttons, inputs, modals, cards, tables, navigation
- For each: how many variants exist in code vs in design?
- Duplicates: multiple components solving the same problem?

### 2. Audit Design Tokens
Check token coverage:
- Colors: are hex values hardcoded or using tokens?
- Typography: ad-hoc font sizes or scale?
- Spacing: magic numbers or 8pt grid?
- Shadows, border-radius, z-index: consistent values?

### 3. Check Component Health
Per component:
- Is it documented? (Storybook or equivalent)
- Does it handle accessibility (ARIA labels, keyboard nav)?
- Does it have responsive behavior defined?
- Is it used consistently (or overridden in individual pages)?

### 4. Identify Gaps
- Missing components (teams building one-offs instead)
- Inconsistent naming (Button vs Btn vs CTAButton)
- Design ↔ code drift (design system out of sync with implementation)

### 5. Report and Roadmap
Prioritize:
- Critical: accessibility failures, major inconsistencies in core flows
- High: components with 3+ variants that should be unified
- Medium: missing documentation
- Low: minor visual inconsistencies

## Key Outputs
- Component inventory spreadsheet
- Token coverage report
- Top issues with severity
- Design system improvement roadmap

## Anti-Patterns
- Auditing design without checking implementation (they drift)
- Rebuilding everything at once — incremental improvement is better
- No adoption tracking after publishing the system
- Design system maintained by one person with no contributors
