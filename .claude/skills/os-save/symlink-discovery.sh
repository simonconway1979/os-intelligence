#!/usr/bin/env bash
#
# /os-save Step 9a: discover dirty files in external repos reachable via workspace symlinks.
#
# Outputs one line per dirty intersected file:
#   [external-repo-abs-path]<TAB>[path-in-external-repo]
#
# Empty output = no companion commits needed; primary commit can proceed alone.
# Non-empty output = each line is a companion-commit candidate.
#
# Run from workspace root. Inspects .claude/skills/, .claude/agents/, sub-agents/
# top-level entries (these are the canonical locations for symlinked skills + sub-agents).
#
# Why this exists: Step 9a was previously an inline compound bash command (cd && for ...
# do ... done | sort -u) which fell through Claude Code's pattern-based bash allowlist
# and prompted for permission on every /os-save run. Moving it to a dedicated script
# lets a single allowlist rule cover it cleanly: Bash(bash .claude/skills/os-save/*:*).
#
# Same pattern as /os-start's menu.sh — deterministic work in bash, judgment in the LLM.

set -uo pipefail

WORKSPACE_ROOT="$(pwd)"

# Build list: each line "ext_repo<TAB>resolved-path-in-ext-repo"
# Skip dangling symlinks, symlinks not under git, and symlinks pointing back into the workspace.
SYMLINK_MAP=$(
  find .claude/skills .claude/agents sub-agents -maxdepth 1 -type l 2>/dev/null | while read -r link; do
    real=$(realpath "$link" 2>/dev/null) || continue
    [ -d "$real" ] || continue
    ext_repo=$(cd "$real" 2>/dev/null && git rev-parse --show-toplevel 2>/dev/null) || continue
    [ -n "$ext_repo" ] && [ "$ext_repo" != "$WORKSPACE_ROOT" ] || continue
    printf "%s\t%s\n" "$ext_repo" "${real#$ext_repo/}"
  done
)

# No external symlinks → nothing to check.
[ -z "$SYMLINK_MAP" ] && exit 0

# For each unique external repo, intersect its dirty files with workspace-reachable paths.
echo "$SYMLINK_MAP" | awk -F'\t' '{print $1}' | sort -u | while read -r ext_repo; do
  [ -n "$ext_repo" ] || continue

  # Resolved paths (relative to ext_repo root) reachable via this workspace's symlinks
  RESOLVED=$(echo "$SYMLINK_MAP" | awk -F'\t' -v r="$ext_repo" '$1 == r {print $2}')

  # All dirty files in the external repo (relative to its root)
  DIRTY=$(cd "$ext_repo" 2>/dev/null && git status --porcelain 2>/dev/null | awk '{print $NF}')
  [ -z "$DIRTY" ] && continue

  # Intersection: emit dirty files that fall under any resolved symlink path.
  # Uses prefix match so a symlinked folder catches every dirty file inside it.
  echo "$DIRTY" | while IFS= read -r dirty; do
    [ -n "$dirty" ] || continue
    while IFS= read -r resolved; do
      [ -n "$resolved" ] || continue
      if [[ "$dirty" == "$resolved"* ]]; then
        printf "%s\t%s\n" "$ext_repo" "$dirty"
        break
      fi
    done <<< "$RESOLVED"
  done
done
