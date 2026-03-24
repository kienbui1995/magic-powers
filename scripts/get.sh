#!/usr/bin/env bash
# get.sh — One-liner installer for Magic Powers
# Usage: curl -fsSL https://raw.githubusercontent.com/kienbui1995/magic-powers/main/scripts/get.sh | bash
set -euo pipefail

REPO_URL="https://github.com/kienbui1995/magic-powers.git"
tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

echo "Cloning Magic Powers..."
git clone --depth=1 "$REPO_URL" "$tmpdir/magic-powers" --quiet

bash "$tmpdir/magic-powers/scripts/install.sh"
