#!/usr/bin/env python3
"""
Migration 0003 — Rename the two project folders: intelligence/ → context/, context/ → state/.

WHY
  The folder that /add-context fills was called `intelligence/`. The folder
  that held the synthesised knowledge (current-state.md, decisions, the
  topic files) was called `context/`. A newcomer reading the repo, or a
  user typing /add-context, could not tell from the names which was which.

  New names say what each folder holds:

      context/   ← what went in: meetings, docs, chats, notes, each with
                   its raw file and its own synthesis beside it. The folder
                   /add-context (and the ctx-* writers) fill.
      state/     ← what we hold now: current-state.md, decisions, the
                   synthesised topic files. Written by /synthesise, /os-save
                   and /ctx-doc.

  Folders are named for what they hold, not for the skill that fills them.
  "context" is the word the skill already uses, so the mental model is one
  word: everything the agent reads is context, and you add to it.

WHAT IT DOES
  For every project folder under projects/ (and every portfolio item folder
  one level below a portfolio), in this order:

    1. renames  <project>/context/       →  <project>/state/
    2. renames  <project>/intelligence/  →  <project>/context/

  then rewrites path references in every *.md, *.sh, *.py, *.yaml file
  under the workspace (skipping .git/, migrations/, _dryrun/ and
  CHANGELOG.md):

    - `context/`       → `state/`      (except context-library/, add-context/)
    - `intelligence/`  → `context/`    (except os-intelligence/, *-intelligence/)

  The two rewrites run as one pass with a placeholder, so a path is never
  rewritten twice.

WHAT IT DOES NOT DO
  - It does not touch a project that has a root-level current-state.md and
    no context/ or intelligence/ folder (the /osi-setup adopt-in-place shape).
  - It does not rename frontmatter field names (`context_enriched`,
    `context_informs` stay as they are; they are field names, not paths).
  - It does not rewrite git history. Old commits keep old paths.

IDEMPOTENT
  A project with `state/` and no `intelligence/` is skipped, and the path
  rewrite only runs when this invocation moved at least one folder. Running
  twice is safe. (The rewrite alone is not idempotent: the new `context/`
  would become `state/`. That is why it is gated. Use --force-rewrite only
  if you moved the folders by hand and still need the paths fixed.)

USAGE
  Dry run from your workspace root:
    python migrations/0003-rename-context-and-state-folders.py --dry-run

  Apply for real:
    python migrations/0003-rename-context-and-state-folders.py

  From elsewhere:
    python migrations/0003-rename-context-and-state-folders.py --root /path/to/workspace

  Commit before you run it. If anything looks wrong, `git checkout .` and
  `git clean -fd` put everything back.
"""
from __future__ import annotations
import argparse
import re
import sys
from pathlib import Path

TEXT_SUFFIXES = {".md", ".sh", ".py", ".yaml", ".yml", ".json", ".html"}
SKIP_DIRS = {".git", "migrations", "_dryrun", "node_modules"}
SKIP_FILES = {"CHANGELOG.md"}

CTX = re.compile(r"(?<![\w\-])context/")        # not context-library/, not add-context/
INT = re.compile(r"(?<![\w\-])intelligence/")   # not os-intelligence/, not stakeholder-intelligence/
PLACEHOLDER = "\x00STATE\x00"


def project_dirs(root: Path):
    """Every project folder, plus every item folder inside a portfolio."""
    projects = root / "projects"
    if not projects.is_dir():
        return []
    out = []
    for p in sorted(projects.iterdir()):
        if not p.is_dir() or p.name.startswith("."):
            continue
        out.append(p)
        # portfolio items: one level down, any folder holding memory/ or intelligence/ or context/
        for child in sorted(p.iterdir()):
            if child.is_dir() and not child.name.startswith(".") and any(
                (child / n).is_dir() for n in ("intelligence", "context", "memory")
            ):
                out.append(child)
    return out


def rename_folders(proj: Path, dry: bool) -> list[str]:
    log = []
    ctx, intel, state = proj / "context", proj / "intelligence", proj / "state"
    # The only reliable "not yet migrated" signal is an intelligence/ folder.
    # A project with context/ and no intelligence/ is either already migrated
    # (context/ = sources) or never had sources; either way, leave it alone.
    if not intel.is_dir():
        return log
    if ctx.is_dir():
        if state.exists():
            log.append(f"  SKIP {proj}: state/ already exists alongside context/; resolve by hand")
            return log
        log.append(f"  mv {ctx.relative_to(proj.parent.parent)} -> state/")
        if not dry:
            ctx.rename(state)
    if intel.is_dir():
        if (proj / "context").exists():
            log.append(f"  SKIP {proj}: context/ still exists; intelligence/ not moved")
            return log
        log.append(f"  mv {intel.relative_to(proj.parent.parent)} -> context/")
        if not dry:
            intel.rename(proj / "context")
    return log


def rewrite_paths(root: Path, dry: bool) -> int:
    n = 0
    for f in root.rglob("*"):
        if not f.is_file() or f.suffix not in TEXT_SUFFIXES or f.name in SKIP_FILES:
            continue
        if any(part in SKIP_DIRS for part in f.relative_to(root).parts):
            continue
        try:
            s = f.read_text()
        except (UnicodeDecodeError, OSError):
            continue
        t = CTX.sub(PLACEHOLDER, s)
        t = INT.sub("context/", t)
        t = t.replace(PLACEHOLDER, "state/")
        if t != s:
            n += 1
            if not dry:
                f.write_text(t)
    return n


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--root", default=".", help="workspace root (default: cwd)")
    ap.add_argument("--dry-run", action="store_true")
    ap.add_argument("--force-rewrite", action="store_true",
                    help="rewrite path references even if no folder was moved (only if you moved folders by hand)")
    a = ap.parse_args()
    root = Path(a.root).resolve()
    if not (root / "projects").is_dir():
        print(f"No projects/ under {root}. Run from your workspace root or pass --root.")
        return 1
    print(f"{'DRY RUN ' if a.dry_run else ''}migration 0003 on {root}")
    moved = 0
    for proj in project_dirs(root):
        for line in rename_folders(proj, a.dry_run):
            print(line)
            moved += 1
    # The path rewrite is NOT idempotent on its own: after migration the new
    # `context/` (sources) would be turned into `state/` on a second run. So it
    # only runs when this invocation moved at least one folder (or on
    # --force-rewrite, for a workspace whose folders were moved by hand).
    if moved == 0 and not a.force_rewrite:
        print("no intelligence/ folder under projects/: workspace already migrated. Paths left untouched.")
        return 0
    n = rewrite_paths(root, a.dry_run)
    print(f"folders moved: {moved} · files with rewritten paths: {n}")
    if a.dry_run:
        print("nothing written. Re-run without --dry-run to apply.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
