# Example: UI Design with Stitch

Using ui-designer agent with Google Stitch SDK for rapid prototyping.

## Scenario

You need a dashboard page with analytics charts and a data table.

## 1. Design with UI Designer (Sonnet)

```
You: @ui-designer Design a dashboard with:
     - Summary cards (revenue, users, orders, conversion rate)
     - Line chart for revenue over time
     - Data table with recent orders
     Use the project's existing design system.
```

UI designer uses `design-with-stitch` skill:
1. Generates design via Stitch SDK → gets component specs
2. Translates to your project's component library
3. Outputs responsive layout with mobile considerations

## 2. Review the Design (Haiku)

```
You: @reviewer Check the dashboard implementation for accessibility and responsiveness.
```

Reviewer checks: ARIA labels, color contrast, keyboard navigation, mobile breakpoints.

## Cost: ~$0.12 total

> **Note:** Cost figures are estimates based on Anthropic API pricing as of early 2025. Actual costs vary by input/output length. See [Anthropic pricing](https://www.anthropic.com/pricing) for current rates.
