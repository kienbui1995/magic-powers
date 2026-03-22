# Example: Building a New Feature End-to-End

This shows how magic-powers agents collaborate on a feature from idea to merge.

## 1. Brainstorm with Architect (Opus)

```
You: @architect I need to add user notifications. Users should get email
and in-app notifications for key events. What's the best approach?
```

Architect explores 3+ approaches, evaluates trade-offs, recommends one.

## 2. Plan with Architect (Opus)

```
You: @architect Write an implementation plan for the event-driven approach.
```

Architect outputs numbered steps with file changes, schema, and API contracts.

## 3. Implement (Main Session — Sonnet)

Follow the plan step by step. The `executing-plans` skill keeps you on track.

## 4. Debug Issues (Sonnet)

```
You: @debugger Tests are failing with "connection refused" on the notification service.
```

Debugger systematically isolates the issue using `systematic-debugging` skill.

## 5. Review (Haiku — cheap!)

```
You: @code-reviewer Review the notification module changes.
You: @security-reviewer Check the notification endpoints for auth issues.
```

Two reviewers run in parallel on Haiku — fast and cheap.

## 6. Merge

```
You: @git-workflow Help me prepare this branch for merge.
```

Git workflow agent checks commit hygiene, suggests squash strategy.

## Cost Breakdown

| Step | Agent | Model | Estimated Cost |
|------|-------|-------|---------------|
| Brainstorm | architect | opus | ~$0.15 |
| Plan | architect | opus | ~$0.20 |
| Implement | main session | sonnet | ~$0.30 |
| Debug | debugger | sonnet | ~$0.10 |
| Review (x2) | code-reviewer + security | haiku | ~$0.02 |
| Git | git-workflow | sonnet | ~$0.05 |
| **Total** | | | **~$0.82** |

Without model routing (all Opus): ~$3.20 — **75% savings**.

> **Note:** Cost figures are estimates based on Anthropic API pricing as of early 2025. Actual costs vary by input/output length. See [Anthropic pricing](https://www.anthropic.com/pricing) for current rates.
