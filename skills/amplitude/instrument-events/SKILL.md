---
name: instrument-events
description: Step 3 of instrumentation workflow — transform event candidates into concrete tracking specifications with exact code locations and property definitions. Uses mcp__Amplitude__get_event_properties, mcp__Amplitude__get_project_context.
---

# Instrument Events

## When to Use

- After `discover-event-surfaces` has produced a candidate event list
- When a team needs implementation-ready specs that engineers can act on directly
- When writing a tracking plan document for a feature launch
- When reviewing instrumentation completeness before a release
- When a new engineer is assigned to add analytics and needs exact instructions

## Core Jobs

### 1. Find Exact Code Location Where Event Should Fire

For each candidate event, navigate to the relevant file and find the precise trigger point:

**Trigger location rules:**
- `page_viewed` → fires in the page component's `useEffect` or `componentDidMount`, after the page renders
- `button_clicked` → fires in the `onClick` handler of the button component
- `form_submitted` → fires on successful form submission (after validation passes, before or after API call depending on if you want success-only)
- `modal_opened` → fires when the modal's open state becomes `true`
- API-driven events → fires in the API success callback, not on user click (captures actual completion)

**Avoid ambiguous triggers:**
- Never fire on both click AND API success — pick one
- Never fire in render functions (causes duplicate events)
- Never fire before input validation succeeds (skews form completion data)

### 2. Write Tracking Call in Project SDK Style

Use the pattern from `discover-analytics-patterns`. Match exactly:

```typescript
// Correct — using project's analytics wrapper
import { track } from '@/analytics';
import { Events } from '@/analytics/events';

// In CheckoutConfirmation.tsx useEffect:
useEffect(() => {
  track(Events.CHECKOUT_CONFIRMATION_VIEWED, {
    order_id: order.id,
    order_total: order.totalAmount,
    payment_method: order.paymentMethod,
    items_count: order.items.length,
  });
}, []);
```

If no `discover-analytics-patterns` has been run, look for the pattern in the nearest existing tracking call in the same file or module.

### 3. Define All Properties with Types and Example Values

For each property on each event, produce a complete definition:

| Property | Type | Required | Example | Description |
|----------|------|----------|---------|-------------|
| `order_id` | string | yes | `"ord_abc123"` | Unique order identifier from backend |
| `order_total` | number | yes | `49.99` | Total order value in USD |
| `payment_method` | string | yes | `"credit_card"` | One of: credit_card, paypal, apple_pay |
| `items_count` | number | yes | `3` | Number of line items in order |
| `coupon_applied` | boolean | no | `true` | Whether a discount code was used |

Rules for property definitions:
- **Strings**: always document valid enum values if the field is constrained
- **Numbers**: always document the unit (USD, seconds, pixels, count)
- **Booleans**: always explain what `true` means vs `false`
- **Arrays**: document element type and max expected length
- **IDs**: document the ID format and which system it comes from

### 4. Specify Trigger Condition (When Exactly to Fire)

Write a precise trigger statement:

```
Trigger: Fire ONCE when the checkout confirmation page renders, after the order data has loaded.
Do NOT fire: if the user arrives via direct URL without a valid order_id (guard with null check).
```

For async events, clarify timing:
- **On click**: fire immediately when user clicks (before API call completes)
- **On success**: fire in API success callback (captures completed action only)
- **On view**: fire when element enters viewport (use IntersectionObserver, not page load)

### 5. Handle Edge Cases

For each event, document the edge cases that must be handled:

**Common edge cases:**
- User is not logged in → is `user_id` available? If not, use anonymous ID
- Value is `null` or `undefined` → don't send the property, or send explicit `null`?
- Event might fire twice (StrictMode double render, back-forward cache) → add deduplication
- Concurrent sessions (multiple tabs) → does this matter for this event?
- Error state → should error events fire alongside or replace success events?

Write the guard code:
```typescript
// Guard: only fire if order data is loaded
if (!order?.id) return;

track(Events.CHECKOUT_CONFIRMATION_VIEWED, {
  order_id: order.id,
  // ...
});
```

### 6. Write Test Case Definition

For each event, define a test that verifies correct instrumentation:

```typescript
// Test: checkout_confirmation_viewed fires correctly
describe('checkout_confirmation_viewed', () => {
  it('fires when confirmation page renders with valid order', () => {
    render(<CheckoutConfirmation order={mockOrder} />);
    expect(mockTrack).toHaveBeenCalledWith('checkout_confirmation_viewed', {
      order_id: 'ord_abc123',
      order_total: 49.99,
      payment_method: 'credit_card',
      items_count: 3,
    });
  });

  it('does NOT fire when order data is missing', () => {
    render(<CheckoutConfirmation order={null} />);
    expect(mockTrack).not.toHaveBeenCalled();
  });
});
```

## MCP Tools

- `mcp__Amplitude__get_event_properties` — verify that property names and types match Amplitude's existing schema for this event (if updating an existing event)
- `mcp__Amplitude__get_project_context` — get project ID and settings needed for validation, confirm the target Amplitude project

## Key Concepts

- **Trigger location**: The exact file and logical location where the tracking call is placed — specificity prevents ambiguity
- **Property type contract**: A formal definition of each property's type, required-ness, and valid values
- **Fire condition**: The precise boolean condition that must be true for the event to fire — prevents over-counting and missing data
- **Edge case guard**: Code that prevents events from firing in invalid states (null data, duplicate renders, error states)
- **Idempotent event**: An event that should fire at most once per user action — requires deduplication logic in some frameworks

## Output Format

One implementation spec per event:

```
## Event: <event_name>

**Trigger:** <when exactly this fires>
**File:** <src/path/to/Component.tsx>
**Location:** <function name, lifecycle hook, or handler>

### Tracking Code
```typescript
<exact code snippet>
```

### Properties
| Property | Type | Required | Example | Description |
|----------|------|----------|---------|-------------|
<table rows>

### Edge Cases
- <edge case 1 with guard code>
- <edge case 2>

### Test Case
```typescript
<test definition>
```
```

After all events: "Implementation specs ready for N events. Hand off to engineers or proceed to `add-analytics-instrumentation` for end-to-end summary."
