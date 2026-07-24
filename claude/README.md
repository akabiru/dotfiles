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
| `hooks/claude-notify.sh` | `Notification` hook — contextual, per-session macOS notifications |

## Custom Commands

Slash commands in `commands/` toggle the pair-programming workflow defined in `CLAUDE.md` (the **Collaboration Model**). By default you drive and Claude navigates; these switch who holds the keyboard.

| Command | Action |
|---------|--------|
| `/drive` | Hand the keyboard to Claude (Mode 2) — it plans first, then implements one reviewable chunk at a time, pausing at each checkpoint for review |
| `/navigate` | Take the keyboard back (Mode 1) — you write the code; Claude reviews your diffs, suggests alternatives, and researches or drafts tests on request |

Verbal triggers work too ("you drive" / "I'll drive"). Any `.md` file added to `commands/` becomes a slash command automatically.

## Notifications

`settings.json` wires a `Notification` hook to `hooks/claude-notify.sh`, which fires `terminal-notifier` whenever Claude is idle waiting for input or needs permission. When several Claude instances run across multiple tmux sessions, a generic "needs your input" alert leaves you guessing which one is asking; the script fixes that.

The hook process inherits `$TMUX_PANE` from the Claude process's pane, so the script resolves the originating session, window, and project:

- **Title** — `Claude · <session>` (e.g. `Claude · opf`), so the session is the first thing you see.
- **Subtitle** — the project directory plus window index (e.g. `openproject  ·  win 2`). tmux auto-names windows after the running command, which is noise, so only the index is used.
- **Grouped per pane** (`-group claude-notify-$TMUX_PANE`) — a repeat alert from the same instance replaces the previous one instead of stacking, and separate instances keep separate slots.
- **Click to jump** — clicking brings Ghostty forward and runs `tmux select-window`/`select-pane`/`switch-client` to focus the exact pane that asked.

Outside tmux it degrades gracefully to a plain `Claude Code` notification that focuses Ghostty on click. Requires `terminal-notifier` and `jq` on `PATH`.

> `settings.json` itself is machine-local (it holds survey/stats state) and is not stowed; only the script is version-controlled here. Wire it in your local `~/.claude/settings.json` with:
>
> ```json
> "hooks": { "Notification": [ { "hooks": [
>   { "type": "command", "command": "$HOME/.claude/hooks/claude-notify.sh" } ] } ] }
> ```
