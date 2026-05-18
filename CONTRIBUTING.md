# Contributing to OS-Intelligence

Thanks for your interest. OS-Intelligence is in early public development; contributions are welcome.

This document covers how to file issues, propose changes, and submit pull requests.

---

## Before you start

- Read [`README.md`](README.md) for what the project is.
- Read [`ARCHITECTURE.md`](ARCHITECTURE.md) for how the pieces fit.
- For larger changes (new skills, structural changes, breaking changes to the file conventions), open an issue first to discuss before writing code. Saves both of us time.

---

## Filing issues

Use GitHub Issues. Useful issue types:

- **Bug** · something doesn't work as documented. Include: what you ran, what you expected, what actually happened, your OS / Claude Code version.
- **Skill request** · a new `ctx-` or `os-` skill that fits the intelligence-layer scope.
- **Doc fix** · ambiguous or wrong documentation, broken links, missing examples.
- **Question** · something the docs should explain but don't.

Search existing issues before opening a new one. If you find a related issue, comment on it rather than starting a duplicate.

---

## Local setup

After cloning, install the version-controlled git hooks:

```
bash scripts/install-hooks.sh
```

This sets `core.hooksPath` to `scripts/hooks/` so the shipped hooks activate. Currently one hook:

- **pre-commit** — scans staged content for test-artefact patterns listed in `scripts/hooks/test-artefact-patterns.txt` (known test project names, `[TEST]` markers, transient `Welcome: pending` tags). Blocks the commit if it matches; existed because a test project once leaked into the public `projects.md`.

To bypass on a specific commit (e.g. you're intentionally editing the pattern file itself):

```
git commit --no-verify
```

---

## Submitting pull requests

### Process

1. Fork the repo and create a branch off `main`. Branch names: `fix/short-description`, `feat/short-description`, `docs/short-description`.
2. Make your changes. Keep PRs small and focused on one thing.
3. Run any tests or skill walkthroughs relevant to what you changed.
4. Open a PR against `main` with a clear description: what changed, why, and how you tested it.
5. Sign the CLA (see below) on first PR.

### What makes a good PR

- One logical change per PR. If you find yourself writing "and also" in the description, split it.
- Update docs in the same PR as code changes. Out-of-sync docs are a real problem.
- Match the existing style of files you're editing. Frontmatter conventions, voice, structure.
- Don't add features, refactors, or abstractions beyond what the issue calls for. If you spot something else worth changing, open a separate issue.

### What we'll push back on

- Renames or restructures without a strong reason. Stable file paths matter for users with their own setups overlaying ours.
- Skills that duplicate functionality of existing skills. The skill set is intentionally small.
- New dependencies or external services without prior discussion.
- Anything that names individuals, companies, or proprietary content. The repo is public; treat it accordingly.

---

## Contributor Licence Agreement (CLA)

OS-Intelligence requires a CLA on first contribution. The CLA confirms you have the right to submit your contribution and that it will be licensed under Apache 2.0 alongside the rest of the project.

The CLA is administered through [cla-assistant.io](https://cla-assistant.io/). When you open your first PR, the bot will prompt you to sign — takes about 30 seconds.

Why we use a CLA: it lets the project re-license cleanly if needed (for example, dual-licensing for an enterprise tier) without having to track down every contributor.

---

## Code of Conduct

By participating, you agree to abide by [`CODE_OF_CONDUCT.md`](CODE_OF_CONDUCT.md).

---

## Maintainer response time

Best-effort, weekly cadence. The project is run alongside other work. If something is urgent (security issue, regression), flag it as such in the issue title and the response will be faster.

For security issues, do not file a public issue. Email simon.conway@condaal.com directly.

---

## Recognition

Contributors are added to [`AUTHORS.md`](AUTHORS.md) on first merged PR.
