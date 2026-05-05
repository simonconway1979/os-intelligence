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
[See Step 9 — included here for reference when committing]
```

---

## Step 5 — Update current-state.md

Check if `[project-root]/context/current-state.md` exists.

**If it doesn't exist:** Create it inline using this template, substituting `[Project Name]`, `[One-liner from projects.md]`, `[Goal from projects.md]`, and `[today]` (YYYY-MM-DD). Fill Project Position from what you know about this session:

```markdown
---
project: [Project Name]
last-updated: [today]
updated-by: os-save
---

# Current State

The current snapshot of the project. Living synthesis.

_Updated by os-save, ctx-synthesise, and ctx-doc. Primary context loaded at session start._

---

## [Project Name]

[One-liner from projects.md]

**Goal:** [Goal from projects.md]

_Synced from `projects.md`. Edit there._

---

## Project Position
_Last updated: [today] via os-save_

**Where we stand:** [2-3 sentences from this session]
**Primary goal:** [what success looks like right now]
**Key constraint or risk:** [the thing most likely to affect whether we succeed]

---

## What We Know From Documents
_Last updated: — via ctx-doc_

—

**Sources:** —

---

## Stakeholder Dynamics
_Last updated: — via ctx-synthesise_

**Current read:** —
**Key positions:** —
**Tensions:** —
**Who to watch:** —

---

## Standing Decisions
_Last updated: [today] via os-save_

| Decision | What was decided | Why it matters |
|----------|-----------------|----------------|
| — | — | — |

---

## In Flight
_Last updated: [today] via os-save_

- —

---

## Open Questions / Blockers
_Last updated: [today] via os-save_

- —

---

## Recent Changes
_Last updated: [today] via os-save_

- —
```

After the file is created, continue with the section updates below to populate In Flight, Open Questions, Recent Changes, and Standing Decisions from this session's content.

**If the file already exists, reconcile the top block before updating sections:** confirm the header is `# Current State` (not `# Current State — [Project Name]`) and that the `## [Project Name]` block immediately below carries the current one-liner + `**Goal:**` line + `_Synced from `projects.md`. Edit there._` note. If the file uses the older header format, or the one-liner / goal has drifted from `projects.md`, rewrite the top block to match. Don't touch sections below `## Project Position` as part of reconciliation — those are handled by the section-update rules below.

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

## Step 9 — Draft commit(s), then commit + push together

### Step 9a — Discover symlinked-skill changes (run BEFORE drafting)

Skills, sub-agents, and other shared assets in this workspace may be symlinks into a master repo (e.g. `~/Code/os-intelligence/`). Edits made via workspace paths land in the master repo, not the current repo — so they need a companion commit there.

Run the deterministic discovery script (don't rely on the model's recollection of files edited this session):

```bash
bash .claude/skills/os-save/symlink-discovery.sh
```

The script (lives at `.claude/skills/os-save/symlink-discovery.sh`):
1. Finds all symlinks in `.claude/skills/`, `.claude/agents/`, `sub-agents/`
2. Resolves each to its backing external repo (skips dangling, skips workspace-internal)
3. For each external repo, runs `git status --porcelain` and intersects with the workspace-reachable resolved paths
4. Outputs one line per dirty intersected file: `[external-repo-abs-path]<TAB>[path-in-external-repo]`

Empty output = no companion commits needed. Skip the rest of 9a and proceed with a single commit.

Non-empty output = each line is a companion-commit candidate. Group lines by external-repo column to determine how many companion commits and which files each touches.

This pattern matches `/os-start`'s `menu.sh` — deterministic work in bash, judgment in the LLM. Single allowlist rule covers all `/os-save` invocations: `Bash(bash .claude/skills/os-save/*:*)`.

> **Note on subtle property:** if you also worked directly in the external repo between sessions (without committing), this check surfaces those changes too. Worst case the user says N and handles separately. Don't try to filter by mtime or guess provenance — just show what's dirty.

### Step 9b — Draft commit message(s)

**Primary commit (current repo):** as today.

```
[type]: [short summary under 60 chars]

- [file or change 1]
- [file or change 2]
- [file or change 3]

Co-Authored-By: Claude <noreply@anthropic.com>
```

Types: `feat` (new feature/file), `update` (changes to existing), `fix` (bug fix), `docs` (documentation only), `refactor` (restructure without behaviour change).

**Companion commit(s) (one per external repo with dirty symlinked files):**

```
[type]: [short summary describing the symlinked changes]

- [resolved file 1 relative to external repo]
- [resolved file 2 relative to external repo]

Companion to <primary-repo-name>: <primary-commit-summary>
(commit hash filled in after primary lands)

Co-Authored-By: Claude <noreply@anthropic.com>
```

### Step 9c — Auto-execute (no prompt)

Show **all** drafts together (primary + companions) so the user sees what's about to land. Then **execute immediately, no y/N**.

If there's nothing to commit (working tree clean for both current and external repos), skip 9c entirely and note in Step 10 ("Nothing to commit").

Execution order, all inline, no prompts:

1. Stage session files in the current repo (do not bulk-stage with `git add -A` — only files this session created or modified).
2. `git commit` in current repo with primary message.
3. `git push` in current repo.
4. Capture the primary commit's short hash. For each companion draft, replace the placeholder line with the actual hash.
5. For each external repo:
   - `cd` into it
   - `git add` only the resolved symlinked paths (not other dirty files in that repo)
   - `git commit` with the companion message
   - `git push`

If primary commit fails (pre-commit hook etc.): surface error, stop. Do NOT proceed to companions, do NOT amend, do NOT skip hooks. The session save files are still on disk — user can re-run /os-save once the underlying issue is fixed.

If primary push fails (no upstream, non-fast-forward): surface error, stop. Do NOT force-push, do NOT proceed to companions. User decides how to proceed (fetch + rebase, or roll back).

If primary succeeds but a companion commit/push fails: surface clearly which repo and at which step. Don't roll back the primary — it's already pushed.

**Rollback paths if a save was wrong:**
- Pre-push (rare with auto-push): `git reset --soft HEAD~1` — undo the commit, keep changes staged.
- Post-push (the normal case): `git revert HEAD && git push` — creates a "Revert: ..." commit on top. Honest history, no force-push needed. Standard solo-repo pattern.
- Don't `git push --force` — blocked by the deny rule in `.claude/settings.json` for safety; revert is the right tool.

---

## Step 10 — Confirm

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
