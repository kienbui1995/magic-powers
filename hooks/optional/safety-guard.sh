#!/usr/bin/env bash
# Safety guard — block writes to dangerous paths
set -euo pipefail

FILE_PATH="${1:-}"
if [ -z "$FILE_PATH" ]; then exit 0; fi

BLOCKED_PATTERNS=(
  "node_modules/" ".env" ".env.local" ".env.production"
  "package-lock.json" "yarn.lock" "pnpm-lock.yaml"
  ".git/" "__pycache__/" ".venv/" "venv/"
  "*.pem" "*.key" "*.p12" "*.pfx"
  "id_rsa" "id_ed25519" ".ssh/"
)

for pattern in "${BLOCKED_PATTERNS[@]}"; do
  if [[ "$FILE_PATH" == *"$pattern"* ]]; then
    echo '{"decision":"block","reason":"⛔ Blocked: writing to '"$FILE_PATH"' is not allowed (matches '"$pattern"')"}'
    exit 0
  fi
done

echo '{"decision":"allow"}'
