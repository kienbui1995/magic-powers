---
name: discover-event-surfaces
description: Step 2 of instrumentation workflow — identify candidate analytics events from code change briefs. Uses mcp__Amplitude__get_event_properties, mcp__Amplitude__get_context.
---

# Discover Event Surfaces

## When to Use

- After running `diff-intake` and receiving a structured YAML brief
- When auditing a new feature for analytics coverage before it ships
- When a PM asks "are we tracking everything important in this release?"
- When mapping user flows to their corresponding analytics events
- When defining what events need to be added vs. updated vs. deprecated

## Core Jobs

### 1. Receive Brief from Diff-Intake

Accept the YAML brief from `diff-intake`. If no brief exists, ask for one or invoke diff-intake first.

Verify brief has: `new_surfaces`, `changed_behaviors`, `technical_context`.

### 2. Check Existing Events (No Duplicates)

Before creating new events, check what already exists in Amplitude:

- Use `mcp__Amplitude__get_event_properties` to pull existing event schemas
- Use `mcp__Amplitude__get_context` to understand the project context
- Search for events that may already cover the same action (e.g., `checkout_completed` may already exist)
- Flag existing events that need property additions rather than new event creation

Rule: **always prefer updating an existing event over creating a new one** if the semantic intent is the same.

### 3. Map Each New Surface to Event Candidates

For each item in `new_surfaces`, derive one or more candidate events:

| Surface Type | Primary Event | Secondary Events |
|-------------|--------------|-----------------|
| New screen | `<screen_name>_viewed` | — |
| Button / CTA | `<action>_clicked` | — |
| Form | `<form_name>_started`, `<form_name>_submitted` | `<form_name>_abandoned` |
| Modal / drawer | `<modal_name>_opened`, `<modal_name>_closed` | — |
| API-triggered action | `<resource>_<past_tense_verb>` | — |
| Feature toggle | `<feature>_enabled`, `<feature>_disabled` | — |

### 4. Apply Naming Convention (Verb-Noun Pattern)

All event names must follow: `verb_noun` in `snake_case`.

Valid examples:
- `page_viewed` ✓
- `checkout_completed` ✓
- `filter_applied` ✓
- `userClickedCheckout` ✗ (camelCase)
- `CheckoutCompleted` ✗ (PascalCase)
- `checkout-click` ✗ (kebab-case)

Check `technical_context.existing_tracking_file` for the project's actual convention — match it if it differs.

### 5. Identify Required Properties for Each Event

For each candidate event, list the properties needed to answer future analytics questions:

**Universal properties** (should be on every event):
- `user_id`, `session_id`, `platform`, `app_version`, `timestamp`

**Contextual properties** (what makes this event useful for analysis):
- Screen context: `page_name`, `page_section`, `referrer_page`
- Item context: `item_id`, `item_type`, `item_name`, `price`
- Action context: `button_label`, `form_fields_completed`, `error_message`
- Experiment context: `experiment_id`, `variant` (if A/B test)

Ask: *What question would a PM ask about this event in 6 months?* Make sure the properties answer it.

### 6. Flag Funnel-Critical Events

Identify events in the critical business funnel and mark them HIGH priority:

- **Acquisition funnel**: `signup_started` → `signup_completed` → `onboarding_completed`
- **Activation funnel**: first meaningful action per your product's activation metric
- **Conversion funnel**: every step in purchase or upgrade flow
- **Retention signals**: session started, core feature used, notification engaged

Rule: **every conversion step needs tracking; every intermediate step enables drop-off analysis**.

Flag any missing step in a funnel as CRITICAL — you can't compute conversion without it.

### 7. Prioritize by Business Value

Assign priority to each candidate event:

- `critical`: funnel step, revenue event, or legal/compliance requirement
- `high`: key feature engagement, activation signal, retention indicator
- `medium`: secondary engagement, UX feedback signal
- `low`: diagnostic, debug, or informational event

### 8. Check Existing Amplitude Schema for Naming Consistency

Query existing events via `mcp__Amplitude__get_event_properties` to verify:

- No naming conflicts (same action, different name)
- No semantic duplicates (two events that mean the same thing)
- Property names match existing conventions (e.g., `user_id` vs `userId`)

### 9. Output Event Candidate List

Produce a YAML list of candidate events:

```yaml
candidates:
  - name: checkout_confirmation_viewed
    trigger: "User lands on /checkout/confirmation page"
    priority: critical
    properties:
      - order_id: string
      - order_total: number
      - payment_method: string
      - items_count: number
    status: new  # or: update_existing, deprecate
    existing_event_ref: null  # or: "checkout_complete" if updating

  - name: shipping_address_submitted
    trigger: "User clicks 'Save Address' on ShippingForm"
    priority: high
    properties:
      - address_country: string
      - is_default_address: boolean
    status: new
    existing_event_ref: null
```

## MCP Tools

- `mcp__Amplitude__get_event_properties` — pull existing event schemas to avoid duplicates and match conventions
- `mcp__Amplitude__get_context` — get project context (project ID, organization, active events)

## Key Concepts

- **Event candidate**: A proposed analytics event not yet implemented — may become a new event or an update to existing
- **Verb-noun pattern**: The standard naming convention for analytics events (`action_object` in snake_case)
- **Funnel-critical**: An event that, if missing, breaks conversion rate calculation for a key business funnel
- **Semantic duplicate**: Two events that track the same user action under different names — a taxonomy problem
- **Universal property**: A property that should appear on every event to enable cross-event analysis

## Output Format

A YAML document with `candidates` array, each entry containing:

```
name: <snake_case event name>
trigger: <human description of when this fires>
priority: <critical|high|medium|low>
properties: <list of {name: type} pairs>
status: <new|update_existing|deprecate>
existing_event_ref: <existing event name if updating, null if new>
```

After output, state: "Found N candidate events. Proceed to `instrument-events` to generate implementation specs, or to `taxonomy` to validate naming against existing schema."
