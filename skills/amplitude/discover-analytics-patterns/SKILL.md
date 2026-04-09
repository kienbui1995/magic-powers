---
name: discover-analytics-patterns
description: Map existing analytics SDK implementations in a codebase to understand naming conventions and instrumentation patterns. Uses mcp__Amplitude__get_event_properties.
---

# Discover Analytics Patterns

## When to Use

- Before adding new analytics instrumentation to an unfamiliar codebase
- When onboarding to a project that has existing analytics — understand what's there before adding more
- When `instrument-events` needs to know the project's SDK style and naming convention
- When auditing whether analytics calls are consistent across the codebase
- When migrating from one analytics SDK to another (need to catalog current state)
- When a new engineer asks "how do we send analytics events here?"

## Core Jobs

### 1. Search for Analytics SDK Imports and Initialization

Scan the codebase for analytics SDK usage:

**Common SDKs to look for:**
- Amplitude: `@amplitude/analytics-browser`, `amplitude-js`, `@amplitude/node`
- Mixpanel: `mixpanel-browser`, `mixpanel`
- Segment: `@segment/analytics-next`, `analytics.js`
- PostHog: `posthog-js`
- Custom wrappers: look for files named `analytics.ts`, `tracking.ts`, `events.ts`, `telemetry.ts`

**Search patterns:**
```
import.*amplitude
import.*mixpanel
import.*segment
import.*analytics
require.*analytics
```

Find the initialization file: where is `init()` or `load()` called? What API key pattern is used? What default properties are set at init time?

### 2. Find All Track / LogEvent / Identify Calls

Search for every place analytics events are sent:

**Amplitude patterns:**
```typescript
amplitude.track('event_name', { prop: value })
amplitude.logEvent('event_name', { prop: value })
client.track({ event_type: 'event_name', event_properties: {} })
```

**Generic patterns:**
```typescript
analytics.track('event_name', properties)
trackEvent('event_name', properties)
logEvent('event_name', properties)
sendEvent('event_name', properties)
```

Collect: file path, line number, event name, properties passed. Build a full inventory.

### 3. Extract Event Names and Property Patterns

From the collected tracking calls, catalog:

**Event names:**
- List all unique event names found
- Identify the naming convention: `camelCase`, `snake_case`, `Title Case`, `kebab-case`, or mixed
- Flag inconsistencies: events that don't follow the dominant pattern

**Property patterns:**
- What properties appear most frequently? (These are likely "super properties" or universal context)
- What properties are event-specific?
- Are properties passed as inline objects or imported from a separate constants file?
- Are there TypeScript interfaces or types defined for event properties?

### 4. Identify Naming Convention

Determine the single authoritative naming convention:

```
Dominant pattern: snake_case (found in 47/52 events)
Exceptions: 5 events use camelCase (legacy, pre-2024)
Recommendation: use snake_case for all new events
```

Document any caveats: some properties use camelCase even when event names use snake_case (common in mixed teams).

### 5. Map Universal vs. Event-Specific Properties

**Universal properties** (appear in >80% of events) — likely set via super properties or middleware:

```typescript
// These are probably set once at init or login:
{
  user_id: string,
  platform: 'web' | 'ios' | 'android',
  app_version: string,
  environment: 'production' | 'staging'
}
```

**Event-specific properties** — only relevant for particular events. Catalog by category:

- Page events: `page_name`, `referrer_url`, `page_section`
- Action events: `button_label`, `element_id`, `interaction_type`
- Commerce events: `item_id`, `price`, `currency`, `quantity`

### 6. Identify Helper Functions or Wrappers

Most codebases wrap the raw SDK. Find:

- Analytics service class or singleton
- Event constants file (exported event name strings)
- Property builder utilities
- Type-safe wrappers with TypeScript interfaces

Document the wrapper API so new instrumentation uses the same pattern, not the raw SDK.

Example finding:
```typescript
// src/analytics/index.ts — use this, not amplitude directly
import { track } from '@/analytics';
track('checkout_completed', { order_id, total });
```

### 7. Document the Pattern for Use in instrument-events

Produce an instrumentation guide:

```yaml
instrumentation_guide:
  sdk: "Amplitude Browser SDK v2"
  entry_point: "src/analytics/index.ts"
  naming_convention: snake_case
  event_constants_file: "src/analytics/events.ts"
  
  universal_properties:
    set_at_init: [user_id, platform, app_version]
    set_at_login: [user_plan, user_role, account_id]
  
  example_call: |
    import { track } from '@/analytics';
    import { Events } from '@/analytics/events';
    
    track(Events.CHECKOUT_COMPLETED, {
      order_id: order.id,
      total: order.totalAmount,
      payment_method: order.paymentMethod,
    });
  
  type_definitions_file: "src/analytics/types.ts"
  
  naming_inconsistencies:
    - "legacy_click_event uses camelCase — do not follow this pattern"
```

## MCP Tools

- `mcp__Amplitude__get_event_properties` — cross-reference discovered event names with Amplitude's recorded schema to verify events are actually reaching Amplitude and what properties Amplitude has recorded

## Key Concepts

- **SDK entry point**: The file where analytics is initialized — often wraps the raw SDK with project-specific config
- **Super properties**: Properties set once (at init or login) that are automatically included in every event
- **Event constants**: A file or object exporting all event name strings — prevents typos and enables type-safety
- **Naming convention**: The canonical pattern for event names in this codebase — new instrumentation must match it
- **Wrapper pattern**: A custom function/class around the raw SDK — almost always exists in mature codebases; always prefer it over raw SDK calls

## Output Format

A YAML instrumentation guide with:

```
instrumentation_guide:
  sdk: <SDK name and version>
  entry_point: <file path to analytics module>
  naming_convention: <snake_case|camelCase|Title Case>
  event_constants_file: <file path or null>
  universal_properties: {set_at_init: [...], set_at_login: [...]}
  example_call: <code snippet showing correct usage>
  type_definitions_file: <file path or null>
  naming_inconsistencies: <list of exceptions to document>
  total_events_found: <count>
```

After output, state: "Pattern documented. This guide is the style reference for `instrument-events`."
