---
name: agentic-eval
description: Use when evaluating AI agent systems — trajectory evaluation, pass@k testing, tool call correctness, non-deterministic behavior testing, and building eval infrastructure specific to multi-step agentic workflows.
---

# Agentic Eval

## Overview

Evaluating an agent is fundamentally different from evaluating a single LLM call. The unit of evaluation is a trajectory — the full sequence of plan, tool calls, observations, and final response. A correct final answer via a bad trajectory is still a bad agent.

## When to Use

- Evaluating a multi-step AI agent (not just a single LLM call)
- Testing tool use correctness and sequence quality
- Handling non-determinism in agent behavior
- Setting up CI/CD eval for an agent system
- Diagnosing WHY an agent fails, not just THAT it fails

## Core Jobs

### 1. Why Agentic Eval ≠ LLM Eval

| Dimension | LLM Eval | Agentic Eval |
|-----------|---------|-------------|
| Unit | 1 prompt → 1 response | Multi-step: plan → tool calls → synthesis |
| Evaluation | Compare output to expected | Evaluate trajectory + output |
| Failure modes | Hallucination, off-topic | Wrong tool, wrong params, infinite loop, tool hallucination |
| Non-determinism | Minor variation | Compound across steps — run multiple times |
| Test design | Golden dataset | Scenario-based with sandbox tools |

Key implication: an agent can produce the correct final answer via a completely wrong path (e.g., lucky guess after repeated failures). Trajectory evaluation catches this; output-only evaluation does not.

### 2. Three-Layer Trajectory Evaluation

**Layer 1: Final response evaluation** ("Did it work?")

```python
def eval_final_response(actual_output, expected_output, criteria):
    score = llm_judge(
        prompt=f"Does this response satisfy the criteria?\nCriteria: {criteria}\nResponse: {actual_output}",
        expected=expected_output
    )
    return score
```

Use this as a quick pass/fail gate before deeper analysis. Necessary but not sufficient.

**Layer 2: Trajectory evaluation** ("Where did it go wrong?")

```python
def eval_trajectory(actual_steps, expected_steps, mode="any_order"):
    if mode == "exact":
        # Strict: same tools, same order
        return actual_steps == expected_steps
    elif mode == "any_order":
        # Valid if same tools called, order flexible
        return set(s.tool for s in actual_steps) == set(s.tool for s in expected_steps)
    elif mode == "subset":
        # Valid if all expected tools called (may call extras)
        expected_tools = set(s.tool for s in expected_steps)
        actual_tools = set(s.tool for s in actual_steps)
        return expected_tools.issubset(actual_tools)
```

Prefer `any_order` or `subset` mode — valid agents often find multiple correct paths. Reserve `exact` mode for security-critical flows where order matters.

**Layer 3: Step-level evaluation** ("Why did it fail?")

```python
def eval_step(step, expected_step):
    return {
        "tool_correct": step.tool == expected_step.tool,
        "params_correct": jaccard_similarity(step.params, expected_step.params) > 0.8,
        "reasoning_sound": llm_judge(step.reasoning, "Is this reasoning valid for the goal?"),
        "output_useful": llm_judge(step.output, "Did this tool output advance the goal?")
    }
```

Step-level breakdown exposes whether failures are systemic (always wrong tool) or situational (wrong params in edge cases).

### 3. Tool Hallucination Detection

Tool hallucination = agent describes calling a tool in its reasoning but never actually invokes it. This is always high severity — the agent is lying about its actions.

```python
def detect_tool_hallucination(trace):
    # Extract tool names mentioned in the agent's reasoning text
    claimed_tools = extract_tool_names_from_reasoning(trace.reasoning)
    # Compare to actual logged tool invocations
    actual_tool_calls = [call.tool for call in trace.tool_calls]

    hallucinated = set(claimed_tools) - set(actual_tool_calls)
    if hallucinated:
        return HallucinationResult(
            detected=True,
            hallucinated_tools=hallucinated,
            severity="high"  # Always high — agent fabricated its own actions
        )
    return HallucinationResult(detected=False)
```

CI rule: tool hallucination rate must be 0.0. Any hallucination is a blocker. An agent that fabricates its own tool calls cannot be trusted in production.

### 4. Pass@k for Non-Deterministic Agents

Agents are non-deterministic. A single test run that passes or fails tells you little. Pass@k measures the probability that at least 1 of k sampled runs succeeds.

```python
from math import comb

def pass_at_k(n_trials, n_successes, k):
    """Probability that at least 1 of k samples succeeds."""
    if n_trials - n_successes < k:
        return 1.0
    return 1.0 - comb(n_trials - n_successes, k) / comb(n_trials, k)

# Run each test case 5-10 times, report pass@1, pass@3, pass@5
results = run_agent_n_times(test_case, n=10)
n_success = sum(results)

p1 = pass_at_k(10, n_success, 1)   # strict: must work on any given run
p3 = pass_at_k(10, n_success, 3)   # lenient: works at least once in 3 tries
p5 = pass_at_k(10, n_success, 5)   # very lenient: works at least once in 5
```

**Target thresholds by use case:**

| Use case | Recommended target |
|----------|--------------------|
| Production customer-facing agent | pass@1 > 0.85 |
| Internal tooling agent | pass@3 > 0.90 |
| Research prototype | pass@5 > 0.70 |

Always report pass@1 AND pass@3 — an agent with pass@1=0.40 and pass@3=0.95 is fine for a retry-based system but unacceptable for single-shot production flows.

### 5. Sandbox Tool Environment

Test agents with mocked tools to avoid hitting real APIs — keeps eval fast, deterministic, and cheap.

```python
class SandboxToolEnv:
    def __init__(self, scenario):
        self.tools = {
            "search": lambda q: scenario.get_search_results(q),
            "write_file": lambda path, content: scenario.record_write(path, content),
            "send_email": lambda to, body: scenario.record_email(to, body),
            "query_db": lambda sql: scenario.get_db_result(sql),
        }
        self.call_log = []

    def call_tool(self, name, params):
        if name not in self.tools:
            raise ToolNotFoundError(f"Tool '{name}' not available")
        self.call_log.append(ToolCall(name, params, timestamp=now()))
        return self.tools[name](**params)

    def assert_tool_called(self, tool_name, params_match=None):
        calls = [c for c in self.call_log if c.name == tool_name]
        assert len(calls) > 0, f"Tool '{tool_name}' was never called"
        if params_match:
            assert any(params_match(c.params) for c in calls), \
                f"Tool '{tool_name}' called but no call matched params filter"

    def assert_tool_not_called(self, tool_name):
        calls = [c for c in self.call_log if c.name == tool_name]
        assert len(calls) == 0, f"Tool '{tool_name}' was called unexpectedly ({len(calls)} times)"
```

Scenarios define what mock tools return for each test situation. This makes tests reproducible — same input always produces same tool responses, exposing agent logic flaws rather than API flakiness.

### 6. Scenario-Based Test Design

Agent tests are scenarios, not golden examples. Each scenario defines: initial context, available mock tools, expected trajectory pattern, and pass criteria.

```python
SCENARIOS = [
    {
        "name": "customer_refund_happy_path",
        "input": "Customer 123 wants a refund for order 456",
        "mock_tools": {
            "get_order": {"id": 456, "status": "delivered", "amount": 49.99},
            "get_customer": {"id": 123, "tier": "premium", "refunds_this_year": 0},
            "process_refund": {"success": True, "refund_id": "R789"}
        },
        "expected_tools": ["get_order", "get_customer", "process_refund"],
        "trajectory_mode": "any_order",
        "pass_criteria": "Refund approved and confirmation provided"
    },
    {
        "name": "customer_refund_fraud_signal",
        "input": "Customer 999 wants a refund for order 101",
        "mock_tools": {
            "get_order": {"id": 101, "status": "delivered", "amount": 299.99},
            "get_customer": {"id": 999, "tier": "standard", "refunds_this_year": 4},
        },
        "expected_tools": ["get_order", "get_customer"],
        "trajectory_mode": "subset",
        "pass_criteria": "Refund escalated to human review, not auto-approved"
    }
]
```

### 7. Agent-Specific CI Pipeline

```yaml
# .github/workflows/agent-eval.yml
name: Agent Eval
on: [push, pull_request]

jobs:
  agent-eval:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        scenario: [customer_support, code_review, data_analysis]
    steps:
      - name: Run agent scenarios (3 trials each)
        run: |
          python eval/run_agent_scenarios.py \
            --scenario ${{ matrix.scenario }} \
            --trials 3 \
            --output eval/results/${{ matrix.scenario }}.json

      - name: Check pass@1 threshold
        run: python eval/check_thresholds.py --metric pass_at_1 --min 0.80

      - name: Check zero tool hallucinations
        run: python eval/check_thresholds.py --metric tool_hallucination_rate --max 0.0

      - name: Check trajectory precision
        run: python eval/check_thresholds.py --metric trajectory_precision --min 0.75

      - name: Upload eval artifacts
        uses: actions/upload-artifact@v3
        with:
          name: eval-results-${{ matrix.scenario }}
          path: eval/results/
```

CI blocks on: any tool hallucination, pass@1 below threshold, trajectory precision below 0.75. CI warns on: pass@1 between threshold and 0.90 (approaching degradation zone).

## Key Concepts

- **Trajectory** — the complete sequence of steps (reasoning, tool calls, observations, synthesis) an agent takes to complete a task; the primary evaluation unit in agentic eval
- **Pass@k** — probability that at least 1 of k sampled runs of the agent succeeds; the correct metric for non-deterministic systems
- **Tool hallucination** — agent describes calling a tool in its reasoning without actual invocation; always high severity, zero-tolerance in production
- **Step precision** — what fraction of actual tool calls were necessary (unnecessary calls = inefficiency or confusion)
- **Step recall** — what fraction of necessary tool calls were actually made (missing calls = incomplete work)
- **Trajectory precision/recall** — step precision and recall aggregated across all steps in a run
- **Sandbox environment** — mocked tool execution environment for reproducible, API-free testing
- **Scenario** — a test case for agents: initial context + mock tool responses + expected trajectory + pass criteria

## Checklist

- [ ] Using pass@k (not single run) for all agent test cases?
- [ ] Sandbox environment set up to mock all tool calls?
- [ ] Tool hallucination detection enabled in eval pipeline?
- [ ] Three-layer eval implemented: final response + trajectory + step-level?
- [ ] CI blocks on tool hallucination rate > 0% (zero tolerance)?
- [ ] Trajectory eval uses `any_order` or `subset` mode (not rigid exact match) for flexible agents?
- [ ] Test scenarios cover failure cases: tool errors, timeouts, ambiguous input, fraud signals?
- [ ] Pass@1 target documented per use case (production vs internal vs prototype)?
- [ ] Eval results tracked over time to detect regression trends?
- [ ] Scenario library covers at least happy path + 2 edge cases per agent capability?

## Key Outputs

- Pass@k scores by scenario (pass@1 and pass@3 minimum) with trend vs baseline
- Tool hallucination report — zero tolerance, any hallucination is a release blocker
- Trajectory precision/recall by scenario, broken down by step
- Step-level failure breakdown — wrong tool selected vs wrong parameters vs unsound reasoning
- CI pass/fail status with failure explanation pointing to specific scenarios and layers
- Scenario library — versioned test cases with mock tool responses for reproducibility

## Output Format

- 🔴 **Critical** — any tool hallucination detected, pass@1 < 0.70 in production agent, CI pipeline not configured, only final-response eval (no trajectory layer)
- 🟡 **Warning** — pass@1 between 0.70–0.85, no sandbox environment (testing against real APIs), exact trajectory matching (too brittle), no step-level eval for diagnosis
- 🟢 **Suggestion** — add step-level eval for deeper failure diagnostics, increase trial count for statistical power, add scenario coverage for adversarial inputs

## Anti-Patterns

- **Single test run for non-deterministic agents** — one pass or fail is noise; always use pass@k with 5+ trials
- **Testing against real APIs in CI** — slow, expensive, flaky, and non-reproducible; use sandbox environments
- **Only checking final output, ignoring trajectory** — correct answer via wrong path is still a broken agent
- **Exact trajectory matching** — valid agents reach correct answers via multiple paths; use `any_order` or `subset`
- **No tool hallucination checks** — the most commonly missed eval dimension; agents fabricating tool calls is a silent failure
- **Aggregate pass rate hiding per-scenario regressions** — a drop from 90% to 70% in one scenario is invisible in the aggregate
- **Using the same LLM as judge that you're evaluating** — model-as-judge should use a different (ideally stronger) model

## Integration

- Use with `ai-harness` (general eval infrastructure) — agentic-eval adds the agent-specific trajectory layer on top of the golden dataset and CI patterns from ai-harness
- Use with `llm-evaluation` (eval frameworks overview) — agentic-eval is the agent-specific specialization of those general frameworks
- Use with `agentic-ai-patterns` for understanding what correct trajectories look like before writing expected trajectory specs
- Use with `llm-observability` to mirror eval metrics into production monitoring for drift detection
- Agent: `@ai-evaluator` uses this skill for all agent quality and regression work
