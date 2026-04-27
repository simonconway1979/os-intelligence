#!/usr/bin/env bash
# log-event.sh — append a JSONL event to the local activity log.
#
# Used as a Claude Code hook. See docs/usage-log.md for schema and how to disable.
#
# Privacy: writes to a local file only. Nothing is sent over the network.
# Safe to delete or disable at any time; OS-Intelligence does not depend on it.
#
# Usage (called by Claude Code hooks):
#   bash log-event.sh session_start
#   bash log-event.sh skill_run     # reads PostToolUse JSON from stdin

EVENT_TYPE="${1:-unknown}"
LOG_DIR="${CLAUDE_PROJECT_DIR:-$(cd "$(dirname "$0")/.." && pwd)}/.os-intel-log"
LOG_FILE="$LOG_DIR/usage.jsonl"

# Wrap everything so any failure exits 0 — never block Claude Code on logging.
{
  mkdir -p "$LOG_DIR" 2>/dev/null || exit 0
  TS="$(date -u +%Y-%m-%dT%H:%M:%SZ 2>/dev/null)" || exit 0

  if [ "$EVENT_TYPE" = "skill_run" ]; then
    INPUT="$(cat 2>/dev/null)"
    SKILL=$(printf '%s' "$INPUT" \
      | grep -oE '"skill"[[:space:]]*:[[:space:]]*"[^"]*"' \
      | head -1 \
      | sed -E 's/.*"skill"[[:space:]]*:[[:space:]]*"([^"]*)".*/\1/')
    [ -z "$SKILL" ] && SKILL="unknown"
    printf '{"ts":"%s","event":"skill_run","skill":"%s"}\n' "$TS" "$SKILL" \
      >> "$LOG_FILE" 2>/dev/null
  else
    printf '{"ts":"%s","event":"%s"}\n' "$TS" "$EVENT_TYPE" \
      >> "$LOG_FILE" 2>/dev/null
  fi
} || true

exit 0
