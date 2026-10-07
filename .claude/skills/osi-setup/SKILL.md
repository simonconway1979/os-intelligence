---
name: osi-setup
description: Adopt an existing folder into OS-Intelligence. Synthesises the folder into a root-level current-state.md, scaffolds the save loop (memory/), and registers it in projects.md so /os-start and /os-save work on it. Use when pointing OS-Intelligence at a folder of work you already have — not a fresh project (that's /os-new-project).
user_invocable: true
---

# /osi-setup — Adopt an existing folder

Point OS-Intelligence at a folder you already have. One command turns it into a project the loop runs on: synthesise its scattered markdown into one `current-state.md`, scaffold the save loop, register it. After this, `/os-start` lists it and loads its context; `/os-save` records reasoning and keeps the state fresh.

This is the **bring-your-own-folder** path. `/os-new-project` creates a fresh, empty project; `/osi-setup` adopts a populated one in place — it imposes no taxonomy, moves nothing, and creates only `current-state.md` (root) + an empty `memory/`.

---

## Step 1 — Resolve the target folder

Take the folder path from the invocation (`/osi-setup <folder>`). If none was given, ask: *"Which folder do you want to adopt? Give me the path."*

Validate:
- The folder exists. If not, say so and stop.
- It contains at least one `.md` or `.txt` source file (search recursively). If it's empty of source, tell the user there's nothing to synthesise yet — they want `/os-new-project` for an empty start.

`[folder]` = the resolved absolute or workspace-relative path. The folder can live **anywhere** — under `projects/` or an external path like `~/work/clientX/`. `projects.md`'s `Folders:` field takes any path.

**Idempotency check:** read `projects.md`. If an `## Active` entry already points `Folders:` at this folder, this is a re-run — skip Step 4's metadata questions, keep the existing entry, and go straight to re-synthesising (Step 3) and confirming (Step 6).

---

## Step 2 — Gather the minimum (new adoptions only)

Ask for the three things `projects.md` needs, in one message. Keep it to the minimum — no people/company/type interrogation:

1. **Name** — default to the folder's basename, title-cased. Offer it: *"I'll call this **[Basename]** — or give me another name."*
2. **One-liner** — what this body of work is, in a sentence.
3. **Goal** — what success looks like right now.

Also capture the **synthesis lens** for Step 3 (this is the single biggest quality lever):
> *"When I synthesise this, whose seat am I reading from and what for? (e.g. 'me, prepping the next client session' or 'the team, deciding what to cut'). One line is enough."*

If the user says "just go" / "neutral", proceed without a lens.

---

## Step 3 — Synthesise the folder

Run the `/synthesise` skill on `[folder]`, passing the lens from Step 2 as the hint (`/synthesise [folder] -- [lens]`). Follow that skill exactly — do not re-implement it. It:

- writes **one** `current-state.md` into the folder root (next to `CLAUDE.md` if present),
- or, for a large/multi-area folder (> ~60 sources), produces a hierarchical roll-up — one `current-state.md` per subfolder plus a parent roll-up.

The output(s) land at the **folder root**, never in a `state/` subfolder. `state/` is a PM-OS convention, not an OSI one — OSI stays minimal.

If `current-state.md` already exists and is OS-managed (`updated-by: os-save` in its frontmatter), `/synthesise` writes `current-state-synth.md` instead (overwrite protection). On a genuine first adoption this won't trigger; on a re-run it's expected — tell the user where the fresh synthesis landed.

Note the path(s) written — you need them for Steps 4 and 5.

---

## Step 4 — Scaffold the save loop

Create an empty `memory/` folder inside `[folder]` (this is where `/os-save` writes session memory + reasoning appendices). A `.gitkeep` or a one-line `memory/README.md` ("Session saves land here — written by /os-save.") is enough to make the empty folder real.

Do **not** create a `state/` folder, an `context/` folder, or a `CLAUDE.md`. The adopted folder gets exactly two new things: `current-state.md` (root) and `memory/`.

---

## Step 5 — Register in projects.md

Add an entry under `## Active` in the repo-root `projects.md`. Use the minimal adopted-folder schema:

```markdown
### [Name]
- **Type:** project
- **Status:** Active
- **One-liner:** [from Step 2]
- **Goal:** [from Step 2]
- **Folders:** [folder]
- **Current-state:** `[path to current-state.md]` · synthesised [today]
- **Started:** [today]
- **Last session:**
```

The `Current-state:` field is the location + freshness tracker — `/os-save` stamps it on every save, so `projects.md` doubles as the index of where each project's state lives and how fresh it is. For a hierarchical roll-up, point `Current-state:` at the **parent** `current-state.md`.

If the folder was already registered (Step 1 re-run), leave the entry's metadata alone — just refresh the `Current-state:` date.

---

## Step 6 — Confirm and hand off to the loop

Print a short confirmation:

```
✦ Adopted: [Name]

  current-state.md   [path]            ← your synthesised state
  memory/            [folder]/memory/  ← session saves land here
  registered in      projects.md

The loop is ready:
  /os-start   → pick [Name], it loads this state
  …work…
  /os-save    → records your reasoning + refreshes the state

Run /os-start to step in.
```

Do not auto-start the session — `/os-start` is the explicit "step into the loop" move, and seeing it work is the point.
