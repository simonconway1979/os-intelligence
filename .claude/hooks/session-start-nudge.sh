#!/usr/bin/env bash
#
# SessionStart nudge: prints a one-line reminder to run /os-start, naming the
# active project and how long ago it was last saved.
#
# Wired into .claude/settings.json on SessionStart. Reads stdin JSON from
# Claude Code, resolves the active project (per-session via .sessions/<sid>,
# falling back to legacy .current-session), finds the newest /os-save artefact
# in that project's memory/, and emits the nudge as additionalContext.
#
# Stays silent (exit 0, no output) when there is no active project, so a
# fresh install with no project chosen doesn't get a noisy banner.
#
# To disable in your own install, remove this hook from .claude/settings.local.json
# (or comment it out in settings.json).
#
# Wraps everything so failures exit 0 — never block Claude Code on this.

{
  INPUT="$(cat 2>/dev/null)"
  SESSION_ID=$(printf '%s' "$INPUT" | jq -r '.session_id // empty' 2>/dev/null)

  WORKSPACE="${CLAUDE_PROJECT_DIR:-$(cd "$(dirname "$0")/../.." && pwd)}"

  # --- Resolve active project ---
  PROJECT=""
  if [ -n "$SESSION_ID" ] && [ -f "$WORKSPACE/.sessions/$SESSION_ID" ]; then
    PROJECT=$(head -n1 "$WORKSPACE/.sessions/$SESSION_ID" 2>/dev/null)
  fi
  if [ -z "$PROJECT" ] && [ -f "$WORKSPACE/.current-session" ]; then
    PROJECT=$(head -n1 "$WORKSPACE/.current-session" 2>/dev/null)
  fi

  # Silent exit if no project is set.
  case "$PROJECT" in
    ""|"(no project)") exit 0 ;;
  esac

  # --- Resolve project folder from projects.md ---
  # Looks for `### <name>` then the next `**Folders:** ` line, extracting the
  # path inside backticks. Portfolio items can have "Portfolio / Item" form;
  # strip after " / " to find the portfolio's folder.
  LOOKUP_NAME="${PROJECT% / *}"
  FOLDER=""
  if [ -f "$WORKSPACE/projects.md" ]; then
    FOLDER=$(awk -v name="$LOOKUP_NAME" '
      $0 == "### " name { found=1; next }
      found && /^### / { exit }
      found && /\*\*Folders:\*\*/ {
        match($0, /`[^`]+`/)
        if (RSTART > 0) {
          path = substr($0, RSTART+1, RLENGTH-2)
          sub("/$", "", path)
          print path
          exit
        }
      }
    ' "$WORKSPACE/projects.md" 2>/dev/null)
  fi

  # --- Find newest /os-save artefact + compute relative time ---
  LAST_SAVE_PHRASE="never (run /os-save when done)"
  if [ -n "$FOLDER" ] && [ -d "$WORKSPACE/$FOLDER/memory" ]; then
    NEWEST=$(ls -1 "$WORKSPACE/$FOLDER/memory" 2>/dev/null \
      | grep -E '^[0-9]{8}-[0-9]{4}\.md$' \
      | sort \
      | tail -n1)
    if [ -n "$NEWEST" ]; then
      SAVE_PATH="$WORKSPACE/$FOLDER/memory/$NEWEST"
      # Compute seconds since modification.
      NOW=$(date +%s)
      MTIME=$(stat -f %m "$SAVE_PATH" 2>/dev/null || stat -c %Y "$SAVE_PATH" 2>/dev/null)
      if [ -n "$MTIME" ]; then
        DELTA=$((NOW - MTIME))
        if [ "$DELTA" -lt 60 ]; then
          LAST_SAVE_PHRASE="just now"
        elif [ "$DELTA" -lt 3600 ]; then
          MIN=$((DELTA / 60))
          LAST_SAVE_PHRASE="${MIN} min ago"
        elif [ "$DELTA" -lt 86400 ]; then
          HR=$((DELTA / 3600))
          LAST_SAVE_PHRASE="${HR}h ago"
        elif [ "$DELTA" -lt 172800 ]; then
          LAST_SAVE_PHRASE="yesterday"
        else
          DAYS=$((DELTA / 86400))
          LAST_SAVE_PHRASE="${DAYS} days ago"
        fi
      fi
    fi
  fi

  # --- Emit nudge as SessionStart additionalContext ---
  NUDGE="💡 Run /os-start to load context for ${PROJECT}. Last save: ${LAST_SAVE_PHRASE}."

  jq -n --arg msg "$NUDGE" '{
    hookSpecificOutput: {
      hookEventName: "SessionStart",
      additionalContext: $msg
    }
  }' 2>/dev/null

} 2>/dev/null

exit 0
