# claude

**Config:** `claude/.claude/`

Global settings, custom agents, and slash commands for [Claude Code](https://docs.anthropic.com/en/docs/claude-code).

| File | Purpose |
|------|---------|
| `CLAUDE.md` | Global instructions applied to all projects |
| `agents/rails-code-reviewer.md` | Rails code review (ActiveRecord, PostgreSQL, service objects) |
| `agents/rails-staff-engineer.md` | Staff-level Rails implementation and refactoring |
| `agents/rails-security-auditor.md` | Rails security audit (injection, authz, uploads, deserialization) |
| `agents/frontend-architect.md` | Frontend architecture guidance (Stimulus, Angular, ViewComponents, Turbo) |
| `agents/local-first-architect.md` | Local-first/CRDT architecture (Yjs, BlockNote, Hocuspocus, ProseMirror) |
| `agents/primer-code-reviewer.md` | Primer design system review (ViewComponents, Forms DSL, a11y) |
| `agents/stimulus-code-reviewer.md` | Stimulus controller and Hotwire review |
| `agents/release-stewardship-cto.md` | Release readiness, deployment compatibility, ownership mapping |
| `commands/drive.md` | `/drive` slash command - hand the keyboard to Claude (pairing Mode 2) |
| `commands/navigate.md` | `/navigate` slash command - Claude drops to navigator (pairing Mode 1) |
| `hooks/claude-notify.sh` | `Notification` hook - contextual, per-session macOS notifications |
| `statusline-command.sh` | Status line: directory, git branch, model, context usage |

> `settings.json` is deliberately **not** stowed; it holds machine-local survey and stats state. See [Multiple accounts](#multiple-accounts) for the per-account settings it needs.

## Custom Commands

Slash commands in `commands/` toggle the pair-programming workflow defined in `CLAUDE.md` (the **Collaboration Model**). By default you drive and Claude navigates; these switch who holds the keyboard.

| Command | Action |
|---------|--------|
| `/drive` | Hand the keyboard to Claude (Mode 2) - it plans first, then implements one reviewable chunk at a time, pausing at each checkpoint for review |
| `/navigate` | Take the keyboard back (Mode 1) - you write the code; Claude reviews your diffs, suggests alternatives, and researches or drafts tests on request |

Verbal triggers work too ("you drive" / "I'll drive"). Any `.md` file added to `commands/` becomes a slash command automatically.

## Notifications

`settings.json` wires a `Notification` hook to `hooks/claude-notify.sh`, which fires `terminal-notifier` whenever Claude is idle waiting for input or needs permission. When several Claude instances run across multiple tmux sessions, a generic "needs your input" alert leaves you guessing which one is asking; the script fixes that.

The hook process inherits `$TMUX_PANE` from the Claude process's pane, so the script resolves the originating session, window, and project:

- **Title** - `Claude · <session>` (e.g. `Claude · api`), so the session is the first thing you see.
- **Subtitle** - the project directory plus window index (e.g. `checkout-service  ·  win 2`). tmux auto-names windows after the running command, which is noise, so only the index is used.
- **Grouped per pane** (`-group claude-notify-$TMUX_PANE`) - a repeat alert from the same instance replaces the previous one instead of stacking, and separate instances keep separate slots.
- **Click to jump** - clicking brings Ghostty forward and runs `tmux select-window`/`select-pane`/`switch-client` to focus the exact pane that asked.

Outside tmux it degrades gracefully to a plain `Claude Code` notification that focuses Ghostty on click. Requires `terminal-notifier` and `jq` on `PATH`.

> `settings.json` itself is machine-local (it holds survey/stats state) and is not stowed; only the script is version-controlled here. Wire it in your local `~/.claude/settings.json` with:
>
> ```json
> "hooks": { "Notification": [ { "hooks": [
>   { "type": "command", "command": "$HOME/.claude/hooks/claude-notify.sh" } ] } ] }
> ```

## Multiple accounts

`CLAUDE_CONFIG_DIR` relocates Claude Code's entire state root, not just its credentials. Point it at a second directory and you get a fully separate identity: its own login, `settings.json`, session history, MCP config, and plugins. On macOS the Keychain namespaces credentials per config dir, so each account's token stays in the Keychain rather than falling back to a file.

That makes it the mechanism for keeping a work account and a personal account apart:

| Config dir | Account | Selected for |
|------------|---------|--------------|
| `~/.claude` | personal | everything not matched below (the default) |
| `~/.claude-<org>-work` | work | that organisation's project root |

Routing is automatic. `fish/functions/claude.fish` wraps `claude` and sets `CLAUDE_CONFIG_DIR` from the current directory, reading its path-to-account mapping from the gitignored `conf.d/secrets.fish` so the layout stays private. An explicit `CLAUDE_CONFIG_DIR` always wins, which doubles as a manual override.

> **Caveat.** The wrapper is a fish function, so it only applies in interactive fish shells. Anything invoking `claude` from a script, a tmux keybinding, or another tool falls through to the default dir. Export `CLAUDE_CONFIG_DIR` in that context if the distinction matters.

### Setting up a second account

Stow this package into the new dir, skipping `agents/` (see below), then log in:

```bash
mkdir -p ~/.claude-<org>-work
stow -d ~/dotfiles/claude -t ~/.claude-<org>-work --ignore='agents' .claude
CLAUDE_CONFIG_DIR=$HOME/.claude-<org>-work claude   # then /login
```

`settings.json` is machine-local, so write one per config dir. Copy the default dir's and repoint the two path-bearing keys at the new dir:

```json
"hooks": { "Notification": [ { "hooks": [
  { "type": "command", "command": "$HOME/.claude-<org>-work/hooks/claude-notify.sh" } ] } ] },
"statusLine": { "type": "command",
  "command": "bash $HOME/.claude-<org>-work/statusline-command.sh" }
```

Plugins are per config dir, so the new account re-downloads them on first run.

### Agents are two-tier

The agents in this repo are the general-purpose versions. Work accounts keep their own copies, enriched with employer-specific domain detail (product editions, in-house APIs and conventions, internal service names), as real files in `~/.claude-<org>-work/agents/`. Those stay machine-local and unversioned on purpose: this repo is public.

That is why the stow command above passes `--ignore='agents'`. Without it, stow would link the general-purpose agents over the top and shadow the work versions.

The two sets share a name, so `/agents` resolves to whichever tier the active account provides. Improving one does not improve the other; they drift unless re-generalized deliberately.
