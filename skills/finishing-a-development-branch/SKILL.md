---
name: finishing-a-development-branch
description: Use when implementation is complete, all tests pass, and you need to decide how to integrate the work
---

# Finishing a Development Branch

## Overview

Guide completion of development work by presenting clear options and handling chosen workflow.

**Core principle:** Verify tests → Present options → Execute choice → Clean up.

## The Process

### Step 1: Verify Tests

```bash
# Run project's test suite
npm test / cargo test / pytest / go test ./...
```

If tests fail: fix before proceeding. Use magic-powers:systematic-debugging if needed.

### Step 2: Present Options

> "All tests pass. How would you like to integrate this work?
>
> 1. **Merge to main** — squash merge, delete branch
> 2. **Create PR** — push branch, open pull request
> 3. **Keep branch** — leave as-is for now
> 4. **Other** — describe your workflow"

### Step 3: Execute Choice

**Merge to main:**
```bash
git checkout main
git merge --squash <feature-branch>
git commit -m "feat: <description>"
git branch -d <feature-branch>
```

**Create PR:**
```bash
git push -u origin <feature-branch>
# Provide PR description with: what changed, why, how to test
```

### Step 4: Clean Up

- Remove worktree if used: `git worktree remove .worktrees/<name>`
- Delete local branch if merged
- Verify main is clean

## Integration

- **magic-powers:verification-before-completion** — verify before merge
- **magic-powers:using-git-worktrees** — cleanup worktree
- **magic-powers:executing-plans** — triggers this after all tasks complete
