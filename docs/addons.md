---
name: addons
description: Where to drop your own skills, sub-agents, frameworks, and integrations on top of OS-Intelligence.
type: reference
tags:
  - type/reference
  - status/synthesised
---

# Add-ons

OS-Intelligence ships an intelligence layer, not a full toolkit. To add your own skills, sub-agents, frameworks, content patterns, or external integrations on top, here's where they go and how they coexist with the public layer.

---

## Skills

**Where:** `.claude/skills/[your-skill-name]/`

**Format:** standard Claude Code skill folder. `SKILL.md` is the entrypoint; optional `BACKGROUND.md` for heavy processing logic that doesn't need to live in the interactive prompt.

**Coexistence:** Claude Code merges the public skills (symlinked from `os-intelligence/.claude/skills/`) with your own. As long as names don't collide, both show up in the skill list.

**Naming.** Public skills use prefixes: `os-` for scaffolding, `ctx-` for context capture and synthesis. Pick a different prefix for yours so it's obvious which is which. Examples: `deck-1-build`, `plan-day`, `nsa-company-info`.

**Conflict.** If you have a skill with the same name as a public one, your local copy wins (Claude Code reads the directory directly, not via symlink resolution). Better: rename your version so both work side by side.

---

## Sub-agents

**Where:** `sub-agents/[your-agent-name].md`

**Format:** standard Claude Code sub-agent definition. Single markdown file with the agent description and instructions.

**Coexistence:** the public 7 sub-agents are at the symlinked `sub-agents/` folder. If you want to add your own, you have two options:

1. **Add a separate folder** (`my-sub-agents/`) and point your harness at both. Cleaner.
2. **Replace the symlink with a real folder** that contains both the public files (copied) and your own. Simpler, but you give up the auto-update benefit.

Option 1 is recommended.

---

## Frameworks and reference docs

**Where:** `context-library/frameworks/[framework-name].md` or `context-library/[your-folder]/`

These are reference documents that skills can read when they need them. Examples: 7 Powers, JTBD canvas, growth loops, your own internal frameworks.

OS-Intelligence ships an empty `context-library/` (apart from file-conventions, writing-styles, tone-of-voice, mcp-setup). Anything you drop in here is yours.

---

## Content patterns and templates

**Where:** `context-library/templates/` or alongside your skills.

If you have a deck template, a PRD template, a meeting-notes template, drop it next to the skill that uses it or in `context-library/templates/`. Reference by relative path from your skill.

---

## External integrations

### MCP servers

See [`context-library/mcp-setup.md`](../context-library/mcp-setup.md). Paste your routing logic and config there.

### n8n / Zapier / other workflow tools

**Where:** `context-library/tools/[tool-name]/`

Drop a reference document for each external system you want Claude to know about: what it does, how to call it, when to reach for it. Skills can read these when they need to plan a workflow.

### Your own MCP servers

If you've built a custom MCP server (for an internal API, a database, a service), document the routing in `mcp-setup.md` like any other MCP. The connection itself happens via Claude Code's MCP config, not in this repo.

---

## Personal context

**Where:** outside this repo, generally.

OS-Intelligence is a public layer. If you want to bring in your personal background (CV, brand notes, working preferences, ongoing projects), keep them in your private workspace and reference them via paths in your project `CLAUDE.md` files.

The clean separation: OS-Intelligence stays public and generic; your private context stays private. The symlink workflow keeps both in sync without mixing.

---

## What not to add here

- Anything that names individuals, real companies, or proprietary frameworks you don't have rights to share publicly.
- Project-specific content. Projects live under `projects/`, not in the global context library.
- API keys, credentials, internal URLs. The `.gitignore` covers `.env` and `*.key` patterns; respect them.
