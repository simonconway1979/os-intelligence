# Skills reference

Each OS-Intelligence skill is a lightweight workflow you trigger with a slash command in Claude Code. Skills are grouped by what they do.

---

## Capture — bring context in

| Skill | What it does |
|---|---|
| `/ctx-transcript` | Process a meeting transcript. Synthesises the meeting, validates against the source, updates people files. |
| `/ctx-doc` | Add a document (PRD, brief, strategy doc) to project context. |
| `/ctx-note` | Capture an observation, written note, or voice memo. Links to a person if relevant. |
| `/ctx-chat` | Capture a chat thread (WhatsApp, Slack, DM). Deduplicates on re-imports. |
| `/ctx-inspiration` | Process new files in the global inspiration library. Updates the index, runs synthesis. |

## Synthesise — turn captures into understanding

| Skill | What it does |
|---|---|
| `/ctx-synthesise` | Cross-cut all stakeholder intelligence: corroborated findings, themes, urgency flags, hypotheses. Updates per-person standing briefs. |
| `/ctx-timeline` | Generate a timeline from intelligence: meetings, events, decisions, what comes next. |

## Retrieve — load context for a session

| Skill | What it does |
|---|---|
| `/os-welcome` | First-run guided onboarding. Routes you to your first piece of value in under 15 minutes. |
| `/os-start` | Load the active project's context and start a session with a compact briefing. |
| `/os-save` | Save a summary of the current session, update memory, optionally commit and push. |
| `/os-switch-project` | Switch the active project. |

## Scaffold — set up new structures

| Skill | What it does |
|---|---|
| `/os-new-project` | Create a new project. Sets up the folder, the `projects.md` entry, and generates `CLAUDE.md`. |
| `/os-new-item` | Add a new item to a portfolio (campaign, opportunity, idea, etc.). |
| `/os-new-person` | Add a person or company. Creates root-level identity files. |
| `/os-archive-item` | Archive a portfolio item. Marks it complete or stopped, writes a structured summary, moves the TRACKER row. |
| `/os-project-design` | Design a project structure when the standard template isn't quite right. |

---

## Sub-agents

Seven sub-agents you can call for second-opinion review on any work product:

`customer-voice` · `designer-reviewer` · `engineer-reviewer` · `executive-reviewer` · `legal-advisor` · `skeptic` · `uxr-analyst`

See `sub-agents/` in the repo for full agent definitions.
