#!/usr/bin/env bash
# convert.sh — Convert magic-powers agents for other AI coding tools
set -euo pipefail
REPO="$(cd "$(dirname "$0")/.." && pwd)"

find_agents() { find "$REPO/agents" -name "*.md" -type f | sort; }

strip_frontmatter() { awk '/^---$/{c++; next} c>=2' "$1"; }

get_field() { grep "^$2:" "$1" 2>/dev/null | head -1 | sed "s/^$2: *\"*//;s/\"*$//"; }

convert_cursor() {
  local out="$REPO/integrations/cursor/rules"
  mkdir -p "$out"
  for f in $(find_agents); do
    local name=$(basename "$f" .md)
    local desc=$(get_field "$f" description)
    { echo "---"; echo "description: $desc"; echo "globs: []"; echo "alwaysApply: false"; echo "---"; echo ""; strip_frontmatter "$f"; } > "$out/${name}.mdc"
  done
  echo "Cursor: $(find_agents | wc -l) rules → integrations/cursor/rules/"
}

convert_copilot() {
  local out="$REPO/integrations/copilot/agents"
  mkdir -p "$out"
  for f in $(find_agents); do cp "$f" "$out/"; done
  echo "Copilot: $(find_agents | wc -l) agents → integrations/copilot/agents/"
}

convert_aider() {
  mkdir -p "$REPO/integrations/aider"
  { echo "# Magic Powers — Agent Conventions"; echo "";
    for f in $(find_agents); do
      echo "## $(basename "$f" .md)"; echo ""; strip_frontmatter "$f"; echo ""; echo "---"; echo ""
    done
  } > "$REPO/integrations/aider/CONVENTIONS.md"
  echo "Aider: integrations/aider/CONVENTIONS.md"
}

convert_windsurf() {
  mkdir -p "$REPO/integrations/windsurf"
  { echo "# Magic Powers — Agent Rules"; echo "";
    for f in $(find_agents); do
      echo "## $(basename "$f" .md)"; echo ""; strip_frontmatter "$f"; echo ""
    done
  } > "$REPO/integrations/windsurf/.windsurfrules"
  echo "Windsurf: integrations/windsurf/.windsurfrules"
}

convert_gemini() {
  for f in $(find_agents); do
    local name=$(basename "$f" .md)
    local desc=$(get_field "$f" description)
    local dir="$REPO/integrations/gemini-cli/skills/magic-${name}"
    mkdir -p "$dir"
    { echo "---"; echo "name: magic-${name}"; echo "description: $desc"; echo "---"; echo ""; strip_frontmatter "$f"; } > "$dir/SKILL.md"
  done
  echo "Gemini CLI: $(find_agents | wc -l) skills → integrations/gemini-cli/skills/"
}

case "${1:-all}" in
  all)     convert_cursor; convert_copilot; convert_aider; convert_windsurf; convert_gemini ;;
  cursor)  convert_cursor ;;
  copilot) convert_copilot ;;
  aider)   convert_aider ;;
  windsurf) convert_windsurf ;;
  gemini)  convert_gemini ;;
  *) echo "Usage: $0 [all|cursor|copilot|aider|windsurf|gemini]"; exit 1 ;;
esac
echo "Done! Run ./scripts/install.sh to install into your tool."
