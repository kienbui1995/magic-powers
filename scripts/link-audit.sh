#!/usr/bin/env bash
# Link audit — validates magic-powers:* references in skills and agents
# Covers flat skills, nested division skills, and agent files
set -euo pipefail

ISSUES=0
TOTAL=0

echo "Link Audit"
echo "=========="

check_refs_in_file() {
  local file="$1"
  # Extract all magic-powers:* references (supports nested paths like cloud/gcp/bigquery-optimization)
  while IFS= read -r ref; do
    TOTAL=$((TOTAL + 1))
    local skill_path
    skill_path=$(echo "$ref" | sed 's/.*magic-powers://' | sed 's/[^a-z0-9\/\-].*//')
    if [ ! -d "skills/$skill_path" ]; then
      echo "FAIL $file: broken ref 'magic-powers:$skill_path'"
      ISSUES=$((ISSUES + 1))
    fi
  done < <(grep -oE 'magic-powers:[a-z][-a-z0-9/]+' "$file" 2>/dev/null || true)
}

# Flat optional skills
for file in skills/*/SKILL.md; do
  [ -f "$file" ] && check_refs_in_file "$file"
done

# Nested division skills (cloud, amplitude, browser-extension)
for file in skills/*/*/SKILL.md skills/*/*/*/SKILL.md; do
  [ -f "$file" ] && check_refs_in_file "$file"
done

# All agent files (flat root + subdirectories: cloud, amplitude, ai, etc.)
while IFS= read -r file; do
  check_refs_in_file "$file"
done < <(find agents/ -name "*.md" -type f | xargs grep -l "^name:" 2>/dev/null)

echo ""
if [ "$ISSUES" -gt 0 ]; then
  echo "FAILED -- $TOTAL refs checked, $ISSUES broken"
  exit 1
else
  echo "PASSED -- $TOTAL refs checked, all valid"
fi
