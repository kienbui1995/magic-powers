---
name: add-analytics-instrumentation
description: End-to-end instrumentation workflow orchestrating diff-intake → discover-event-surfaces → instrument-events. Uses mcp__Amplitude__get_event_properties, mcp__Amplitude__get_project_context.
---

# Add Analytics Instrumentation

## When to Use

- This is the **primary entry point** for all instrumentation work — users invoke this skill, not the sub-skills directly
- A PM or engineer says "add analytics to this feature" or "track this PR"
- Before a feature ships: "make sure we're tracking everything in this release"
- After a feature ships: "what did we miss tracking in last week's release?"
- When an analytics audit reveals coverage gaps in a specific user flow

## Core Jobs

### Step 0: Capture Intent and Classify Input

Ask (or infer from context) what the user has provided:

| Input Type | How to Detect | Ingestion Path |
|-----------|--------------|----------------|
| PR URL | `github.com/.../pull/NNN` | Fetch diff via GitHub API |
| Branch name | `feat/`, `fix/`, etc. | Run `git diff main...branch` |
| File or directory | `/src/...` path | Read files directly |
| Feature description | Free text | Search codebase for relevant files |

Confirm: "I'll instrument the [checkout flow / PR #234 / feat/new-onboarding] — is that right?"

### Step 1: Gather Code (Invoke Diff-Intake)

For **PR or branch input**:
- Fetch the diff or run git commands to get changed files
- Invoke the `diff-intake` skill logic to produce the structured YAML brief
- Output: YAML brief with `new_surfaces`, `removed_surfaces`, `changed_behaviors`

For **file/directory input**:
- Read the files directly
- Identify analytics-relevant code (UI components, handlers, API calls)
- Produce an equivalent YAML brief inline

For **feature description input**:
- Search git history for recent commits matching the feature
- Find the relevant files in the codebase
- Produce the YAML brief from code inspection

**Validation**: Confirm the brief captures what the user expected. Show a 3-bullet summary:
- "N new UI surfaces found (screens, forms, buttons)"
- "N behaviors changed in existing flows"
- "Estimated N new events needed"

### Step 2: Discover Event Surfaces (Invoke Discover-Event-Surfaces)

Pass the YAML brief to the `discover-event-surfaces` skill logic:

- Check Amplitude for existing events (no duplicates)
- Map each new surface to candidate events
- Apply naming convention (verb_noun snake_case)
- Identify required properties per event
- Flag funnel-critical events
- Prioritize by business value (critical / high / medium / low)

Show results grouped by priority:
```
CRITICAL (funnel steps — must track):
  - checkout_confirmation_viewed
  - order_placed

HIGH (key engagement — should track):
  - shipping_address_submitted
  - promo_code_applied

MEDIUM (informational — nice to have):
  - order_details_expanded
```

Ask: "Does this list look complete? Are there events you'd add or remove before I write the specs?"

### Step 3: Generate Tracking Plan (Invoke Instrument-Events)

For each approved event candidate, invoke `instrument-events` logic to produce the full spec:

For each event, present:
- **What**: Event name and trigger condition
- **Why**: Business question this event answers
- **Where**: Exact file and code location
- **Properties**: Full type-annotated property table
- **Code**: Ready-to-paste tracking call in the project's SDK style
- **Test**: Test case definition

Format as sequential steps an engineer can follow:

```
## Event 1: checkout_confirmation_viewed

WHY: Measures how many users successfully reach order confirmation
     (critical for purchase funnel conversion rate).

WHERE: src/pages/checkout/ConfirmationPage.tsx — in useEffect after order loads

WHAT TO ADD:
  useEffect(() => {
    if (!order?.id) return;
    track(Events.CHECKOUT_CONFIRMATION_VIEWED, {
      order_id: order.id,
      order_total: order.totalAmount,
      payment_method: order.paymentMethod,
      items_count: order.items.length,
    });
  }, [order]);

PROPERTIES:
  order_id (string, required): "ord_abc123"
  order_total (number, required, USD): 49.99
  payment_method (string, required): credit_card | paypal | apple_pay
  items_count (number, required): 3
```

### Final Confirmation

After presenting all event specs:

1. Ask: "Should I implement these tracking calls directly in the codebase, or is this a spec for your team?"
2. If implementing: write the tracking calls file by file
3. If spec only: offer to export as markdown table or YAML tracking plan

Also offer: "Would you like me to add these events to your Amplitude tracking plan taxonomy?"

## MCP Tools

- `mcp__Amplitude__get_event_properties` — check existing events before proposing new ones; match property naming to existing schema
- `mcp__Amplitude__get_project_context` — confirm the Amplitude project and get project ID for any schema lookups

## Key Concepts

- **Orchestration skill**: This skill calls the logic of three sub-skills in sequence — users never need to invoke the sub-skills manually
- **Tracking plan**: The full output of this workflow — a document specifying every event, its trigger, and its properties
- **Funnel completeness**: A tracking plan is only valuable if it covers every step in the user's critical path — gaps break conversion analysis
- **Event-by-event review**: Presenting results event-by-event (not all at once) helps users catch mistakes before implementation
- **Priority triage**: Not all events are equal — critical funnel events ship first; lower-priority events can be a follow-up

## Output Format

Three-phase output:

**Phase 1 — Brief Summary** (after diff-intake):
```
Found N changes across X files.
New surfaces: <list>
Changed behaviors: <list>
Estimated events needed: N
```

**Phase 2 — Event Candidate Review** (after discover-event-surfaces):
```
Grouped by priority (CRITICAL / HIGH / MEDIUM / LOW)
Await user confirmation before proceeding
```

**Phase 3 — Implementation Specs** (after instrument-events):
```
One section per event with: WHY / WHERE / WHAT TO ADD / PROPERTIES
Followed by: offer to implement or export
```
