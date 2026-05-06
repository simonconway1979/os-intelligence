# OS-Intelligence

**A reasoning layer for AI-native knowledge work.**

Every AI session starts cold. You re-explain context, re-derive decisions, hold the thread in your head until you don't. What if every session built on the last, and the system held the thread for you?

OS-Intelligence is a free, open-source context system for Claude Code. It captures your meetings, documents, chats, and notes, synthesises them into reference state, and surfaces the right context at the start of every session. It's the rails for AI-native knowledge work: every interaction has a reason, every decision is traceable, the system shows its homework.

Built by [Simon Conway](https://linkedin.com/in/simonconway), an AI-native PM. In daily use, designed to be shaped by the people who use it. If you live in Claude Code and you've already started building your own context system to make it work, this is for you.

Files stay on your machine. The only network call is the one Claude Code already makes to Anthropic.

---

## Setup

New to Claude Code? Start with the **[Setup guide](docs/setup.md)**. It walks you through installing Claude Code, Cursor, and OS-Intelligence in about 15 minutes. No coding skills needed.

Already have Claude Code installed? Skip to **Get started** below.

---

## Get started

In your terminal:

```bash
mkdir -p ~/Code && cd ~/Code   # or any other location
git clone https://github.com/simonconway1979/os-intelligence.git
cd os-intelligence
claude
```

Once Claude is running, type:

```
/os-welcome
```

This walkthrough guides you through your first project end-to-end so you experience the workflow with your own data.

### Keep your context private: clone, don't fork

OS-Intelligence is the framework. Your meetings, documents, notes, and people files are the context, and that context is private. **Don't fork this repo on GitHub.** Forks default to public, so anything you add gets indexed.

Recommended: create your own private repo and repoint the remote so commits go there. Full walkthrough in the [Setup guide](docs/setup.md#step-4-clone-the-repo).

---

## Compounding value

The value of OS-Intelligence increases as your context layer develops. This happens naturally as you use it.

After the `/os-welcome` walkthrough you'll have a feel for how it works and where it could fit. A few weeks in, the system is doing real lifting on the things you used to re-explain. Past that, it's hard to remember how you worked without it.

---

## Example project

You can see a fully populated OS-Intelligence project at [`projects/acme-corp-example/`](projects/acme-corp-example/) — synthesised context across docs, meetings, chats, and people for a (fully synthetic) scenario. To get started, take a look at the [example project tour](projects/acme-corp-example/START-HERE.md).

---

## Skills

Each skill is a lightweight workflow that helps you manage people, projects, and context.

See the **[Skills reference](docs/skills.md)** for what each skill does, grouped by capture, synthesise, retrieve, and scaffold.

---

## Status bar

Set up your status bar to show your current model, context usage, session cost, and anything else you'd otherwise switch tabs to check. Stops you from breaking flow to ask Claude what model you're on.

See the **[Status bar guide](docs/status-bar.md)**. Adapted from [Hannah Stulberg's article](https://hannahstulberg.substack.com/p/claude-code-for-everything-your-status-line-is-empty) on the same.

---

## Architecture

How the pieces fit, projects vs portfolios, the context flow: [`ARCHITECTURE.md`](ARCHITECTURE.md).

---

## Plugging in your own setup

OS-Intelligence is the reasoning layer. It expects you'll bring your own skills, frameworks, and workflows on top.

- **Tone of voice** · [`context-library/tone-of-voice.md`](context-library/tone-of-voice.md). Default styles in `writing-styles-global/`. Edit them.
- **MCP setup** · [`context-library/mcp-setup.md`](context-library/mcp-setup.md). Paste your own routing.
- **Add-ons** · [`docs/addons.md`](docs/addons.md). Where to drop your own skills, sub-agents, and frameworks.

If you already have a working `CLAUDE.md`, keep it. Just preserve the stakeholder-intelligence section so the `ctx-` skills know where to write. See [`CLAUDE.md`](CLAUDE.md).

---

## Activity log

A local activity log at `.os-intel-log/usage.jsonl` records skill usage and session counts so you can see your own patterns. It never leaves your machine. See [`docs/usage-log.md`](docs/usage-log.md) to inspect or disable.

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

Now operating independently. Claude Code is the daily driver. OS-Intelligence is the public, free version of the system Simon uses every day. The fiddly migration (overlaying it onto an existing PM setup so you keep your workflows and gain persistent context) is also offered as paid consulting.

Reach out via [LinkedIn](https://linkedin.com/in/simonconway) or open an issue on this repo.
