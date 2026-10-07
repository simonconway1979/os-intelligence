# Migrations

Change notes for every structural change to an OS-Intelligence workspace, newest first. Each has a script in `migrations/` that applies it. Run the dry run first, from your workspace root, with the workspace committed.

---

## 0003 · Project folders renamed: `intelligence/` → `context/`, `context/` → `state/`

_25 September 2026 · script: `migrations/0003-rename-context-and-state-folders.py`_

### What changed

Every project folder has two renamed subfolders.

| Before | After | What it holds | Who writes it |
|---|---|---|---|
| `intelligence/` | `context/` | What went in: `meetings/`, `docs/raw/`, `chats/`, `notes/`. Each source with its raw file and its own synthesis beside it. | `/add-context` and the `ctx-*` writers; you, when you drop a file in |
| `context/` | `state/` | What we hold now: `current-state.md`, decisions, the synthesised topic files. | `/synthesise`, `/os-save`, `/ctx-doc`, `/ctx-synthesise` |

Everything else stays where it was: `memory/` (session saves), `people/`, `outputs/`, `CLAUDE.md`. A project adopted with `/osi-setup` keeps `current-state.md` at its root and has neither folder; the migration leaves it alone.

### Why

The old names did not say what the folders held. `intelligence/` was the folder `/add-context` fills, and nothing about the word told a newcomer that. `context/` held the synthesised state, which is the opposite of what a person typing `/add-context` would guess. The confusion showed up in testing: new users looked in the wrong folder first.

Two rules settled the new names.

1. **Folders are named for what they hold, not for the skill that fills them.** `add-context/` was considered and rejected: a reader browsing the repo would have to know the command to understand the folder, and more than one skill writes there.
2. **One word for the mental model.** Everything the agent reads is context, and you add to it. `state/` is the derived layer, what the system holds now, which `/os-start` loads and `/os-save` maintains.

### What the script does

1. For each project under `projects/` (and each item folder inside a portfolio) that still has an `intelligence/` folder: renames `context/` to `state/` (if present), then `intelligence/` to `context/`. A project without `intelligence/` is left alone, whatever else it holds, so the script is safe to run twice. The path rewrite (step 2) only runs when this invocation moved at least one folder, because on its own it is not idempotent: the new `context/` would become `state/`.
2. Rewrites path references in every `.md`, `.sh`, `.py`, `.yaml`, `.json` and `.html` file under the workspace, in one pass with a placeholder so nothing is rewritten twice. `context-library/`, `add-context/`, `os-intelligence/` and any `*-intelligence/` are left alone. `.git/`, `migrations/`, `_dryrun/` and `CHANGELOG.md` are skipped.
3. Does not rename frontmatter field names (`context_enriched`, `context_informs` are field names, not paths). Does not rewrite git history.

### Compatibility

`os-start`, `os-save`, `ctx-doc` and `os-save/session-diff.sh` resolve the current-state file root-first, then `state/`, then the pre-0003 `context/current-state.md`. An unmigrated workspace keeps working; it gets a one-line suggestion to run the migration.

### How to run it

```
git add -A && git commit -m "before migration 0003"
python migrations/0003-rename-context-and-state-folders.py --dry-run
python migrations/0003-rename-context-and-state-folders.py
git status
```

If anything looks wrong: `git checkout . && git clean -fd` puts everything back.

### Known effects on a large workspace

Link rewriting touches every file that references either folder. On a workspace with a thousand files that is a large diff in one commit; that is expected. Session memory files under `memory/` are rewritten too, so their paths resolve; their prose still says "intelligence" where a person wrote it, and that is left as history.

### What is not migrated by this script

- Your own skills outside `.claude/skills/` from this repo, if they hard-code either folder name.
- Symlinks into a project's `intelligence/` folder from elsewhere (for example a `granola-sync` target). Re-point them.
- Anything in `_dryrun/`.

---

## 0002 · Drop the `Goal` field from project `CLAUDE.md`

_script: `migrations/0002-drop-claude-md-goal.py`_

Project `CLAUDE.md` files carried the project goal, duplicating `projects.md` and `current-state.md`. `CLAUDE.md` is reference, not state; the copy went stale. The script removes the `Goal` line and inserts a pointer to `current-state.md`. Idempotent.

---

## 0001 · Drop `Key People` from project `CLAUDE.md`

_script: `migrations/0001-drop-claude-md-key-people.py`_

The `Key People` table in project `CLAUDE.md` duplicated the `people/` folder and went stale. The script removes it and points to `people/`. Idempotent.
