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
# Run from workspace root. Two passes:
#   Pass 1 — top-level symlinks under .claude/skills/, .claude/agents/, sub-agents/
#            (per-skill symlinks like ctx-doc -> external repo's skill folder).
#            Intersects dirty files with the resolved symlink paths.
#   Pass 2 — directory-level symlinks at projects/*/github/ that point at the
#            full repo root of an external repo (e.g. projects/os-intelligence/
#            github -> ~/Code/os-intelligence). Emits every dirty file in that
#            repo — no intersection filter, because the symlink IS the repo.
#
# Output from both passes is unioned and deduped.
#
# Why this exists: Step 9a was previously an inline compound bash command (cd && for ...
# do ... done | sort -u) which fell through Claude Code's pattern-based bash allowlist
# and prompted for permission on every /os-save run. Moving it to a dedicated script
# lets a single allowlist rule cover it cleanly: Bash(bash .claude/skills/os-save/*:*).
#
# Same pattern as /os-start's menu.sh — deterministic work in bash, judgment in the LLM.

set -uo pipefail

WORKSPACE_ROOT="$(pwd)"

# ============================================================
# Pass 1: per-skill / per-agent symlinks (intersection)
# ============================================================
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

PASS1=$(
  [ -z "$SYMLINK_MAP" ] && exit 0
  echo "$SYMLINK_MAP" | awk -F'\t' '{print $1}' | sort -u | while read -r ext_repo; do
    [ -n "$ext_repo" ] || continue
    RESOLVED=$(echo "$SYMLINK_MAP" | awk -F'\t' -v r="$ext_repo" '$1 == r {print $2}')
    DIRTY=$(cd "$ext_repo" 2>/dev/null && git status --porcelain 2>/dev/null | awk '{print $NF}')
    [ -z "$DIRTY" ] && continue
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
)

# ============================================================
# Pass 2: full-repo directory symlinks at projects/*/github/
# ============================================================
# Each projects/*/github/ symlink that points at an external repo's root means
# every dirty file in that repo is in workspace scope. Catches edits to README,
# docs/, landing pages — anywhere outside the .claude/skills/ scan in Pass 1.
PASS2=$(
  find projects -maxdepth 2 -type l -name github 2>/dev/null | while read -r link; do
    real=$(realpath "$link" 2>/dev/null) || continue
    [ -d "$real" ] || continue
    ext_repo=$(cd "$real" 2>/dev/null && git rev-parse --show-toplevel 2>/dev/null) || continue
    [ -n "$ext_repo" ] || continue
    [ "$real" = "$ext_repo" ] || continue
    [ "$ext_repo" != "$WORKSPACE_ROOT" ] || continue
    cd "$ext_repo" 2>/dev/null && git status --porcelain 2>/dev/null | awk '{print $NF}' | while IFS= read -r dirty; do
      [ -n "$dirty" ] && printf "%s\t%s\n" "$ext_repo" "$dirty"
    done
  done
)

# Combine + dedupe
{
  [ -n "$PASS1" ] && echo "$PASS1"
  [ -n "$PASS2" ] && echo "$PASS2"
} | sort -u
