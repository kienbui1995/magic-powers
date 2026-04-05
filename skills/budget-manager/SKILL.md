# Budget Manager Skill

Track and optimize AI coding costs with real-time monitoring, budget alerts, and usage analytics.

## Features
- Real-time cost tracking per agent/model/project
- Budget alerts (email/Slack/Webhook)
- Usage analytics dashboard
- OpenRouter/Claude Code Router integration
- Cost forecasting and recommendations

## Usage
```javascript
import { BudgetManager } from './budget-manager.js';

const budgetManager = new BudgetManager({
  monthlyBudget: 100,
  alertThreshold: 0.8,
  providers: ['openrouter', 'anthropic', 'openai']
});

// Track cost
budgetManager.trackCost('agent-1', 'claude-3-opus', 0.15);

// Check budget
if (budgetManager.isOverBudget()) {
  console.log('Budget exceeded!');
}
```

## Configuration
Set environment variables:
- `BUDGET_MONTHLY_LIMIT`: Monthly budget in USD
- `BUDGET_ALERT_THRESHOLD`: Alert at X% of budget (default: 0.8)
- `BUDGET_PROVIDERS`: Comma-separated list of AI providers

## Integration
Works with existing cost-aware-routing skill for optimal provider selection.
