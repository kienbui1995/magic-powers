#!/usr/bin/env bash
# Sync audit — ensures integrations match skills/ + agents/ count
set -euo pipefail

SKILLS=$(ls skills/ | wc -l)
AGENTS=$(ls agents/ | wc -l)
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
