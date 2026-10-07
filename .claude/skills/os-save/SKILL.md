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

Read `[workspace-root]/.sessions/<session-id>` (your Claude Code session ID is injected into your context by the SessionStart hook). If that file doesn't exist or you don't have a session ID, fall back to `[workspace-root]/.current-session`.

- If the value contains ` / ` (e.g. `Job Opportunities / Acme Corp — Senior PM`): this is a portfolio item session. Go to Step 1b.
- If it's a single name (e.g. `PM-OS`): look it up in `projects.md` to find the folder path. Use that as the project root.
- If neither file exists or both are empty: ask the user which project this session belongs to.

### Step 1b — Portfolio item session

Parse the text:
- **Portfolio name** = text before ` / ` (e.g. `Job Opportunities`)
- **Item display name** = text after ` / ` (e.g. `Acme Corp — Senior PM`)

Look up the portfolio name in `projects.md` to get the portfolio folder (e.g. `projects/job-opportunities/`).

Read the portfolio's `CLAUDE.md` to find `**Items folder:**` (e.g. `opportunities/`).

Find the item folder: read `[portfolio-folder]/TRACKER.md`. Find the row where the link text matches the item display name. Extract the relative path from the markdown link (e.g. `[Acme Corp — Senior PM](opportunities/acme-corp-senior-pm/opportunity.md)` → item folder = `opportunities/acme-corp-senior-pm/`). If no exact match, scan subdirectories under the items folder for a main file whose title matches.

**Use `[portfolio-folder]/[item-folder]/` as the project root for Steps 4–7.** (This is where memory/ and context/ live.)

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

## Step 3 — Assess session type

Set both **Duration** and **Cost** to `[unknown]` in the snapshot. Most users don't have these readily available. Users who track time and cost can fill them in manually after.

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

> **Mode switch — workspace incremental synthesis.** Before doing anything in this step, read `[workspace-root]/.os-config`. If it exists and contains `synthesise-on-save: true`, **skip the rest of Step 5 and follow Step 5S (Incremental synthesis) below instead.** If the file is absent, unreadable, or the flag is not set to true, do the legacy procedure in the rest of this step — this is the default and the only path public users get.

**Resolve the current-state location root-first:** if `[project-root]/current-state.md` exists, that's the file (the OSI adopt-in-place location, written by `/osi-setup` and `/synthesise`); else if `[project-root]/state/current-state.md` exists, use that (the richer PM-OS / `/os-new-project` shape); else if `[project-root]/context/current-state.md` exists, use that and note the workspace predates migration 0003; if none exists, create a new one at `[project-root]/current-state.md` (root is the OSI default). Use the resolved path everywhere `current-state.md` is read or written below.

**If it doesn't exist:** Create it at the resolved root path using this template, substituting `[Project Name]`, `[One-liner from projects.md]`, `[Goal from projects.md]`, and `[today]` (YYYY-MM-DD). Fill Project Position from what you know about this session:

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

## Step 5S — Incremental synthesis (flagged; replaces Step 5 when `synthesise-on-save: true`)

This produces `current-state.md` by reconciling **only what changed this session** against the existing file, instead of hand-patching fixed sections. It writes the **same os-schema** as Step 5 (Project Position, What We Know From Documents, Stakeholder Dynamics, Standing Decisions, In Flight, Open Questions, Recent Changes) — it does **not** adopt the standalone `/synthesise` template. It borrows `/synthesise`'s *method*, not its output shape.

Three passes: **incremental reconcile** → **staleness sweep** → (occasionally) **full re-anchor**.

### 5S.0 — If current-state.md doesn't exist
Create it from the Step 5 template first (the block above), then continue — the first run reconciles against an empty base, which is fine.

### 5S.1 — Compute the changed-input set (deterministic)
Run the diff script (don't rely on recollection of files touched):

```bash
bash .claude/skills/os-save/session-diff.sh [project-root-relative-to-workspace]
```

It prints `## base-commit`, `## project`, `## mode`, then one `STATUS<TAB>path` line per changed source (`A` added/untracked, `M` modified, `D` deleted), already excluding `current-state.md`, `SESSIONS-INDEX.md`, and the synth sidecar. The base is the commit that last wrote this project's `current-state.md`, so the set is exactly what moved since the last save (this session is still uncommitted — os-save commits in Step 9).

Classify the lines into buckets — they weight differently in reconciliation:
- **session / reasoning** (`memory/[YYYYMMDD-HHMM].md`, `-reasoning.md`) — carry this session's decisions and reasoning. Always present.
- **canonical context** (`state/*.md` other than current-state) — feed *What We Know From Documents* and *Standing Decisions*.
- **intelligence / raw** (`context/**`, `people/*`) — feed *Stakeholder Dynamics* and *What We Know*.
- **deletions** (`D`) — handled in 5S.2 as retractions.

### 5S.2 — Incremental vs full re-anchor
Read `last-full-synthesise:` from current-state frontmatter (absent = never). Do a **full re-anchor** (read the whole project folder via the `/synthesise` method — Steps 2–5 of that skill, hierarchical roll-up if > ~60 sources) instead of incremental when **any** holds:
- `last-full-synthesise` is missing or older than **14 days**, or
- the changed set is large (**> ~40 files** — `## mode: first-run` always qualifies).

A full re-anchor re-reads sources, rebuilds every section, and **resets `last-full-synthesise:` to today**. Otherwise do the incremental reconcile in 5S.3. (Thresholds are provisional — tune from observed drift.)

### 5S.3 — Incremental reconcile
Base = the existing `current-state.md`. Read the full content of each `A`/`M` file in the changed set. **Prefer raw, dedupe derived** (`/synthesise` Step 1.3): for a meeting folder carrying `raw.md` + `synthesis.md` + `validation.md` + `shareable.md`, read one representation (prefer `raw`), not all four — they're one source re-expressed, not corroboration. The session memory file and the raw artifacts are complementary here (one carries decisions, the other evidence); reconcile where they overlap, don't double-count.

Apply `/synthesise`'s reconciliation rules over **prior current-state + this delta only**:
- **Corroborate / sequence over time** — newer evidence updates older; say what changed; weight repeated signals over single fresh anecdotes.
- **Surface contradictions, never flatten** — name both sides with sources; reconcile only if evidence supports it.
- **Cross-check structural claims** — when a changed source asserts something another document would independently record (a reporting line, a "shipped" claim, a named gate), pull that counterpart in *even if it didn't change this session* and surface any *stated ≠ recorded* mismatch.
- **Self-correct vs prior** — where a changed input supersedes a claim already in current-state, weaken/resolve it explicitly; don't carry it forward stale.
- **Deletions = retractions** — for each `D` path, find any finding in current-state whose provenance cites it; weaken or flag it (the support is gone), don't silently keep it.

Update the os-schema sections from the reconciled result (only those the delta touches): **Project Position**, **What We Know From Documents**, **Stakeholder Dynamics**, **Standing Decisions**, **In Flight**, **Open Questions**, **Recent Changes** (prepend one line, keep last 3–5). Keep/add a provenance link for every finding that changed, relative to the file's folder.

### 5S.4 — Staleness sweep (always, even on incremental)
This is the cheap pass that recovers what an input-diff can't see — rot in sections nothing touched this session. **No source reads.** Over the current-state file itself:
- For each section, recompute the age of its `_Last updated:_` date vs today and set the flag: 🟢 fresh · 🟡 ageing (re-check soon) · 🔴 materially stale (recommend refresh).
- Scan the prose for **dated commitments / passed milestones** (a date that has gone by with no later line confirming it shipped/closed) and **open loops** (an agreed action or promised artifact with no recorded outcome); surface them in Open Questions or a one-line staleness note. A prior 🟡/🔴 with no new evidence gets *louder* with elapsed time noted, never silently dropped.

### 5S.5 — Frontmatter
```yaml
last-updated: [today]
updated-by: os-save (synthesise)
last-full-synthesise: [today if 5S.2 ran a full re-anchor; otherwise carry the prior value]
```
Update each changed section's `_Last updated:_` line to today.

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

Also refresh the `Current-state:` field to record this save's freshness (it's the index of where each project's state lives and how current it is):

```
**Current-state:** `[resolved current-state path]` · updated [YYYY-MM-DD]
```

If the entry has no `Current-state:` field yet (an older entry, or one created before this field existed), add it.

---

## Step 8b — Post-save hooks

Read `post-save-hooks` from `[workspace-root]/.os-config` — an optional list of skill names. For each
skill listed, invoke it now: after Step 5 has rewritten `current-state.md` (the substance source) and
before Step 9 commits, so any doc edits a hook makes land in the same commit. If the key is absent —
the default, and the only path public installs get — **skip this step entirely**.

A hook may perform outward writes (e.g. to an external tracker). Those keep their own explicit approval —
Step 9's auto-commit covers files on disk only. If the user declines a hook's proposal, continue to
Step 9 with docs as-is. This is a generic extension point: it names no specific skill, so which hooks run
is private to `.os-config`.

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
4. **Always** run `git status -sb | head -1` afterwards and read the `[ahead N]` count, whether the push reported success or not. This number, not the push command's exit code, is the source of truth for whether the work reached GitHub. Carry it into Step 10 and Step 11.
5. Capture the primary commit's short hash. For each companion draft, replace the placeholder line with the actual hash.
6. For each external repo:
   - `cd` into it
   - `git add` only the resolved symlinked paths (not other dirty files in that repo)
   - `git commit` with the companion message
   - `git push`
   - `git status -sb | head -1` — capture that repo's ahead count too

If primary commit fails (pre-commit hook etc.): surface error, stop. Do NOT proceed to companions, do NOT amend, do NOT skip hooks. The session save files are still on disk — user can re-run /os-save once the underlying issue is fixed.

**If the push fails, first tell the two causes apart — they need opposite responses:**

- **Sandbox/network refusal** (`nc: authentication method negotiation failed`, `Connection closed by UNKNOWN port`, `x509: OSStatus`, TLS or proxy errors). This is Claude's sandbox, not the repo, and in a sandboxed setup it can be the **normal** outcome. Do NOT treat it as a blocking error and do NOT stop: the commit is safely on disk and on the local branch. Continue with companions, then give the user the push command to run themselves and surface the ahead count in Steps 10 and 11.
- **A real git failure** (no upstream, non-fast-forward, rejected by remote). Surface the error and stop. Do NOT force-push, do NOT proceed to companions. The user decides how to proceed (fetch + rebase, or roll back).

**Why the distinction matters:** the sandbox failure is silent and repeatable, so it accumulates. Unpushed commits pile up when each save hands off a push command that never gets run and no save reports the running total. The ahead count in Steps 10 and 11 exists to make that impossible to miss again.

If primary succeeds but a companion commit/push fails: surface clearly which repo and at which step. Don't roll back the primary — it's already pushed.

**Rollback paths if a save was wrong:**
- Pre-push — **now the common case**, since the sandbox refuses the push and commits sit local until the user runs the hand-off command: `git reset --soft HEAD~1` undoes the commit and keeps changes staged. Check the ahead count before choosing: if the bad commit hasn't reached origin, this is the clean route.
- Post-push: `git revert HEAD && git push` — creates a "Revert: ..." commit on top. Honest history, no force-push needed. Standard solo-repo pattern.
- Don't `git push --force` — blocked by the deny rule in `.claude/settings.json` for safety; revert is the right tool.

---

## Step 10 — Confirm

```
✅ Session saved

Context snapshot:   [active-project]/memory/[YYYYMMDD-HHMM].md
Reasoning log:      [active-project]/memory/[YYYYMMDD-HHMM]-reasoning.md  (if created)
Sessions index:     [active-project]/memory/SESSIONS-INDEX.md
Current state:      [active-project]/state/current-state.md  (updated)
Git:                [see rule below]
```

The `Git:` line reports the ahead count captured in Step 9c.4, never the push command's exit code:

- Pushed cleanly (`ahead 0`) → `pushed — [hash] on origin/main`
- Anything unpushed → `⚠️ [N] commits NOT pushed (oldest [YYYY-MM-DD]) — run the push command`

Get the oldest unpushed date with `git log --reverse --date=short --pretty=%ad origin/main..HEAD | head -1`. Naming the date is what turns a number into an alarm: "3 commits" reads as housekeeping, "3 commits, oldest 12 Jul" reads as a problem.

---

## Step 10b — Welcome flow post-save summary (conditional)

Read the active project's entry in `projects.md`. If it contains `- **Welcome:** pending`, this is the user's first session through `/os-welcome`. Append the following block immediately after the Step 10 confirmation. Otherwise skip Step 10b entirely.

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  YOU JUST RAN THE FULL OS-INTELLIGENCE LOOP
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

In this session, you:
  - Set up a project with a stated goal
  - Captured your context across documents, transcripts, chats, and notes
  - Cross-synthesised it into one read of the project
  - Pressure-tested the synthesis with Claude
  - Saved the session as memory

You'll do this every time. The hard part is over.

After one week of using OS-Intelligence, your context will be doing real lifting — every meeting briefed before you walk in, every project surfaceable on demand. By four weeks, you won't remember how you worked without it.

Now quit Claude Code.

Next time you launch Claude Code, run /os-start and pick this project. What you'll see is everything you just built — current, ready, no context-switching needed. From there you keep working.

I'll meet you there.
```

Do NOT clear the `**Welcome:** pending` tag in this skill — `/os-start` clears it after rendering the welcome-back content next session. That's what creates the cliffhanger payoff.

---

## Step 11 — Final saved banner (always last)

This is the last thing printed by the skill, except for the temporary diff-review offer in Step 12 (which fires only when synthesise-on-save is on). It comes after Step 10's confirmation block and after the Step 10b welcome block if that fired — the user returns to the terminal and needs the save state visible near the bottom of the window without scrolling up to hunt for it.

Print exactly:

```
Summary
[One or two sentences describing what this session did — the same gist as the git commit summary, in plain language.]

-------------
SESSION SAVED
-------------
```

Keep the Summary to one or two sentences. No file lists, no next-steps — those live in Step 10 above. The point of this block is a single glance: "yes, it saved, and here's what it was."

**Unpushed-work banner (conditional).** If the ahead count from Step 9c.4 is greater than zero, print this immediately *below* the `SESSION SAVED` block, so it is the last thing on screen:

```
⚠️  [N] COMMITS NOT ON GITHUB  (oldest [YYYY-MM-DD])
    Push:  cd [workspace-root] && git push origin main
```

Include the same warning for any external repo left ahead, one line each. If the count is zero, print nothing extra — a clean save stays quiet.

This banner outranks the visual tidiness of the save block. It sits last because the previous design buried the same information in a mid-scroll footnote and unpushed commits piled up before anyone noticed.

---

## Step 12 — Diff-review offer (temporary; synthesise-on-save only)

Only if `[workspace-root]/.os-config` has `synthesise-on-save: true` (the same flag Step 5S checks), print one line immediately after the banner:

```
synthesise-on-save rewrote current-state.md this run. Review the change before trusting it?  →  /review-save
```

When the flag is false/absent, skip Step 12 entirely — the banner is the last line. This is a temporary validation aid while the incremental synthesis is being trusted; remove it once the diff-review habit is established. Note: this one line sits below the banner, so the banner is no longer the literal last line while it's active — that's the deliberate trade for surfacing the review prompt.

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
