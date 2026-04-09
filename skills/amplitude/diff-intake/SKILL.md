---
name: diff-intake
description: Transform code diffs (PRs, branches, files) into structured YAML briefs for analytics instrumentation planning. Minimal MCP usage — primarily code analysis.
---

# Diff Intake

## When to Use

- Starting an instrumentation workflow from a pull request URL or branch name
- Auditing what analytics-relevant changes exist in a feature branch before it ships
- Converting a vague feature description into a concrete list of trackable interactions
- Feeding downstream skills (discover-event-surfaces, instrument-events) with structured input
- Reviewing merged PRs retroactively to find missed instrumentation

## Core Jobs

### 1. Classify Input Type

Determine what the user has provided and select the right ingestion path:

- **PR URL** (`github.com/.../pull/123`) → fetch the diff via GitHub API or `gh pr diff`
- **Branch name** (`feat/checkout-v2`) → run `git diff main...feat/checkout-v2` to get full changeset
- **File or directory path** → read the files directly and look for new/changed code
- **Feature description** (free text) → search the codebase for relevant files using keywords

Output of classification: input_type + source_reference + list of files changed.

### 2. Parse Changes

For each changed file, extract:

- What was **added** (new functions, components, API routes, state variables)
- What was **removed** (deleted screens, deprecated flows, removed UI elements)
- What was **modified** (changed behavior in existing flows — renamed fields, reordered steps)
- **New UI surfaces**: screens, modals, drawers, tooltips, banners
- **User interactions**: buttons, forms, links, gestures, keyboard shortcuts
- **Data flows**: new API calls, changed request/response shapes, new data dependencies

Focus on user-facing changes only. Skip internal refactors with no UX impact.

### 3. Extract Analytics-Relevant Changes

Filter parsed changes down to what matters for analytics:

- New screens → candidate `page_viewed` events
- New buttons/CTAs → candidate `button_clicked` or action-specific events
- New forms → candidate `form_started`, `form_submitted`, `form_abandoned` events
- New API endpoints exposed to users → candidate conversion or action events
- State changes with business significance → candidate status-change events
- Removed features → events that may need deprecation
- Changed flows → events that may need property updates

### 4. Produce Structured YAML Brief

Output a YAML document consumed by discover-event-surfaces:

```yaml
brief:
  summary: "One sentence describing the feature change"
  pr_reference: "<URL or branch>"
  files_changed: 12
  new_surfaces:
    - type: screen
      name: "Checkout Confirmation Page"
      file: "src/pages/checkout/confirmation.tsx"
      interactions:
        - "Continue Shopping button"
        - "View Order Details link"
    - type: form
      name: "Shipping Address Form"
      file: "src/components/ShippingForm.tsx"
      fields: ["street", "city", "zip", "country"]
  removed_surfaces:
    - type: screen
      name: "Legacy Cart Page"
      note: "Replaced by new unified checkout"
  changed_behaviors:
    - description: "Payment step now skipped for free orders"
      files: ["src/flows/checkout.ts"]
      impact: "high — affects conversion funnel"
  technical_context:
    stack: "React + TypeScript"
    analytics_sdk: "Amplitude Browser SDK v2"
    existing_tracking_file: "src/analytics/events.ts"
```

## MCP Tools

This skill uses minimal MCP — primarily local code analysis tools:

- No `mcp__Amplitude__*` tools required at this stage
- The output YAML is the input to `discover-event-surfaces` which uses Amplitude tools
- If the input is a GitHub PR URL, use web fetch or GitHub CLI to retrieve the diff

## Key Concepts

- **Analytics brief**: The YAML document produced by this skill — the contract between diff analysis and event discovery
- **New surface**: Any new user-facing UI element that a user can interact with or see
- **Changed behavior**: An existing flow that works differently — may require property updates on existing events
- **Technical context**: Stack, SDK, and conventions that downstream skills need to write correct tracking code
- **Funnel-critical change**: A change that adds or removes a step in acquisition, activation, or conversion — highest priority for tracking

## Output Format

A structured YAML brief with these top-level sections:

```
brief:
  summary: <string>
  pr_reference: <URL or branch name>
  files_changed: <count>
  new_surfaces: <list of {type, name, file, interactions}>
  removed_surfaces: <list of {type, name, note}>
  changed_behaviors: <list of {description, files, impact}>
  technical_context: {stack, analytics_sdk, existing_tracking_file}
```

After producing the YAML, state: "Brief ready. Proceed to `discover-event-surfaces` to map these surfaces to candidate analytics events."
