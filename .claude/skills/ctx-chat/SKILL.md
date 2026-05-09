---
name: ctx-chat
description: Capture a WhatsApp, Slack, or DM thread into project context. Handles multi-party threads with deduplication — import the same thread repeatedly and only new messages get processed.
user_invocable: true
---

# CTX Chat

Two phases:
1. **Interactive:** Confirm project, get thread content, confirm participants and thread name, handle deduplication
2. **Background:** Synthesise → validate → update thread index → write outputs

---

## Phase 1 — Collect Inputs

**Step 1** — Print:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  CAPTURE A CHAT THREAD
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

Then print this one-line tip (non-blocking — proceed to Step 2 without waiting):
```
Tip: make sure auto-accept edits is ON (Shift + Tab) — background synthesis fails silently otherwise.
```

**Step 2 — Project.** Read `[workspace-root]/.current-session` for the active project. Show pre-selected, list others. Wait for confirmation.

**Step 3 — Content.** Ask: `Paste thread below, or give a file path:`

**Step 4 — Participants.** Extract participant names from speaker labels (`Name:`, `[timestamp] Name:`, bold patterns).
- Match each against `[PROJECT_ROOT]/people/` by first name, full name, or role
- Show confirmation table:

```
Name found in content  →  Matched to               Action
─────────────────────────────────────────────────────────
Alex Chen              →  alex-chen.md              ✓ matched
Priya Sharma           →  priya-sharma.md           ✓ matched
Marcus Webb            →  No match found            Create stub?
```

Offer to create stubs for unmatched names.

**Step 5 — Thread name.** Ask: `Thread name (used for deduplication):`
Suggest a slug based on participants or platform (e.g. `acme-launch-team-whatsapp`). User can edit.

**Step 6 — Deduplication check.** Check if `[PROJECT_ROOT]/intelligence/chats/[thread-slug]/index.md` exists.
- If yes: show last processed date range. Ask: `Last import covered [date range]. Process from [end date] onwards? [Y/N]`
- If no: first import — process all.

**Step 7 — Context (optional).** Ask: `Any context? e.g. post-event, planning thread (type "none" to skip):`

**Step 8 — Date range.** Check content for timestamps. If found, confirm. If not: `Date or date range (e.g. 10–17 Apr 2026):`

Show summary:
```
Project:      [name]
Thread:       [thread-slug]
Participants: [names]
Import:       [N] (new / existing thread)
Date range:   [range]
Folder:       chats/[thread-slug]/[date-range]/
```
Ask: `Looks right? [Y/N]`

---

## Handoff to Background Agent

Say: `Got it. Processing in the background — you can keep working.`

Spawn background agent (`run_in_background: true`). Pass:
- `PROJECT_ROOT`
- `CONTENT_PATH` — file path if given; if pasted, write verbatim to a temp path and pass that
- `THREAD_SLUG`
- `IS_NEW_THREAD` — true/false
- `PROCESS_FROM_DATE` — for existing threads, only synthesise content after this date
- `PARTICIPANTS` — `[{full_name, role, people_file_path}]`
- `CONTEXT` — optional context string
- `DATE_RANGE` — e.g. "2026-04-10_2026-04-17"
- `CHAT_FOLDER` — `[PROJECT_ROOT]/intelligence/chats/[thread-slug]/[DATE_RANGE]/`

Tell the agent: **Read `.claude/skills/ctx-chat/BACKGROUND.md` for processing instructions. Do not ask questions — proceed through all steps.**

---

## File structure

```
[PROJECT_ROOT]/intelligence/chats/

  [thread-slug]/
    index.md                    ← thread identity + import history (deduplication record)
    [DATE-RANGE]/               ← e.g. 2026-03-30_2026-04-16
      raw.md
      synthesis.md
      validation.md
```
