#!/usr/bin/env python3
"""
Migration 0001 — Drop CLAUDE.md "Key People" table; replace with pointer.

WHY
  Project CLAUDE.md files used to carry a hand-maintained "Key People" table
  (Name | Role). This goes stale: no skill updates it after /os-new-project
  seeds it. The same information is auto-maintained elsewhere:
    - projects/[project]/people/  ← per-person profile files (auto-created
      by /ctx-transcript and /ctx-doc)
    - context/current-state.md → Stakeholder Dynamics  ← auto-maintained
      by /ctx-synthesise (includes "Who to watch")

  Skill templates have been updated to drop this table from new projects.
  This migration cleans up existing CLAUDE.md files in installed workspaces.

WHAT IT DOES
  For each projects/*/CLAUDE.md, replaces the "## Key People" block with:

      ## Key People

      See `people/` for project-level stakeholder profiles (auto-maintained
      by `/ctx-transcript` and `/ctx-doc`).
      Current dynamics: `context/current-state.md` → Stakeholder Dynamics
      (auto-maintained by `/ctx-synthesise`).

IDEMPOTENT
  Files already migrated (containing the marker text) are skipped. Re-running
  is safe.

USAGE
  Dry run from your workspace root:
    python migrations/0001-drop-claude-md-key-people.py --dry-run

  Apply for real:
    python migrations/0001-drop-claude-md-key-people.py

  From elsewhere, point at a workspace:
    python migrations/0001-drop-claude-md-key-people.py --root /path/to/workspace
"""
from __future__ import annotations
import argparse
import re
import sys
from pathlib import Path

POINTER_BLOCK = """## Key People

See `people/` for project-level stakeholder profiles (auto-maintained by `/ctx-transcript` and `/ctx-doc`).
Current dynamics: `context/current-state.md` → Stakeholder Dynamics (auto-maintained by `/ctx-synthesise`).
"""

MIGRATED_MARKER = "auto-maintained by `/ctx-transcript`"

# Match "## Key People\n..." up to (but not including) the next "---" line
# or next "## " heading. Captures the whole stale block for replacement.
KEY_PEOPLE_PATTERN = re.compile(
    r'^## Key People\s*\n(?:(?!^---\s*$|^## ).*\n?)*',
    re.MULTILINE,
)


def migrate_file(path: Path, dry_run: bool) -> str:
    content = path.read_text()
    if MIGRATED_MARKER in content:
        return "skipped (already migrated)"
    m = KEY_PEOPLE_PATTERN.search(content)
    if not m:
        return "skipped (no Key People section)"
    old_block = m.group(0).rstrip() + "\n"
    new_content = content[:m.start()] + POINTER_BLOCK + content[m.start() + len(old_block):]
    if dry_run:
        old_lines = old_block.count("\n")
        new_lines = POINTER_BLOCK.count("\n")
        return f"would update ({old_lines} → {new_lines} lines)"
    path.write_text(new_content)
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
    counts = {"migrated": 0, "would update": 0, "skipped": 0}
    for f in files:
        result = migrate_file(f, args.dry_run)
        print(f"  {f.relative_to(root)} — {result}")
        if "migrated" in result and "already" not in result:
            counts["migrated"] += 1
        elif "would update" in result:
            counts["would update"] += 1
        else:
            counts["skipped"] += 1
    print()
    if args.dry_run:
        print(f"Summary: {counts['would update']} would update, {counts['skipped']} skipped")
        print("Run without --dry-run to apply.")
    else:
        print(f"Summary: {counts['migrated']} migrated, {counts['skipped']} skipped")
    return 0


if __name__ == "__main__":
    sys.exit(main())
