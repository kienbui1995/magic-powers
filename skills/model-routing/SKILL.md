---
name: model-routing
description: Use when selecting AI models for different tasks, designing cost-aware routing (cheap→expensive cascade), implementing model fallbacks, and optimizing the capability/cost/latency tradeoff across model tiers.
---

# Model Routing

## Overview

Not all LLM tasks are equal. Sending every request to the most capable — and most expensive — model is a failure of system design. Model routing assigns each task to the cheapest model that can handle it reliably, uses cascade escalation when a cheaper model is insufficient, and maintains fallback chains to keep systems available when a model is down.

## When to Use

- Choosing which model to use for different tasks in a system
- Reducing AI costs by routing simple tasks to cheaper models
- Designing fallback chains when a model is unavailable
- Building a routing layer for a multi-model AI application
- Evaluating whether to upgrade from a cheaper to a more capable model

## Core Jobs

### 1. Model Capability Tiers (2025)

| Tier | Models | Cost | Best For |
|------|--------|------|---------|
| **Frontier/Opus** | Claude Opus 4.6, GPT-4o, Gemini 1.5 Pro | $$$$ | Complex reasoning, multi-step planning, nuanced judgment |
| **Standard/Sonnet** | Claude Sonnet 4.6, GPT-4o-mini, Gemini 1.5 Flash | $$ | Most tasks: coding, analysis, writing, RAG Q&A |
| **Fast/Haiku** | Claude Haiku 4.5, GPT-3.5-turbo | $ | Classification, simple extraction, routing decisions, short summaries |
| **Reasoning** | o1, o3-mini, Claude extended thinking | $$$-$$$$ | Math, logic, code correctness, multi-step reasoning |
| **Embeddings** | text-embedding-3-small/large, voyage-large | $ | Semantic search, clustering, similarity |

### 2. Task-Based Routing

Route tasks to the cheapest model that can handle them reliably:

```python
class TaskRouter:
    def route(self, task: Task) -> str:
        # Classify task complexity first (use haiku for this — it's cheap)
        complexity = self.classify_complexity(task)

        routing_table = {
            "simple_extraction": "claude-haiku-4-5",      # extract structured data
            "classification": "claude-haiku-4-5",          # categorize input
            "short_summary": "claude-haiku-4-5",           # <500 word summary
            "rag_qa": "claude-sonnet-4-6",                 # RAG Q&A with context
            "code_generation": "claude-sonnet-4-6",        # write/review code
            "complex_analysis": "claude-opus-4-6",         # deep analysis
            "multi_step_planning": "claude-opus-4-6",      # agent planning
            "math_logic": "claude-opus-4-6",               # reasoning tasks
        }

        return routing_table.get(complexity, "claude-sonnet-4-6")

    def classify_complexity(self, task: Task) -> str:
        # Use haiku to classify — fast and cheap
        response = haiku.classify(
            task.description,
            categories=list(routing_table.keys())
        )
        return response.category
```

### 3. Cascade Routing (Smart Escalation)

Try cheap model first; escalate only when output quality is insufficient:

```python
async def cascade_generate(prompt: str, quality_threshold: float = 0.8) -> str:
    models = [
        "claude-haiku-4-5",    # try cheapest first
        "claude-sonnet-4-6",   # escalate if haiku insufficient
        "claude-opus-4-6",     # escalate for complex cases
    ]

    for model in models:
        response = await llm.generate(prompt, model=model)
        quality = await evaluate_quality(response, prompt)

        if quality >= quality_threshold:
            log_routing_decision(model, quality, escalated=(model != models[0]))
            return response.text

        log_escalation(from_model=model, quality=quality)

    return response.text  # return best available even if below threshold
```

**87% cost reduction potential:** OpenAI's analysis shows 87% of queries can be handled by cheaper models in well-designed cascades. Only ~13% need frontier models.

### 4. Content-Based Routing

Route based on the content characteristics of the request:

```python
def content_based_route(query: str, context: dict) -> str:
    # Length heuristics
    if len(query.split()) < 20 and not context.get("requires_reasoning"):
        return "claude-haiku-4-5"

    # Topic-based routing
    if any(kw in query.lower() for kw in ["calculate", "prove", "math", "algorithm"]):
        return "claude-opus-4-6"  # reasoning intensive

    if any(kw in query.lower() for kw in ["summarize", "extract", "list", "classify"]):
        return "claude-haiku-4-5"  # structured, simple

    # Context length routing
    total_tokens = count_tokens(query) + count_tokens(str(context))
    if total_tokens > 50000:
        return "claude-sonnet-4-6"  # long context needs capable model

    return "claude-sonnet-4-6"  # default: balanced
```

### 5. Model Fallback Chain

Always define fallbacks for production reliability:

```python
MODEL_FALLBACK_CHAIN = {
    "claude-opus-4-6":   ["claude-sonnet-4-6", "claude-haiku-4-5"],
    "claude-sonnet-4-6": ["claude-haiku-4-5", "gpt-4o-mini"],
    "claude-haiku-4-5":  ["gpt-3.5-turbo"],
}

async def generate_with_fallback(prompt: str, preferred_model: str) -> GenerationResult:
    models_to_try = [preferred_model] + MODEL_FALLBACK_CHAIN.get(preferred_model, [])

    for model in models_to_try:
        try:
            result = await llm.generate(prompt, model=model)
            return GenerationResult(
                text=result,
                model_used=model,
                used_fallback=(model != preferred_model)
            )
        except (ModelUnavailableError, RateLimitError) as e:
            log_fallback(from_model=model, reason=str(e))
            continue

    raise AllModelsFailedError(f"All models in chain failed: {models_to_try}")
```

### 6. Routing Metrics and Optimization

Track routing decisions to optimize over time:

```python
# Log every routing decision
def log_routing_decision(model, quality_score, latency_ms, cost_usd, task_type):
    metrics.record({
        "model": model,
        "quality": quality_score,
        "latency_ms": latency_ms,
        "cost_usd": cost_usd,
        "task_type": task_type,
        "timestamp": now()
    })

# Weekly analysis: what % of tasks need each model tier?
# If haiku handles 70% of tasks at acceptable quality → good routing
# If haiku handles only 20% → routing too conservative, tighten thresholds
```

## Key Concepts

- **Model cascade** — try cheap→expensive until quality threshold met
- **Task router** — classify task type first, then select model
- **Quality threshold** — minimum acceptable output score for a model tier
- **Fallback chain** — ordered list of alternative models when primary unavailable
- **Token economics** — output tokens 3-8x more expensive than input; model tier also multiplies
- **Reasoning models** — o1/o3, extended thinking: better on logic/math, slower, more expensive

## Checklist

- [ ] Routing table defined for all task types in the system?
- [ ] Haiku/fast models used for classification, extraction, simple summaries?
- [ ] Cascade routing tested — does quality threshold correctly gate escalation?
- [ ] Fallback chain defined for each model (at least 2 fallbacks)?
- [ ] Routing decisions logged for cost/quality analysis?
- [ ] Quality evaluator calibrated (not too strict/lenient)?
- [ ] Reasoning models used ONLY for tasks requiring deep logic?

## Key Outputs

- Routing table: task type → model mapping with justification
- Cascade configuration: quality thresholds per task type
- Cost projection: expected cost per 1K requests with routing vs without
- Routing metrics dashboard: model distribution, escalation rate, quality by model

## Output Format

- 🔴 **Critical** — using frontier model for all tasks (10-100x overspend), no fallback chain (hard failure when model unavailable)
- 🟡 **Warning** — no quality-based cascade (routing too rigid), routing table not task-specific (coarse routing)
- 🟢 **Suggestion** — implement cascade routing for 50%+ cost reduction, add A/B testing to measure quality/cost tradeoff by route

## Anti-Patterns

- Using GPT-4o or Claude Opus for everything "to be safe" — 10-100x unnecessary cost
- No quality measurement before routing — can't know if cheap model is sufficient
- Routing only by task type, ignoring input complexity — simple and complex queries get same model
- No fallback chain — one model outage takes down entire system
- Routing decisions not logged — can't optimize what you don't measure

## Integration

- Use with `llm-cost-optimization` for comprehensive cost reduction strategy
- Use with `agentic-reliability` for fallback chain implementation patterns
- Use with `llm-observability` to track routing decisions in production
- Agent: `@ai-engineer` and `@ai-product` use this when designing multi-model systems
