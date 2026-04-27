# SI Add Transcript — Background Agent Instructions

You are processing a confirmed stakeholder meeting transcript. All inputs have been provided and confirmed. Write all outputs to the meeting folder. Do not ask questions.

---

## Inputs you were given

- `PROJECT_ROOT`, `TRANSCRIPT_PATH`, `MEETING_FOLDER`
- `ATTENDEES`, `MENTIONED`, `DATE`, `TIME`, `DURATION`

Create `MEETING_FOLDER` before writing any files.

**Project slug:** derive from `PROJECT_ROOT` — the folder name under `projects/`. E.g. `projects/pm-os/` → `pm-os`. Use as `project/[slug]` in tags below.

---

## Step 1 — Save raw transcript

Read `TRANSCRIPT_PATH`. Write verbatim to `MEETING_FOLDER/raw.md` with this frontmatter prepended (skip if file already exists at that path):

```markdown
---
date: [DATE]
time: [TIME]
duration: [DURATION]
setting: [extract from transcript, or "Not recorded"]
attendees: [Full Name — Role, ...]
tags:
  - type/transcript
  - project/[PROJECT_SLUG]
  - status/raw
---
```

Never alter the transcript content.

---

## Step 2 — Synthesise + metadata (one pass)

Write `MEETING_FOLDER/synthesis.md` with YAML frontmatter at the top, then synthesis sections below.

**Frontmatter** (extract from transcript where possible):
```yaml
---
date: [DATE]
time: [TIME]
topic: [3–6 word description]
projects: [project names]
duration: [DURATION]
setting: [extracted or "Not recorded"]
attendees:
  - [Full Name — Role — Company]
mentioned:
  - [names referenced but not attending]
interview_number: [N — count prior meetings for this person in meetings/]
themes: [3–5 specific tags — not generic words like "discussion"]
sentiment: [three words]
commitments: [actions, or "None stated"]
confidence: Low / Medium / High
tags:
  - type/context
  - project/[PROJECT_SLUG]
  - status/synthesised
---
```
Confidence: Low = 1 meeting, Medium = 2–3, High = 4+.

**Synthesis sections:**
- **What they said** — factual summary, neutral tone, no interpretation
- **What they meant** — subtext, what was avoided or implied. Mark: `PRIVATE — omit from shareable`
- **Key quotes** — max 3, only when exact wording matters. Format: `> "quote"` + one-line note
- **New information** — facts, names, decisions not previously known
- **People mentioned** — not attending; note how characterised
- **Actions and commitments** — with owner if stated; "None stated" if not
- **Emotional register** — tone, energy, any shifts and why
- **Potential contradictions** — conflicts with other stakeholders (reference who)
- **Open questions** — what you now want to know

Flag uncertain claims with "appears to suggest" or "implied but not stated". If transcript is garbled or truncated, add `⚠️ Transcript quality: [issue]` at top.

---

## Step 3 — Validate interpretive claims only

Only validate statements from these sections: **What they meant**, **Emotional register**, **Potential contradictions**, and any strong characterisations in other sections. Skip **What they said** (factual) and **New information** (verifiable facts).

For each interpretive claim:
1. Find source text in `raw.md` — GROUNDED or NOT GROUNDED
2. Assess directness — EXPLICIT, INFERRED, or SPECULATIVE
3. Check cross-stakeholder — read existing synthesis files for this person in `[PROJECT_ROOT]/intelligence/meetings/`. Flag contradictions or position shifts.

**Decisions:** NOT GROUNDED → REMOVE. EXPLICIT → KEEP. INFERRED → KEEP, soften overconfident language. SPECULATIVE → REMOVE or add explicit caveat.

Apply all changes to `synthesis.md`. Write reasoning to `MEETING_FOLDER/validation.md`:

```markdown
# Validation — [Names] — [Date]
Statements checked: N | Kept: N | Softened: N | Removed: N

---
### "[statement]"
Source: "[quote]" / None found
Grounding: GROUNDED / NOT GROUNDED
Explicitness: EXPLICIT / INFERRED / SPECULATIVE
Cross-stakeholder: OK / NEW / POSITION SHIFT — [note]
Decision: KEEP / SOFTEN / REMOVE
Reason: [one sentence]
Revised: [new wording if softened]
```

---

## Step 4b — Create / update people files

For each attendee (excluding the user):

**Root-level stub** (`people/[name-slug].md`):
- If it doesn't exist: create using `people/TEMPLATE.md`. Populate name, title, company, and Project Footprint only. Add frontmatter: `tags: [type/person, status/synthesised]`
- If it exists: append this project to the `Project Footprint` table if not already listed.

**Project-level profile** (`[PROJECT_ROOT]/people/[name-slug].md`):
- If it doesn't exist: create it using the format defined in the skill's SKILL.md File Structure section. Populate **Their Role Here** from what the transcript makes clear. Leave other sections as placeholders. Add frontmatter: `tags: [type/person, project/[PROJECT_SLUG], status/synthesised]`
- If it exists: update **Their Role Here** only if the transcript adds something new. Do not overwrite other sections.

---

## Step 5 — Shareable output

Write `MEETING_FOLDER/shareable.md`. Professional, warm, suitable for email or Slack. Surface content only — nothing from the interpretive layer.

```markdown
# Meeting Notes — [Topic] — [Date]

Hi [name],

Thanks for your time [on [date]]. Here's a quick summary.

## What we discussed
[3–5 bullets]

## Key themes
[2–3 sentences]

## Follow-ups
[bullets with owners, or "No specific follow-ups agreed"]

---
[User's name]
```

If `[PROJECT_ROOT]/intelligence/comms-style.md` exists, follow that style instead.

---

## Step 6 — Notify

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  TRANSCRIPT PROCESSED ✓
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Meeting:    [Topic] — [Date]
Attendees:  [Names]
Project(s): [Projects]

Files written:
  ✓ raw.md
  ✓ synthesis.md (validated)
  ✓ validation.md
  ✓ shareable.md

Validation:
  [N] kept · [N] softened · [N] removed

Notable flags:
[Cross-stakeholder contradictions, position shifts, new information worth highlighting]
```
