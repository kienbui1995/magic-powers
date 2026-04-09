---
name: ai-harness
description: Use when building evaluation infrastructure for AI systems — test harnesses, CI pipelines for AI, automated regression detection, golden datasets, and continuous quality measurement.
---

# AI Harness

## When to Use

- Setting up automated evaluation pipeline for an LLM feature
- Catching quality regressions before they reach production
- Building a continuous eval CI/CD system
- Creating golden datasets for systematic testing
- Comparing prompt versions or model upgrades systematically

## Core Components of an AI Harness

### 1. Golden Dataset Design

- Representative inputs covering: happy path, edge cases, adversarial, real user examples
- Each test case: input + expected output + evaluation criteria
- Minimum 50-100 cases before automated eval is meaningful
- Label types: exact match, semantic similarity, rubric-based, human preference
- Dataset versioning (git or DVC) — same discipline as code

### 2. Evaluation Layers

Three layers for comprehensive coverage:

```
Layer 1: Deterministic checks (fast, cheap)
  - Output schema validation (JSON structure, required fields)
  - Length constraints (too short/long)
  - Keyword presence/absence
  - PII detection in outputs

Layer 2: Model-as-judge (flexible, moderate cost)
  - Use GPT-4/Claude to score outputs on rubric
  - Criteria: accuracy, helpfulness, safety, hallucination
  - Score 1-5 with reasoning
  - Compare to baseline (previous prompt/model)

Layer 3: Human review (ground truth, expensive)
  - Sample 5-10% of outputs weekly
  - Focus on borderline model-as-judge scores (2-3 out of 5)
  - Use disagreements to improve rubric
```

### 3. CI Integration

```yaml
# .github/workflows/ai-eval.yml
name: AI Eval
on: [push, pull_request]
jobs:
  eval:
    steps:
      - name: Run eval harness
        run: python eval/run_harness.py
        env:
          OPENAI_API_KEY: ${{ secrets.OPENAI_API_KEY }}
      - name: Check pass rate
        run: python eval/check_thresholds.py --min-pass-rate 0.85
      - name: Upload results
        uses: actions/upload-artifact@v3
        with:
          name: eval-results
          path: eval/results/
```

### 4. Regression Detection

- Baseline: capture current pass rates per category
- Alert when: pass rate drops >5% vs baseline, any critical test fails, cost increases >20%
- Track over time: eval results → time-series DB → dashboard

### 5. Prompt Version Testing

```python
# A/B test two prompts against golden dataset
results = {
    "prompt_v1": run_eval(dataset, prompt_v1),
    "prompt_v2": run_eval(dataset, prompt_v2),
}
# Compare: accuracy, cost, latency, safety
winner = select_winner(results, primary_metric="accuracy", cost_constraint=1.2)
```

### 6. Tools and Frameworks

| Tool | Use case |
|------|---------|
| **LangSmith** | Tracing + eval for LangChain apps |
| **Braintrust** | Eval platform, dataset management, CI integration |
| **PromptFoo** | Open-source prompt testing, CLI-first |
| **Weights & Biases** | Experiment tracking, model comparison |
| **Ragas** | RAG-specific evaluation (faithfulness, answer relevance) |
| **pytest + custom** | Lightweight eval for simple use cases |

## Core Jobs

1. **Golden dataset** — curate representative test cases (happy path, edge cases, adversarial, real user queries)
2. **Eval layers** — deterministic checks → model-as-judge → human review
3. **CI integration** — run eval on every PR; block merge on critical failures
4. **Regression detection** — baseline pass rates; alert on >5% drop by category
5. **Prompt A/B testing** — compare prompt versions against dataset; select winner by metric

## Key Outputs

- Eval report: pass rate by category + comparison vs baseline
- CI check: green/red with failure breakdown
- Dataset: versioned JSONL with input/expected/criteria
- Regression alert: which category dropped and by how much

## Anti-Patterns

- Evaluating only on training distribution (test on real user queries)
- Using BLEU/ROUGE for open-ended generation (meaningless for chat)
- No baseline — "better" means nothing without comparison
- Running eval only before major releases (too late to catch drift)
- One aggregated score hiding category regressions

## Integration

- Use with `llm-evaluation` (frameworks) and `llm-observability` (production monitoring)
- Use `ai-safety-guardrails` to add safety checks as eval layer
- CI eval catches regressions; observability catches production drift
