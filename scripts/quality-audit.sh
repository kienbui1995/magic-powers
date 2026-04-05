#!/usr/bin/env bash
# Quality audit — validates skill format, structure, and completeness
set -euo pipefail

EXIT_CODE=0
TOTAL=0
ISSUES=0

check_skill() {
  local file="$1"
  local dir=$(basename $(dirname "$file"))
  TOTAL=$((TOTAL + 1))

  # 1. Has name in frontmatter
  if ! grep -q '^name:' "$file"; then
    echo "FAIL $file: Missing 'name' in frontmatter"
    ISSUES=$((ISSUES + 1))
  fi

  # 2. Has description in frontmatter
  if ! grep -q '^description:' "$file"; then
    echo "FAIL $file: Missing 'description' in frontmatter"
    ISSUES=$((ISSUES + 1))
  fi

  # 3. Name matches folder name
  local name=$(grep '^name:' "$file" | head -1 | sed 's/^name: *//')
  if [ "$name" != "$dir" ]; then
    echo "FAIL $file: name '$name' != folder '$dir'"
    ISSUES=$((ISSUES + 1))
  fi

  # 4. Has at least one heading (## section)
  if ! grep -q '^## ' "$file"; then
    echo "FAIL $file: No ## sections found"
    ISSUES=$((ISSUES + 1))
  fi

  # 5. Not too short (<100 bytes = likely empty/stub)
  local size=$(wc -c < "$file")
  if [ "$size" -lt 100 ]; then
    echo "FAIL $file: Too short (${size} bytes)"
    ISSUES=$((ISSUES + 1))
  fi
}

echo "Skill Quality Audit"
echo "==================="

for file in skills/*/SKILL.md; do
  [ -f "$file" ] && check_skill "$file"
done

echo ""
if [ "$ISSUES" -gt 0 ]; then
  echo "FAILED -- $TOTAL skills, $ISSUES issues"
  exit 1
else
  echo "PASSED -- $TOTAL skills, all valid"
fi
