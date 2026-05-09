# Welcome to OS-Intelligence

Hi, I'm Simon. I built this because the most valuable context in PM work (meetings, docs, chats, my own thinking) was scattered everywhere and never compounded. New project, blank page, every time. So I built the system I wished I had.

You're about to spend ~45 minutes with it, plus another ~10 minutes of processing time between steps.

## What we'll do

Walk you through your first small project end to end. We'll set it up, drop in a bit of real context (a transcript or two, or a few documents, whatever you have to hand), and run the synthesis. You'll see the loop work on something real, not a demo.

## By the end

- You'll have a project running on your own context, ready to keep using
- You'll understand the model: how OS-Intelligence thinks about projects, people, and the intelligence around them
- You'll have a sense of what to point it at next

## What you need

Not much. A laptop and Claude Code (you've already got it). If you have a recent meeting transcript or doc to hand, that's the shortest path to the "oh, that's useful" moment. If you can't find anything quickly, a few typed notes about a current piece of work will do. They go through the same loop.

## A note on state

This is v0.1. It works on real PM work (it's how I run mine), but you'll hit rough edges. When you do, tell me. I'm building this to be useful in real conditions, not to be impressive in a demo, and I read every piece of feedback.

Open source. Files stay on your machine. The only network call is the one Claude Code already makes to Anthropic.

Ready to start?

---

# Getting started

Type `/os-start` in Claude Code. This is how every session begins. It loads the context you've already captured so Claude builds on it instead of starting from a blank page.

You'll see a list of projects. Right now there's just one: my Acme Corp example. I built it as a fully-loaded reference so you can see what OS-Intelligence looks like once 30+ documents and transcripts have been synthesised. Ignore it for now.

To make your own, pick **Add new project** (the last numbered option). Give it a short, real name. If nothing comes to mind, look at the starters below first, pick one that fits, and use that as your project name.

---

# Pick a small project that's meaningful to you

You've got about 45 minutes. Pick something small enough to finish in that window. The point is to feel the loop work on your own data, not to build the perfect first project.

Eight starters. Pick the one you can find material for fastest:

**1. Catch what's slipping across your sprints**
Drop in transcripts from your last 3 sprint reviews. Get a synthesis showing what's shipped, what's blocked, and what's drifting between teams. ~15 min.

**2. Find the patterns across your research**
Drop in transcripts from 3 research calls. Get cross-cut themes, tensions, and patterns you'd otherwise miss reading them one at a time. ~15 min.

**3. Brief a new joiner in 10 minutes**
Drop in 5 key documents about a project (PRD, strategy, last quarterly update, customer escalation, whatever shaped it). Get a current-state a new joiner can read in 10 minutes and come up to speed. ~20 min.

**4. Walk into your next 1:1 prepared**
Drop in past meeting transcripts and supporting docs for someone you're meeting soon. Get a stakeholder brief: what they care about, what's open, what to ask. ~10 min.

**5. Find the next move on a stalled project**
Drop in 5-10 docs from a project that's been sitting. Get a current-state showing where things stood, what's open, and what to do next. ~20 min.

**6. Coach with the full picture**
For someone you coach or mentor, drop in past session transcripts, any feedback or 360 docs, and notes that frame what they're working on. Get a standing brief: the patterns you've spotted, what's progressing, what's stuck, and where to push next session. ~15 min.

**7. Sharpen your strategy**
Drop in your strategy docs, recent strategy meeting transcripts, and your own notes on the bets you're making. Get a synthesis showing the tensions, the assumptions you're depending on, and the open questions you haven't answered. ~20 min.

**8. Pressure-test your next presentation**
Drop in your slides (as PDF or text), your speaker notes, and a few lines on the audience and what you want them to take away. If you've recorded a runthrough, transcribe it and drop the transcript too (Claude Code reads text, not raw video). Get a critique on the story arc, the slide-by-slide logic, and what your audience is likely to push back on. ~20 min.

**Tip:** Start small. 3-5 files is enough to seed a project. You can always add more later.

If you can't find anything in five minutes, don't push it. Open a notes file and type 200 words about a current piece of work. That goes through the same loop and gets you to the synthesis just as well.

Which one will you pick? Reply with the number.

---

# Start your project

`/os-new-project` sets up a new project. (You can also pick it from the `/os-start` menu.)

I'll start the flow for you now. It'll ask you a handful of questions. Below: what each one is for, and a suggestion if you picked "Walk into your next 1:1 prepared". Adapt the suggestions for whichever starter you chose.

**Give a project name**
This becomes the folder name and what you'll see in `/os-start` every session.
Tip: Something like "Prep for 1:1 with Jane".

**One sentence: what is this project?**
A working description so future-you knows what's in this folder.
Tip: Something like "Preparation for my discussion with Jane about Q1 OKRs for my project."

**What's the primary goal? What does success look like?**
Frames the synthesis. Claude uses this to interpret everything you bring.
Tip: Think outcomes. "I want alignment on OKRs at the end of the call." Or "I want her support on a new initiative." Specific outcomes give Claude something concrete to work toward.

**What type of project is this? Standalone or portfolio?**
Standalone is one project with one goal. Portfolio is a managed collection of similar items (e.g. a set of job opportunities, an ideas bank, a reading list). Folder shape differs.
Tip: For 1:1 prep, pick standalone. You can ask Claude to convert later if you ever want to.

**Is this a personal or professional project?**
Routes which framework applies and tags the project accordingly.
Tip: Professional.

**Is this project run for a business or organisation?**
Claude shows a list of companies you've added before, plus options to "Add another" or "None / not applicable".
Tip: Pick your company from the list, or "Add another" if it's not there yet. For 1:1 prep with a colleague, this is the company you both work for.

**Who's the 1:1 with? First name is fine.**
Sets up the person record. If they're already in your contacts, Claude links to them. If not, Claude creates a new record and asks for their company.
Tip: Just first name. "Jane".

**What's the company name?**
Claude shows a list of companies you've added before, plus a default inferred from your email domain (e.g. "Condaal" from simon.conway@condaal.com), plus an "Add new" option.
Tip: For a new company, pick "Add new". Otherwise pick from the list or accept the inferred default.

The project folder is now created and the active session is switched to it. The person and company you added are in your global rolodex now. Every future project builds on them, not from scratch.

---

# Add context

Now we bring in the materials Claude will work with. One type at a time. Run each command, then drag your files into the chat. Skip any type you don't have material for.

**Run `/ctx-transcript`**
For meeting transcripts: 1:1s, customer calls, interviews, kickoffs.
Tip: For 1:1 prep, drop in your last 2-3 meetings with Jane.

**Run `/ctx-doc`**
For documents: PRDs, briefs, strategy docs, status updates, anything written.
Tip: For 1:1 prep, drop the OKRs you're discussing, the project's PRD, or any relevant status notes.

**Run `/ctx-note`**
For notes and observations: your own thoughts, voice memos transcribed, things you don't want to lose.
Tip: For 1:1 prep, capture what you actually want from this conversation.

**Run `/ctx-chat`**
For chat threads: Slack channels, Teams DMs, WhatsApp groups, email chains. Export the thread to text first, then drag it in.
Tip: For 1:1 prep, a recent Slack DM thread with Jane works well if you have one.

**Tip:** Start small. A few highly relevant files beat many lower-relevance ones. 3-5 is plenty to seed a project, and you can always add more later.

After each upload, you'll see this menu:

**Would you like to add more context?**

1. /ctx-transcript - Add meeting transcripts
2. /ctx-doc - Add documents
3. /ctx-note - Add a note or thought
4. /ctx-chat - Add a chat (email chain, Slack channel, WhatsApp, etc.)
5. No more to add

Pick another command to keep going. When you've added everything, pick 5 to move on.

---

# Synthesise

`/ctx-synthesise` is where the loop pays off. It reads every file you've added (meetings, docs, notes, chats) and asks one question of all of it together: what does this mean for your goal?

The goal you wrote at project setup ("I want alignment on OKRs", "I want her support for a new initiative", whatever it was) becomes the lens. The synthesis isn't a summary. It's a read on what's emerging, what contradicts, what's missing, and what to do about it. All framed against the outcome you said you wanted.

The result writes to `current-state.md`, with claims linked back to their source files. From here on, every session starts with this synthesis loaded.

A note: this is the one step worth running on Opus. Cross-cutting analysis is where reasoning quality matters most. The other `/ctx-` commands run fine on faster models.

Run `/ctx-synthesise`.

---

# Session memory

This is where it compounds. With your context in and the synthesis run, you can now work with Claude on the actual problem. Ask questions, pressure-test, find the next move. When you're done, `/os-save` captures what you've learned. Next time you `/os-start`, you pick up exactly where you left off.

Good questions to start with:

- What's the single most important thing to focus on, given my goal?
- What's missing from my context that would change your read?
- What would you suggest I do next?

This is the thinking partner. The best context isn't what you build upfront. It's what you build with Claude over time. Every session adds something: a transcript you just had, a doc that landed, a thought worth keeping. After three weeks, your context will be doing real lifting. At six weeks, you won't know how you worked without it.

---

# Save the session

Run `/os-save`.

This captures what we just worked through. Decisions made, questions raised, what's open. All of it becomes memory the next session loads from. Without this step, the conversation evaporates when you quit Claude.

---

# Quit and come back

That's session one done.

Now quit Claude Code.

Tomorrow morning, next week, whenever your next working session starts: run `/os-start` and pick this project. The briefing you'll see is the synthesis you just built. From there you keep working.

I'll meet you there.

---

> The two sections below are not part of session one. They render on the user's next `/os-start` when the project has the `Welcome: pending` tag in `projects.md`. After they render, `/os-start` clears the tag.

---

# Welcome back

You ran `/os-start`, picked your project, and you're back exactly where you left off. That's the loop.

In your first session you:

- Set up a project with a stated goal
- Brought in your own context across documents, transcripts, and notes
- Ran a goal-aware synthesis that cross-cut everything
- Captured the session as memory

You'll do this every time. The hard part is over.

**The biggest win:** I no longer have to context switch. OS-Intelligence handles it. I used to lose half a morning re-loading state, and watch things slip through the cracks across 8-12 projects in flight. Now `/os-start` does the load for me, and nothing slips through anymore. I drop into the meeting ready. If you're a PM, you'll feel this most.

---

# One last thing

If this clicked, I'd like to swap 20 minutes with you.

You tell me what worked, what broke, and what you wish was there. In return, I help you scope your next OS-Intelligence project: what to bring, how to structure it, what to skip.

Complimentary, no strings. Book a slot here: https://calendly.com/simonconway/os-intelligence
