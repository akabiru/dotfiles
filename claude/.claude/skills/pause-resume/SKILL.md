---
name: pause-resume
description: Pause an in-flight orchestration (stop agents, snapshot state) and schedule a one-shot cron that resumes it at a given time. Use when the user says "pause", "I'm at N% usage", "resume at <time>", "pick this up later", or wants running subagents halted without losing their work.
---

# Pause and resume via cron

`/pause-resume [time]`. With no time, the resume moment comes from the plan-usage snapshot (below); a time given (`/pause-resume 5:31 PM`) overrides it.

Token budget is the reason this exists, so the pause itself must be cheap: no reviews, no summaries beyond the status file, no new agents.

## Pick the resume time (no time given)

Run the helper first; it reads `rate-limits.json` in the current Claude profile directory (`$CLAUDE_CONFIG_DIR`, default `~/.claude`), which the status line writes on every refresh from Claude Code's `rate_limits` stdin JSON (5-hour, 7-day and spend windows with `used_percentage` and `resets_at`):

```bash
bash <skill-base-dir>/usage.sh        # threshold 85% by default
bash <skill-base-dir>/usage.sh 90     # custom threshold
```

Output is JSON with `windows[]`, `can_resume_now`, `resume_at` (local) and `resume_cron` (a ready 5-field one-shot expression: the latest reset among windows at or above the threshold, plus two minutes). Rules:

- `can_resume_now: false`: schedule with `resume_cron` and tell the user which window is blocking and its reset time.
- `can_resume_now: true`: no window is over the threshold; say so and ask whether they still want to pause and until when (their reason may be something other than usage).
- Exit 2 (no snapshot, or older than 15 minutes): the status line has not rendered a plan window this session (API-key sessions never get one). Fall back to asking for a time once.

The snapshot exists only because the status line script (`statusline-command.sh` in the Claude profile directory) writes it; if that script is replaced, port the `rate_limits` block or the helper goes blind.

## Pause

1. **Snapshot state** into the orchestration status file (`tmp/agents/<feature>.md`, or wherever the routing table lives). One block, dated, containing per chunk: agent id, worktree, branch + head SHA, test-db suffix, what is committed vs on disk, PR numbers and bases, the exact next step. Anything the resume prompt will need must be in this file, not in conversation memory.
2. **Stop every running subagent** with `TaskStop <agent id>` (implementers and reviewers). Their transcripts survive; a later `SendMessage` to the same id resumes them mid-task (see memory `resume-agent-after-rate-limit`). Do not spawn replacements.
3. **Kill stray processes the agents left behind**: `pgrep -f bin/rspec` and kill; leave dev servers running unless the user says otherwise (they cost nothing idle and the resume may probe them).
4. Do not commit, push, or amend anything on the agents' behalf. Uncommitted edits stay in their worktrees.

## Schedule the resume

`CronCreate` with `recurring: false`, cron pinned to the requested minute/hour/day/month (local time). The prompt must be self-contained; the session that fires it has the conversation, but the prompt is what steers it. Template:

```
Resume <feature> orchestration. Status file: <path>. Plan: <path>.
State at pause: <one line per chunk: branch@sha, PR#, base, agent id, suffix, committed?>.
Steps: (1) inspect each paused worktree (`/usr/bin/git status --short`, `git log -1`);
(2) SendMessage each stopped agent id with what to continue (rebase target, spec command,
commit/push/PR instructions from its original brief); (3) on hand-back run the review gate
per chunk; (4) <stack/merge step, e.g. gh stack link ...>; (5) cleanup (servers, temp grants)
and report to <user>.
```

Tell the user: the job is **session-only** (dies if this Claude session exits) and fires only while the REPL is idle. If they may close the session, offer the `/schedule` skill (cloud routine) instead.

## Resume (when the cron fires)

1. Read the status file first; trust it over memory.
2. For each stopped agent: `SendMessage` its id with the continuation. Never respawn while the id still answers.
3. Re-run the review gate on any chunk that landed after the pause; then continue the plan's remaining steps.
4. Log the resume in the status file.

## Gotchas

- `TaskStop` kills the agent, not the shell commands it started: check `ps` for `rspec`, `rails server`, `sleep`/`until` pollers.
- Subagents share the session scratchpad; a resumed agent may find another's drafts under a generic name (memory `parallel-agents-share-scratchpad`).
- A worktree left mid-rebase blocks the resumed agent; the status file should say if a rebase was in progress.
