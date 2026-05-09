#!/usr/bin/env bash
# sync-test.sh — wipe + recreate a local test clone from master working tree.
#
# Default target: ~/Code/os-intelligence-test-fast — the throwaway dir for tight
# /os-welcome iteration. Always overwritten in full. Numbered test dirs
# (test-1, test-2, ...) are reserved for end-to-end checks via refresh-test.sh
# (which clones from GitHub remote, requires push first).
#
# Usage:
#   bash scripts/sync-test.sh                                   # default: ~/Code/os-intelligence-test-fast
#   bash scripts/sync-test.sh ~/Code/os-intelligence-test-foo   # custom path
#
# Workflow:
#   1. Edit master at ~/Code/os-intelligence (or via workspace symlink)
#   2. bash scripts/sync-test.sh
#   3. In the test-fast Claude window: /os-welcome
#   4. Observe friction, repeat from 1
#
# IMPORTANT: must run from your interactive shell (Terminal app or via `!`
# prefix in the Claude prompt). Running from inside Claude Code's sandboxed
# bash hits macOS TCC restrictions on com.apple.provenance-tagged files.
#
# Use refresh-test.sh instead when you want to verify the actual install
# experience as a brand-new GitHub user would see it.

set -e

TEST_DIR="${1:-$HOME/Code/os-intelligence-test-fast}"
SOURCE_DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo "Source:    $SOURCE_DIR"
echo "Test dir:  $TEST_DIR"
echo

if [ -d "$TEST_DIR" ]; then
  echo "Removing existing $TEST_DIR"
  rm -rf "$TEST_DIR"
fi

echo "Copying master into $TEST_DIR"
cp -R "$SOURCE_DIR" "$TEST_DIR"

echo
echo "Done. Test clone synced from master."
echo "Open $TEST_DIR in a new Claude Code window, then run /os-welcome."
