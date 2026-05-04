#!/usr/bin/env python3
"""
Migration 0002 — Drop CLAUDE.md "Goal" field; replace with pointer to current-state.md.

WHY
  Project CLAUDE.md files used to carry the project Goal (and only Goal,
  not the one-liner) inside the `## Project` block. This duplicates what
  lives in `projects.md` and the `## [Project Name]` block at the top of
  `context/current-state.md` (auto-synced from projects.md by `/os-save`).

  CLAUDE.md is reference, not state. Goals evolve, the CLAUDE.md copy goes
  stale because no skill updates it. Single source of truth = projects.md;
  current-state.md mirrors it via os-save.

WHAT IT DOES
  For each projects/*/CLAUDE.md, removes the `- **Goal:** ...` line from
  the `## Project` block and inserts a pointer line right after `- **Started:**`:

      See `context/current-state.md` for description, goal, and current
      state (synced from `projects.md`).

IDEMPOTENT
  Files already migrated (containing the pointer marker) are skipped.

USAGE
  Dry run from your workspace root:
    python migrations/0002-drop-claude-md-goal.py --dry-run

  Apply for real:
    python migrations/0002-drop-claude-md-goal.py

  From elsewhere:
    python migrations/0002-drop-claude-md-goal.py --root /path/to/workspace
"""
from __future__ import annotations
import argparse
import re
import sys
from pathlib import Path

POINTER_LINE = "See `context/current-state.md` for description, goal, and current state (synced from `projects.md`)."
MIGRATED_MARKER = "synced from `projects.md`"

# Match `- **Goal:** anything` (can contain inline markdown). Single line.
GOAL_LINE = re.compile(r'^- \*\*Goal:\*\*.*\n', re.MULTILINE)
# Match `- **Started:** anything` so we can insert the pointer immediately after.
STARTED_LINE = re.compile(r'^(- \*\*Started:\*\*.*\n)', re.MULTILINE)


def migrate_file(path: Path, dry_run: bool) -> str:
    content = path.read_text()
    if MIGRATED_MARKER in content:
        return "skipped (already migrated)"

    has_goal = bool(GOAL_LINE.search(content))
    has_started = bool(STARTED_LINE.search(content))

    if not has_goal and not has_started:
        return "skipped (no Project block fields found)"

    new = content
    if has_goal:
        new = GOAL_LINE.sub("", new, count=1)

    # Insert pointer after the Started line (or, if no Started line, after the project block heading)
    if has_started:
        new = STARTED_LINE.sub(r"\1\n" + POINTER_LINE + "\n", new, count=1)
    else:
        # Best-effort: insert after `## Project` heading
        new = re.sub(r'^(## Project\s*\n)', r"\1\n" + POINTER_LINE + "\n", new, count=1, flags=re.MULTILINE)

    if new == content:
        return "skipped (no change made)"

    if dry_run:
        return "would update"
    path.write_text(new)
    return "migrated"


def main() -> int:
    p = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    p.add_argument("--dry-run", action="store_true", help="Report changes without writing")
    p.add_argument("--root", default=".", help="Workspace root containing projects/ (default: cwd)")
    args = p.parse_args()

    root = Path(args.root).resolve()
    projects_dir = root / "projects"
    if not projects_dir.is_dir():
        print(f"ERROR: No projects/ folder at {root}", file=sys.stderr)
        return 1

    files = sorted(projects_dir.glob("*/CLAUDE.md"))
    if not files:
        print(f"No CLAUDE.md files found in {projects_dir}/*/")
        return 0

    prefix = "DRY RUN — " if args.dry_run else ""
    print(f"{prefix}Scanning {len(files)} CLAUDE.md file(s) in {projects_dir}/")
    print()
    counts = {"migrated": 0, "would": 0, "skipped": 0}
    for f in files:
        result = migrate_file(f, args.dry_run)
        print(f"  {f.relative_to(root)} — {result}")
        if "would" in result:
            counts["would"] += 1
        elif "migrated" in result and "already" not in result:
            counts["migrated"] += 1
        else:
            counts["skipped"] += 1
    print()
    if args.dry_run:
        print(f"Summary: {counts['would']} would update, {counts['skipped']} skipped")
        print("Run without --dry-run to apply.")
    else:
        print(f"Summary: {counts['migrated']} migrated, {counts['skipped']} skipped")
    return 0


if __name__ == "__main__":
    sys.exit(main())
