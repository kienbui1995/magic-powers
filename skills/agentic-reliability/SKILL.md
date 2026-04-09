---
name: agentic-reliability
description: Use when designing reliable AI agent systems — retry strategies, circuit breakers, fallbacks, graceful degradation, timeout management, and handling compound failures in multi-step agent workflows.
---

# Agentic Reliability

## Overview

Agent systems fail differently than single API calls. Failures compound multiplicatively across steps, a stuck loop can run indefinitely, and a single slow dependency can freeze the entire pipeline. Reliability must be designed in — it cannot be bolted on after the fact.

## When to Use

- An agent calls external APIs that can fail or rate-limit
- Building multi-step agent workflows where failures compound
- Designing fallback behavior when an AI model is unavailable
- Agent loops that can get stuck or run indefinitely
- Production agents that must degrade gracefully, not crash

## Core Jobs

### 1. The Compounding Failure Problem

Agent reliability compounds multiplicatively — unlike single LLM calls:

```
5 steps, each 99% reliable  →  0.99^5  = 95% system reliability
10 steps, each 99% reliable →  0.99^10 = 90% system reliability
20 steps, each 99% reliable →  0.99^20 = 82% system reliability
```

**Implication:** Each component must be extremely reliable individually, or agent system reliability collapses. Target 99.9% per step for a 10-step workflow to achieve 99% system reliability. This is why agent reliability engineering is harder than regular API reliability.

### 2. Retry Strategy

```python
import asyncio
from tenacity import retry, stop_after_attempt, wait_exponential, retry_if_exception_type

@retry(
    stop=stop_after_attempt(3),
    wait=wait_exponential(multiplier=1, min=1, max=10),
    retry=retry_if_exception_type((RateLimitError, TimeoutError, APIConnectionError)),
    reraise=True
)
async def call_llm_with_retry(prompt: str, model: str) -> LLMResponse:
    return await llm.call(prompt, model=model, timeout=30)

# Different retry strategies by error type
RETRY_STRATEGIES = {
    "rate_limit":   {"max_attempts": 5, "base_delay": 2,   "max_delay": 60},
    "timeout":      {"max_attempts": 2, "base_delay": 0,   "max_delay": 0},   # fast fail
    "server_error": {"max_attempts": 3, "base_delay": 1,   "max_delay": 10},
    "connection":   {"max_attempts": 3, "base_delay": 0.5, "max_delay": 5},
}
```

**Never retry:** Validation errors (400), authorization errors (401/403) — retrying wastes time and money.
**Always retry with backoff:** Rate limits (429), timeouts, transient server errors (500/503).

### 3. Circuit Breaker

Prevent cascading failures by temporarily stopping calls to a failing service:

```python
class AgentCircuitBreaker:
    def __init__(self, failure_threshold=5, recovery_timeout=60, success_threshold=2):
        self.state = "closed"  # closed=normal, open=failing, half_open=testing
        self.failure_count = 0
        self.failure_threshold = failure_threshold
        self.recovery_timeout = recovery_timeout
        self.last_failure_time = None
        self.success_count = 0
        self.success_threshold = success_threshold

    def call(self, fn, *args, **kwargs):
        if self.state == "open":
            if time.time() - self.last_failure_time > self.recovery_timeout:
                self.state = "half_open"  # try one request
            else:
                raise CircuitOpenError("Service temporarily unavailable")

        try:
            result = fn(*args, **kwargs)
            self._on_success()
            return result
        except Exception as e:
            self._on_failure()
            raise

    def _on_success(self):
        if self.state == "half_open":
            self.success_count += 1
            if self.success_count >= self.success_threshold:
                self.state = "closed"
                self.failure_count = 0

    def _on_failure(self):
        self.failure_count += 1
        self.last_failure_time = time.time()
        if self.failure_count >= self.failure_threshold:
            self.state = "open"
            alert(f"Circuit breaker opened for service")
```

**Production thresholds:** Open after 5 failures in 60 seconds. Attempt recovery after 60 seconds. Close after 2 consecutive successes. Expose circuit state in your observability dashboard — patterns in circuit events reveal infrastructure problems.

### 4. Fallbacks & Graceful Degradation

Design every agent action with a fallback:

```python
class AgentWithFallbacks:
    def search_web(self, query: str) -> SearchResult:
        try:
            return primary_search_api.search(query)
        except SearchAPIError:
            try:
                return fallback_search_api.search(query)  # secondary provider
            except Exception:
                return SearchResult(
                    source="cache",
                    results=self.search_cache.get(query, []),
                    degraded=True  # flag that this is stale/incomplete
                )

    def generate_response(self, prompt: str) -> str:
        for model in ["claude-opus-4-5", "claude-sonnet-4-6", "claude-haiku-4-5"]:
            try:
                return llm.call(prompt, model=model)
            except ModelUnavailableError:
                continue  # try next model
        # All models failed — return cached or template response
        return self.get_cached_response(prompt) or "Service temporarily unavailable."
```

**Degradation tiers:**
1. Primary path (full quality)
2. Secondary provider (same quality, different vendor)
3. Cached response (stale but available)
4. Template response (predetermined, no AI)
5. Graceful error (clear user message, no crash)

Always set `degraded=True` on fallback responses. Callers need to know the response quality is reduced.

### 5. Timeout Management

```python
import asyncio

class AgentTimeoutManager:
    TIMEOUTS = {
        "llm_call":       30,    # 30 seconds for LLM response
        "tool_execution": 10,    # 10 seconds for tool calls
        "web_search":     5,     # 5 seconds for web search
        "agent_task":     120,   # 2 minutes for full task
        "human_approval": 3600,  # 1 hour for human input
    }

    async def with_timeout(self, operation_type: str, coro):
        timeout = self.TIMEOUTS.get(operation_type, 30)
        try:
            return await asyncio.wait_for(coro, timeout=timeout)
        except asyncio.TimeoutError:
            raise AgentTimeoutError(
                f"{operation_type} exceeded {timeout}s timeout",
                operation=operation_type,
                timeout=timeout
            )
```

**Never use infinite timeouts.** Always set explicit timeouts on every external call. A single hanging tool call can freeze an entire agent pipeline indefinitely.

### 6. Loop Detection & Step Limits

Agents can get stuck in infinite loops — detect and break:

```python
class LoopSafeAgent:
    MAX_STEPS = 20
    MAX_LOOPS = 3  # same action repeated

    def run(self, task: str) -> AgentResult:
        steps = []
        action_history = Counter()

        for step_num in range(self.MAX_STEPS):
            action = self.decide_next_action(task, steps)

            # Detect repeated actions
            action_key = f"{action.tool}:{hash(str(action.params))}"
            action_history[action_key] += 1

            if action_history[action_key] > self.MAX_LOOPS:
                return AgentResult(
                    status="stuck",
                    message=f"Agent stuck in loop: {action.tool} repeated {self.MAX_LOOPS} times",
                    steps_taken=steps,
                    partial_result=self.extract_partial_result(steps)
                )

            result = self.execute(action)
            steps.append(Step(action, result))

            if self.is_complete(result):
                return AgentResult(status="success", steps_taken=steps, result=result)

        # Max steps reached — return partial result, not a crash
        return AgentResult(
            status="max_steps_reached",
            steps_taken=steps,
            partial_result=self.extract_partial_result(steps)
        )
```

Always return a partial result when hitting step limits. Hard crashes leave users with no information about what was accomplished before the limit was reached.

### 7. Partial Result Extraction

When an agent cannot complete fully, extract what was done:

```python
def extract_partial_result(steps: list[Step]) -> PartialResult:
    """Return useful output even from an incomplete agent run"""
    completed_steps = [s for s in steps if s.status == "success"]
    findings = [s.result for s in completed_steps if s.result is not None]

    return PartialResult(
        completed_count=len(completed_steps),
        total_attempted=len(steps),
        findings=findings,
        last_successful_step=completed_steps[-1].name if completed_steps else None,
        resumable=True,  # can be retried with context from this partial result
        summary=f"Completed {len(completed_steps)}/{len(steps)} steps before stopping."
    )
```

## Key Concepts

- **Circuit breaker** — stops calling a failing service temporarily; prevents cascade failures where one slow dependency brings down the whole pipeline
- **Retry with backoff** — exponential delay between retries; reduces thundering herd and gives the failing service time to recover
- **Graceful degradation** — agent continues with reduced capability when a component fails; partial value beats total failure
- **Timeout** — maximum time to wait for any operation; never use infinite timeouts in production agents
- **Loop detection** — count repeated actions; break after MAX_LOOPS repetitions of the same tool+params combination
- **Step limit** — maximum agent steps; prevents runaway execution, unbounded cost, and infinite loops
- **Fallback chain** — ordered list of alternatives to try when primary fails; each tier reduces quality but maintains availability
- **Partial result** — return what was completed even if task didn't finish; always better than a crash with no output

## Checklist

- [ ] Every external API call has explicit timeout set?
- [ ] Retry logic with exponential backoff for transient errors?
- [ ] Circuit breaker configured for each external service dependency?
- [ ] Fallback defined for each critical agent action?
- [ ] Max steps limit set and enforced (hard cap, not advisory)?
- [ ] Loop detection implemented (repeated action counter per tool+params)?
- [ ] Partial results returned when agent hits step limit or gets stuck?
- [ ] Different retry strategies for different error types (no retry for 400/401/403)?
- [ ] Circuit breaker state exposed in observability dashboard?
- [ ] Degraded responses flagged so callers know quality is reduced?

## Key Outputs

- Reliability design doc: retry strategies per error type, circuit breaker thresholds, fallback chains per action
- Timeout budget per operation type (LLM call, tool call, full task, human approval)
- Graceful degradation tiers: what the agent can still do if X fails

## Output Format

- 🔴 **Critical** — no timeouts (agent hangs forever on slow dependency), no step limit (infinite loop risk with unbounded cost), no retry on transient errors (unnecessary failures on rate limits and brief outages)
- 🟡 **Warning** — same retry strategy for all error types (retrying 400s wastes money), no circuit breaker (one degraded service cascades to full pipeline failure), no fallback defined (hard fail on primary failure with no recovery path)
- 🟢 **Suggestion** — implement partial result extraction for interrupted tasks so users get value even from incomplete runs, add reliability dashboard tracking circuit breaker state and retry rates per service

## Anti-Patterns

- **Infinite timeout on LLM calls** — one slow model response hangs the entire agent pipeline; always set explicit timeouts
- **Retrying authentication errors** — a 401 won't fix itself with retries; wastes time and burns through rate limits
- **No circuit breaker** — one slow or failing service degrades the entire agent, even for tasks that don't need it
- **Hard crash on step limit** — return partial result with status instead; users need to know what was completed
- **Logging only failures** — log retries and circuit state transitions too; they reveal reliability trends before full outages
- **Same fallback for all failure types** — tailor fallback to failure mode (model unavailable vs. rate limit vs. timeout need different responses)
- **Optimistic step counting** — counting only successful steps toward MAX_STEPS; failed steps must count too or a stuck agent can retry indefinitely

## Integration

- Use with `agentic-ai-patterns` for integrating reliability patterns into agent loop design (where to place retries, circuit breakers, and checkpoints in the observe-think-act cycle)
- Use with `llm-observability` for monitoring retry rates, circuit breaker state transitions, timeout frequency, and step limit hits in production
- Use with `agentic-security` — reliability mechanisms can be exploited (e.g., deliberately flooding requests to trigger circuit breakers as a denial-of-service)
- Agent: `@ai-engineer` uses this skill when building production agent systems; `@sre` uses this for reliability reviews of existing agent infrastructure
