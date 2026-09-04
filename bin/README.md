# bin

Personal scripts on `PATH`, stowed into `~/.local/bin`.

```sh
stow --target="$HOME" bin
```

## work

Opens a tmux workspace for a project: editor and shell stacked on the left, two
AI agents stacked on the right. Creates the session on first call and attaches
to it on every call after, so it doubles as the way back in. Run it with no args
(or `-h`/`--help`) for usage.

```sh
work .                        # session named after the directory
work ~/src/app -n review      # explicit session name
work . -d                     # build it, stay where you are
work . -k                     # kill the session
```

Pane commands and sizes come from the environment: `WORK_EDITOR` (default nvim
with the Snacks explorer open), `WORK_TOP` (`pi`), `WORK_BOTTOM` (`claude`),
`WORK_RIGHT_WIDTH` (31), `WORK_SHELL_HEIGHT` (12).

## tmux-agents

Traffic lights for AI agent panes in the tmux status bar. Each agent pane
carries a `@agent_state` pane option (`working`, `blocked`, `done`, `idle`);
this script is the only writer, `tmux/.config/tmux/agents.conf` renders it.

```sh
tmux-agents set working      # mark the calling pane (agents call this)
tmux-agents clear            # unmark it
tmux-agents hook             # Claude Code hook adapter, reads the hook JSON on stdin
tmux-agents sync             # reconcile marked panes against `claude agents --json`
tmux-agents list             # marked panes, blocked first
tmux-agents next             # jump to the next blocked pane, else the next done one
tmux-agents menu             # pick an agent pane from a tmux menu
tmux-agents jump %12         # jump to one pane, across sessions
```

Claude Code drives it through hooks (`tmux-agents hook` under SessionStart,
SessionEnd, UserPromptSubmit, PreToolUse, PostToolUse, PermissionRequest,
PermissionDenied, Notification, Stop; see [claude](../claude/README.md#notifications)),
pi through the extension in [pi](../pi/README.md). Hooks fire nothing when you
Esc out of a turn, so `sync` runs every `status-interval` and corrects any pane
whose light disagrees with what Claude reports (`busy`, `waiting`, `idle`); it
queries `~/.claude` and every `~/.claude-*` that has a `settings.json`, or the
colon-separated `TMUX_AGENTS_CONFIG_DIRS`. `TMUX_AGENTS_LOG` appends every hook
event and the state it mapped to, for debugging.

## op-test

Runs RSpec inside the OpenProject `backend-test` container against whatever git
worktree you're currently in. Derives the container path from your cwd, and
temporarily matches the worktree's `.ruby-version` to the main checkout so a
linked worktree on another branch still boots. Run it with no args (or
`-h`/`--help`) for usage.

```sh
op-test spec/models/user_spec.rb
op-test spec/requests/foo_spec.rb:42 spec/models/bar_spec.rb
op-test spec/foo_spec.rb -- --seed 1234    # args after -- go to rspec
```

Env overrides: `OP_CONTAINER_ROOT`, `OP_TEST_SERVICE`, `OP_RSPEC`.
