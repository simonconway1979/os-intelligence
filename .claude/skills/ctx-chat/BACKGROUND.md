# CTX Chat — Background Agent Instructions

You are processing a confirmed chat thread (WhatsApp, Slack, DM, or similar). All inputs confirmed. Write outputs to CHAT_FOLDER. Do not ask questions.

---

## Inputs you were given

- `PROJECT_ROOT`, `CONTENT_PATH`, `CHAT_FOLDER`
- `THREAD_SLUG`, `IS_NEW_THREAD`, `PROCESS_FROM_DATE`
- `PARTICIPANTS` — `[{full_name, role, people_file_path}]`
- `CONTEXT` — optional context string
- `DATE_RANGE`

Create `CHAT_FOLDER` before writing any files.

**Project slug:** derive from `PROJECT_ROOT` — the folder name under `projects/`. E.g. `projects/pm-os/` → `pm-os`. Use as `project/[slug]` in tags below.

---

## Step 1 — Save raw

Read `CONTENT_PATH`. If `PROCESS_FROM_DATE` is set, extract only messages after that date before saving.

Write to `CHAT_FOLDER/raw.md` with frontmatter:

```markdown
---
date: [DATE_RANGE]
type: chat
thread: [THREAD_SLUG]
participants: [list of full names]
context: [CONTEXT or "None provided"]
tags:
  - type/chat
  - project/[PROJECT_SLUG]
  - status/raw
---
```

Then the content verbatim. Never alter it.

---

## Step 2 — Synthesise

Write `CHAT_FOLDER/synthesis.md` with YAML frontmatter followed by synthesis sections.

**Frontmatter:**
```yaml
---
date: [DATE_RANGE]
type: chat
thread: [THREAD_SLUG]
context: [CONTEXT or null]
participants:
  - [Full Name — Role — Company]
themes: [3–5 specific tags]
sentiment: [three words]
commitments: [actions or "None stated"]
confidence: Low / Medium / High
tags:
  - type/context
  - project/[PROJECT_SLUG]
  - status/synthesised
---
```

Confidence: Low = first import of this thread, Medium = 2–3, High = 4+.

**Synthesis sections:**

- **Conversation arc** — how did the thread evolve? What shifted? Who led?
- **What they said** — factual summary per participant, neutral tone
- **What it means** — relationship dynamics, subtext, what was avoided, what was emphasised. Mark: `PRIVATE`
- **Key quotes** — max 2, only when exact wording matters
- **New information** — facts, decisions, signals not previously known
- **Actions and commitments** — with owner; "None stated" if absent
- **Open questions** — what you now want to know

If `CONTEXT` is set, reference it in the interpretive sections.

---

## Step 3 — Validate (SPECULATIVE claims only)

Only check claims assessed as SPECULATIVE — interpretations that go beyond what the content directly supports.

For each SPECULATIVE claim:
1. Find source text — is there anything in the raw content that grounds it?
2. If GROUNDED but a stretch: soften language ("may suggest", "appears to")
3. If NOT GROUNDED: remove

Write `CHAT_FOLDER/validation.md`:

```markdown
# Validation — Chat — [DATE_RANGE]
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

## Step 4 — Update thread index

Write or update `[PROJECT_ROOT]/intelligence/chats/[THREAD_SLUG]/index.md`:

```markdown
---
thread: [THREAD_SLUG]
participants: [names]
platform: [WhatsApp / Slack / DM / other — infer from content if possible]
project: [PROJECT_ROOT]
tags:
  - type/context
  - project/[PROJECT_SLUG]
  - status/synthesised
---

# Thread Index — [thread name]

| Import | Date range | Folder | Notes |
|--------|------------|--------|-------|
| [N] | [DATE_RANGE] | [folder name] | [context if any] |
```

Append a new row for each import. This is the deduplication record.

---

## Step 5 — Notify

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  CHAT CAPTURED ✓
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Thread:       [THREAD_SLUG] — import [N]
Date range:   [DATE_RANGE]
Participants: [names]
Project:      [project name]

Files written:
  ✓ raw.md
  ✓ synthesis.md (validated)
  ✓ validation.md
  ✓ index.md updated

Validation:
  [N] speculative claims checked · [N] softened · [N] removed

Notable:
[Relationship signals, decisions, anything worth flagging from this thread]
```
