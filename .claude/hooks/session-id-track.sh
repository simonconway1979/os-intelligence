#!/usr/bin/env bash
#
# Per-session project state tracking.
#
# Replaces the single workspace-root `.current-session` file with
# `.sessions/<session_id>` keyed by Claude Code's session ID, so parallel
# Claude Code windows don't clobber each other's project state.
#
# Usage (registered as Claude Code hooks in .claude/settings.json):
#   bash session-id-track.sh start   # SessionStart
#   bash session-id-track.sh end     # SessionEnd
#
# Wraps everything so failures exit 0 — never block Claude Code on this.

EVENT="${1:-unknown}"

{
  INPUT="$(cat 2>/dev/null)"
  SESSION_ID=$(printf '%s' "$INPUT" | jq -r '.session_id // empty' 2>/dev/null)
  [ -z "$SESSION_ID" ] && exit 0

  WORKSPACE="${CLAUDE_PROJECT_DIR:-$(cd "$(dirname "$0")/../.." && pwd)}"
  SESSIONS_DIR="$WORKSPACE/.sessions"

  mkdir -p "$SESSIONS_DIR" 2>/dev/null || exit 0

  if [ "$EVENT" = "start" ]; then
    # Initialise the per-session file (placeholder until /os-start picks one).
    [ -f "$SESSIONS_DIR/$SESSION_ID" ] || printf '(no project)\n' > "$SESSIONS_DIR/$SESSION_ID"

    # Tell the assistant its own session ID so it can pass it to bash skills.
    # Format: Claude Code SessionStart hook JSON output.
    jq -n --arg sid "$SESSION_ID" '{
      hookSpecificOutput: {
        hookEventName: "SessionStart",
        additionalContext: ("Your Claude Code session ID for this window is: " + $sid + "\n\nWhen invoking bash commands inside skills that read or write per-session project state (`/os-start`, `/os-save`, `/os-new-project`, `/os-switch-project`), pass this session ID as the first argument so they target `.sessions/" + $sid + "` instead of the shared `.current-session` file. Example: `bash .claude/skills/os-start/menu.sh " + $sid + "`.")
      }
    }' 2>/dev/null

  elif [ "$EVENT" = "end" ]; then
    rm -f "$SESSIONS_DIR/$SESSION_ID" 2>/dev/null

    # Opportunistic cleanup: prune any session files older than 7 days, in case
    # SessionEnd didn't fire (Claude crash, terminal force-quit).
    find "$SESSIONS_DIR" -maxdepth 1 -type f -mtime +7 -delete 2>/dev/null
  fi
} 2>/dev/null

exit 0
