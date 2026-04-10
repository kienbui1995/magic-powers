---
name: llm-cost-optimization
description: Use when reducing AI API costs — prompt caching, token reduction, batch processing, cost accounting for multi-step workflows, and building a cost optimization strategy for LLM-powered applications.
---

# LLM Cost Optimization

## Overview

LLM API costs grow faster than usage — every inefficiency compounds with scale. Optimization is not a one-time fix but a set of layered practices: know where money goes, reduce the most expensive drivers first, and track continuously so cost growth is caught before the invoice arrives.

## When to Use

- AI API costs are growing faster than usage
- Building a cost budget for an AI feature or product
- Optimizing an existing LLM workflow for cost efficiency
- Choosing between on-demand and batch processing
- Adding caching to reduce redundant LLM calls

## Core Jobs

### 1. Token Economics (Where Money Goes)

Understanding the cost structure is prerequisite to optimization:

```
Cost = (input_tokens × input_price) + (output_tokens × output_price)

Claude Sonnet 4.6: $3/1M input, $15/1M output  → output is 5x more expensive
GPT-4o:           $2.5/1M input, $10/1M output → output is 4x more expensive

Key insight: Generate LESS output, not shorter prompts.
```

**Token cost drivers by category:**

| Driver | Impact | Fix |
|--------|--------|-----|
| Verbose system prompts | High input cost per request | Compress, cache prefix |
| Long output generation | Highest cost | Constrain with format/length instructions |
| Multi-step agent loops | Compound input+output × steps | Reduce unnecessary steps |
| RAG context | High input cost | Improve retrieval precision, trim irrelevant chunks |
| No caching on repeated prefixes | Redundant input tokens | Implement prompt caching |

### 2. Prompt Caching (42% Median Reduction)

Cache repeated prompt prefixes to pay only for the delta:

```python
# Anthropic prompt caching — cache system prompt + static content
response = client.messages.create(
    model="claude-sonnet-4-6",
    system=[{
        "type": "text",
        "text": LONG_SYSTEM_PROMPT,  # 2000+ tokens
        "cache_control": {"type": "ephemeral"}  # cache for 5 minutes
    }],
    messages=[{"role": "user", "content": user_query}]
)
# First request: pay full price
# Subsequent requests: pay ~10% of system prompt cost (cached)

# OpenAI automatic caching (>1024 tokens prefix)
# Same request structure — caching applied automatically for repeated prefixes
```

**Cache hit conditions:**
- Prompt must be identical up to the cache breakpoint
- Cache TTL: ~5 minutes (Anthropic ephemeral), longer for persistent caches
- Best for: system prompts, tool definitions, document context, few-shot examples

**Expected savings:** 42% median reduction for workloads with stable system prompts.

### 3. Output Token Reduction

Output tokens cost 3-8x more than input tokens — highest ROI optimization target:

```python
# Verbose output — costs 3-5x more than needed
prompt = "Analyze this code and tell me everything you notice."
# Output: 2000 tokens of verbose analysis

# Constrained output — same information, 60-80% fewer tokens
prompt = """Analyze this code. Respond in JSON:
{
  "issues": [{"severity": "high|medium|low", "description": "...", "line": N}],
  "summary": "one sentence"
}
Maximum 5 issues. No explanation beyond the fields."""
# Output: 300 tokens of structured data
```

**Output reduction techniques:**
- Structured output (JSON/XML) instead of prose
- Explicit length constraints: "In 2-3 sentences", "Maximum 5 items"
- One-shot format examples showing desired density
- Remove preambles: "Skip explanations, give only the answer"
- Streaming + early stopping for interactive use cases

### 4. Batch Processing vs Real-Time

```python
# On-demand (real-time): high cost, immediate response
response = client.messages.create(model="claude-sonnet-4-6", ...)

# Batch API (50% cheaper, ~24h turnaround — Anthropic and OpenAI both offer this)
batch = client.messages.batches.create(requests=[
    {"custom_id": f"item_{i}", "params": {"model": "claude-sonnet-4-6", ...}}
    for i in range(1000)
])
# ~50% cheaper, results available within 24 hours
```

**When to batch:**
- Data processing, document analysis, content generation at scale
- Eval runs (eval datasets don't need real-time)
- Nightly reports, weekly analysis

**When NOT to batch:**
- User-facing features requiring <5s response
- Any flow where the user is waiting

### 5. Cost Accounting in Multi-Step Workflows

Single-call cost tracking misses compound costs in agent workflows:

```python
class WorkflowCostTracker:
    def __init__(self, budget_usd: float):
        self.budget = budget_usd
        self.steps = []
        self.total_cost = 0.0

    def record_step(self, step_name: str, usage: TokenUsage, model: str):
        cost = calculate_cost(usage, model)
        self.total_cost += cost
        self.steps.append({
            "step": step_name,
            "input_tokens": usage.input_tokens,
            "output_tokens": usage.output_tokens,
            "cost_usd": cost,
            "cumulative_cost": self.total_cost
        })

        if self.total_cost > self.budget * 0.8:
            # Early warning at 80% of budget
            log.warning(
                f"Workflow at {self.total_cost/self.budget:.0%} of budget "
                f"after {len(self.steps)} steps"
            )

        if self.total_cost > self.budget:
            raise BudgetExceededError(f"Workflow exceeded ${self.budget} budget")

    def report(self) -> CostReport:
        top_steps = sorted(self.steps, key=lambda s: s["cost_usd"], reverse=True)[:3]
        return CostReport(
            total=self.total_cost,
            step_count=len(self.steps),
            most_expensive_steps=top_steps,
            cost_per_step=self.total_cost / len(self.steps)
        )
```

### 6. Application-Level Response Caching

Beyond prompt caching — cache entire responses for identical inputs:

```python
import hashlib
from cachetools import TTLCache

class CachedLLM:
    def __init__(self, cache_ttl_seconds=3600):
        self.cache = TTLCache(maxsize=1000, ttl=cache_ttl_seconds)

    def generate(self, prompt: str, model: str, **kwargs) -> str:
        # Only cache deterministic prompts (temperature=0)
        if kwargs.get("temperature", 1.0) > 0:
            return self._raw_generate(prompt, model, **kwargs)

        cache_key = hashlib.sha256(f"{model}:{prompt}".encode()).hexdigest()

        if cache_key in self.cache:
            metrics.record("cache_hit", model=model)
            return self.cache[cache_key]

        result = self._raw_generate(prompt, model, **kwargs)
        self.cache[cache_key] = result
        metrics.record("cache_miss", model=model)
        return result
```

**Cache-able patterns:**
- Classification with same inputs (document type, intent detection)
- Template-based generation with same variables
- RAG with same query + same retrieved chunks
- System health checks, status pages

**Not cache-able:** Personalized responses, time-sensitive queries, anything with temperature > 0.

## Key Concepts

- **Prompt caching** — provider-level cache of repeated token prefixes (~42% cost reduction)
- **Batch API** — process requests asynchronously for ~50% discount (24h turnaround)
- **Output tokens** — cost 3-8x more than input tokens — highest ROI optimization target
- **Application cache** — cache full LLM responses for identical deterministic inputs
- **Budget tracker** — per-workflow cost accounting with early warning at 80% budget
- **Token reduction** — structured output, length constraints reduce output cost without quality loss

## Checklist

- [ ] Prompt caching enabled for system prompts >1024 tokens?
- [ ] Output format constrained (JSON/structured) where prose isn't needed?
- [ ] Batch API used for non-real-time workloads (eval, data processing)?
- [ ] Per-workflow cost tracking implemented (not just per-call)?
- [ ] Application-level cache for deterministic repeated queries?
- [ ] Model routing in place (not using frontier model for simple tasks)?
- [ ] Cost budget with early warning at 80% threshold?
- [ ] Weekly cost trend review (catch growth before invoice)?

## Key Outputs

- Cost breakdown: input vs output tokens, by model tier, by task type
- Optimization roadmap: ranked by estimated savings (caching > routing > output reduction)
- Budget configuration: per-workflow limits with alerting thresholds
- Cache hit rate: application cache effectiveness metric

## Output Format

- 🔴 **Critical** — no cost tracking (blind spending), frontier model for all tasks, no output constraints (verbose = expensive)
- 🟡 **Warning** — no prompt caching on stable system prompts, no batch API for async workloads, per-call tracking only (misses compound costs)
- 🟢 **Suggestion** — implement cascade routing + prompt caching for 60-80% total reduction, add batch API for eval/data workloads

## Anti-Patterns

- Optimizing input tokens while ignoring output tokens — wrong target; output costs 3-8x more
- Application cache with temperature>0 responses — non-deterministic responses cause cache poisoning
- No budget per workflow — can't catch runaway agent loops until the invoice arrives
- Batch API for user-facing features — 24h turnaround breaks user experience
- Cost optimization after building — 10x harder than designing for cost from day 1

## Integration

- Use with `model-routing` for model-tier cost optimization
- Use with `agentic-reliability` — retries increase cost; budget tracking catches retry storms
- Use with `llm-observability` for production cost monitoring and trend alerts
- Agent: `@ai-engineer` uses this when designing AI system architecture
