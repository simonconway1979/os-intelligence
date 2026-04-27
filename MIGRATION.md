---
title: Migration
author: Simon Conway
type: reference
status: synthesised
---

# Migration

Three ways to start using OS-Intelligence. Pick the one that matches your starting point.

1. **Fresh** · no existing Claude Code setup. Easiest path.
2. **Overlay** · existing Claude Code workspace with a `CLAUDE.md` and a few projects, but no formal context system.
3. **Replace and migrate** · existing PM-OS-style setup with projects, people, meeting transcripts, and history you want to bring across.

---

## 1. Fresh start

You don't have anything yet, or you're happy starting clean.

```bash
git clone https://github.com/simonconway1979/os-intelligence.git ~/Code/os-intelligence
cd ~/Code/os-intelligence
```

Open the folder in Claude Code. Then:

```
/os-start            # creates .current-session, asks what to work on
                     # pick "New project"
/os-new-project      # scaffolds your first project
/ctx-transcript      # drop in your first meeting transcript
/os-save             # capture state at the end of the session
```

That's it. Next session, `/os-start` reads the project's `current-state.md` and you're back in context immediately.

---

## 2. Overlay onto an existing Claude Code workspace

You already have a `CLAUDE.md` and maybe a few project folders. You want OS-Intelligence on top, without throwing away what you have.

### Step 1 · clone alongside, not on top

Don't drop OS-Intelligence files into your existing workspace. Clone it as a sibling:

```bash
git clone https://github.com/simonconway1979/os-intelligence.git ~/Code/os-intelligence
```

### Step 2 · symlink the public layer into your workspace

OS-Intelligence becomes the master for skills, sub-agents, and context-library files. Your workspace points at it via symlinks. Edit either path; both reflect.

```bash
cd ~/your-existing-workspace

# Skills
mkdir -p .claude/skills
for skill in os-start os-save os-switch-project os-new-project os-new-item \
             os-new-person os-project-design \
             ctx-transcript ctx-doc ctx-note ctx-chat ctx-synthesise \
             ctx-timeline ctx-inspiration; do
  ln -s ~/Code/os-intelligence/.claude/skills/$skill .claude/skills/$skill
done

# Sub-agents
ln -s ~/Code/os-intelligence/sub-agents sub-agents

# Context library files (only the public ones)
ln -s ~/Code/os-intelligence/context-library/file-conventions.md \
      context-library/file-conventions.md
ln -s ~/Code/os-intelligence/context-library/writing-styles-global \
      context-library/writing-styles-global
```

Add the symlink targets to your `.gitignore` so your workspace doesn't track pointers to files that live in another repo.

### Step 3 · merge the stakeholder-intelligence section into your CLAUDE.md

Open the section labelled "Stakeholder intelligence" in `os-intelligence/CLAUDE.md` and paste it into your existing `CLAUDE.md`. The `ctx-` skills depend on the folder shape it describes. Everything else in your `CLAUDE.md` keeps working.

### Step 4 · run `/os-project-design` on your existing projects

For each existing project that doesn't yet have `intelligence/` and `context/current-state.md`, run `/os-project-design`. The skill reads the project, asks a few questions, and scaffolds the missing folders without overwriting what you already have.

---

## 3. Replace and migrate an existing PM-OS-style setup

You have a working setup with projects, people, meeting transcripts, decisions, and history. You want to switch to OS-Intelligence as your spine without losing any of it.

This is the path that gets fiddly. Read the whole section before you start.

### What's actually hard

- **Reconciling two `CLAUDE.md` files.** Yours has voice, conventions, and project pointers. OS-Intelligence's has the stakeholder-intelligence shape the `ctx-` skills expect. The merge isn't mechanical; some of your conventions will conflict with the public ones and you have to pick.
- **Mapping existing project folders to the new shape.** If your projects have `meetings/`, `transcripts/`, `raw/`, `docs/` scattered at different levels, they need to consolidate under `intelligence/{meetings,docs/raw,notes,chats}/`. Each move risks breaking links in your existing `current-state.md` or session files.
- **The two-layer people system.** OS-Intelligence splits people into root-level identity (`/people/[name].md`) and project-level operational context (`projects/[project]/people/[name].md`). If your existing setup is single-layer, you have to decide what's identity vs context for each person and split accordingly.
- **Retroactive tagging.** OS-Intelligence uses YAML frontmatter tags (`type/`, `project/`, `status/`, `theme/`, `item/`). Existing files don't have them. A batch script can add the obvious ones; the theme tags need judgement.
- **Synthesising existing context into `current-state.md`.** `/ctx-synthesise` does this if you point it at the right inputs. But it works best when files are already in the new shape. So the order matters: shape first, synthesise second.
- **Skills overlap.** If you have your own `os-start` or `ctx-transcript`, you'll get a collision. Decide which version wins per skill and either delete or rename.

### Recommended order

1. **Back up.** Branch your current setup. Don't migrate against `main`.
2. **Symlink the public layer in** (steps 1 and 2 from path 2 above). This gives you the new skills without touching your data.
3. **Pick one project as the canary.** A small one. Migrate it end-to-end before touching the rest.
4. **Reshape its folders** to match the OS-Intelligence project shape. Move existing files into `intelligence/{meetings,docs/raw,notes,chats}/`. Don't rewrite content; just relocate.
5. **Run `/os-project-design`** on the canary. Confirm the scaffold matches.
6. **Run `/ctx-synthesise`** to generate `current-state.md` from existing inputs. Review.
7. **Add tags** retroactively. Frontmatter first; theme tags last (they need judgement).
8. **Split people files** into root identity + project context for everyone tied to the canary.
9. **Open a fresh Claude Code session** and run `/os-start`. If it loads cleanly and the briefing makes sense, the canary is migrated. Repeat for the rest.

### Realistic time estimate (DIY)

For a setup with five active projects, twenty people, fifty meeting transcripts, and a working `CLAUDE.md`:

- Symlink + skill setup: 30 minutes
- Canary project end-to-end: half a day
- Remaining four projects: one to two days, depending on shape consistency
- People split + retroactive tagging: half a day
- Verification (fresh sessions for each project): two hours

Call it three working days for a clean migration. More if your existing setup has a lot of bespoke conventions.

### When DIY isn't the right call

The migration is documented and reproducible. Most users with a tidy existing setup can do it themselves in three days.

If your setup is messier than that, or you'd rather skip the three days and have someone do it for you, paid migration help is available. Reach out via the GitHub repo or the contact link on the project site. The migration is the fiddly part; the day-to-day use is straightforward once the spine is in place.

---

## After migration

Whichever path you took, the next sessions look the same:

```
/os-start        # at the start of every session
[do the work]
/os-save         # at the end
```

The capture skills (`/ctx-transcript`, `/ctx-doc`, `/ctx-note`, `/ctx-chat`) plug into your normal flow whenever new input arrives. `/ctx-synthesise` runs occasionally (weekly is a good cadence) to keep `current-state.md` honest.

If something breaks, the most common cause is a project folder that's missing `context/current-state.md` or `intelligence/`. Run `/os-project-design` on it.
