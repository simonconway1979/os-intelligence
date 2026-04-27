---
name: ctx-timeline
description: Generate a project timeline from stakeholder intelligence — meetings, logs, events, decisions, and what comes next. Two modes: summary (one-liner per event) and detailed (expanded with quotes, decisions, shifts).
user_invocable: true
---

# SI Timeline

Two phases:
1. **Interactive:** Confirm project, mode, and scope
2. **Background:** Read all SI sources → build chronological timeline → write to disk

---

## Phase 1 — Confirm Scope

**Step 1** — Print:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  TIMELINE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**Step 2 — Project.** Read root `CLAUDE.md` for `**Active project:**`. Show the project name. Confirm with user (Y/N or just Enter).

**Step 3 — Mode.** Ask:
```
Mode?
  1. Summary  — one line per event (fast read, shareable)
  2. Detailed — expanded with key quotes, decisions, and shifts

(Enter 1 or 2)
```

Wait for response.

**Step 4 — Scope.** Ask:
```
Time range?
  1. Full history (all meetings and logs)
  2. From a date (enter YYYY-MM-DD)

(Enter 1 or date)
```

Wait for response.

**Step 5 — Hand off.**

Say: `Got it. Building timeline in the background — you can keep working.`

Spawn background agent (`run_in_background: true`). Pass:
- `PROJECT_ROOT` — e.g. `projects/acme-corp-launch/`
- `PROJECT_NAME` — from CLAUDE.md
- `MODE` — `summary` or `detailed`
- `FROM_DATE` — YYYY-MM-DD or null (full history)
- `SI_DIR` — `[PROJECT_ROOT]/intelligence/`
- `EVENTS_DIR` — `[PROJECT_ROOT]/events/` (may not exist)
- `MEMORY_DIR` — `[PROJECT_ROOT]/memory/`
- `OUTPUT_PATH` — `[PROJECT_ROOT]/intelligence/timeline.md`

Tell the agent: **Read `.claude/skills/ctx-timeline/BACKGROUND.md` for full instructions. Do not ask questions — proceed through all steps.**
