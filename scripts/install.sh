#!/usr/bin/env bash
# install.sh — Install converted agents into target tool
set -euo pipefail
REPO="$(cd "$(dirname "$0")/.." && pwd)"

detect_tool() {
  [ -d "$PWD/.kiro" ] || [ -d "$HOME/.kiro" ] && echo 8 && return
  [ -d "$PWD/.cursor" ] && echo 1 && return
  command -v windsurf &>/dev/null && echo 4 && return
  [ -d "$HOME/.codex" ] && echo 7 && return
  command -v gemini &>/dev/null && echo 5 && return
  command -v opencode &>/dev/null && echo 9 && return
  command -v claude &>/dev/null && echo 6 && return
  echo ""
}

TOOL_NAMES=("" "Cursor" "GitHub Copilot" "Aider" "Windsurf" "Gemini CLI" "Claude Code" "Codex" "Kiro" "OpenCode")

echo "Magic Powers Installer"
echo "======================"
echo ""

detected=$(detect_tool)
choice=""
if [ -n "$detected" ]; then
  echo "Detected: ${TOOL_NAMES[$detected]}"
  read -rp "Install for ${TOOL_NAMES[$detected]}? [Y/n]: " confirm
  if [[ "${confirm:-Y}" =~ ^[Yy]$ ]]; then
    choice=$detected
  fi
fi

if [ -z "$choice" ]; then
echo "Select your tool:"
echo "  1) Cursor"
echo "  2) GitHub Copilot"
echo "  3) Aider"
echo "  4) Windsurf"
echo "  5) Gemini CLI"
echo "  6) Claude Code (plugin — recommended)"
echo "  7) Codex"
echo "  8) Kiro"
echo "  9) OpenCode"
echo ""
read -rp "Choice [1-9]: " choice
fi

case "$choice" in
  1)
    dest="${CURSOR_RULES:-$PWD/.cursor/rules}"
    mkdir -p "$dest"
    bash "$REPO/scripts/convert.sh" cursor
    cp "$REPO/integrations/cursor/rules/"*.mdc "$dest/"
    echo "Installed to $dest" ;;
  2)
    dest="${COPILOT_AGENTS:-$PWD/.github/copilot/agents}"
    mkdir -p "$dest"
    bash "$REPO/scripts/convert.sh" copilot
    cp "$REPO/integrations/copilot/agents/"*.md "$dest/"
    echo "Installed to $dest" ;;
  3)
    dest="$PWD"
    bash "$REPO/scripts/convert.sh" aider
    cp "$REPO/integrations/aider/CONVENTIONS.md" "$dest/"
    echo "Installed CONVENTIONS.md to $dest" ;;
  4)
    dest="$PWD"
    bash "$REPO/scripts/convert.sh" windsurf
    cp "$REPO/integrations/windsurf/.windsurfrules" "$dest/"
    echo "Installed .windsurfrules to $dest" ;;
  5)
    dest="${GEMINI_SKILLS:-$HOME/.gemini/skills}"
    mkdir -p "$dest"
    bash "$REPO/scripts/convert.sh" gemini
    cp -r "$REPO/integrations/gemini-cli/skills/"* "$dest/"
    echo "Installed to $dest" ;;
  6)
    echo "For Claude Code, use: /plugin install github:YOUR_USERNAME/magic-powers"
    echo "No manual install needed." ;;
  7)
    skill_dest="${CODEX_SKILLS:-$HOME/.codex/skills}"
    codex_home="${CODEX_HOME:-$HOME/.codex}"
    mkdir -p "$skill_dest"
    bash "$REPO/scripts/convert.sh" codex
    cp -r "$REPO/integrations/codex/skills/"* "$skill_dest/"
    if [ -f "$codex_home/AGENTS.md" ]; then
      echo "Warning: $codex_home/AGENTS.md already exists — skipping (add content from integrations/codex/AGENTS.md manually)"
    else
      cp "$REPO/integrations/codex/AGENTS.md" "$codex_home/AGENTS.md"
      echo "Installed AGENTS.md to $codex_home/AGENTS.md"
    fi
    echo "Installed skills to $skill_dest"
    echo "Restart Codex to pick up new skills." ;;
  8)
    dest="${KIRO_STEERING:-$PWD/.kiro/steering}"
    mkdir -p "$dest"
    bash "$REPO/scripts/convert.sh" kiro
    cp "$REPO/integrations/kiro/steering/"*.md "$dest/"
    echo "Installed to $dest"
    echo "Steering files load automatically when relevant (inclusion: auto)." ;;
  9)
    dest="${OPENCODE_CONFIG:-$HOME/.config/opencode}"
    mkdir -p "$dest"
    bash "$REPO/scripts/convert.sh" opencode
    if [ -f "$dest/AGENTS.md" ]; then
      echo "Warning: $dest/AGENTS.md already exists — skipping (add content from integrations/opencode/AGENTS.md manually)"
    else
      cp "$REPO/integrations/opencode/AGENTS.md" "$dest/AGENTS.md"
      echo "Installed AGENTS.md to $dest/AGENTS.md"
    fi ;;
  *)
    echo "Invalid choice"; exit 1 ;;
esac
