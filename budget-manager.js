// Magic Budget Manager - Core Implementation
class BudgetManager {
  constructor() {
    this.costs = new Map(); // agent -> total cost
    this.budgets = new Map(); // agent -> budget limit
    this.alerts = new Set(); // alert thresholds
  }

  track(agent, model, tokens, costPerToken) {
    const cost = tokens * costPerToken;
    const current = this.costs.get(agent) || 0;
    this.costs.set(agent, current + cost);
    
    // Check alerts
    this.checkAlerts(agent);
    return cost;
  }

  setBudget(agent, budget) {
    this.budgets.set(agent, budget);
  }

  setAlert(agent, threshold) {
    this.alerts.add(`${agent}:${threshold}`);
  }

  checkAlerts(agent) {
    const spent = this.costs.get(agent) || 0;
    const budget = this.budgets.get(agent);
    
    if (budget && spent >= budget) {
      this.triggerAlert(agent, 'budget_exceeded', { spent, budget });
    }
  }

  triggerAlert(agent, type, data) {
    // Implement alert logic (email, webhook, etc.)
    console.log(`ALERT: ${agent} - ${type}`, data);
  }

  getReport(agent) {
    return {
      spent: this.costs.get(agent) || 0,
      budget: this.budgets.get(agent) || null,
      alerts: Array.from(this.alerts).filter(a => a.startsWith(agent))
    };
  }
}

module.exports = BudgetManager;
