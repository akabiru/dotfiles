# claude

**Config:** `claude/.claude/`

Global settings, custom agents, and slash commands for [Claude Code](https://docs.anthropic.com/en/docs/claude-code).

| File | Purpose |
|------|---------|
| `CLAUDE.md` | Global instructions applied to all projects |
| `settings.json` | Model, plugins, environment, and preference settings |
| `agents/rails-code-reviewer.md` | Custom Rails code review agent |
| `agents/frontend-architect.md` | Frontend architecture guidance (Stimulus, Angular, ViewComponents, Turbo) |
| `agents/local-first-architect.md` | Local-first/CRDT architecture (Yjs, BlockNote, Hocuspocus, ProseMirror) |
| `commands/drive.md` | `/drive` slash command — hand the keyboard to Claude (pairing Mode 2) |
| `commands/navigate.md` | `/navigate` slash command — Claude drops to navigator (pairing Mode 1) |

## Custom Commands

Slash commands in `commands/` toggle the pair-programming workflow defined in `CLAUDE.md` (the **Collaboration Model**). By default you drive and Claude navigates; these switch who holds the keyboard.

| Command | Action |
|---------|--------|
| `/drive` | Hand the keyboard to Claude (Mode 2) — it plans first, then implements one reviewable chunk at a time, pausing at each checkpoint for review |
| `/navigate` | Take the keyboard back (Mode 1) — you write the code; Claude reviews your diffs, suggests alternatives, and researches or drafts tests on request |

Verbal triggers work too ("you drive" / "I'll drive"). Any `.md` file added to `commands/` becomes a slash command automatically.

## Notifications

`settings.json` wires a `Notification` hook that fires `terminal-notifier` whenever Claude is idle waiting for input or needs permission — works through tmux, clicking focuses Ghostty. Requires `terminal-notifier` on `PATH`.
