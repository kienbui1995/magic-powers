#!/usr/bin/env bash
# Link audit — validates cross-references between skills
set -euo pipefail

ISSUES=0
TOTAL=0

echo "Link Audit"
echo "=========="

for file in skills/*/SKILL.md; do
  [ -f "$file" ] || continue
  # Find magic-powers:skill-name references
  while IFS= read -r ref; do
    TOTAL=$((TOTAL + 1))
    skill=$(echo "$ref" | sed 's/.*magic-powers://' | sed 's/[^a-z0-9-].*//')
    if [ ! -d "skills/$skill" ]; then
      echo "FAIL $file: broken ref 'magic-powers:$skill'"
      ISSUES=$((ISSUES + 1))
    fi
  done < <(grep -oE 'magic-powers:[a-z][-a-z0-9]+' "$file" 2>/dev/null || true)
done

echo ""
if [ "$ISSUES" -gt 0 ]; then
  echo "FAILED -- $TOTAL refs checked, $ISSUES broken"
  exit 1
else
  echo "PASSED -- $TOTAL refs checked, all valid"
fi
