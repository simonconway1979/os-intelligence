---
name: os-welcome
description: First-run entry point. Routes new users to their first piece of value in under 15 minutes. Detects fresh install vs returning user. Chains into /os-new-project for active paths.
user_invocable: true
---

# Welcome — first-run entry point

Routes the user from "I just installed OS-Intelligence" to "I have my first synthesis on my own data" as fast as possible. This skill is a router — it does not do the work itself. It chains into `/os-new-project` for active paths and ends by handing off to `/ctx-transcript` or `/ctx-doc`.

For returning users it offers a quick path to `/os-start`.

---

## Step 1 — Print the banner

Print this banner exactly, as the first thing in the output:

```
   ___  ____         ___ _   _ _____ _____ _     _     ___ ____ _____ _   _  ____ _____
  / _ \/ ___|       |_ _| \ | |_   _| ____| |   | |   |_ _/ ___| ____| \ | |/ ___| ____|
 | | | \___ \   _    | ||  \| | | | |  _| | |   | |    | | |  _|  _| |  \| | |   |  _|
 | |_| |___) | (_)   | || |\  | | | | |___| |___| |___ | | |_| | |___| |\  | |___| |___
  \___/|____/       |___|_| \_| |_| |_____|_____|_____|___|\____|_____|_| \_|\____|_____|

       The intelligence layer for your operating system.
```

A blank line, then continue.

---

## Step 2 — Detect state

Check three signals at the workspace root:

- **A.** Does `.current-session` exist?
- **B.** Does `projects.md` have any Active entries other than `Acme Corp Example`?
- **C.** Are there any files in any `projects/[*]/memory/` directory (excluding `SESSIONS-INDEX.md` templates)?

Classify:

- **Fresh install** = A is missing AND B is false AND C is false
- **Returning user** = any of A, B, C is true

Save the state for Step 4.

---

## Step 3 — Permissions setup

Check whether `.claude/settings.local.json` at the workspace root already grants OS-Intelligence write access to its managed paths.

**How to detect "already configured":** read the file if it exists. Look for `permissions.allow` containing `"Edit(projects.md)"` or any of the OS-Intelligence-scoped patterns (`Edit(projects/**)`, `Write(projects/**)`, etc.). If found, skip this step silently — proceed to Step 4.

If not configured (file missing, or `permissions.allow` does not contain the OS-Intelligence pattern), show the offer:

```
Quick check before we get started.

OS-Intelligence creates and updates structural files as you work —
projects.md, project folders, people files, current-state.md, and so on.
By default, Claude Code will ask you to approve each edit. That gets
noisy fast.

Want me to add an auto-approve rule to your local settings so the
system files can be edited without prompting?

Scope (OS-Intelligence-managed paths only):
  ✓ projects.md           (your project index)
  ✓ projects/**           (your project folders)
  ✓ people/**             (people files)
  ✓ companies/**          (company files)
  ✓ .current-session      (which project you're working on)

NOT auto-approved:
  ✗ .claude/skills/       (skill code stays explicit)
  ✗ Root CLAUDE.md and settings.json
  ✗ context-library/
  ✗ Anything else outside the scoped paths

The rule is written to .claude/settings.local.json which is gitignored —
stays on this machine, never committed to the repo.

1. Yes, add the rules (recommended)
2. No, I'll approve each edit manually
3. Show me the exact JSON first
```

Wait for selection.

### Selection 1 — Yes

Merge the following into `.claude/settings.local.json` at the workspace root:

```json
{
  "permissions": {
    "allow": [
      "Edit(projects.md)",
      "Edit(projects/**)",
      "Edit(people/**)",
      "Edit(companies/**)",
      "Edit(.current-session)",
      "Write(projects.md)",
      "Write(projects/**)",
      "Write(people/**)",
      "Write(companies/**)",
      "Write(.current-session)"
    ]
  }
}
```

**Merge rules:**
- If the file does not exist: create it with exactly this content.
- If the file exists with other top-level keys (e.g. `hooks`, other settings): preserve them. Only add or update `permissions.allow`.
- If `permissions.allow` already exists: append the OS-Intelligence entries that are not already present. Do not remove any existing entries.
- Validate the result is valid JSON before saving.

After saving, print:

```
Done. Permissions added to .claude/settings.local.json.
You won't be prompted for edits to OS-Intelligence-managed files.
```

Proceed to Step 4.

### Selection 2 — No

Print:

```
Got it. You'll be prompted for each edit during this and future sessions.
Run /os-welcome again later if you change your mind.
```

Proceed to Step 4.

### Selection 3 — Show me the exact JSON first

Print the JSON block (same as Selection 1's payload above). Then re-ask:

```
1. Yes, add the rules
2. No, I'll approve each edit manually
```

Wait for selection. Route to Selection 1 or Selection 2 based on the choice.

---

## Step 4 — Show the menu

### If fresh install

Print:

```
OS-Intelligence is set up. Let's get you to your first piece of value
in about 15 minutes.

What do you want to do first?

1. Walk into your next 1:1 prepared
   Drop in 3 past meetings with someone. Get a stakeholder brief.
   ~10 min.

2. Pick up a stalled project
   Drop in 5–10 old documents. Get a current-state showing where it
   stood and what's open. ~15 min.

3. Synthesise user research
   Drop in 3–5 interview transcripts. Get cross-cut themes, tensions,
   and patterns. ~15 min.

4. Tour the Acme Corp example
   Browse a populated project. Read-only, no setup needed.

5. Just show me the docs
   Pointers to README, ARCHITECTURE, MIGRATION.
```

### If returning user

Print:

```
Looks like you've used OS-Intelligence before. Quick options:

1. Walk into your next 1:1 prepared (~10 min)
2. Pick up a stalled project (~15 min)
3. Synthesise user research (~15 min)
4. Tour the Acme Corp example
5. Show me the docs
6. Run /os-start (load your last project)
```

Wait for selection. Accept a single number 1–5 (or 1–6 for returning users).

---

## Step 5 — Route to the selected path

### Path 1 — 1:1 prep

Ask: **"Who's the 1:1 with? (first name is fine)"**

Suggest project name: `1-on-1 prep with [Name]`. Confirm with user.

Run `/os-new-project` with the confirmed name. The skill will walk through type (project), personal vs professional, company (likely none), people, and key contacts. Let it complete fully.

After `/os-new-project` returns, print the path-specific hand-off (Step 6).

### Path 2 — Stalled project recovery

Ask: **"What's the project name?"**

Suggest project name: the user's input as given (don't transform). Confirm.

Run `/os-new-project` with that name. Let it complete.

After it returns, print the path-specific hand-off (Step 6).

### Path 3 — Research synthesis

Ask: **"What's the research topic?"**

Suggest project name: `Research synthesis: [Topic]`. Confirm.

Run `/os-new-project` with the confirmed name. Let it complete.

After it returns, print the path-specific hand-off (Step 6).

### Path 4 — Tour Acme

No state changes. Print:

```
The Acme Corp example lives at:
  projects/acme-corp-example/

Three files to look at first:

1. projects/acme-corp-example/context/current-state.md
   The live read. This is what /os-start loads at session start.

2. projects/acme-corp-example/intelligence/meetings/
   Real-shape meeting transcripts plus their synthesis output.
   Open one synthesis.md to see what /ctx-transcript produces.

3. projects/acme-corp-example/people/
   Two-layer people: project-level operational notes that link
   to the global identity files in /people/ at workspace root.

Browse the folders directly in your editor. When you're ready to
start your own first project, run /os-welcome again and pick 1, 2, or 3.
```

### Path 5 — Docs

No state changes. Print:

```
Top docs to read, in order of usefulness on first run:

  README.md         What this is, who it's for, three "try this" use cases
  ARCHITECTURE.md   Mental model: layers, projects vs portfolios, the flow
  MIGRATION.md      Three install patterns: fresh, overlay, replace+migrate
  CLAUDE.md         Working context for Claude Code sessions in this repo

Second-tier:

  docs/usage-log.md   What gets logged locally and how to disable
  docs/addons.md      Where to drop your own skills, frameworks, integrations

Run /os-welcome again to start your first project when ready.
```

### Path 6 — `/os-start` (returning user only)

Run `/os-start`. Welcome ends.

---

## Step 6 — Hand-off (paths 1, 2, 3 only)

After `/os-new-project` completes for paths 1–3, print the path-specific instructions:

### For Path 1 (1:1 prep)

```
Project ready at: projects/[slug]/

Next: drop your past meeting transcripts with [Name] into:
  projects/[slug]/intelligence/meetings/

On macOS:
  open projects/[slug]/intelligence/meetings/

Drag the transcript files in. Three is a good number. Then run:

  /ctx-transcript          (run once per transcript)
  /ctx-synthesise          (cross-cuts the meetings)
  /os-start                (loads the brief)

Total time from here: about 10 minutes.
```

### For Path 2 (stalled project)

```
Project ready at: projects/[slug]/

Next: drop your old project documents into:
  projects/[slug]/intelligence/docs/raw/

On macOS:
  open projects/[slug]/intelligence/docs/raw/

Drag in 5–10 docs (briefs, status updates, design specs, anything
relevant). Then run:

  /ctx-doc                 (run once per doc)
  /ctx-synthesise          (builds current-state.md)
  /os-start                (loads the picture)

Total time from here: about 15 minutes.
```

### For Path 3 (research synthesis)

```
Project ready at: projects/[slug]/

Next: drop your interview transcripts into:
  projects/[slug]/intelligence/meetings/

On macOS:
  open projects/[slug]/intelligence/meetings/

Drag in 3–5 transcript files. Then run:

  /ctx-transcript          (run once per transcript)
  /ctx-synthesise          (cross-cuts the cohort)

Total time from here: about 15 minutes.
```

Substitute `[slug]` with the actual kebab-case slug created by `/os-new-project`. Substitute `[Name]` with the name the user gave.

---

## Step 7 — Stop

After printing the hand-off, end the welcome flow. Do not chain into `/ctx-transcript` or `/ctx-doc` — the user controls the next move.

---

## What this skill does NOT do

- Does not auto-populate Acme example content
- Does not detect or set up Layered install pattern (deferred to `/os-update` in v0.2)
- Does not import existing PM workflow tools
- Does not process files for the user — that's the `ctx-*` skills' job

---

## Tone

Direct, brief, action-oriented. Match the voice of `/os-start`. No "Welcome aboard!" framing. No emojis.
