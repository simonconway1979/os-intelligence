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

Check whether `.claude/settings.local.json` at the workspace root already grants OS-Intelligence the full current set of permissions.

**The current expected set** (must all be present in `permissions.allow` to count as configured):
```
Read(projects/**)
Read(people/**)
Read(companies/**)
Read(**/intelligence/**)
Edit(projects.md)
Edit(projects/**)
Edit(people/**)
Edit(companies/**)
Edit(.current-session)
Write(projects.md)
Write(projects/**)
Write(people/**)
Write(companies/**)
Write(.current-session)
Write(**/intelligence/**)
```

**How to detect "already configured":** read `.claude/settings.local.json` if it exists. Compute the set of expected entries above that are MISSING from `permissions.allow`.

- If **0 missing** → fully configured. Skip this step silently and proceed to Step 4.
- If **some missing but at least one present** → partially configured (older version). Show the migration offer below.
- If **all missing** (or file doesn't exist, or `permissions.allow` doesn't exist) → never configured. Show the first-run offer below.

### First-run offer (all missing)

```
Quick check before we get started.

OS-Intelligence creates and updates structural files as you work —
projects.md, project folders, people files, current-state.md,
intelligence/ inputs, and so on. By default, Claude Code will ask
you to approve each edit. That gets noisy fast.

Want me to add an auto-approve rule to your local settings so the
system files can be read and written without prompting?

Scope (OS-Intelligence-managed paths only):
  ✓ projects.md             (your project index)
  ✓ projects/**             (your project folders)
  ✓ people/**               (people files)
  ✓ companies/**            (company files)
  ✓ .current-session        (which project you're working on)
  ✓ **/intelligence/**      (meetings, docs, chats, notes — bulk import)

NOT auto-approved:
  ✗ .claude/skills/         (skill code stays explicit)
  ✗ Root CLAUDE.md and settings.json
  ✗ context-library/
  ✗ Anything else outside the scoped paths

The rule is written to .claude/settings.local.json which is gitignored —
stays on this machine, never committed to the repo.

1. Yes, add the rules (recommended)
2. No, I'll approve each edit manually
3. Show me the exact JSON first
```

### Migration offer (some missing — older version detected)

Show the missing entries explicitly so the user sees what's new:

```
Quick check — your permissions are partially configured from an
earlier OS-Intelligence run, but [N] new entries have been added
since then. They cover [short human-readable summary, e.g. "the
intelligence/ folders for bulk-importing meetings, docs, chats,
and notes"].

Missing from your current settings:
  + [list each missing entry, one per line]

Want me to add them now?

1. Yes, add the missing rules
2. No, leave settings as is
3. Show me the exact JSON to be added
```

Wait for selection.

### Selection 1 — Yes

Merge the following into `.claude/settings.local.json` at the workspace root:

```json
{
  "permissions": {
    "allow": [
      "Read(projects/**)",
      "Read(people/**)",
      "Read(companies/**)",
      "Read(**/intelligence/**)",
      "Edit(projects.md)",
      "Edit(projects/**)",
      "Edit(people/**)",
      "Edit(companies/**)",
      "Edit(.current-session)",
      "Write(projects.md)",
      "Write(projects/**)",
      "Write(people/**)",
      "Write(companies/**)",
      "Write(.current-session)",
      "Write(**/intelligence/**)"
    ]
  }
}
```

**Merge rules:**
- If the file does not exist: create it with exactly this content.
- If the file exists with other top-level keys (e.g. `hooks`, other settings): preserve them. Only add or update `permissions.allow`.
- If `permissions.allow` already exists: append the OS-Intelligence entries that are not already present. Do not remove any existing entries.
- Validate the result is valid JSON before saving.

After saving, print one of these depending on which case applied:

**First-run case (file/permissions.allow didn't exist or had no OS-Intelligence entries):**
```
Done. Permissions added to .claude/settings.local.json.
You won't be prompted for edits to OS-Intelligence-managed files.
```

**Migration case (some entries existed, others were appended):**
```
Done. [N] new permission rule(s) added to .claude/settings.local.json.
Your existing rules were left untouched.
```

Proceed to Step 4.

### Selection 2 — No

Print one of these:

**First-run case:**
```
Got it. You'll be prompted for each edit during this and future sessions.
Run /os-welcome again later if you change your mind.
```

**Migration case:**
```
Got it — leaving your settings as is. The [N] missing rule(s) won't be added.
Run /os-welcome again any time to re-offer them.
```

Proceed to Step 4.

### Selection 3 — Show me the exact JSON first

**First-run case:** Print the full JSON block from Selection 1.

**Migration case:** Print only the missing entries as a JSON snippet, framed as "these will be appended to your existing `permissions.allow` array":

```json
[
  // each missing entry, one per line, exact strings
]
```

Then re-ask:

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
   Pointers to README, ARCHITECTURE, and the docs/ folder.
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

  README.md         What this is, who it's for, the install flow
  ARCHITECTURE.md   Mental model: layers, projects vs portfolios, the flow
  CLAUDE.md         Working context for Claude Code sessions in this repo

Second-tier:

  docs/setup.md       Step-by-step Claude Code + Cursor + OS-Intelligence install
  docs/skills.md      What each skill does, grouped by capture/synthesise/retrieve/scaffold
  docs/status-bar.md  Set up your Claude Code status bar
  docs/addons.md      Where to drop your own skills, frameworks, integrations
  docs/usage-log.md   What gets logged locally and how to disable

Run /os-welcome again to start your first project when ready.
```

### Path 6 — `/os-start` (returning user only)

Run `/os-start`. Welcome ends.

---

## Step 6 — Hand-off: walk through the four capture types (paths 1, 2, 3 only)

After `/os-new-project` completes for paths 1–3, walk the user through what context they might have to bring. Four capture types, asked one at a time. The order varies by path (most relevant first). For each: ask Y/n, give where-to-drop instructions if yes, move to the next.

Substitute `[slug]` with the kebab-case slug created by `/os-new-project`. Substitute `[Name]` with the name the user gave (path 1 only).

### Common opening

Print:

```
Project ready at: projects/[slug]/

Now we'll import the four foundational inputs for stakeholder
intelligence: documents, meeting transcripts, chat threads, and notes.

I'll ask about each in turn — say no to anything you don't have, or
don't want to bring right now. You can always run /os-welcome again
later to add more.
```

### The four capture types

For each type, ask the question, wait for Y/n, and respond:

#### Type: Documents → `/ctx-doc`

Question (paths 1, 2, 3 alike):

```
1. Documents
   Slide decks, briefs, PRDs, strategy docs, org charts, status updates,
   policies, anything written about the project or its context.

   Got any to bring? (Y/n)
```

If **Y**, print:

```
   Drop them at:
     projects/[slug]/intelligence/docs/raw/

   On macOS:
     open projects/[slug]/intelligence/docs/raw/

   Later you'll run /ctx-doc and it'll process them in parallel.
```

If **n**, just say `Skipping documents.` and continue.

#### Type: Meeting transcripts → `/ctx-transcript`

Question:

```
2. Meeting transcripts
   Kickoffs, 1:1s, customer calls, team meetings, interviews.

   Got any to bring? (Y/n)
```

If **Y**, print:

```
   Drop them at:
     projects/[slug]/intelligence/meetings/

   On macOS:
     open projects/[slug]/intelligence/meetings/

   Later you'll run /ctx-transcript (or its --batch mode if you have a
   pile) and it'll synthesise each meeting and update people files.
```

If **n**, say `Skipping meeting transcripts.` and continue.

#### Type: Chat threads → `/ctx-chat`

Question:

```
3. Chat threads
   Slack channels, Teams DMs, WhatsApp groups — anything where the team
   talks informally and useful context lives.

   Got any to bring? (Y/n)
```

If **Y**, print:

```
   Export the thread to a markdown or text file, then drop it at:
     projects/[slug]/intelligence/chats/

   On macOS:
     open projects/[slug]/intelligence/chats/

   Later you'll run /ctx-chat. It deduplicates on re-imports, so you
   can update the same thread over time.
```

If **n**, say `Skipping chats.` and continue.

#### Type: Notes / observations → `/ctx-note`

Question:

```
4. Notes and observations
   Your own field notes, voice memos transcribed, off-the-cuff thoughts,
   ideas you don't want to lose.

   Got any to bring? (Y/n)
```

If **Y**, print:

```
   Drop them at:
     projects/[slug]/intelligence/notes/

   On macOS:
     open projects/[slug]/intelligence/notes/

   Later you'll run /ctx-note to capture and link them to people if relevant.
```

If **n**, say `Skipping notes.` and continue.

### Order by path

Use the priority order most relevant to the user's chosen path. Same four questions, just sequenced differently:

- **Path 1 (1:1 prep):** transcripts → chats → notes → documents
  (transcripts are central; chats are conversational context; notes are your read of them; documents matter least for 1:1s)

- **Path 2 (stalled project):** documents → transcripts → chats → notes
  (the formal record matters most; meetings show decisions; chats catch informal threads; notes capture your own)

- **Path 3 (research synthesis):** transcripts → documents → notes → chats
  (interview transcripts are THE source; research briefs and prior work matter; field notes round it out; chats rarely relevant for research)

### Common closing

After all four questions, print:

```
Got it. Once you've dropped everything, run these in order — only the
ones you have material for:

  /ctx-doc                 (processes documents)
  /ctx-transcript          (processes meetings)
  /ctx-chat                (processes chat threads)
  /ctx-note                (processes notes)

Then to bring it together:

  /ctx-synthesise          (cross-cuts everything, updates current-state.md)
  /os-start                (loads the briefing for your next session)

Total time from here: 10–20 minutes depending on volume. The synthesis
step is where the picture comes together.
```

---

## Step 7 — Stop

After the hand-off, end the welcome flow. Do not chain into `/ctx-doc`, `/ctx-transcript`, `/ctx-chat`, or `/ctx-note` — the user needs to drop their files first, then run the relevant skills themselves.

---

## What this skill does NOT do

- Does not auto-populate Acme example content
- Does not detect or set up Layered install pattern (deferred to `/os-update` in v0.2)
- Does not import existing PM workflow tools
- Does not process files for the user — that's the `ctx-*` skills' job

---

## Tone

Direct, brief, action-oriented. Match the voice of `/os-start`. No "Welcome aboard!" framing. No emojis.
