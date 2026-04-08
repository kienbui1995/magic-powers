#!/usr/bin/env bash
# Validates new optional skill files have required frontmatter and sections
# Skips the 43 original built-in skills (they use a different format)

SKILLS_DIR="$(dirname "$0")/../skills"
ERRORS=0

# Original 43 built-in skills — skip these
BUILTIN_SKILLS=(
  accessibility-compliance agentic-ai-patterns ai-safety-guardrails
  api-design authentication-patterns brainstorming caching-strategy
  ci-cd-pipeline cost-aware-routing database-optimization dependency-management
  design-with-pencil design-with-stitch dispatching-parallel-agents
  docker-containerization environment-setup executing-plans
  finishing-a-development-branch incident-response infrastructure-review
  llm-evaluation llm-observability mvp-rapid-development open-source-project
  performance-optimization prompt-engineering pr-workflow product-strategy
  rag-architecture receiving-code-review refactoring requesting-code-review
  security-review spec-driven-development subagent-driven-development
  systematic-debugging technical-writing test-driven-development
  using-git-worktrees using-magic-powers verification-before-completion
  writing-plans writing-skills
)

is_builtin() {
  local name="$1"
  for builtin in "${BUILTIN_SKILLS[@]}"; do
    [ "$builtin" = "$name" ] && return 0
  done
  return 1
}

NEW_COUNT=0
for skill_dir in "$SKILLS_DIR"/*/; do
  skill_file="$skill_dir/SKILL.md"
  name=$(basename "$skill_dir")

  # Skip built-in skills
  if is_builtin "$name"; then
    continue
  fi

  # Skip namespace directories (contain subdirectories but no SKILL.md)
  if [ ! -f "$skill_file" ] && ls -d "$skill_dir"*/ 2>/dev/null | head -1 | grep -q .; then
    continue
  fi

  NEW_COUNT=$((NEW_COUNT + 1))

  if [ ! -f "$skill_file" ]; then
    echo "MISSING: $name/SKILL.md"
    ERRORS=$((ERRORS + 1))
    continue
  fi

  if ! grep -q "^name:" "$skill_file"; then
    echo "MISSING frontmatter 'name:' in $name"
    ERRORS=$((ERRORS + 1))
  fi

  if ! grep -q "^description:" "$skill_file"; then
    echo "MISSING frontmatter 'description:' in $name"
    ERRORS=$((ERRORS + 1))
  fi

  if ! grep -q "## When to Use" "$skill_file"; then
    echo "MISSING '## When to Use' in $name"
    ERRORS=$((ERRORS + 1))
  fi

  if ! grep -q "## Core Jobs" "$skill_file"; then
    echo "MISSING '## Core Jobs' in $name"
    ERRORS=$((ERRORS + 1))
  fi

  if ! grep -q "## Key Outputs" "$skill_file"; then
    echo "MISSING '## Key Outputs' in $name"
    ERRORS=$((ERRORS + 1))
  fi

  if ! grep -q "## Anti-Patterns" "$skill_file"; then
    echo "MISSING '## Anti-Patterns' in $name"
    ERRORS=$((ERRORS + 1))
  fi
done

# Cloud Division skills — use cloud schema (Key Concepts, Checklist, Output Format, Exam Tips)
CLOUD_COUNT=0
for cloud_skill_dir in "$SKILLS_DIR"/cloud/*/*/; do
  [ -d "$cloud_skill_dir" ] || continue
  skill_file="$cloud_skill_dir/SKILL.md"
  provider=$(basename "$(dirname "$cloud_skill_dir")")
  name=$(basename "$cloud_skill_dir")
  label="cloud/$provider/$name"

  CLOUD_COUNT=$((CLOUD_COUNT + 1))

  if [ ! -f "$skill_file" ]; then
    echo "MISSING: $label/SKILL.md"
    ERRORS=$((ERRORS + 1))
    continue
  fi

  if ! grep -q "^name:" "$skill_file"; then
    echo "MISSING frontmatter 'name:' in $label"
    ERRORS=$((ERRORS + 1))
  fi

  if ! grep -q "^description:" "$skill_file"; then
    echo "MISSING frontmatter 'description:' in $label"
    ERRORS=$((ERRORS + 1))
  fi

  if ! grep -q "## When to Use" "$skill_file"; then
    echo "MISSING '## When to Use' in $label"
    ERRORS=$((ERRORS + 1))
  fi

  if ! grep -q "## Core Jobs" "$skill_file"; then
    echo "MISSING '## Core Jobs' in $label"
    ERRORS=$((ERRORS + 1))
  fi

  if ! grep -q "## Exam Tips" "$skill_file"; then
    echo "MISSING '## Exam Tips' in $label"
    ERRORS=$((ERRORS + 1))
  fi
done

TOTAL=$((NEW_COUNT + CLOUD_COUNT))
if [ $ERRORS -eq 0 ]; then
  echo "✅ All $NEW_COUNT optional skills valid + $CLOUD_COUNT cloud division skills valid ($TOTAL total)"
else
  echo "❌ $ERRORS error(s) found across $TOTAL skills"
  exit 1
fi
