# Projects

Source of truth for all projects in this OS-Intelligence install. Create a project here first, then build the folder structure (or run `/os-new-project` and it does both).

Two types: **project** (one ongoing piece of work) or **portfolio** (a container for many similar items, like a job-search pipeline or an ideas list). Portfolios add a `TRACKER.md` listing items.

---

## Active

### Acme Corp Example
- **Type:** project
- **Status:** Active
- **One-liner:** Demo project showing the OS-Intelligence folder shape, intelligence/ subfolders, and what a synthesised current-state.md looks like.
- **Goal:** Help new users see the system populated with realistic content before they set up their own projects.
- **Folders:** `projects/acme-corp-example/`
- **Company:** [Acme Corp](companies/acme-corp.md)
- **Key people:** —
- **Started:** 2026-04-29
- **Last session:**

### Sobremesa BCN
- **Type:** project
- **Status:** Active
- **One-liner:** A Barcelona supper-club series pairing a curated guest list with a provocative dinner-table question and a guest speaker.
- **Goal:** Run memorable monthly events that grow a warm community and a credible host reputation.
- **Folders:** `_dryrun/sobremesa/`
- **Current-state:** `_dryrun/sobremesa/current-state.md` · updated 2026-06-17
- **Started:** 2026-06-17
- **Last session:** 2026-06-17

---

## Paused

_None._

---

## Complete / Archived

_None._

---

## How to add a new project

- **Starting fresh?** Run `/os-new-project`. It creates the folder structure, generates a `CLAUDE.md`, links people and company files, and adds an entry to this file.
- **Already have a folder of work?** Run `/osi-setup <folder>`. It synthesises that folder into a root-level `current-state.md`, scaffolds the save loop, and adds a minimal entry here — no restructuring of your folder.

To add a portfolio item (under an existing portfolio), run `/os-new-item` from inside the portfolio.

**The `Current-state:` field** (on entries adopted via `/osi-setup`) records where a project's `current-state.md` lives and when it was last refreshed. `/os-save` stamps it on every save, so this file doubles as the index of every project's state and how fresh it is.
