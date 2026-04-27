---
name: os-switch-project
description: Switch the active project. Optionally saves the current session and instructs the user to clear context. Run /os-start in the new session to choose a project and load context.
---

# /os-switch-project — Switch Project

Cleanly switches from the current active project to a new one across a context boundary.

---

## Step 1 — Offer to save current session

Ask:
```
Switching projects.

Save this session before switching? (Y/n)
```

If yes: run `/os-save`.
If no: continue.

---

## Step 2 — Choose new project

Read `projects.md` and list all Active projects. Count them, then add one final option dynamically:

```
Switch to which project?

1. [Project Name]
2. [Project Name]
3. [Project Name]
[...all active projects from projects.md...]
N. Add a new project
```

Wait for selection.

---

## Step 3 — Handle selection

### If an existing project is selected:

If the user skipped `/os-save` in Step 1, update the `Last session:` field for that project in `projects.md` to today's date.

Print:
```
Now working on [New Project Name].

Run /clear to reset context, then /os-start to load the new project.
```

### If "Add a new project" is selected:

Run `/os-new-project`.

---

## Notes

- There is no longer an "Active project" line in root `CLAUDE.md`. Project selection happens at `/os-start` time.
- The switch takes effect after `/clear`. Run `/os-start` in the new session to select and load a project.
