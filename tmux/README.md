# tmux

**Config:** `tmux/.tmux.conf`, `tmux/.config/tmux/agents.conf`

Terminal multiplexer with Catppuccin theme and vim-style navigation.

## Keybindings

**Prefix:** `Ctrl + Space` (remapped from default `Ctrl + b`)

| Key | Action |
|-----|--------|
| `prefix + r` | Reload config |
| `prefix + \|` | Vertical split (current directory) |
| `prefix + -` | Horizontal split (current directory) |
| `prefix + c` | New window (current directory) |
| `prefix + h/j/k/l` | Vim-style pane navigation |
| `Ctrl + h/j/k/l` | Cross-pane navigation (via vim-tmux-navigator) |
| `prefix + A` | Jump to the next agent that needs you (blocked first, then done) |
| `prefix + a` | Menu of every agent pane, across sessions |
| click an agent | Jump to that pane |
| click a session name | Switch to that session |

## Settings

| Setting | Value |
|---------|-------|
| Default shell | Fish |
| Mouse | Enabled |
| Scrollback | 50,000 lines |
| Escape time | 0ms (no lag for Vim mode switching) |
| Focus events | Enabled (for Neovim autoread) |
| Base index | 1 (windows and panes) |
| Renumber windows | On close |
| Status bar | Top |
| Clipboard | OSC 52 (system clipboard) |

## Display

- Active pane border: blue, bold
- Inactive pane border: catppuccin `overlay2` (adapts to latte/mocha)
- Pane border lines: heavy (thicker Unicode box-drawing glyphs)
- Catppuccin status modules: application, directory, session

## Agent traffic lights

`agents.conf` renders one flat strip, centred in the status line, listing
every AI agent pane in every session, plus a plain dot on each window tab that
holds one. The strip has pointed powerline ends and a darker surface than the rounded
window tabs so the two never read as the same row of chips. It opens with a
robot, then one group per session: the session name (mauve for the attached
session), and per agent a dot in its state colour and the agent name cut to
ten characters. Groups are split by a thin bar. The pane title is left to the
window tab on purpose, so no text appears twice on the line.

| Colour | State |
|--------|-------|
| green | working |
| red | blocked: permission prompt or question waiting for you |
| yellow | done, your turn |
| grey | fresh session, nothing asked yet |

State comes from the `@agent_state` pane option written by
[`tmux-agents`](../bin/README.md#tmux-agents); the status line is pure tmux
format apart from the `tmux-agents sync` reconcile that runs every 5s
(`status-interval`). The whole segment disappears when no agent is running.
Agents and session names are clickable through `range=user` status ranges on `MouseDown1Status`;
clicks elsewhere on the status line keep tmux's default window select.

## Plugins

| Plugin | Purpose |
|--------|---------|
| [tpm](https://github.com/tmux-plugins/tpm) | Plugin manager |
| [catppuccin/tmux](https://github.com/catppuccin/tmux) (v2.1.3) | Catppuccin theme |
| [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator) | Seamless Neovim/tmux navigation |

The catppuccin flavor (mocha/latte) is set at startup from `~/.theme-mode`; see the [Theme System](../README.md#theme-system).
