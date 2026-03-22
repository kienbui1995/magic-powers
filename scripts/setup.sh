#!/usr/bin/env bash
set -euo pipefail

# magic-powers setup — personalize agents & skills for your project
# Run: bash <plugin-path>/scripts/setup.sh
# Or:  npx magic-powers setup

BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'
BOLD='\033[1m'

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PLUGIN_DIR="$(dirname "$SCRIPT_DIR")"
PROJECT_DIR="${1:-.}"

echo -e "${BOLD}🪄 magic-powers setup${NC}"
echo ""

# --- Step 1: Detect tech stack ---
echo -e "${CYAN}Scanning project...${NC}"
STACK=""
LANG=""
FRAMEWORK=""
DB=""

detect() {
  [ -f "$PROJECT_DIR/package.json" ] && LANG="javascript"
  [ -f "$PROJECT_DIR/tsconfig.json" ] && LANG="typescript"
  [ -f "$PROJECT_DIR/requirements.txt" ] || [ -f "$PROJECT_DIR/pyproject.toml" ] && LANG="python"
  [ -f "$PROJECT_DIR/go.mod" ] && LANG="go"
  [ -f "$PROJECT_DIR/Cargo.toml" ] && LANG="rust"
  [ -f "$PROJECT_DIR/Gemfile" ] && LANG="ruby"

  if [ -f "$PROJECT_DIR/package.json" ]; then
    grep -q "next" "$PROJECT_DIR/package.json" 2>/dev/null && FRAMEWORK="nextjs"
    grep -q "react" "$PROJECT_DIR/package.json" 2>/dev/null && FRAMEWORK="${FRAMEWORK:-react}"
    grep -q "vue" "$PROJECT_DIR/package.json" 2>/dev/null && FRAMEWORK="vue"
    grep -q "express" "$PROJECT_DIR/package.json" 2>/dev/null && FRAMEWORK="${FRAMEWORK:-express}"
    grep -q "fastify" "$PROJECT_DIR/package.json" 2>/dev/null && FRAMEWORK="${FRAMEWORK:-fastify}"
  fi
  if [ "$LANG" = "python" ]; then
    grep -rq "fastapi\|FastAPI" "$PROJECT_DIR" --include="*.py" --include="*.toml" --include="*.txt" -l 2>/dev/null && FRAMEWORK="fastapi"
    grep -rq "django\|Django" "$PROJECT_DIR" --include="*.py" --include="*.toml" --include="*.txt" -l 2>/dev/null && FRAMEWORK="${FRAMEWORK:-django}"
    grep -rq "flask\|Flask" "$PROJECT_DIR" --include="*.py" --include="*.toml" --include="*.txt" -l 2>/dev/null && FRAMEWORK="${FRAMEWORK:-flask}"
  fi

  [ -f "$PROJECT_DIR/docker-compose.yml" ] || [ -f "$PROJECT_DIR/docker-compose.yaml" ] && {
    grep -q "postgres" "$PROJECT_DIR/docker-compose."* 2>/dev/null && DB="postgresql"
    grep -q "mysql" "$PROJECT_DIR/docker-compose."* 2>/dev/null && DB="${DB:-mysql}"
    grep -q "mongo" "$PROJECT_DIR/docker-compose."* 2>/dev/null && DB="${DB:-mongodb}"
    grep -q "redis" "$PROJECT_DIR/docker-compose."* 2>/dev/null && DB="${DB:+$DB+redis}"
  }

  STACK="${LANG}${FRAMEWORK:+/$FRAMEWORK}${DB:+ + $DB}"
}
detect

if [ -n "$STACK" ]; then
  echo -e "  Detected: ${GREEN}${STACK}${NC}"
else
  echo -e "  ${YELLOW}No stack detected${NC}"
fi
echo ""

# --- Step 2: Ask role ---
echo -e "${BOLD}What's your role?${NC}"
echo "  1) Solo Builder (full stack, làm hết)"
echo "  2) Frontend Developer"
echo "  3) Backend Developer"
echo "  4) Product Manager"
echo "  5) Team Lead"
read -rp "Choose [1-5, default=1]: " ROLE_NUM
ROLE_NUM="${ROLE_NUM:-1}"

case "$ROLE_NUM" in
  1) ROLE="solo-builder" ;;
  2) ROLE="frontend" ;;
  3) ROLE="backend" ;;
  4) ROLE="product-manager" ;;
  5) ROLE="team-lead" ;;
  *) ROLE="solo-builder" ;;
esac
echo ""

# --- Step 3: Ask priority ---
echo -e "${BOLD}Priority?${NC}"
echo "  1) Ship nhanh"
echo "  2) Chất lượng cao"
echo "  3) Tiết kiệm cost"
read -rp "Choose [1-3, default=1]: " PRIO_NUM
PRIO_NUM="${PRIO_NUM:-1}"

case "$PRIO_NUM" in
  1) PRIORITY="speed" ;;
  2) PRIORITY="quality" ;;
  3) PRIORITY="cost" ;;
  *) PRIORITY="speed" ;;
esac
echo ""

# --- Step 4: Generate ---
echo -e "${CYAN}Generating personalized config...${NC}"
mkdir -p "$PROJECT_DIR/.claude/agents" "$PROJECT_DIR/.claude/skills/project-conventions"

# --- Agent recommendations per role ---
get_primary_agents() {
  case "$ROLE" in
    solo-builder)  echo "architect debugger reviewer ui-designer product-strategist sre copywriter" ;;
    frontend)      echo "ui-designer reviewer architect copywriter" ;;
    backend)       echo "architect debugger database-optimizer sre reviewer security-reviewer" ;;
    product-manager) echo "product-strategist copywriter technical-writer architect" ;;
    team-lead)     echo "architect reviewer product-strategist sre git-workflow" ;;
  esac
}

get_model_preference() {
  case "$PRIORITY" in
    speed) echo "Prefer Haiku for quick tasks. Use Sonnet only when reasoning matters." ;;
    quality) echo "Use full review pipeline: @reviewer → @security-reviewer before every commit." ;;
    cost) echo "Start with Haiku agents. Escalate to Sonnet/Opus only when stuck." ;;
  esac
}

PRIMARY=$(get_primary_agents)
MODEL_GUIDE=$(get_model_preference)

# --- Generate CLAUDE.md ---
cat > "$PROJECT_DIR/CLAUDE.md" << CLAUDEMD
# Project Configuration — magic-powers

## Stack
${STACK:-Not detected — update this manually}

## Role: ${ROLE}
## Priority: ${PRIORITY}

## Recommended Agents
$(for agent in $PRIMARY; do
  emoji=""
  case "$agent" in
    architect) emoji="🏗️" ;; debugger) emoji="🐛" ;; reviewer) emoji="🔍" ;;
    ui-designer) emoji="🎨" ;; security-reviewer) emoji="🛡️" ;; database-optimizer) emoji="🗄️" ;;
    technical-writer) emoji="📝" ;; sre) emoji="🔧" ;; git-workflow) emoji="🌿" ;;
    product-strategist) emoji="🎯" ;; copywriter) emoji="✍️" ;;
  esac
  echo "- ${emoji} \`@${agent}\`"
done)

## Model Guide
${MODEL_GUIDE}

## Conventions
- Follow existing patterns in the codebase
- ${LANG:+Language: $LANG}
- ${FRAMEWORK:+Framework: $FRAMEWORK}
- ${DB:+Database: $DB}
CLAUDEMD

# --- Generate project-conventions skill ---
cat > "$PROJECT_DIR/.claude/skills/project-conventions/SKILL.md" << SKILLMD
---
name: project-conventions
description: Auto-detected project conventions — follow these when writing code
---

# Project Conventions

## Stack
- Language: ${LANG:-unknown}
- Framework: ${FRAMEWORK:-unknown}
- Database: ${DB:-unknown}

## Rules
- Match existing code style in the project
- Check existing patterns before creating new abstractions
- ${FRAMEWORK:+Follow $FRAMEWORK best practices and conventions}
- ${DB:+Use parameterized queries for all $DB operations}
SKILLMD

# --- Override agents with stack context if detected ---
if [ -n "$LANG" ]; then
  # Add stack context to architect
  if echo "$PRIMARY" | grep -q "architect"; then
    cat > "$PROJECT_DIR/.claude/agents/architect.md" << AGENTMD
---
name: architect
description: "Architecture decisions for this ${STACK} project"
model: opus
emoji: 🏗️
vibe: visionary
tools: Read, Grep, Glob, Bash
memory: user
skills:
  - magic-powers:brainstorming
  - magic-powers:writing-plans
---

You are a senior software architect specializing in ${STACK} projects.

When designing for this project:
- Use ${LANG} idioms and best practices
${FRAMEWORK:+- Follow $FRAMEWORK conventions and patterns}
${DB:+- Design with $DB strengths in mind}
- Check existing code patterns before proposing new ones
- Read package files and configs to understand current dependencies

You plan and design. You do NOT write implementation code.
AGENTMD
  fi

  # Add stack context to debugger for backend roles
  if echo "$PRIMARY" | grep -q "debugger"; then
    cat > "$PROJECT_DIR/.claude/agents/debugger.md" << AGENTMD
---
name: debugger
description: "Debug ${STACK} issues systematically"
model: sonnet
emoji: 🐛
vibe: persistent
tools: Read, Edit, Write, Bash, Grep, Glob
memory: project
skills:
  - magic-powers:systematic-debugging
---

You are an expert debugger for ${STACK} projects.

When debugging:
- Check ${LANG}-specific error patterns first
${FRAMEWORK:+- Know common $FRAMEWORK pitfalls}
${DB:+- Check $DB connection, queries, and migrations}
- Read error logs and stack traces
- Test one hypothesis at a time
- Implement minimal fix and verify
AGENTMD
  fi
fi

echo ""
echo -e "${GREEN}${BOLD}✅ Setup complete!${NC}"
echo ""
echo "Generated:"
[ -f "$PROJECT_DIR/CLAUDE.md" ] && echo -e "  ${GREEN}✅${NC} CLAUDE.md (personalized workflow)"
[ -d "$PROJECT_DIR/.claude/skills/project-conventions" ] && echo -e "  ${GREEN}✅${NC} .claude/skills/project-conventions/"
for f in "$PROJECT_DIR/.claude/agents/"*.md; do
  [ -f "$f" ] && echo -e "  ${GREEN}✅${NC} .claude/agents/$(basename "$f") (stack-specific override)"
done
echo ""
echo -e "Run ${CYAN}magic-powers setup${NC} again anytime to reconfigure."
