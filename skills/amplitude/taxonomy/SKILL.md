---
name: taxonomy
description: Create, validate, audit, and govern Amplitude event taxonomy across a product. Uses mcp__Amplitude__get_event_properties, mcp__Amplitude__get_project_context, mcp__Amplitude__query_amplitude_data.
---

# Taxonomy

## When to Use

- Auditing an existing Amplitude project for naming inconsistencies, duplicates, and orphaned events
- Establishing a taxonomy standard before a major product launch
- Onboarding a new analytics engineer who needs to understand the event schema
- Quarterly analytics hygiene review
- Before migrating analytics to a new SDK or platform
- When event volume is unexpectedly high (may indicate duplicate tracking)
- When reports break after a code change (may indicate event renamed/removed)

## Core Jobs

### 1. Naming Consistency

Every product needs exactly one naming convention. Enforce it ruthlessly.

**Standard convention:** `verb_noun` in `snake_case`

```
page_viewed ✓
button_clicked ✓
form_submitted ✓

PageViewed ✗        → rename to page_viewed
buttonClick ✗       → rename to button_clicked
form-submit ✗       → rename to form_submitted
FormWasSubmitted ✗  → rename to form_submitted
```

**Common verb vocabulary** (use these, don't invent synonyms):
- Views: `viewed`, `rendered`, `displayed`
- Actions: `clicked`, `tapped`, `submitted`, `applied`, `selected`, `toggled`
- Lifecycle: `started`, `completed`, `abandoned`, `cancelled`, `failed`
- Navigation: `navigated`, `redirected`, `scrolled`

**Rule**: If two events describe the same action, they must use the same verb. `button_clicked` and `cta_pressed` are synonyms — eliminate one.

### 2. Property Standardization

Define a set of shared properties that appear on every event. Call these "global context properties."

**Required global properties:**

| Property | Type | Source | Notes |
|----------|------|--------|-------|
| `user_id` | string | auth system | null for anonymous users |
| `session_id` | string | SDK | auto-populated by Amplitude |
| `platform` | string | app config | `web`, `ios`, `android` |
| `app_version` | string | build system | `1.4.2` |
| `environment` | string | env var | `production`, `staging` |

**Prohibited property anti-patterns:**
- `userId` — use `user_id` (consistent snake_case)
- `ts` — use `timestamp` (readable)
- `v` — use `app_version` (no abbreviations)
- `flag` — too generic; name what the flag is

Use `mcp__Amplitude__get_event_properties` to audit actual property names across events.

### 3. Deduplication

Identify events that track the same user action under different names:

**Detection signals:**
- Similar event names: `checkout_complete` vs `checkout_completed` vs `purchase_completed`
- Similar volume curves: events with identical daily trends are likely duplicates
- Same trigger code in different branches or pages

**Resolution process:**
1. Identify canonical name (follows naming convention, most descriptive)
2. Map old names → canonical name in code
3. Set sunset date for old event names (keep 90 days for backfill continuity)
4. Document the migration in the taxonomy changelog

### 4. Lifecycle Management

Every event has a lifecycle: proposed → active → deprecated → removed.

**Lifecycle states:**

| State | Description | Action Required |
|-------|-------------|-----------------|
| `proposed` | Defined but not yet implemented | Implement or discard |
| `active` | Currently firing in production | Monitor volume |
| `stale` | Volume declining but still active | Review if still needed |
| `deprecated` | Replaced by new event, still firing | Set end date, update code |
| `removed` | No longer firing | Archive in taxonomy doc |

**Orphaned event detection** (events potentially abandoned):
- Volume < 100/day AND no dashboard references → likely orphaned
- Last seen > 90 days ago → likely removed from code but still in Amplitude
- Zero properties → likely a placeholder or misconfigured event

Use `mcp__Amplitude__query_amplitude_data` to check event volumes and last-seen dates.

### 5. Documentation Standards

Every active event must have:
- **Description**: one sentence explaining what user action this captures
- **Trigger**: when exactly this fires (not just "when user clicks" — be specific about which button)
- **Owner**: team or person responsible for maintaining this event
- **Properties**: full definition with types and valid values
- **Funnel membership**: which funnel(s) does this event belong to?
- **Created date** and **last modified date**

Template:
```yaml
event: checkout_confirmation_viewed
description: "Fires when a user successfully reaches the order confirmation screen after completing payment"
trigger: "Page component mounts after order API returns 200 with valid order_id"
owner: "growth-team"
funnel: ["purchase-funnel", "first-purchase-funnel"]
properties:
  order_id: {type: string, required: true, example: "ord_abc123"}
  order_total: {type: number, required: true, unit: "USD", example: 49.99}
status: active
created: "2024-01-15"
last_modified: "2024-11-03"
```

### 6. Governance Process

Define how new events get approved and who can add/change events:

**Approval tiers:**
- **Tier 1 (fast track)**: New event that follows naming convention + has owner + has all required properties → can be added without review
- **Tier 2 (review required)**: New event in a critical funnel, or an event that renames an existing event → requires analytics team sign-off
- **Tier 3 (committee required)**: Removing an active event with dashboard dependencies, or changing a property on a widely-used event → requires PM + analytics + engineering sign-off

**Taxonomy changelog**: Every change to the taxonomy is logged with date, change type, rationale, and owner.

### Taxonomy Audit Workflow

1. Pull all events from Amplitude via `mcp__Amplitude__get_event_properties`
2. Use `mcp__Amplitude__query_amplitude_data` to get volume per event for last 30 days
3. Group events by naming pattern (snake_case, camelCase, etc.)
4. Flag inconsistencies: events not following dominant convention
5. Identify low-volume events (< 100/day) as potentially orphaned
6. Identify events with identical volume curves as potential duplicates
7. Check for events with no properties (likely misconfigured)
8. Produce remediation plan with priority ordering

## MCP Tools

- `mcp__Amplitude__get_event_properties` — pull the full event and property schema for the project
- `mcp__Amplitude__get_project_context` — get project metadata and configuration
- `mcp__Amplitude__query_amplitude_data` — check event volumes, last-seen dates, and trend data to detect orphaned or duplicate events

## Key Concepts

- **Taxonomy**: The complete schema of all analytics events, their properties, and their relationships — the "data dictionary" for analytics
- **Global context property**: A property included on every event automatically — provides cross-event analysis capability
- **Orphaned event**: An event that appears in Amplitude but is no longer fired from production code — creates confusion and inflates event counts
- **Semantic duplicate**: Two events that capture the same user action under different names — the #1 taxonomy problem in growing products
- **Governance tier**: The level of approval required to make a taxonomy change — protects data integrity in high-volume systems

## Output Format

**Taxonomy audit report:**

```
## Taxonomy Health Score: <score>/100

### Issues by Severity

CRITICAL:
  - 3 funnel events missing (cannot compute purchase conversion rate)

HIGH:
  - 7 events violate naming convention (camelCase instead of snake_case)
  - 2 duplicate event pairs: checkout_complete / checkout_completed

MEDIUM:
  - 12 events have no owner assigned
  - 5 events have no trigger documentation

LOW:
  - 8 events with volume < 100/day (possible orphans)

### Remediation Plan (priority ordered)
1. Add missing funnel events (week 1) — unblocks conversion analysis
2. Rename 7 non-convention events (week 2) — coordinate with all clients
3. Merge duplicate pairs (week 3) — 90-day overlap period
4. Assign owners to undocumented events (ongoing)

### Migration Plan
<event rename mapping table with sunset dates>
```
