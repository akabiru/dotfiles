---
name: orchestrate
description: Subagent-driven implementation with per-chunk reviews. Use when the user asks to orchestrate, delegate implementation to subagents, "keep the main agent free", or wants implementation subagents with review agents after every chunk. Main agent acts as supervisor only.
---

# Orchestrate: Supervisor + Implementation Subagents + Per-Chunk Review

## Role split

The main agent is the **supervisor**. It makes NO direct implementation edits (plan files, memory, and todo bookkeeping excepted). It:

1. Holds the approved plan and splits it into **chunks** (a chunk = one reviewable logical unit: a migration + its spec, one shim removal + its spec updates, one feature).
2. Dispatches an **implementation subagent** per chunk with a self-contained prompt.
3. Dispatches a **review subagent** on each chunk's diff as soon as it lands, before the next dependent chunk starts.
4. Routes review findings back to an implementation subagent (never fixes inline).
5. Delegates test runs and keeps a short running status for the user.

## Choosing agents

- Implementation: `rails-staff-engineer` for Ruby/Rails/migrations, `frontend-architect` or `general-purpose` for frontend, `caveman:cavecrew-builder` only for bounded 1-2 file mechanical edits.
- Review: matching profile reviewer (`rails-code-reviewer`, `stimulus-code-reviewer`, `primer-code-reviewer`); `caveman:cavecrew-reviewer` for quick diff passes.
- Test runs: delegate to the implementing agent or a follow-up agent; in OpenProject use the backend-test container (works from worktrees too).

## Scheduling rules

- Chunks touching **disjoint files** may be implemented in parallel (single message, multiple Agent calls). Reviews still run per chunk.
- Chunks sharing files run sequentially: implement -> review -> fix -> next.
- Milestone review: before each commit/PR, run one reviewer over the full diff (not per-chunk deltas).

## Prompt contract for implementation subagents

Every dispatch prompt must include:

- Repo path, branch expectations, and "do NOT commit / do NOT create branches" unless committing is the task.
- All verified design facts the agent needs (file paths with line hints, storage formats, settled design decisions with their rationale, marked "don't improve these away").
- Explicit non-goals ("do NOT touch X - parallel agent owns it").
- TDD instruction where feasible (red first, then green) and exact test commands with fallbacks.
- Style constraints (near-zero comments, rubocop scope limited to touched files).
- Requested report format: files changed, test output red->green, deviations + why.

## Prompt contract for review subagents

- Scope: exactly the chunk's files/diff (name them), severity-tagged findings, no scope creep.
- Ask for concrete failure scenarios, not style opinions; formatting nits only when they change meaning.
- Supervisor triages findings: real defects go back to an implementation subagent; rejected findings are noted with the reason.

## Failure handling

- Subagent errored or produced a wrong-shaped result: re-dispatch with the correction appended; don't silently patch it yourself.
- Two subagents conflict on a file: stop, reconcile in the supervisor by re-reading the file, dispatch one fix agent.
- Never fabricate a pending agent's result; wait for its notification.
