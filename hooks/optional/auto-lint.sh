#!/usr/bin/env bash
# Auto-lint — run linter on changed file after write/edit
set -euo pipefail

FILE_PATH="${1:-}"
if [ -z "$FILE_PATH" ]; then exit 0; fi

EXT="${FILE_PATH##*.}"

case "$EXT" in
  js|jsx|ts|tsx|mjs|cjs)
    if command -v npx &>/dev/null; then
      npx --yes eslint --fix "$FILE_PATH" 2>/dev/null || true
    fi
    ;;
  py)
    if command -v ruff &>/dev/null; then
      ruff check --fix "$FILE_PATH" 2>/dev/null || true
      ruff format "$FILE_PATH" 2>/dev/null || true
    elif command -v black &>/dev/null; then
      black --quiet "$FILE_PATH" 2>/dev/null || true
    fi
    ;;
  go)
    if command -v gofmt &>/dev/null; then
      gofmt -w "$FILE_PATH" 2>/dev/null || true
    fi
    ;;
  rs)
    if command -v rustfmt &>/dev/null; then
      rustfmt "$FILE_PATH" 2>/dev/null || true
    fi
    ;;
esac

exit 0
