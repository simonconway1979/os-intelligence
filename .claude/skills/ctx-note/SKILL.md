---
name: ctx-note
description: Capture a personal observation, written note, or voice memo into project context. Synthesises and validates the note, links to a person if relevant.
user_invocable: true
---

# CTX Note

Two phases:
1. **Interactive:** Confirm project, get content, link to a person (optional), set date
2. **Background:** Synthesise → validate → write outputs

---

## Phase 1 — Collect Inputs

**Step 1** — Print:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  CAPTURE A NOTE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

Then print this one-line tip (non-blocking — proceed to Step 2 without waiting):
```
Tip: make sure auto-accept edits is ON (Shift + Tab) — background synthesis fails silently otherwise.
```

**Step 2 — Project.** Read `[workspace-root]/.current-session` for the active project. Show pre-selected, list others. Wait for confirmation.

**Step 3 — Content.** Ask: `Paste note below, or give a file path:`

**Step 4 — Person (optional).** Ask: `Is this about a specific person? (name, or "none" to skip)`
If yes, match to `[PROJECT_ROOT]/people/`. If no match found, offer to create a stub.

**Step 5 — Context (optional).** Ask: `Any context? e.g. post-event reflection, follow-up to April 16 (type "none" to skip):`

**Step 6 — Date.** Check content for a date. If found, confirm. If not: `Date (e.g. 17 Apr 2026):`

**Step 7 — Slug.** Generate a short slug from the content topic (e.g. `april-16-reflection`). Show and ask to confirm or edit.

Show summary:
```
Project:  [name]
About:    [person name / "Not linked"]
Context:  [context / "None"]
Date:     [date]
Folder:   notes/[DATE]-[slug]/
```
Ask: `Looks right? [Y/N]`

---

## Handoff to Background Agent

Say: `Got it. Processing in the background — you can keep working.`

Spawn background agent (`run_in_background: true`). Pass:
- `PROJECT_ROOT`
- `CONTENT_PATH` — file path if given; if pasted, write verbatim to a temp path and pass that
- `ABOUT_PERSON` — person slug if linked, else null
- `CONTEXT` — optional context string
- `DATE` — e.g. "2026-04-17"
- `NOTE_FOLDER` — `[PROJECT_ROOT]/intelligence/notes/[DATE]-[slug]/`

Tell the agent: **Read `.claude/skills/ctx-note/BACKGROUND.md` for processing instructions. Do not ask questions — proceed through all steps.**

---

## File structure

```
[PROJECT_ROOT]/intelligence/notes/

  [DATE]-[slug]/
    raw.md
    synthesis.md
    validation.md
```
