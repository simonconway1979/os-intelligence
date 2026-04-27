#!/usr/bin/env bash
# refresh-test.sh — re-clone the OS-Intelligence repo into a throwaway test folder.
#
# Usage:
#   bash scripts/refresh-test.sh                                # default: ~/Code/os-intelligence-test-1
#   bash scripts/refresh-test.sh ~/Code/os-intelligence-test-2  # custom path
#
# Workflow: edit master at ~/Code/os-intelligence, commit + push, then run this
# to get a fresh clone for testing the install experience as a new user would.

set -e

TEST_DIR="${1:-$HOME/Code/os-intelligence-test-1}"
REPO_URL="${OS_INTEL_REPO:-https://github.com/simonconway1979/os-intelligence.git}"

echo "Test dir:  $TEST_DIR"
echo "Repo URL:  $REPO_URL"
echo

if [ -d "$TEST_DIR" ]; then
  echo "Removing existing $TEST_DIR"
  rm -rf "$TEST_DIR"
fi

echo "Cloning fresh"
git clone "$REPO_URL" "$TEST_DIR"

echo
echo "Done. Test clone ready at:"
echo "  $TEST_DIR"
echo
echo "Open it in Claude Code, then run /os-welcome."
