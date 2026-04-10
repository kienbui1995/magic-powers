---
name: claude-hooks
description: Use when automating Claude Code workflows with hooks — PreToolUse (validate/block actions), PostToolUse (react to completions), Stop (enforce standards before finishing), and SessionStart (load context). Configure in .claude/settings.json.
---

# Claude Hooks

## Overview

Hooks let you automate Claude Code: run tests automatically after edits, block dangerous operations, enforce quality gates before Claude declares done. Without hooks, Claude relies purely on its training and your instructions. With hooks, you build enforced guardrails and automation into the workflow itself.

## When to Use

- Want Claude Code to auto-run tests after editing files
- Need to prevent certain risky operations (e.g., `rm -rf`, force push)
- Want to auto-format code whenever Claude edits files
- Need to log or audit all Claude Code actions
- Want to enforce quality checks before Claude finishes a task

## Core Jobs

### 1. Hook Types

| Hook | When it fires | Use for |
|------|--------------|---------|
| `SessionStart` | Every new Claude Code session | Load context, greet, check state |
| `PreToolUse` | Before ANY tool executes | Validate, block, or modify tool calls |
| `PostToolUse` | After tool executes | React to changes, run follow-ups |
| `Stop` | When Claude finishes responding | Enforce done-criteria before Claude stops |

### 2. Configuring Hooks (.claude/settings.json)

```json
{
  "hooks": {
    "PreToolUse": [{
      "matcher": "Bash",
      "hooks": [{
        "type": "command",
        "command": "bash .claude/hooks/validate-bash.sh '$CLAUDE_TOOL_INPUT'"
      }]
    }],
    "PostToolUse": [{
      "matcher": "Edit|Write",
      "hooks": [{
        "type": "command",
        "command": "bash .claude/hooks/post-edit.sh",
        "async": true
      }]
    }],
    "Stop": [{
      "hooks": [{
        "type": "command",
        "command": "bash .claude/hooks/enforce-done.sh"
      }]
    }]
  }
}
```

### 3. Practical Hook Examples

**Block dangerous bash commands (PreToolUse):**

```bash
#!/bin/bash
# .claude/hooks/validate-bash.sh
INPUT="$1"

# Block destructive operations
if echo "$INPUT" | grep -qE "rm -rf|DROP TABLE|git push --force"; then
    echo "BLOCKED: Destructive operation requires explicit confirmation"
    exit 1  # Exit code 1 = block the tool, show error to Claude
fi

exit 0  # Exit code 0 = allow
```

**Auto-run tests after file edits (PostToolUse):**

```bash
#!/bin/bash
# .claude/hooks/post-edit.sh - runs async (doesn't block Claude)
CHANGED_FILE="$CLAUDE_TOOL_RESULT"

if [[ "$CHANGED_FILE" == *.py ]]; then
    cd "$(git rev-parse --show-toplevel)"
    python -m pytest tests/ -x -q --tb=short 2>&1 | tail -20
fi
```

**Enforce test passing before finishing (Stop):**

```bash
#!/bin/bash
# .claude/hooks/enforce-done.sh
if git diff --name-only | grep -q "\.py$"; then
    echo "Running tests before declaring done..."
    if ! python -m pytest tests/ -x -q; then
        echo "Tests failing — cannot mark task complete"
        exit 1  # Blocks Claude from stopping, forces it to fix tests
    fi
fi
exit 0
```

### 4. Hook Environment Variables

Available in hook scripts:

```bash
CLAUDE_TOOL_NAME        # Name of tool being called (Bash, Edit, Write, etc.)
CLAUDE_TOOL_INPUT       # Input to the tool (command being run, file path, etc.)
CLAUDE_TOOL_RESULT      # Result of tool execution (PostToolUse only)
CLAUDE_SESSION_ID       # Current session ID
CLAUDE_PLUGIN_ROOT      # Path to magic-powers plugin root
```

## Key Concepts

- **PreToolUse hook** — intercepts tool calls before execution; exit 1 = block, exit 0 = allow
- **PostToolUse hook** — runs after tool completion; `async: true` means non-blocking
- **Stop hook** — runs when Claude finishes; exit 1 = force Claude to continue working
- **Matcher** — regex or tool name that determines when hook fires
- **Hook chaining** — multiple hooks can fire for the same event in sequence

## Checklist

- [ ] `.claude/settings.json` exists in project?
- [ ] Dangerous commands blocked with PreToolUse hook?
- [ ] Tests run automatically after code edits (PostToolUse)?
- [ ] Stop hook enforces done-criteria (tests pass, lint clean)?
- [ ] Hooks committed to repo so team benefits too?
- [ ] Async hooks used for slow operations (don't block Claude)?

## Key Outputs

- `.claude/settings.json`: hooks configuration
- `.claude/hooks/` directory: shell scripts for each hook behavior
- Documented hook behaviors in CLAUDE.md

## Output Format

- 🔴 **Critical** — no hooks configured (no safety net, no automation), hooks blocking Claude unnecessarily (overly strict PreToolUse that never allows anything)
- 🟡 **Warning** — hooks not committed to repo (team doesn't benefit), synchronous hooks for slow operations (blocks Claude mid-task)
- 🟢 **Suggestion** — add auto-format hook (PostToolUse on Edit), add Stop hook enforcing tests pass, block common accidents (force push, DROP TABLE)

## Anti-Patterns

- Hooks that always exit 1 (defeats the purpose — Claude can't do any work)
- Slow operations in synchronous hooks (use `async: true` for anything taking >1s)
- Not committing hooks to repo (only you benefit, not the team)
- Complex hooks with no error handling (hooks that crash silently, allowing everything)

## Integration

- Use with `claude-md-authoring` (document hook behaviors in CLAUDE.md so team understands them)
- Use with `claude-project-settings` (hooks configured in same settings.json)
- Agent: `@debugger` can help debug why hooks are firing unexpectedly
