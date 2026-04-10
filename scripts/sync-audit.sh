#!/usr/bin/env bash
# Sync audit — ensures integrations match skills/ + agents/ count
set -euo pipefail

SKILLS=$(find skills/ -name "SKILL.md" | wc -l)
AGENTS=$(find agents/ -name "*.md" -type f | xargs grep -l "^name:" 2>/dev/null | wc -l)
EXPECTED=$((SKILLS + AGENTS))
ISSUES=0

echo "Sync Audit"
echo "=========="
echo "Source: $SKILLS skills + $AGENTS agents = $EXPECTED total"
echo ""

check_integration() {
  local name="$1"
  local dir="$2"
  local count=$(ls "$dir" | wc -l)
  if [ "$count" -ne "$EXPECTED" ]; then
    echo "FAIL $name: $count files (expected $EXPECTED)"
    ISSUES=$((ISSUES + 1))
  else
    echo "OK   $name: $count files"
  fi
}

check_integration "kiro"       "integrations/kiro/steering"

# Kiro native agent JSONs (one per named agent)
kiro_json_count=$(ls "integrations/kiro/agents/" 2>/dev/null | wc -l | tr -d ' ')
if [ "$kiro_json_count" -ne "$AGENTS" ]; then
  echo "FAIL kiro-agents: $kiro_json_count JSON files (expected $AGENTS)"
  ISSUES=$((ISSUES + 1))
else
  echo "OK   kiro-agents: $kiro_json_count native agent JSON files"
fi

check_integration "cursor"     "integrations/cursor/rules"
check_integration "copilot"    "integrations/copilot/agents"
check_integration "gemini-cli" "integrations/gemini-cli/skills"
check_integration "codex"      "integrations/codex/skills"

echo ""
if [ "$ISSUES" -gt 0 ]; then
  echo "FAILED -- $ISSUES integration(s) out of sync. Run: bash scripts/convert.sh all"
  exit 1
else
  echo "PASSED -- all integrations in sync"
fi
