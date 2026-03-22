---
name: using-git-worktrees
description: Use when starting feature work that needs isolation from current workspace or before executing implementation plans
---

# Using Git Worktrees

## Overview

Git worktrees create isolated workspaces sharing the same repository, allowing work on multiple branches simultaneously without switching.

**Core principle:** Systematic directory selection + safety verification = reliable isolation.

## Directory Selection

Follow this priority order:

### 1. Check Existing Directories
```bash
ls -d .worktrees 2>/dev/null     # Preferred (hidden)
ls -d worktrees 2>/dev/null      # Alternative
```
If found, use that directory. If both exist, `.worktrees` wins.

### 2. Check CLAUDE.md / Project Config
Look for worktree directory preferences in project configuration.

### 3. Create Default
```bash
mkdir -p .worktrees
```

## Creating a Worktree

```bash
# Create branch and worktree
git worktree add .worktrees/<feature-name> -b <feature-branch>

# Verify
cd .worktrees/<feature-name>
git branch  # Should show feature branch
pwd         # Should be in worktree
```

## Safety Verification

After creating, verify:
1. ✅ Correct branch checked out
2. ✅ Clean working directory
3. ✅ Can run tests independently
4. ✅ Not on main/master branch

## Cleanup

After merging:
```bash
git worktree remove .worktrees/<feature-name>
git branch -d <feature-branch>
```

## Integration

- **magic-powers:brainstorming** — creates worktree for implementation
- **magic-powers:executing-plans** — requires worktree before starting
- **magic-powers:finishing-a-development-branch** — cleanup after merge
