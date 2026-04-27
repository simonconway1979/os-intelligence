# OS-Intelligence

The intelligence layer for your operating system.

Built by [Simon Conway](https://linkedin.com/in/simonconway) · AI-native PM.

OS-Intelligence is a free, installable context layer for Claude Code. Drop in your meetings, documents, notes, and chats; it captures, synthesises, and surfaces the right context at the start of every session.

Files stay on your machine. The only network call is the one Claude Code already makes to Anthropic.

A local activity log at `.os-intel-log/usage.jsonl` records skill usage and session counts so you can see your own patterns. It never leaves your machine. See [`docs/usage-log.md`](docs/usage-log.md) to inspect or disable.

---

## Get started

After install, run **`/os-welcome`** in Claude Code. It walks you through your first project end-to-end, starting from one of the three jobs below.

Or jump straight in by following one of these on your own.

---

## Try this in 10 minutes

Three concrete jobs that show what the system does. Pick the one closest to your current work. Each is a complete loop with visible output at the end. `/os-welcome` will guide you through any of them.

### 1. Walk into your next 1:1 prepared in 10 minutes

You have a 1:1 tomorrow with someone you haven't met with in three weeks. You'd normally spend 30 minutes scrolling Slack, Notion, and old notes trying to remember what's open with them.

Instead:

```
/os-new-project              → call it "1-on-1 prep with Alex"
[drop 3 past meeting transcripts into intelligence/meetings/]
/ctx-transcript              → run for each transcript
/ctx-synthesise              → cross-cuts the three
/os-start                    → opens the brief
```

**What you get:** a one-page stakeholder brief with what Alex cares about, recent commitments, open threads, and where things may have shifted.

---

### 2. Pick up a stalled project without re-reading everything

You paused a project two months ago. Opening the folder is overwhelming. You've forgotten where things stood, who's involved, and what was waiting on whom.

Instead:

```
/os-new-project              → name the stalled project
[drop 5-10 documents into intelligence/docs/raw/]
/ctx-doc                     → run for each doc
/ctx-synthesise              → builds current-state.md
/os-start                    → loads the picture
```

**What you get:** a `current-state.md` showing where it stood, the people involved, what was open, and what's likely changed since.

---

### 3. Synthesise user research before the readout

You have five user interview transcripts to read before Friday. Two days to find patterns. Half a day to write the readout.

Instead:

```
/os-new-project              → call it "Research synthesis: [topic]"
[drop the 5 transcripts]
/ctx-transcript              → run for each
/ctx-synthesise              → cross-cuts them
```

**What you get:** themes, tensions, who said what, where the cohort agrees and where they don't. Two hours instead of two days.

---

## What synthesis actually looks like

After two or three meetings on a project, your `current-state.md` looks like this:

```markdown
## Project Position
_Last updated: 2026-04-15 via os-save_

Initial discovery complete. Three customer interviews confirm pricing
sensitivity is the primary blocker, not feature gaps. Engineering has
bandwidth from week of May 5. Decision needed by 2026-04-30 on whether
to ship a price-test variant.

## Stakeholder Dynamics

**Key positions:**
- Alex Chen (CEO, High/High Ally): wants pricing test by mid-May, less
  patient with discovery than two weeks ago
- Priya Sharma (Eng Lead, Medium/High): bandwidth confirmed, raised a
  data-pipeline concern in last 1:1

**Tensions:** Alex's timeline vs Priya's data concern. Unresolved.

## In Flight
- Pricing variant scope (decision Apr 30)
- Customer interview #4 scheduled Apr 28

## Open Questions
- Does the data pipeline support real-time variant assignment?
- Who owns the pricing decision if Alex is travelling?
```

Loaded automatically by `/os-start` at the start of every session. Nothing to remember, nothing to scroll.

---

## What you get

**16 skills** that handle context end-to-end:

- **Capture** · `ctx-transcript`, `ctx-doc`, `ctx-note`, `ctx-chat`, `ctx-inspiration`
- **Synthesise** · `ctx-synthesise`, `ctx-timeline`
- **Retrieve** · `os-welcome`, `os-start`, `os-save`, `os-switch-project`
- **Scaffold** · `os-new-project`, `os-new-item`, `os-new-person`, `os-project-design`, `new-project`

**7 sub-agents** for second-opinion review: `customer-voice`, `designer-reviewer`, `engineer-reviewer`, `executive-reviewer`, `legal-advisor`, `skeptic`, `uxr-analyst`.

**A context library** with file conventions, writing-style guides (edit to your tone), and stub configuration for MCP setup and add-ons.

**An example project** (`projects/acme-corp-example/`) populated with realistic stakeholders, meetings, and synthesis output so you can see a working setup before building your own.

---

## Install

```bash
git clone https://github.com/simonconway1979/os-intelligence.git ~/Code/os-intelligence
cd ~/Code/os-intelligence
```

Open the folder in Claude Code. Run **`/os-welcome`** for a guided first run, or **`/os-start`** if you already know what you want.

Prerequisites: Claude Code installed and authenticated. New to Claude Code? Start at [claude.com/code](https://claude.com/code).

Full walkthrough: [`MIGRATION.md`](MIGRATION.md).

---

## Architecture

How the pieces fit, projects vs portfolios, the context flow: [`ARCHITECTURE.md`](ARCHITECTURE.md).

---

## Plugging in your own setup

OS-Intelligence is the intelligence layer. It expects you'll bring your own skills, frameworks, and workflows on top.

- **Tone of voice** · [`context-library/tone-of-voice.md`](context-library/tone-of-voice.md). Default styles in `writing-styles-global/`. Edit them.
- **MCP setup** · [`context-library/mcp-setup.md`](context-library/mcp-setup.md). Paste your own routing.
- **Add-ons** · [`docs/addons.md`](docs/addons.md). Where to drop your own skills, sub-agents, and frameworks.

If you already have a working `CLAUDE.md`, keep it. Just preserve the stakeholder-intelligence section so the `ctx-` skills know where to write. See [`CLAUDE.md`](CLAUDE.md).

---

## Demo

Coming soon. A short walkthrough: install, first synthesis, and what a populated `current-state.md` looks like after three meetings.

---

## Contributing

Apache 2.0 with a contributor licence agreement. See [`CONTRIBUTING.md`](CONTRIBUTING.md), [`CODE_OF_CONDUCT.md`](CODE_OF_CONDUCT.md), [`AUTHORS.md`](AUTHORS.md).

In active development. Open an issue or reach out directly.

---

## Licence

Apache 2.0. See [`LICENSE`](LICENSE).

---

## About the author

OS-Intelligence is built by [Simon Conway](https://linkedin.com/in/simonconway), an AI-native product manager.

20 years in product across SaaS, consultancy, and operating-model transformation. Most recently led an AI-transformation North Star at a PE-backed enterprise software unicorn, launching it to a 1,000-person All Hands and aligning a 2,000-person R&D organisation. Earlier: Product Principal at AND Digital (Constellation Brands operating-model transformation, tier-one bank mobile app at 5M users), product and AI research at Capgemini, and 14 years as Director of Product at Alps Education building 0-1 products deployed into ~2,000 UK schools.

Now operating independently. Claude Code is the daily driver. OS-Intelligence is the public, free version of the system Simon uses every day. The fiddly migration (overlaying it onto an existing PM setup so you keep your workflows and gain persistent context) is also offered as paid consulting. See [`MIGRATION.md`](MIGRATION.md).

Reach out via [LinkedIn](https://linkedin.com/in/simonconway) or open an issue on this repo.
