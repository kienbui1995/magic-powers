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
