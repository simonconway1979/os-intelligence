---
name: ctx-transcript
description: Process a new stakeholder meeting transcript. Collects inputs interactively (project, transcript, attendees, date), then runs synthesis, validation, and shareable output in the background so you can keep working.
user_invocable: true
---

# ctx-transcript

Two phases:
1. **Interactive:** Confirm project, get transcript, confirm attendees and date
2. **Background:** Synthesis → validation → metadata → shareable output

Supports `--batch` flag for processing multiple transcripts at once.

---

## Phase 1 — Collect Inputs

**Step 1** — Print:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ADD A TRANSCRIPT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**Step 1b — Batch mode check.**

Read `[workspace-root]/.current-session` to identify the active project and its `PROJECT_ROOT`.

If `--batch` flag passed: skip to **Batch Mode** section below.

Otherwise, check `[PROJECT_ROOT]/intelligence/meetings/` for any subdirectories containing a `synthesis.md` file (i.e. processed meetings).

- **No processed meetings found** → print:
  ```
  No meetings processed yet for this project.

  Want to load several transcripts at once? Drop your files into:
    [PROJECT_ROOT]/intelligence/meetings/inbox/

  Then press Enter and I'll process them all together.
  Or paste a single transcript now to get started.

  [batch / paste]
  ```
  Wait for response. If `batch`: go to **Batch Mode**. If `paste`: continue to Step 2.

- **Processed meetings exist** → continue to Step 2 (normal flow).

---

## Batch Mode

**B1 — Create inbox.** Create `[PROJECT_ROOT]/intelligence/meetings/inbox/` if it doesn't exist.

**B2 — Wait for files.** If the user selected batch mode, print:
```
Ready. Drop your transcript files (.md or .txt) into:
  [PROJECT_ROOT]/intelligence/meetings/inbox/

Press Enter when ready.
```
Wait for confirmation.

**B3 — Read inbox.** List all files in `inbox/`. If empty: print `No files found in inbox. Add files and try again.` and stop.

**B4 — Process each file.** For each file in the inbox:

1. Read the first 40 lines to extract: date, time, attendee names, topic.
2. Match attendees against root `people/` and `[PROJECT_ROOT]/people/`. Note any unmatched names.
3. Build `MEETING_FOLDER`: `[PROJECT_ROOT]/intelligence/meetings/[DATE]-[TIME]-[slug]/`
4. Copy file content verbatim to `[MEETING_FOLDER]/raw.md`.
5. Delete the source file from `inbox/`.
6. Spawn a background agent to process this meeting. Pass the same parameters as the single-transcript handoff. Tell the agent: **Read `.claude/skills/ctx-transcript/BACKGROUND.md` for processing instructions. Do not ask questions — proceed through all steps.**

**B5 — Gaps report.** After all files are dispatched, print a summary:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  BATCH COMPLETE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Processed: [N] transcripts

⚠ Gaps to resolve:
- [filename]: date not found — assumed [date] from filename
- [filename]: "Alex M" unmatched — no contact record found
- [filename]: attendees unclear — only one speaker detected
```

Any gaps the user should address manually are listed. Syntheses run in the background — no further input needed.

---

## Phase 1 — Single Transcript (normal flow)

**Step 2 — Project.** Read `[workspace-root]/.current-session` for the active project. Show pre-selected, list others from `projects.md`. Wait for confirmation.

**Step 3 — Transcript.** Ask: `Paste the transcript below, or give a file path:`. Accept either. If a path: read only the first 30 lines (header block) to extract attendees and date/time — do not read the full file. Pass the path to the background agent.

**Step 4 — Attendees.** Identify speakers from header block or first few lines. Match each against BOTH root `people/` AND `[PROJECT_ROOT]/people/` by first name, full name, or role keyword. Show confirmation table — full name, role, matched/unmatched.

For unmatched names, offer to create a contact: extract name, role, company from what's visible and write:
- Root stub: `people/[name-slug].md` (using `people/TEMPLATE.md`)
- Project profile: `[PROJECT_ROOT]/people/[name-slug].md` (see File Structure below)

For matched names who don't yet have a project-level profile, create `[PROJECT_ROOT]/people/[name-slug].md` automatically.

Skip "Me" / "You" / the user.

**Step 5 — Date/time.** Check transcript headers first. If found, confirm with user (Y/N). If not found, ask. Get duration too.

---

## Handoff to Background Agent

Say: `Got everything. Processing in the background — you can keep working.`

Spawn background agent (`run_in_background: true`). Pass:
- `PROJECT_ROOT` — e.g. `projects/acme-corp-launch/`
- `TRANSCRIPT_PATH` — file path if given; if pasted, write verbatim to `[MEETING_FOLDER]/raw.md` first, then pass that path
- `ATTENDEES` — list of `{full_name, role, company, people_file_path}`
- `MENTIONED` — names referenced but not attending
- `DATE`, `TIME`, `DURATION`
- `MEETING_FOLDER` — `[PROJECT_ROOT]/intelligence/meetings/[DATE]-[TIME]-[attendee-slug]/`

Slug = attendee names joined by hyphens (exclude user), max 40 chars.

Tell the agent: **Read `.claude/skills/ctx-transcript/BACKGROUND.md` for processing instructions. Do not ask questions — proceed through all steps.**

---

## File structure

```
[PROJECT_ROOT]/intelligence/meetings/[DATE]-[TIME]-[slug]/
  raw.md          ← verbatim transcript, never modified
  synthesis.md    ← validated synthesis + YAML frontmatter
  validation.md   ← per-statement evidence audit
  shareable.md    ← professional summary, safe to send to attendees

[PROJECT_ROOT]/people/[name-slug].md   ← project-level profile (created/updated per attendee)
people/[name-slug].md                  ← root-level identity stub (created if new contact)
```

**Project-level people file format** (`[PROJECT_ROOT]/people/[name-slug].md`):

```markdown
# [Full Name] — [Project Name]

**Role:** [Title, Company]
**See also:** [Root profile](../../people/[name-slug].md)

---

## Their Role Here

[Fill in after first meeting]

---

## What They Care About

[Fill in after first meeting]

---

## Working With Them

[Fill in after first meeting]

---

## Key Context

[Fill in after first meeting]

---

## Sources
```

The background agent populates **Their Role Here** from the transcript if clear. Other sections are left as placeholders for the user to fill in, or for `ctx-doc` to populate from richer material.
