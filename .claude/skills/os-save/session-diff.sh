#!/usr/bin/env bash
# session-diff.sh — compute the set of source files changed since the last os-save
# for one project, to drive incremental synthesis in /os-save (Step 5S).
#
# Usage:  bash .claude/skills/os-save/session-diff.sh <project-root-relative-to-workspace>
# Example: bash .claude/skills/os-save/session-diff.sh projects/os-intelligence
#
# Output (stdout):
#   ## base-commit: <sha|none>
#   ## project: <project-root>
#   ## mode: incremental | first-run
#   <STATUS>\t<path>          # one line per changed source file
# where STATUS is A (added/untracked), M (modified), D (deleted).
#
# Lines beginning "## " are header/report metadata; everything else is a
# tab-separated changed-file record. The model classifies paths into buckets
# (session/reasoning vs canonical context vs context/raw) — the script
# just reports what git says moved.
#
# Base = the commit that last wrote <project>/state/current-state.md (the
# previous save for this project). Working-tree + staged + untracked changes
# since that commit are all included, because the current session has not
# committed yet (os-save commits in Step 9, after this step). Pinning the base
# to current-state.md's last commit (not HEAD) keeps it correct even if other
# projects' saves committed in between.

set -uo pipefail

PROJECT="${1:?usage: session-diff.sh <project-root>}"
PROJECT="${PROJECT%/}"                      # strip any trailing slash

CS="$PROJECT/current-state.md"                    # OSI adopt-in-place location
[ -f "$CS" ] || CS="$PROJECT/state/current-state.md"   # PM-OS shape
[ -f "$CS" ] || CS="$PROJECT/context/current-state.md" # pre-migration-0003 workspaces

GIT() { git -c core.quotepath=false "$@"; } # keep non-ASCII paths literal

BASE="$(GIT log -1 --format=%H -- "$CS" 2>/dev/null || true)"

echo "## base-commit: ${BASE:-none}"
echo "## project: $PROJECT"

is_excluded() {
  case "$1" in
    "$CS") return 0 ;;                       # base, not an input
    */SESSIONS-INDEX.md) return 0 ;;         # derived index
    */current-state-synth.md) return 0 ;;    # synth sidecar
    *) return 1 ;;
  esac
}

emit() {
  local status="$1" path="$2"
  is_excluded "$path" && return 0
  case "$path" in
    *.md|*.txt) printf '%s\t%s\n' "$status" "$path" ;;
  esac
}

if [ -z "$BASE" ]; then
  echo "## mode: first-run"
  { GIT ls-files "$PROJECT"; GIT ls-files --others --exclude-standard "$PROJECT"; } \
    | sort -u | while IFS= read -r f; do [ -n "$f" ] && emit A "$f"; done
  exit 0
fi

echo "## mode: incremental"

# Tracked changes since BASE (working tree vs BASE).
while IFS=$'\t' read -r status path rest; do
  [ -z "${status:-}" ] && continue
  case "$status" in
    A*) emit A "$path" ;;
    M*) emit M "$path" ;;
    D*) emit D "$path" ;;
    T*) emit M "$path" ;;                     # type change — treat as modified
    R*) [ -n "${rest:-}" ] && emit A "$rest"; emit D "$path" ;;  # rename = add new, drop old
    C*) [ -n "${rest:-}" ] && emit A "$rest" ;;                  # copy = add new
    *)  emit M "$path" ;;
  esac
done < <(GIT diff --name-status "$BASE" -- "$PROJECT")

# Untracked new files under the project (the session memory file lands here).
while IFS= read -r f; do
  [ -n "$f" ] && emit A "$f"
done < <(GIT ls-files --others --exclude-standard "$PROJECT")
