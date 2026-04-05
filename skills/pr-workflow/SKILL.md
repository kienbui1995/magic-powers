---
name: pr-workflow
description: Use when creating pull requests - PR structure, description templates, review checklist, merge strategies, branch naming
---

# PR Workflow

## Overview

Good PRs are small, well-described, and easy to review. A PR is a communication tool, not just a code delivery mechanism.

## When to Use

- Creating a pull request
- Reviewing PR size and structure
- Setting up PR templates and branch policies
- Choosing merge strategy

## PR Size Rules

| Size | Lines Changed | Review Time | Quality |
|------|--------------|-------------|---------|
| ✅ Small | <200 | 15 min | Best reviews |
| ⚠️ Medium | 200-400 | 30 min | Acceptable |
| ❌ Large | >400 | 60+ min | Rubber-stamp risk |

**If PR is too large:** split into stacked PRs (infra → logic → UI).

## PR Description Template

```markdown
## What
Brief description of the change.

## Why
Link to issue/ticket. Context on why this approach.

## How
Key implementation decisions. What reviewers should focus on.

## Testing
- [ ] Unit tests added/updated
- [ ] Manual testing done
- [ ] Edge cases considered

## Screenshots
(if UI change)
```

## Branch Naming

```
feature/TICKET-123-add-user-auth
fix/TICKET-456-null-pointer-login
chore/update-dependencies
docs/api-authentication-guide
```

## Merge Strategies

| Strategy | History | Use When |
|----------|---------|----------|
| **Squash merge** | Clean, 1 commit per PR | Default for most teams |
| **Merge commit** | Preserves all commits | Need full history |
| **Rebase** | Linear history | Small teams, clean commits |

## Review Checklist (for reviewers)

- [ ] Does the code do what the PR description says?
- [ ] Are there tests for the changes?
- [ ] No obvious security issues (SQL injection, XSS, auth bypass)
- [ ] No hardcoded secrets or config
- [ ] Error handling present
- [ ] Naming is clear and consistent

## Anti-Patterns

| Pattern | Fix |
|---------|-----|
| "WIP" PRs open for days | Use draft PRs, keep them short-lived |
| No description | Require PR template |
| Mixing refactor + feature | Separate PRs |
| Approving without reading | Use review checklist |

## Integration

- **magic-powers:requesting-code-review** — how to ask for effective reviews
- **magic-powers:receiving-code-review** — how to respond to feedback
- **magic-powers:finishing-a-development-branch** — merge and cleanup workflow
- **magic-powers:ci-cd-pipeline** — CI must pass before merge
