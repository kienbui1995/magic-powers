---
name: llm-evaluation
description: Use when measuring AI output quality - eval frameworks, golden datasets, regression testing, benchmarking, human-in-the-loop evaluation
---

# LLM Evaluation

## Overview

If you can't measure it, you can't improve it. LLM eval is the difference between "it seems to work" and "it works 94% of the time on our test set."

## When to Use

- Before deploying any LLM feature to production
- After changing prompts, models, or RAG pipeline
- Setting up CI for AI quality regression testing
- Comparing models or providers

## Eval Framework

```
1. Define what "good" means (criteria)
2. Build golden dataset (input → expected output)
3. Run eval automatically
4. Track scores over time
5. Block deploys that regress
```

### RAG-Specific Metrics (Ragas)

For RAG systems, use [Ragas](https://github.com/explodinggradients/ragas) for component-level eval:

| Metric | Measures | Target |
|--------|---------|--------|
| **Faithfulness** | Does answer contain only info from retrieved context? | > 0.85 |
| **Answer Relevance** | Is the answer relevant to the question? | > 0.80 |
| **Context Precision** | What % of retrieved chunks are actually useful? | > 0.70 |
| **Context Recall** | Did retrieval capture all relevant info? | > 0.75 |

```python
from ragas import evaluate
from ragas.metrics import faithfulness, answer_relevancy, context_precision, context_recall

results = evaluate(
    dataset=eval_dataset,  # questions, answers, contexts, ground_truths
    metrics=[faithfulness, answer_relevancy, context_precision, context_recall]
)
# results.to_pandas() → per-question breakdown
```

**Diagnosing RAG failures:**
- Low faithfulness → hallucination; fix retrieval or generation prompt
- Low context precision → too many irrelevant chunks retrieved; tune top-K or reranker
- Low context recall → missing relevant docs; fix chunking or embedding model
- Low answer relevance → answer drifts from question; tighten generation prompt

## Eval Types

### 1. Golden Set Eval (must-have)
- 50-200 curated examples with expected outputs
- Run on every prompt/model change
- Score: exact match, fuzzy match, or LLM-as-judge

### 2. LLM-as-Judge
```
Rate the following response on a scale of 1-5 for:
- Accuracy: Is the information correct?
- Relevance: Does it answer the question?
- Completeness: Is anything missing?

Question: {question}
Response: {response}
Reference: {expected}
```

### 3. Human-in-the-Loop
- Sample 5-10% of production outputs for human review
- Use thumbs up/down or 1-5 rating
- Track agreement rate between human and auto-eval

### 4. A/B Testing
- Route 10% traffic to new prompt/model
- Compare metrics: quality score, latency, cost, user satisfaction
- Promote winner after statistical significance

### Latency & Cost Metrics

Track alongside quality — they're part of the eval contract:

| Metric | Good | Warning | Critical |
|--------|------|---------|---------|
| Time to first token | < 500ms | 500ms-2s | > 2s |
| Total latency (P50) | < 3s | 3-10s | > 10s |
| Total latency (P95) | < 8s | 8-20s | > 20s |
| Cost per 1K requests | baseline | +25% | +50% |
| Token efficiency | baseline | -15% | -30% |

```python
# Include latency in golden set evaluation
def eval_with_latency(test_case, fn):
    start = time.monotonic()
    result = fn(test_case.input)
    latency_ms = (time.monotonic() - start) * 1000
    
    return EvalResult(
        quality_score=score(result, test_case.expected),
        latency_ms=latency_ms,
        input_tokens=result.usage.input_tokens,
        output_tokens=result.usage.output_tokens,
        cost_usd=calculate_cost(result.usage, model=result.model)
    )
```

### Stratified Evaluation

Aggregate scores hide per-category regressions. Always stratify:

```python
# Segment test cases by complexity, domain, input length
test_cases = [
    TestCase(input="...", expected="...", category="simple", domain="billing"),
    TestCase(input="...", expected="...", category="complex", domain="technical"),
    # ...
]

# Evaluate per segment
results_by_segment = {}
for category in ["simple", "complex", "edge_case"]:
    subset = [t for t in test_cases if t.category == category]
    results_by_segment[category] = run_eval(subset)

# Alert if any segment drops > 5% vs baseline
for segment, results in results_by_segment.items():
    if results.pass_rate < baseline[segment] - 0.05:
        alert(f"Regression in {segment}: {results.pass_rate:.0%} vs {baseline[segment]:.0%}")
```

**Recommended segments:**
- By complexity: simple / medium / complex / edge case
- By domain: billing / technical / general
- By input length: short (<100 tokens) / medium / long (>1000 tokens)
- By user type: new_user / power_user / enterprise

## Key Metrics

| Metric | What | Target |
|--------|------|--------|
| Accuracy | Correct answers / total | >90% |
| Faithfulness | Grounded in source (RAG) | >95% |
| Latency p95 | Response time | <3s |
| Cost per query | Token cost | Track trend |
| Hallucination rate | Made-up facts | <5% |
| User satisfaction | Thumbs up rate | >80% |

## Tools

| Tool | Type | Best For |
|------|------|----------|
| promptfoo | OSS | Prompt testing, CI integration |
| Braintrust | Managed | Logging + eval + datasets |
| LangSmith | Managed | LangChain ecosystem |
| Ragas | OSS | RAG-specific evaluation |
| Custom script | DIY | Simple golden set testing |

## Minimum Viable Eval

```python
# run_eval.py — run on every prompt change
import json

def run_evaluation(test_cases, run_fn):
    results = []
    for case in test_cases:
        output = run_fn(case["input"])
        score = judge(output, case["expected"])
        results.append({"input": case["input"], "score": score})
    avg = sum(r["score"] for r in results) / len(results)
    assert avg >= 0.85, f"Quality regression: {avg:.2f} < 0.85"
    return avg
```

## Integration

- **magic-powers:prompt-engineering** — test prompts systematically
- **magic-powers:rag-architecture** — evaluate retrieval quality
- **magic-powers:ci-cd-pipeline** — run evals in CI, block bad deploys
