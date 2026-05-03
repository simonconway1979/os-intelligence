#!/bin/bash
# Renders the /os-start menu from projects.md — fast, deterministic, no LLM needed.

set -e
WORKSPACE="$(cd "$(dirname "$0")/../../.." && pwd)"
PROJECTS_FILE="$WORKSPACE/projects.md"

awk '
  /^## Active/ { in_active=1; next }
  /^## / && in_active { in_active=0 }
  in_active && /^### / {
    name = substr($0, 5)
    projects[++n] = name
    types[n] = ""
  }
  in_active && /^- \*\*Type:\*\*/ {
    types[n] = $3
  }
  END {
    print "✦ os-start ✦"
    print "Getting your context..."
    print ""
    print "What do you want to work on?"
    print ""
    for (i = 1; i <= n; i++) {
      label = projects[i]
      if (types[i] == "portfolio") label = label " (portfolio)"
      printf "%d. %s\n", i, label
    }
    printf "%d. New project\n", n+1
  }
' "$PROJECTS_FILE"
