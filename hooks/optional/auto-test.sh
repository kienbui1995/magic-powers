#!/usr/bin/env bash
# Auto-test — run related tests after code change
set -euo pipefail

FILE_PATH="${1:-}"
if [ -z "$FILE_PATH" ]; then exit 0; fi

# Skip test files themselves to avoid loops
if [[ "$FILE_PATH" == *test* ]] || [[ "$FILE_PATH" == *spec* ]] || [[ "$FILE_PATH" == *__tests__* ]]; then
  exit 0
fi

EXT="${FILE_PATH##*.}"
DIR=$(dirname "$FILE_PATH")
BASE=$(basename "$FILE_PATH" ".$EXT")

# Find matching test file
find_test() {
  local patterns=("$DIR/${BASE}.test.$EXT" "$DIR/${BASE}.spec.$EXT" "$DIR/__tests__/${BASE}.test.$EXT" "$DIR/../tests/test_${BASE}.$EXT")
  for p in "${patterns[@]}"; do
    if [ -f "$p" ]; then echo "$p"; return; fi
  done
}

TEST_FILE=$(find_test)
if [ -z "$TEST_FILE" ]; then exit 0; fi

case "$EXT" in
  js|jsx|ts|tsx)
    if [ -f "package.json" ]; then
      npx jest --bail --findRelatedTests "$FILE_PATH" 2>/dev/null || true
    fi
    ;;
  py)
    if command -v pytest &>/dev/null; then
      pytest "$TEST_FILE" -x -q 2>/dev/null || true
    fi
    ;;
esac

exit 0
