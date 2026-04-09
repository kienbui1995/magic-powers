#!/usr/bin/env bash
# Version audit — ensures version is consistent across all files
set -euo pipefail

ISSUES=0
SOURCE_VERSION=$(grep '"version"' package.json | head -1 | sed 's/.*: *"//;s/".*//')

echo "Version Audit"
echo "============="
echo "Source version (package.json): $SOURCE_VERSION"
echo ""

check_version() {
  local file="$1"
  local pattern="$2"
  local found=$(grep -oE "$pattern" "$file" 2>/dev/null | head -1)
  if [ -z "$found" ]; then
    echo "WARN $file: version not found"
  elif echo "$found" | grep -q "$SOURCE_VERSION"; then
    echo "OK   $file"
  else
    echo "FAIL $file: found '$found' (expected $SOURCE_VERSION)"
    ISSUES=$((ISSUES + 1))
  fi
}

check_version ".claude-plugin/plugin.json" '[0-9]+\.[0-9]+\.[0-9]+'
check_version "site/index.html"            'v[0-9]+\.[0-9]+\.[0-9]+'
check_version "CHANGELOG.md"               '\['"$SOURCE_VERSION"'\]'

# Check skill count consistency
SKILL_COUNT=$(find skills/ -name "SKILL.md" | wc -l)
README_COUNT=$(grep -oE '[0-9]+ Skills' README.md | head -1 | grep -oE '[0-9]+')
SITE_COUNT=$(grep -oE 'stat-num">[0-9]+' site/index.html | head -2 | tail -1 | grep -oE '[0-9]+')

echo ""
echo "Skill count: $SKILL_COUNT actual"
if [ "$README_COUNT" != "$SKILL_COUNT" ]; then
  echo "FAIL README.md: says $README_COUNT skills"
  ISSUES=$((ISSUES + 1))
else
  echo "OK   README.md: $README_COUNT"
fi
if [ "$SITE_COUNT" != "$SKILL_COUNT" ]; then
  echo "FAIL site/index.html: says $SITE_COUNT skills"
  ISSUES=$((ISSUES + 1))
else
  echo "OK   site/index.html: $SITE_COUNT"
fi

echo ""
if [ "$ISSUES" -gt 0 ]; then
  echo "FAILED -- $ISSUES inconsistencies"
  exit 1
else
  echo "PASSED -- all versions and counts consistent"
fi
