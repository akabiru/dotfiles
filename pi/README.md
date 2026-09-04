# pi

**Config:** `pi/.pi/agent/extensions/`

Extensions for the [pi coding agent](https://pi.dev). pi loads every `.ts`
file in `~/.pi/agent/extensions/` at startup (no build step); `/reload`
picks up edits.

| File | Purpose |
|------|---------|
| `extensions/tmux-agents.ts` | Reports pi's state to the tmux status bar through [`tmux-agents`](../bin/README.md#tmux-agents): grey on start, green while a turn runs, yellow when it is your turn, cleared on exit |

pi has no built-in permission prompt, so there is no red state; an extension
that gates tools itself would set `blocked` around its own confirm dialog.
