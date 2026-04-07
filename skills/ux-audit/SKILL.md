---
name: ux-audit
description: Use when conducting a heuristic evaluation of an existing interface, identifying usability problems, or prioritizing UX improvements
---

# UX Audit

## When to Use
When assessing an existing product's user experience before a redesign, after user complaints, or as a quarterly practice.

## Core Jobs

### 1. Heuristic Evaluation (Nielsen's 10)
Evaluate each screen against:
1. Visibility of system status — does the user know what's happening?
2. Match between system and real world — familiar language, not jargon?
3. User control and freedom — easy undo/exit?
4. Consistency and standards — same patterns throughout?
5. Error prevention — does the design prevent mistakes?
6. Recognition over recall — visible options, not memorized commands?
7. Flexibility and efficiency — shortcuts for power users?
8. Aesthetic and minimal design — no irrelevant information?
9. Help users recognize/diagnose/recover from errors — clear error messages?
10. Help and documentation — findable when needed?

Score each: 0 (no problem) to 4 (usability catastrophe)

### 2. User Flow Analysis
Walk through top 3 user flows:
- Map each step from entry to goal completion
- Note where users might get confused or drop off
- Measure click depth: how many clicks to complete key tasks?

### 3. Prioritize Findings
Severity × Frequency:
- Critical (score 3–4 + common flow) → fix before next release
- Major (score 2–3 + occasional flow) → next sprint
- Minor (score 1–2) → backlog

### 4. Write the Report
Per finding:
- Screenshot + annotation
- Heuristic violated
- Severity rating (1–4)
- Recommended fix

## Key Outputs
- Heuristic evaluation scorecard
- User flow breakdown
- Prioritized findings report with screenshots
- Top 5 quick wins

## Anti-Patterns
- Auditing without real users (adds subjective bias)
- Treating all findings as equal priority
- UX audit without connecting to business metrics
- One-time audit with no follow-up measurement
