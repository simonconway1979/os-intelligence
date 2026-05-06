# Setup

Get OS-Intelligence running on your machine in about 15 minutes.

| Step | What | Time |
|---|---|---|
| 1 | Install Claude Code | ~3 min |
| 2 | Install Cursor (or use your existing editor) | ~3 min |
| 3 | Set up Cursor | ~2 min |
| 4 | Clone the repo | ~2 min |
| 5 | Set up your workspace | ~2 min |
| 6 | First run | ~3 min |

## What you'll install

1. **Claude Code**: Anthropic's CLI that runs in your terminal
2. **Cursor** (recommended): AI-powered editor for viewing your project files alongside Claude. Any editor works.
3. **OS-Intelligence**: this repo

No coding skills needed. You won't write code. You'll talk to Claude in plain English and watch your files update in Cursor.

---

## Step 1: Install Claude Code (~3 min)

### Prerequisites

- macOS, Linux, or Windows with WSL ([install WSL](https://learn.microsoft.com/en-us/windows/wsl/install))
- Terminal access (Terminal.app on Mac, WSL on Windows)
- A stable internet connection
- One of: **Claude Pro** ($20/mo), **Claude Max** ($100–200/mo), or an Anthropic API key from [console.anthropic.com](https://console.anthropic.com)

### Install

Open your terminal and paste:

```bash
curl -fsSL https://claude.ai/install.sh | bash
```

Or download directly from [claude.com/code](https://claude.com/code) if you'd rather not pipe to bash.

### Verify

```bash
claude --version
```

You should see a version number printed.

### Sign in (Pro / Max users)

```bash
claude
```

The first time you run `claude`, a browser window opens. Sign in with your Anthropic account, then return to the terminal. Type `/exit` to close.

### Set your API key (API users only)

Skip this if you signed in with Pro / Max. If you're using an API key:

```bash
echo 'export ANTHROPIC_API_KEY="your-api-key-here"' >> ~/.zshrc
source ~/.zshrc
```

(Use `~/.bashrc` instead of `~/.zshrc` if you're on bash.)

---

## Step 2: Install Cursor (~3 min)

We recommend Cursor for working with OS-Intelligence. It's a fork of VS Code with AI built in and shows you your files while Claude works on them.

**Already have VS Code, Sublime, Obsidian, or another editor you prefer?** Skip to Step 4. The split-screen workflow works the same in any editor.

### Download

Visit [cursor.com](https://cursor.com) and download for your operating system.

- **Mac:** Open the .dmg and drag Cursor to Applications
- **Windows:** Run the installer
- **Linux:** Follow the install instructions on the download page

### Why we recommend Cursor

- Markdown preview (your project is mostly markdown)
- File tree navigation in the sidebar
- Shows hidden folders like `.claude/` so you can see Claude's skills
- Built-in AI chat (`Cmd+L`) and inline edits (`Cmd+K`) if you want them
- Works alongside Claude Code in your terminal

---

## Step 3: Set up Cursor (~2 min)

### First launch

Open Cursor. You'll see a welcome screen.

- Sign in if it asks. The free tier is fine; you don't need Cursor Pro.
- Pick a theme.
- Skip the AI account setup. You'll be using Claude Code, not Cursor's AI.

### Show hidden files

OS-Intelligence puts skills in a folder called `.claude/`. Cursor hides folders that start with a dot by default.

- Open Cursor settings (`Cmd+,` on Mac, `Ctrl+,` on Windows / Linux)
- Search for `files.exclude`
- Find `**/.claude` if it's listed and remove it, or just remove `**/.*` if that's the pattern hiding it

Or quicker: in the file tree, press `Cmd+Shift+.` (Mac) or `Ctrl+H` (Windows / Linux) to toggle hidden files.

---

## Step 4: Clone the repo (~2 min)

In your terminal:

```bash
cd ~/Code
git clone https://github.com/simonconway1979/os-intelligence.git
cd os-intelligence
```

(If you don't have a `~/Code` folder yet, run `mkdir ~/Code` first.)

### Keep your context private: clone, don't fork

OS-Intelligence is the framework. Your meetings, documents, notes, and people files are the context, and that context is private. **Don't fork this repo on GitHub.** Forks default to public, so anything you add gets indexed.

Recommended: create your own private repo and repoint the remote so commits go there. Keep upstream tracked separately so you can pull updates.

```bash
git remote rename origin upstream
git remote add origin git@github.com:YOUR-USERNAME/YOUR-PRIVATE-REPO.git
git push -u origin main

# Later, to pull updates from OS-Intelligence:
git fetch upstream
git merge upstream/main
```

### Open it in your editor

If you're using Cursor:

```bash
cursor .
```

Or in Cursor: **File → Open Folder → ~/Code/os-intelligence**.

For other editors, open the `~/Code/os-intelligence` folder however you normally would.

You should see folders like `companies/`, `people/`, `projects/`, `sub-agents/` in the sidebar.

---

## Step 5: Set up your workspace (~2 min)

The split-screen workflow:

```
+-----------------------------+-----------------------------+
|                             |                             |
|     Terminal                |     Cursor                  |
|     (Claude Code)           |     (your files)            |
|                             |                             |
|  > claude                   |   companies/                |
|  Welcome!                   |   context-library/          |
|                             |   projects/                 |
|  You: /os-welcome           |   .claude/                  |
|                             |   CLAUDE.md                 |
|  Claude: Let's get          |                             |
|  you set up...              |   [file you've opened]      |
|                             |                             |
+-----------------------------+-----------------------------+
```

Resize and position the windows side by side. Terminal on the left. Cursor on the right.

You'll chat with Claude on the left and watch files appear on the right as Claude creates them.

---

## Step 6: First run (~3 min)

You've finished setup. Time to start.

In your terminal, from inside the `os-intelligence` folder:

```bash
claude
```

When Claude starts, type:

```
/os-welcome
```

This kicks off the guided onboarding. It walks you through creating your first project, dropping in documents and transcripts, and getting a synthesised briefing of where the project stands.

(This is the same `/os-welcome` invitation you saw in the README. Both routes lead here.)

---

## Common issues

### `claude: command not found`

- Restart your terminal (the install adds Claude to your PATH and a new shell picks it up)
- Check it's there: `which claude`
- If still missing, re-run the install command from Step 1

### Sign-in loop or API key error

- Pro / Max users: run `claude` and sign in again. Use `/logout` first if it gets stuck.
- API users: check `echo $ANTHROPIC_API_KEY` returns your key. If empty, redo the export step.

### Cursor doesn't show the `.claude/` folder

- Press `Cmd+Shift+.` (Mac) or `Ctrl+H` (Windows / Linux) to toggle hidden files
- Or check `files.exclude` in settings
- You can still use the system without seeing `.claude/`. It just helps to know it's there.

### Permission prompts in Claude Code

- Claude asks before running shell commands or editing files
- Click **"Yes, and don't ask again"** for routine ones (file reads, listing folders)
- Read carefully before approving anything that writes outside the project folder

### Windows specifics

- Use WSL (Windows Subsystem for Linux), not native Windows. Claude Code runs cleanest on Unix.
- If you haven't already, install WSL first: `wsl --install` in PowerShell as admin, then run all the steps above inside the WSL terminal.

---

## Optional shortcuts

### Quick-launch alias

Add this to your `~/.zshrc` (or `~/.bashrc`):

```bash
alias os="cd ~/Code/os-intelligence && claude"
```

Reload your shell:

```bash
source ~/.zshrc
```

Now you can type `os` from anywhere to jump in.

---

## What's next

You're set up. Run `/os-welcome` inside Claude Code to start. The skill guides you through:

1. Creating your first project
2. Dropping in your documents (PRDs, transcripts, notes)
3. Getting a synthesised briefing
4. Loading context for any future session with `/os-start`

The README at the repo root has the intro if you want a sense of what the system does first.
