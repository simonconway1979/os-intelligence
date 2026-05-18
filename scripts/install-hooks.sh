#!/usr/bin/env bash
# install-hooks.sh — activate the version-controlled git hooks for this repo.
#
# Sets `git config core.hooksPath scripts/hooks` so every hook in
# scripts/hooks/ runs at the matching git event. Idempotent.
#
# Why this exists: git's default hooks path (.git/hooks/) isn't version-
# controlled, so shipped hooks don't activate on clone. core.hooksPath fixes
# that with one config line.
#
# Run once after cloning:
#   bash scripts/install-hooks.sh

set -e

REPO_ROOT="$(git rev-parse --show-toplevel)"
TARGET="scripts/hooks"

if [ ! -d "$REPO_ROOT/$TARGET" ]; then
  echo "✗ $TARGET/ not found in $REPO_ROOT — aborting."
  exit 1
fi

current="$(git -C "$REPO_ROOT" config --get core.hooksPath || true)"
if [ "$current" = "$TARGET" ]; then
  echo "✓ core.hooksPath already set to $TARGET — nothing to do."
  exit 0
fi

git -C "$REPO_ROOT" config core.hooksPath "$TARGET"

echo "✓ core.hooksPath set to $TARGET"
echo "  Active hooks:"
for h in "$REPO_ROOT/$TARGET"/*; do
  [ -f "$h" ] && [ -x "$h" ] && echo "    - $(basename "$h")"
done
echo
echo "To bypass a hook on a specific commit:"
echo "  git commit --no-verify"
