---
name: llm-observability
description: Use when monitoring AI systems in production - cost tracking, latency, token usage, error rates, quality drift, and LLMOps dashboards
---

# LLM Observability

## Overview

You can't manage what you can't see. LLM systems fail silently — quality degrades, costs spike, latency creeps up — all without errors in your logs.

## When to Use

- Deploying any LLM feature to production
- Investigating cost spikes or quality drops
- Setting up monitoring for AI systems
- Building LLMOps dashboards

## What to Track

### Must-Have Metrics

| Metric | Why | Alert When |
|--------|-----|------------|
| **Cost per query** | Budget control | >2x baseline |
| **Latency p50/p95** | User experience | p95 >5s |
| **Token usage** (input + output) | Cost driver | Sudden spike |
| **Error rate** | Reliability | >1% |
| **Quality score** | Output quality | Drops >10% |

### Nice-to-Have

| Metric | Why |
|--------|-----|
| Cache hit rate | Cost savings effectiveness |
| Fallback trigger rate | How often guardrails fire |
| Model version distribution | Track rollouts |
| User satisfaction (thumbs) | Ground truth quality |

## Logging Pattern

```json
{
  "trace_id": "abc-123",
  "timestamp": "2026-04-05T08:30:00Z",
  "model": "gpt-4o",
  "prompt_tokens": 1200,
  "completion_tokens": 350,
  "latency_ms": 2100,
  "cost_usd": 0.023,
  "quality_score": 0.92,
  "guardrail_triggered": false,
  "cached": false,
  "user_id": "user_456",
  "feature": "chat_support"
}
```

Log EVERY LLM call. Storage is cheap, debugging without logs is expensive.

## Quality Drift Detection

Silent quality degradation is harder to catch than errors. Use statistical methods:

```python
# Moving average drift detection
class QualityDriftDetector:
    def __init__(self, window=100, threshold=0.05):
        self.window = window
        self.threshold = threshold
        self.scores = deque(maxlen=window)
        self.baseline = None
    
    def update(self, quality_score: float) -> DriftAlert | None:
        self.scores.append(quality_score)
        
        if len(self.scores) < self.window:
            return None  # not enough data yet
        
        if self.baseline is None:
            self.baseline = mean(self.scores)
            return None
        
        current_avg = mean(self.scores)
        drift = self.baseline - current_avg
        
        if drift > self.threshold:
            return DriftAlert(
                severity="warning" if drift < 0.10 else "critical",
                baseline=self.baseline,
                current=current_avg,
                drift=drift
            )
        return None
```

**Run on every production request:** sample 10% of outputs through model-as-judge, feed scores into drift detector.

**Trigger investigation when:** 7-day rolling average drops >5% from 30-day baseline.

## Agent-Specific Observability Metrics

Single-call LLM metrics aren't enough for agents. Track these additionally:

```python
# Track per agent task
agent_metrics = {
    "steps_per_task": [],      # average steps to complete
    "tool_calls_per_task": [], # tool call count
    "loop_count": [],          # number of reasoning loops
    "abandonment_rate": 0.0,   # % tasks agent couldn't complete
    "human_escalation_rate": 0.0,  # % requiring human intervention
    "token_efficiency": [],    # quality per 1K tokens (output quality / tokens used)
    "step_success_rate": {},   # per-tool success rate
}

# Alert thresholds for agents
AGENT_ALERTS = {
    "max_steps_per_task": 15,      # more = likely stuck in loop
    "abandonment_rate": 0.05,      # 5% fail to complete
    "human_escalation_rate": 0.10, # 10% need human help
    "tool_error_rate": 0.02,       # 2% tool calls fail
}
```

**Key agent health signals:**
- Steps per task increasing → agent less efficient (prompt degradation? tool issues?)
- Abandonment rate increasing → harder inputs or capability regression
- Loop count > max_steps → infinite loop; needs circuit breaker
- Tool error rate → upstream API issues or bad tool design

## Cost Management

```
Daily cost = Σ (calls × avg_tokens × price_per_token)
```

**Cost reduction levers:**
1. **Prompt optimization** — shorter prompts, same quality (→ prompt-engineering)
2. **Model routing** — use cheaper model for simple tasks
3. **Caching** — cache identical/similar queries
4. **Batching** — batch API calls for 50% discount (where available)
5. **Rate limiting** — per-user limits to prevent abuse

## Tools

| Tool | Type | Best For |
|------|------|----------|
| LangSmith | Managed | LangChain apps, tracing |
| Helicone | Managed | Cost tracking, caching proxy |
| Braintrust | Managed | Eval + logging |
| Langfuse | OSS | Self-hosted, full tracing |
| OpenTelemetry + custom | DIY | Existing observability stack |

## Distributed Tracing

Correlate LLM calls to user actions across services:

```python
# OpenTelemetry for LLM tracing
from opentelemetry import trace

tracer = trace.get_tracer(__name__)

def traced_llm_call(prompt, model, **kwargs):
    with tracer.start_as_current_span("llm.call") as span:
        span.set_attribute("llm.model", model)
        span.set_attribute("llm.prompt_tokens", count_tokens(prompt))
        span.set_attribute("user.session_id", get_session_id())
        
        result = llm.call(prompt, model=model, **kwargs)
        
        span.set_attribute("llm.completion_tokens", result.usage.completion_tokens)
        span.set_attribute("llm.cost_usd", calculate_cost(result.usage, model))
        span.set_attribute("llm.latency_ms", result.latency_ms)
        return result
```

## Cost Forecasting

Catch cost explosions before they hit the invoice:

```python
# Real-time cost budget with alerts
class CostBudgetMonitor:
    def __init__(self, daily_budget_usd: float):
        self.daily_budget = daily_budget_usd
        self.today_spend = 0.0
    
    def record(self, cost_usd: float):
        self.today_spend += cost_usd
        
        utilization = self.today_spend / self.daily_budget
        if utilization > 0.80:  # 80% of daily budget
            alert(f"Cost alert: ${self.today_spend:.2f} of ${self.daily_budget:.2f} budget used today")
        if utilization > 1.0:
            hard_limit_enforcement()  # block new requests or switch to cheaper model
```

**Weekly cost trend:** if 7-day cost growing >20% week-over-week without traffic growth → investigate model usage patterns.

## Alerting Rules

```yaml
alerts:
  - name: cost_spike
    condition: daily_cost > 2x rolling_7d_avg
    action: slack_notify + auto_rate_limit

  - name: quality_drop
    condition: avg_quality_score < 0.80 over 1h
    action: page_oncall

  - name: latency_degradation
    condition: p95_latency > 5000ms over 15m
    action: slack_notify
```

## Integration

- **magic-powers:llm-evaluation** — quality scores feed into observability
- **magic-powers:ai-safety-guardrails** — track guardrail trigger rates
- **magic-powers:incident-response** — respond to AI system incidents
- **magic-powers:cost-aware-routing** — optimize based on cost data
