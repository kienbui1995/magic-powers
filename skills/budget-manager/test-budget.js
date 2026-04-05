import { BudgetManager } from './budget-manager.js';

// Test basic functionality
const budget = new BudgetManager({ monthlyBudget: 50 });

console.log('Testing Budget Manager...');

// Track some costs
budget.trackCost('agent1', 'claude-3-opus', 0.15);
budget.trackCost('agent2', 'gpt-4', 0.10);
budget.trackCost('agent1', 'claude-3-sonnet', 0.05);

console.log('Total cost:', budget.getTotalCost());
console.log('Remaining budget:', budget.getRemainingBudget());
console.log('Is over budget?', budget.isOverBudget());

// Generate report
const report = budget.generateReport();
console.log('\nReport:', JSON.stringify(report, null, 2));

console.log('\n✅ Budget Manager test completed');
