#!/usr/bin/env bash
# convert.sh — Convert magic-powers agents for other AI coding tools
set -euo pipefail
REPO="$(cd "$(dirname "$0")/.." && pwd)"

find_agents() { find "$REPO/agents" -name "*.md" -type f | sort; }
find_skills() { find "$REPO/skills" -name "SKILL.md" -type f | sort; }

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
  for f in $(find_skills); do
    local name=$(get_field "$f" name)
    local desc=$(get_field "$f" description)
    { echo "---"; echo "description: $desc"; echo "globs: []"; echo "alwaysApply: false"; echo "---"; echo ""; strip_frontmatter "$f"; } > "$out/${name}.mdc"
  done
  echo "Cursor: $(( $(find_agents | wc -l) + $(find_skills | wc -l) )) rules → integrations/cursor/rules/"
}

convert_copilot() {
  local out="$REPO/integrations/copilot/agents"
  mkdir -p "$out"
  for f in $(find_agents); do cp "$f" "$out/"; done
  for f in $(find_skills); do
    local name=$(get_field "$f" name)
    cp "$f" "$out/${name}.md"
  done
  echo "Copilot: $(( $(find_agents | wc -l) + $(find_skills | wc -l) )) files → integrations/copilot/agents/"
}

convert_aider() {
  mkdir -p "$REPO/integrations/aider"
  { echo "# Magic Powers — Agent Conventions & Skills"; echo "";
    echo "## Agents"; echo ""
    for f in $(find_agents); do
      echo "### $(basename "$f" .md)"; echo ""; strip_frontmatter "$f"; echo ""; echo "---"; echo ""
    done
    echo "## Skills"; echo ""
    for f in $(find_skills); do
      local name=$(get_field "$f" name)
      echo "### ${name}"; echo ""; strip_frontmatter "$f"; echo ""; echo "---"; echo ""
    done
  } > "$REPO/integrations/aider/CONVENTIONS.md"
  echo "Aider: integrations/aider/CONVENTIONS.md"
}

convert_windsurf() {
  mkdir -p "$REPO/integrations/windsurf"
  { echo "# Magic Powers — Agents & Skills"; echo "";
    echo "## Agents"; echo ""
    for f in $(find_agents); do
      echo "### $(basename "$f" .md)"; echo ""; strip_frontmatter "$f"; echo ""
    done
    echo "## Skills"; echo ""
    for f in $(find_skills); do
      local name=$(get_field "$f" name)
      echo "### ${name}"; echo ""; strip_frontmatter "$f"; echo ""
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
  for f in $(find_skills); do
    local name=$(get_field "$f" name)
    local desc=$(get_field "$f" description)
    local dir="$REPO/integrations/gemini-cli/skills/${name}"
    mkdir -p "$dir"
    cp "$f" "$dir/SKILL.md"
  done
  echo "Gemini CLI: $(( $(find_agents | wc -l) + $(find_skills | wc -l) )) skills → integrations/gemini-cli/skills/"
}

convert_codex() {
  # Convert agents to Codex skills
  for f in $(find_agents); do
    local name=$(basename "$f" .md)
    local desc=$(get_field "$f" description)
    local dir="$REPO/integrations/codex/skills/magic-${name}"
    mkdir -p "$dir"
    { echo "---"; echo "name: magic-${name}"; echo "description: $desc"; echo "---"; echo ""; strip_frontmatter "$f"; } > "$dir/SKILL.md"
  done
  # Convert skills to Codex skills
  for f in $(find_skills); do
    local name=$(get_field "$f" name)
    local dir="$REPO/integrations/codex/skills/${name}"
    mkdir -p "$dir"
    cp "$f" "$dir/SKILL.md"
  done

  # Generate AGENTS.md for ~/.codex/AGENTS.md
  mkdir -p "$REPO/integrations/codex"
  { echo "# Magic Powers — Codex Instructions"
    echo ""
    echo "Magic Powers provides specialized agent skills for cost-optimized AI development."
    echo "Skills are installed in your Codex skills directory and auto-discovered."
    echo ""
    echo "## Available Skills"
    echo ""
    echo "Invoke explicitly with \`\$magic-<name>\`, or describe your task and Codex picks the right one."
    echo ""
    for f in $(find_agents); do
      local name=$(basename "$f" .md)
      local desc=$(get_field "$f" description)
      echo "- **\$magic-${name}**: ${desc}"
    done
    echo ""
    echo "## Recommended Workflow"
    echo ""
    echo "1. Complex features → \`\$magic-architect\` to plan before coding"
    echo "2. Bugs & failures → \`\$magic-debugger\` for systematic root cause analysis"
    echo "3. Before merging → \`\$magic-reviewer\` for code review"
    echo "4. Security concerns → \`\$magic-security-reviewer\` before deploying"
    echo "5. Slow queries / schema → \`\$magic-database-optimizer\`"
    echo "6. Docs & READMEs → \`\$magic-technical-writer\`"
  } > "$REPO/integrations/codex/AGENTS.md"

  echo "Codex: $(( $(find_agents | wc -l) + $(find_skills | wc -l) )) skills → integrations/codex/skills/"
  echo "Codex: AGENTS.md → integrations/codex/AGENTS.md"
}

convert_kiro() {
  local out="$REPO/integrations/kiro/steering"
  mkdir -p "$out"
  for f in $(find_agents); do
    local name=$(basename "$f" .md)
    local desc=$(get_field "$f" description)
    { echo "---"; echo "inclusion: auto"; echo "name: magic-${name}"; echo "description: $desc"; echo "---"; echo ""; strip_frontmatter "$f"; } > "$out/magic-${name}.md"
  done
  for f in $(find_skills); do
    local name=$(get_field "$f" name)
    local desc=$(get_field "$f" description)
    { echo "---"; echo "inclusion: auto"; echo "name: ${name}"; echo "description: $desc"; echo "---"; echo ""; strip_frontmatter "$f"; } > "$out/${name}.md"
  done
  echo "Kiro: $(( $(find_agents | wc -l) + $(find_skills | wc -l) )) steering files → integrations/kiro/steering/"
}

convert_opencode() {
  mkdir -p "$REPO/integrations/opencode"
  { echo "# Magic Powers — OpenCode Instructions"
    echo ""
    echo "Magic Powers provides specialized agents and workflow skills for cost-optimized AI development."
    echo ""
    echo "## Agents"
    echo ""
    echo "Invoke with \`@magic-<name>\` or describe your task and OpenCode picks the right one."
    echo ""
    for f in $(find_agents); do
      local name=$(basename "$f" .md)
      local desc=$(get_field "$f" description)
      echo "- **@magic-${name}**: ${desc}"
    done
    echo ""
    echo "## Skills"
    echo ""
    echo "Reference these workflows explicitly in your prompts when needed."
    echo ""
    for f in $(find_skills); do
      local name=$(get_field "$f" name)
      local desc=$(get_field "$f" description)
      echo "### ${name}"
      echo ""
      echo "_${desc}_"
      echo ""
      strip_frontmatter "$f"
      echo ""
    done
  } > "$REPO/integrations/opencode/AGENTS.md"
  echo "OpenCode: AGENTS.md → integrations/opencode/AGENTS.md"
}

case "${1:-all}" in
  all)     convert_cursor; convert_copilot; convert_aider; convert_windsurf; convert_gemini; convert_codex; convert_kiro; convert_opencode ;;
  cursor)  convert_cursor ;;
  copilot) convert_copilot ;;
  aider)   convert_aider ;;
  windsurf) convert_windsurf ;;
  gemini)  convert_gemini ;;
  codex)   convert_codex ;;
  kiro)    convert_kiro ;;
  opencode) convert_opencode ;;
  *) echo "Usage: $0 [all|cursor|copilot|aider|windsurf|gemini|codex|kiro|opencode]"; exit 1 ;;
esac
echo "Done! Run ./scripts/install.sh to install into your tool."
