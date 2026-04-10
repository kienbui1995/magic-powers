#!/usr/bin/env bash
# Security audit for Magic Powers skills and agents
# Based on Snyk ToxicSkills study (2026) + real-world attack vectors
set -euo pipefail

RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m'

EXIT_CODE=0
TOTAL_FILES=0
CRITICAL=0
WARNINGS=0

# Security documentation files — discuss dangerous patterns to TEACH defense, not to implement
# These files intentionally contain examples of attacks/dangerous commands as educational content
is_security_doc() {
  local file="$1"
  local security_docs=(
    "skills/agentic-security"
    "skills/ai-safety-guardrails"
    "skills/browser-extension/extension-security"
    "skills/claude-project-settings"
    "skills/claude-hooks"
  )
  for pattern in "${security_docs[@]}"; do
    [[ "$file" == *"$pattern"* ]] && return 0
  done
  # Also skip generated integration copies of security docs
  if echo "$file" | grep -qE "(agentic-security|ai-safety-guardrails|extension-security|claude-project-settings|claude-hooks)\.(md|mdc)$"; then
    return 0
  fi
  # Skip aggregate files that concatenate all skills (including security docs)
  if echo "$file" | grep -qE "(integrations/opencode/AGENTS\.md|integrations/aider/CONVENTIONS\.md|integrations/windsurf/\.windsurfrules)$"; then
    return 0
  fi
  return 1
}

audit_file() {
  local file="$1"
  local issues=0

  TOTAL_FILES=$((TOTAL_FILES + 1))

  # Skip security documentation files for pattern-based critical checks
  # (they intentionally document attack patterns as examples for defense)
  if is_security_doc "$file"; then
    return 0
  fi

  # === CRITICAL ===

  # 1. Hardcoded secrets/keys/tokens
  if grep -qiE '(api[_-]?key|secret[_-]?key|access[_-]?token|password)[[:space:]]*[:=][[:space:]]*"[A-Za-z0-9+/=_-]{16,}' "$file"; then
    echo -e "${RED}CRITICAL${NC} $file: Hardcoded secret/key"
    CRITICAL=$((CRITICAL + 1)); issues=$((issues + 1))
  fi

  # 2. Dangerous shell commands
  if grep -qiE '(rm[[:space:]]+-rf[[:space:]]+/[^a-z]|sudo[[:space:]]|chmod[[:space:]]+777|curl.*\|[[:space:]]*bash|wget.*\|[[:space:]]*sh)' "$file"; then
    echo -e "${RED}CRITICAL${NC} $file: Dangerous shell command"
    CRITICAL=$((CRITICAL + 1)); issues=$((issues + 1))
  fi

  # 3. Prompt injection patterns
  if grep -qiE '(ignore[[:space:]]+(previous|above|all)[[:space:]]+instructions|you[[:space:]]+are[[:space:]]+now|disregard[[:space:]]+(your|all)|override[[:space:]]+system[[:space:]]+prompt)' "$file"; then
    echo -e "${RED}CRITICAL${NC} $file: Prompt injection pattern"
    CRITICAL=$((CRITICAL + 1)); issues=$((issues + 1))
  fi

  # 4. Environment variable exfiltration
  if grep -qiE '(process\.env[^_A-Z]|os\.environ|printenv|env[[:space:]]*\|[[:space:]]*(grep|sort|curl|wget))' "$file"; then
    echo -e "${RED}CRITICAL${NC} $file: Env variable exfiltration pattern"
    CRITICAL=$((CRITICAL + 1)); issues=$((issues + 1))
  fi

  # 5. Write to sensitive paths (backdoor/persistence)
  if grep -qiE '(>>?[[:space:]]*~/\.(bashrc|bash_profile|profile|zshrc)|>>?[[:space:]]*/etc/(crontab|sudoers|rc\.local)|>>?[[:space:]]*/usr/local/bin/)' "$file"; then
    echo -e "${RED}CRITICAL${NC} $file: Write to sensitive system path"
    CRITICAL=$((CRITICAL + 1)); issues=$((issues + 1))
  fi

  # 6. Crypto wallet / private key patterns
  if grep -qiE '(wallet\.dat|seed[[:space:]]*phrase|mnemonic|private[_-]?key[[:space:]]*[:=][[:space:]]*"0x[0-9a-f]{64}|keystore/UTC)' "$file"; then
    echo -e "${RED}CRITICAL${NC} $file: Crypto wallet/private key pattern"
    CRITICAL=$((CRITICAL + 1)); issues=$((issues + 1))
  fi

  # === WARNINGS ===

  # 7. Overly broad file access
  if grep -qiE '(read|write|access|open)[[:space:]]+any[[:space:]]+file|/etc/(passwd|shadow)|~/\.(ssh|aws|gnupg|kube)' "$file"; then
    echo -e "${YELLOW}WARNING${NC} $file: Broad file access pattern"
    WARNINGS=$((WARNINGS + 1)); issues=$((issues + 1))
  fi

  # 8. Data exfiltration (POST to external URLs)
  if grep -qiE 'curl[[:space:]]+(-X[[:space:]]+POST|--data)[[:space:]]+https?://' "$file"; then
    echo -e "${YELLOW}WARNING${NC} $file: Data exfiltration pattern"
    WARNINGS=$((WARNINGS + 1)); issues=$((issues + 1))
  fi

  # 9. Eval/exec calls (word boundary via space/paren)
  if grep -qE '(^|[^a-zA-Z_])(eval|exec)[[:space:]]*\(' "$file"; then
    echo -e "${YELLOW}WARNING${NC} $file: eval/exec usage"
    WARNINGS=$((WARNINGS + 1)); issues=$((issues + 1))
  fi

  # 10. Large encoded payloads
  if grep -qE '[A-Za-z0-9+/]{100,}=?=?' "$file"; then
    echo -e "${YELLOW}WARNING${NC} $file: Large encoded payload"
    WARNINGS=$((WARNINGS + 1)); issues=$((issues + 1))
  fi

  # 11. Malicious package install (from URL/git, not registry)
  if grep -qiE '(npm[[:space:]]+install|pip[[:space:]]+install)[[:space:]]+(https?://|git\+|git://)' "$file"; then
    echo -e "${YELLOW}WARNING${NC} $file: Package install from URL/git"
    WARNINGS=$((WARNINGS + 1)); issues=$((issues + 1))
  fi

  # 12. Network recon tools
  if grep -qiE '\b(nmap|netcat|masscan|ncat)\b' "$file"; then
    echo -e "${YELLOW}WARNING${NC} $file: Network recon tool"
    WARNINGS=$((WARNINGS + 1)); issues=$((issues + 1))
  fi

  # 13. Obfuscated strings (hex escapes)
  if grep -qE '(\\x[0-9a-fA-F]{2}){8,}' "$file"; then
    echo -e "${YELLOW}WARNING${NC} $file: Obfuscated string"
    WARNINGS=$((WARNINGS + 1)); issues=$((issues + 1))
  fi

  # 14. Overly permissive instructions (jailbreak enablers)
  if grep -qiE '(no[[:space:]]+restrictions|do[[:space:]]+anything[[:space:]]+(the[[:space:]]+)?user[[:space:]]+asks|bypass[[:space:]]+(all[[:space:]]+)?safety|ignore[[:space:]]+(all[[:space:]]+)?guardrails|unlimited[[:space:]]+access)' "$file"; then
    echo -e "${YELLOW}WARNING${NC} $file: Overly permissive instruction"
    WARNINGS=$((WARNINGS + 1)); issues=$((issues + 1))
  fi

  if [ "$issues" -gt 0 ]; then
    EXIT_CODE=1
  fi
}

scan_dir() {
  local dir="$1"
  local pattern="$2"
  if [ -d "$dir" ]; then
    while IFS= read -r -d '' file; do
      audit_file "$file"
    done < <(find "$dir" -name "$pattern" -type f -print0)
  fi
}

echo "Magic Powers Security Audit (v2)"
echo "====================================="
echo "14 checks - Based on Snyk ToxicSkills study"
echo ""

# Scan all content directories
scan_dir "skills" "SKILL.md"
scan_dir "agents" "*.md"
scan_dir "integrations" "*.md"
scan_dir "integrations" "*.mdc"
scan_dir "hooks" "*"
scan_dir "commands" "*.md"

ISSUES=$((CRITICAL + WARNINGS))
echo ""
echo "====================================="
echo "Files scanned: $TOTAL_FILES"
echo "Critical:      ${CRITICAL}"
echo "Warnings:      ${WARNINGS}"
echo ""
if [ "$CRITICAL" -gt 0 ]; then
  echo "FAILED -- $CRITICAL critical issue(s) must be fixed"
  EXIT_CODE=1
elif [ "$WARNINGS" -gt 0 ]; then
  echo "PASSED WITH WARNINGS -- $WARNINGS warning(s) to review"
  EXIT_CODE=0
else
  echo "PASSED -- $TOTAL_FILES files scanned, 0 issues"
fi

exit $EXIT_CODE
