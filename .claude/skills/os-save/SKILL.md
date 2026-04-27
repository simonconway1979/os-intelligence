---
name: os-save
description: Save a summary of the current session to the project memory folder and create a context snapshot for future retrieval. Run at the end of any working session, or before switching projects.
user_invocable: true
---

# /os-save — Session Save

Records what happened in this session, creates a searchable context snapshot, updates the sessions index, updates projects.md, and optionally commits and pushes to git.

---

## Opening notification

Print this before doing anything:

```
Saving session for [active project name]...
```

---

## Step 1 — Identify the active project

Read `[workspace-root]/.current-session`.

- If it contains ` / ` (e.g. `Job Opportunities / Acme Corp — Senior PM`): this is a portfolio item session. Go to Step 1b.
- If it's a single name (e.g. `PM-OS`): look it up in `projects.md` to find the folder path. Use that as the project root.
- If `.current-session` is missing or empty: ask the user which project this session belongs to.

### Step 1b — Portfolio item session

Parse the text:
- **Portfolio name** = text before ` / ` (e.g. `Job Opportunities`)
- **Item display name** = text after ` / ` (e.g. `Acme Corp — Senior PM`)

Look up the portfolio name in `projects.md` to get the portfolio folder (e.g. `projects/job-opportunities/`).

Read the portfolio's `CLAUDE.md` to find `**Items folder:**` (e.g. `opportunities/`).

Find the item folder: read `[portfolio-folder]/TRACKER.md`. Find the row where the link text matches the item display name. Extract the relative path from the markdown link (e.g. `[Acme Corp — Senior PM](opportunities/acme-corp-senior-pm/opportunity.md)` → item folder = `opportunities/acme-corp-senior-pm/`). If no exact match, scan subdirectories under the items folder for a main file whose title matches.

**Use `[portfolio-folder]/[item-folder]/` as the project root for Steps 4–7.** (This is where memory/ and intelligence/ live.)

Keep the portfolio folder path for Step 1c.

### Step 1c — Portfolio summary index

After saving the item memory in Step 4, also update `[portfolio-folder]/memory/SESSIONS-INDEX.md` with a one-liner linking to the item session file:

```
| [YYYYMMDD-HHMM] | [Item display name] | [One sentence summary] | [link to item memory file] |
```

Create this file if it doesn't exist, with header:
```markdown
# Portfolio Sessions Index — [Portfolio Name]

| Session | Item | Summary | File |
|---------|------|---------|------|
```

This gives portfolio-level retrieval without reading all item memory files.

---

## Step 2 — Get the datetime

Run `date +"%Y%m%d-%H%M"` to get the current datetime.

**Filename format:** `YYYYMMDD-HHMM`
**Examples:** `20260409-1430`, `20260409-0915`

This timestamp is used for all files created in this skill.

---

## Step 3 — Gather session metadata

Ask the user (both fields are skippable — press enter to use `[unknown]`):

1. **Session duration** — "How long was this session? (e.g. 1h 20m — shown in your status bar, or enter to skip)"
2. **Session cost** — "What's the session cost shown in your status bar? (e.g. $1.21, or enter to skip)"

Use `[unknown]` for any skipped field.

Assess whether this was an **exploratory session** (lots of discussion, direction changes, dead ends) or an **execution session** (clear tasks, concrete outputs). This determines whether a reasoning appendix is needed.

---

## Step 4 — Create the context snapshot

Save to: `[active-project]/memory/[YYYYMMDD-HHMM].md`

Review the full conversation history carefully before writing. This file is the primary context source for future sessions — prioritise the decisions and reasoning sections over the file list.

**File format:**

```markdown
---
session: [YYYYMMDD-HHMM]
project: [project name from CLAUDE.md]
topics: [comma-separated keywords — think: what would someone search to find this?]
session-type: exploratory | execution | mixed
context-quality: [leave blank — filled in at start of next related session]
reasoning-appendix: [YYYYMMDD-HHMM]-reasoning.md | none
tags:
  - type/memory
  - project/[project-slug]
  - status/synthesised
---

## Summary
**Duration:** [Xh Ym] | **Cost:** [$X.XX]

[One paragraph: what this session was about and what it produced. Written so a search
for the topic would surface this file. Plain language, no jargon.]

## Active Work Streams
What was in progress during this session and its current status.

- **[Work stream name]** — [COMPLETE | IN PROGRESS | PLANNED | ABANDONED]
  [One sentence on where it stands and what's left if not complete.]

## Files Created / Modified
| File | Action | What it contains |
|------|--------|-----------------|
| [path] | Created / Updated / Deleted | [one line] |

## Key Decisions
The most important section. For each significant decision made this session:

**[Decision title]**
- **Decided:** [what was decided]
- **Why:** [the reasoning — be specific, this decays fastest]
- **Rejected alternatives:** [what else was considered and why it was rejected]
- **Assumes:** [what has to be true for this decision to hold]
- **Where it lives:** [file path where this is implemented or documented]

## Current State
Honest snapshot. What's actually done. What's partially done. What was discussed but not shipped.

- ✅ [Done]
- 🔄 [In progress — what's left]
- 📋 [Discussed/planned but not started]

## Suggested Next Steps
Ordered by priority. Specific enough to act on without loading more context.

1. [Action] — [why it's first]
2. [Action]
3. [Action]

## Open Questions / Blockers
Things not resolved. Things that need a decision before work can continue.

- [Question or blocker] — [what's needed to resolve it]

## Git Commit Draft
[See Step 8 — included here for reference when committing]
```

---

## Step 5 — Update current-state.md

Check if `[project-root]/context/current-state.md` exists.

**If it doesn't exist:** Create it by copying the template from `setup/project-template v2/context/current-state.md`. Fill in the project name in frontmatter and the Project Position section from what you know about this session.

**Update the following sections** (leave other sections unchanged):

**In Flight** — Replace with the current Active Work Streams that are IN PROGRESS or PLANNED. Remove anything marked COMPLETE.

**Open Questions / Blockers** — Replace with the current Open Questions / Blockers from the snapshot.

**Recent Changes** — Prepend a new line (keep last 3-5 entries, remove older ones):
```
- [YYYY-MM-DD] [one-line summary of what changed this session]
```

**Standing Decisions** — For any Key Decisions in this session that are architectural or likely to persist across many sessions, add a row to the Standing Decisions table. Use judgment — not every decision warrants promotion. Skip decisions that are session-specific or likely to be revisited soon.

**Update frontmatter:**
```yaml
last-updated: [today's date]
updated-by: os-save
```

Update each modified section's `_Last updated:_` line to today's date.

---

## Step 6 — Create reasoning appendix (exploratory sessions only)

If the session was exploratory or had significant direction changes, create a second file:

Save to: `[active-project]/memory/[YYYYMMDD-HHMM]-reasoning.md`

```markdown
# Reasoning Log — [YYYYMMDD-HHMM]

## What We Tried and Abandoned
For each dead end:
- **Tried:** [what was attempted]
- **Why abandoned:** [the reason]
- **What we learned:** [the insight, so we don't revisit]

## Direction Changes Mid-Session
- **Original direction:** [what we started with]
- **What changed:** [the pivot]
- **Why:** [the reason for the change]
- **New direction:** [where we ended up]

## Assumptions Still Unvalidated
- **[Assumption]** — if wrong, [consequence]

## Exploratory Threads (No Conclusion)
Topics discussed but not resolved — worth knowing they were explored.
- [Thread] — [current status / why unresolved]
```

Reference this file in the main snapshot's frontmatter: `reasoning-appendix: [YYYYMMDD-HHMM]-reasoning.md`

For execution sessions with no significant exploration, set `reasoning-appendix: none`.

---

## Step 7 — Update the sessions index

File: `[active-project]/memory/SESSIONS-INDEX.md`

Create this file if it doesn't exist. Add one line per session in this format (newest first):

```markdown
| [YYYYMMDD-HHMM] | [topic1, topic2, topic3] | [One sentence: what happened and what was produced] |
```

**Index file format (create if missing):**
```markdown
# Sessions Index — [Project Name]

| Session | Topics | Summary |
|---------|--------|---------|
| [newest first] | | |
```

---

## Step 8 — Update projects.md

Update the `Last session:` field for the active project in `projects.md`:

```
**Last session:** [YYYY-MM-DD]
```

---

## Step 9 — Draft git commit and ask to commit

Review all files created or modified this session. Draft a commit message in this format:

```
[type]: [short summary under 60 chars]

- [file or change 1]
- [file or change 2]
- [file or change 3]

Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>
```

Types: `feat` (new feature/file), `update` (changes to existing), `fix` (bug fix), `docs` (documentation only), `refactor` (restructure without behaviour change).

Show the draft commit to the user, then ask:

> Commit to git? (y/N)

If yes: stage the relevant files and commit using the draft message.
If no: save the draft in the snapshot's "Git Commit Draft" section and move on.

---

## Step 10 — Ask to push

If a commit was made in Step 8, ask:

> Push to git? (y/N)

Default is no. If yes: run `git push`.

---

## Step 11 — Confirm

```
✅ Session saved

Context snapshot:   [active-project]/memory/[YYYYMMDD-HHMM].md
Reasoning log:      [active-project]/memory/[YYYYMMDD-HHMM]-reasoning.md  (if created)
Sessions index:     [active-project]/memory/SESSIONS-INDEX.md
Current state:      [active-project]/context/current-state.md  (updated)
```

---

## Loading Context in Future Sessions

When a user asks about past work, follow this retrieval order:

1. **Load the index** (`[active-project]/memory/SESSIONS-INDEX.md`) — scan topics and summaries to find the relevant session
2. **Load the matching snapshot** — read the full context snapshot for that session
3. **Load the reasoning appendix** only if the user asks why a decision was made or wants to understand the exploration
4. **Load additional sessions** only if the user asks for more context or history

Never load multiple full snapshots upfront. Start with one, offer to load more.

When loading a snapshot, note the `context-quality` field. If blank, ask at the end of the session: "How useful was the context from [date]? [complete / partial / stale]" and update the field.

---

## Important Constraints

- One snapshot file per session — never append to an existing file
- Datetime filename ensures chronological ordering and no collisions
- The decisions section is the most valuable part — never summarise it too briefly
- Reasoning appendix is optional but important for exploratory sessions
- Index lines must stay short — they are scanned, not read
- If session cost or duration is unknown, use `[unknown]` — don't omit the field
