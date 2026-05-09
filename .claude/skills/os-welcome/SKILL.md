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
Before we start, some admin to make OS-Intelligence easier to use...

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
Done. Permissions added. That will reduce unneeded requests for permission and make your flow faster.
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
Let's get you to your first piece of value in about 15 minutes.

We'll set up a small project, to show you how it works. Here are some suggestions... What do you want to do first?

**1. Walk into your next 1:1 prepared  ·  10 min**
What they care about, what's open, what to ask.

**2. Catch what's slipping across your sprints  ·  15 min**
What shipped, what's blocked, what's drifting between teams.

**3. Find the next move on a stalled project  ·  20 min**
Where things stood, what's open, what to do next.

**4. Find patterns across your research  ·  15 min**
Cross-cut themes and tensions from 3 research calls.

**5. Sharpen your strategy  ·  20 min**
Tensions, assumptions, and open questions on your bets.

**6. Pressure-test your next presentation  ·  20 min**
Story arc, slide logic, likely pushback.

**7. Coach with the full picture  ·  15 min**
Patterns, what's progressing, where to push next.

**8. Brief a new joiner  ·  20 min**
Project current-state someone can explore interactively.

**9. Something else — describe what you'd want.**
```

### If returning user

Print:

```
Looks like you've used OS-Intelligence before. Quick options:

1. Walk into your next 1:1 prepared (~10 min)
2. Catch what's slipping across your sprints (~15 min)
3. Find the next move on a stalled project (~20 min)
4. Find patterns across your research (~15 min)
5. Sharpen your strategy (~20 min)
6. Pressure-test your next presentation (~20 min)
7. Coach with the full picture (~15 min)
8. Brief a new joiner (~20 min)
9. Something else — describe what you'd want
10. Load your last project (/os-start)
```

Wait for selection. Accept a single number 1–9 (or 1–10 for returning users).

---

## Step 5 — Route to project creation

### Paths 1–8 — Generic project flow

Ask: **"What's a short, real name for this project?"**

If the user is unsure, suggest one based on the starter they picked. Examples:
- 1 (1:1 prep): `1-on-1 prep with [Name]`
- 2 (sprints): `Q3 sprint patterns`
- 3 (stalled project): the user's project name as given
- 4 (research): `Research synthesis: [topic]`
- 5 (strategy): `[Quarter or year] strategy`
- 6 (presentation): `[Topic] presentation review`
- 7 (coaching): `Coaching: [Name]`
- 8 (new joiner): `[Project] context for new joiners`

Confirm with the user, then run `/os-new-project` with the confirmed name. The skill will walk through type (project), personal vs professional, company, people, and key contacts. Let it complete fully.

After `/os-new-project` returns, proceed to Step 6.

### Path 9 — Something else

Ask: **"In a sentence — what do you have, and what do you want from it?"**

Let the user describe their use case in their own words. Acknowledge what you heard in one short line, then ask: **"What's a short, real name for this project?"** Suggest a name based on what they described if they're unsure. Confirm, then run `/os-new-project` with the confirmed name. Proceed to Step 6 — the four capture types apply regardless of starter.

### Path 10 — `/os-start` (returning user only)

Run `/os-start`. Welcome ends.

---

## Step 6 — Hand-off: walk through the four capture types (paths 1–8)

After `/os-new-project` completes, walk the user through what context they might have to bring. Four capture types, asked one at a time, in the order: **documents → transcripts → chats → notes**. For each: ask Y/n, give where-to-drop instructions if yes, move to the next.

Substitute `[slug]` with the kebab-case slug created by `/os-new-project`. Substitute `[Name]` with the name the user gave (path 1 only).

### Common opening

Substitute `[Project Name]` with the project's name from Step 5. Substitute `[Company]` with the company linked to the project (from `/os-new-project`'s output). Substitute `[recommendation]` with a one-line suggestion of likely document types, tailored to the starter picked at Step 4. Examples:
- 1 (1:1 prep): past meeting notes with [Name] and recent updates from their team
- 2 (sprints): sprint review transcripts, planning docs, retros
- 3 (stalled project): the project's PRD, status updates, last decisions
- 4 (research): research call transcripts and any customer interview notes
- 5 (strategy): strategy docs, recent planning transcripts, OKRs
- 6 (presentation): the slide deck, speaker notes, audience brief
- 7 (coaching): past 1:1 notes, 360 feedback, performance docs
- 8 (new joiner): PRD, last quarterly update, key customer escalations
- 9 (something else): infer from what the user described

Print:

```
Project set up. OS-Intelligence has linked [Project Name] to its people and [Company].

By your third project, that link becomes a graph: every person you've added surfaces across every project they touch. Same for companies you work with more than once. Each new entry pulls in what you already have.

---

Adding context

Project ready at: projects/[slug]/

The next steps capture and analyse your context. This is heavier at
the start than once your project is set up. After that, you add info
as it arrives.

OS-Intelligence captures four types of context:

| Type        | What it is                                              |
|-------------|---------------------------------------------------------|
| Documents   | Slide decks, PRDs, strategy docs, briefs, updates       |
| Transcripts | Meeting recordings, 1:1s, interviews, calls             |
| Chats       | Slack, WhatsApp, iMessage threads with stakeholders     |
| Notes       | Your own observations, voice memos, written reflections |

For [Project Name], you'll likely need [recommendation].

Tip: start with 3–4 documents only. You'll build better context by
adding files with Claude over time than by trying to load everything
at the start.
```

### The four capture types

For each type, ask the question, wait for Y/n, and respond:

#### Type: Documents → `/ctx-doc`

Question:

```
Let's start with documents:
(Slide decks, briefs, PRDs, strategy docs, org charts, status updates, policies, anything written about the project or its context.)

Got any to add? (Y/n)
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
Now transcripts:
(Kickoffs, 1:1s, customer calls, team meetings, interviews.)

Got any to add? (Y/n)
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
Now chats:
(Slack channels, Teams DMs, WhatsApp groups. Anywhere the team talks informally and useful context lives.)

Got any to add? (Y/n)
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
Finally, notes:
(Your own field notes, voice memos transcribed, off-the-cuff thoughts, ideas you don't want to lose.)

Got any to add? (Y/n)
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
