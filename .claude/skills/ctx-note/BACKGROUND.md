# CTX Note — Background Agent Instructions

You are processing a confirmed personal note or observation. All inputs confirmed. Write outputs to NOTE_FOLDER. Do not ask questions.

---

## Inputs you were given

- `PROJECT_ROOT`, `CONTENT_PATH`, `NOTE_FOLDER`
- `ABOUT_PERSON` — person slug or null
- `CONTEXT` — optional context string (e.g. "post-event reflection")
- `DATE`

Create `NOTE_FOLDER` before writing any files.

**Project slug:** derive from `PROJECT_ROOT` — the folder name under `projects/`. E.g. `projects/pm-os/` → `pm-os`. Use as `project/[slug]` in tags below.

---

## Step 1 — Save raw

Read `CONTENT_PATH`. Write to `NOTE_FOLDER/raw.md` with frontmatter:

```markdown
---
date: [DATE]
type: note
about: [ABOUT_PERSON or "Not linked"]
context: [CONTEXT or "None provided"]
tags:
  - type/note
  - project/[PROJECT_SLUG]
  - status/raw
---
```

Then the content verbatim. Never alter it.

---

## Step 2 — Synthesise

Write `NOTE_FOLDER/synthesis.md` with YAML frontmatter followed by synthesis sections.

**Frontmatter:**
```yaml
---
date: [DATE]
type: note
context: [CONTEXT or null]
about: [ABOUT_PERSON or null]
themes: [3–5 specific tags]
sentiment: [three words]
confidence: Low / Medium / High
tags:
  - type/context
  - project/[PROJECT_SLUG]
  - status/synthesised
---
```

Confidence: Low = first signal from this person/topic, Medium = 2–3, High = 4+.

**Synthesis sections:**

- **What it says** — factual summary of the note's content
- **What it means** — interpretation, implications, subtext. Mark: `PRIVATE`
- **Key quotes** — max 2, only when exact wording matters
- **New information** — facts, names, decisions not previously known
- **People mentioned** — who came up and how
- **Actions and commitments** — with owner; "None stated" if absent
- **Open questions** — what you now want to know

If `CONTEXT` is set, reference it in the interpretive sections.

---

## Step 3 — Validate (SPECULATIVE claims only)

Only check claims assessed as SPECULATIVE — interpretations that go beyond what the content directly supports. Skip factual statements.

For each SPECULATIVE claim:
1. Find source text — is there anything in the raw content that grounds it?
2. If GROUNDED but a stretch: soften language ("may suggest", "appears to")
3. If NOT GROUNDED: remove

Write `NOTE_FOLDER/validation.md`:

```markdown
# Validation — Note — [DATE]
Speculative claims checked: N | Kept: N | Softened: N | Removed: N

---
### "[claim]"
Source: "[quote]" / None found
Decision: KEEP / SOFTEN / REMOVE
Reason: [one sentence]
Revised: [new wording if softened]
```

If no speculative claims found, write: `No speculative claims identified.`

---

## Step 4 — Notify

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  NOTE CAPTURED ✓
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Date:     [DATE]
About:    [ABOUT_PERSON or "Not linked"]
Project:  [project name]

Files written:
  ✓ raw.md
  ✓ synthesis.md (validated)
  ✓ validation.md

Validation:
  [N] speculative claims checked · [N] softened · [N] removed

Notable:
[New information, anything worth flagging from this note]
```
