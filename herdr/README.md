# herdr

**Config:** `herdr/.config/herdr/config.toml`

Terminal multiplexer with Catppuccin theme and vim-style navigation. Installed
alongside [tmux](../tmux/README.md); both work, and you pick one by launching
`herdr` or `tmux`.

Herdr's hierarchy is **workspace → tab → pane**, where tmux has session → window → pane.

## Keybindings

**Prefix:** `Ctrl + Space` (remapped from default `Ctrl + b`, matching tmux)

| Key | Action |
|-----|--------|
| `prefix + r` | Reload config |
| `prefix + \|` or `prefix + v` | Split right |
| `prefix + -` | Split down |
| `prefix + c` | New tab |
| `prefix + h/j/k/l` | Vim-style pane navigation |
| `Ctrl + Alt + h/j/k/l` | Pane navigation without the prefix |
| `Ctrl + h/j/k/l` | Cross-pane navigation from inside Neovim (see below) |
| `prefix + ;` | Last pane (toggle) |
| `prefix + n` / `prefix + p` | Next / previous tab |
| `prefix + 1..9` | Switch tab |
| `prefix + (` / `prefix + )` | Previous / next workspace |
| `prefix + Shift + L` | Last workspace (toggle) |
| `prefix + Shift + 1..9` | Switch workspace |
| `prefix + Shift + R` | Resize mode (displaced by `prefix + r`) |

Everything not listed is a herdr default; run `herdr --default-config` for the
full set.

## Settings

| Setting | Value |
|---------|-------|
| Default shell | Fish |
| Mouse | Enabled |
| New pane directory | Follows the source pane |
| Scrollback | 10 MB per pane (herdr default, matches Ghostty) |
| Status bar | Top |
| Clipboard | Copy on select |
| Theme | Catppuccin, following host light/dark appearance |

## Neovim navigation

`Ctrl + h/j/k/l` crosses between Neovim splits and herdr panes, but the
mechanism is inverted from tmux.

tmux inspects a pane's foreground process (`is_vim`) and decides whether to
swallow the key or forward it to Neovim. Herdr has no such conditional, so the
decision is made on the Neovim side instead: `ctrl+hjkl` is deliberately left
**unbound** in `config.toml` so the keys reach Neovim, and
`nvim/.config/nvim/lua/config/herdr-nav.lua` hands off to `herdr pane focus`
only after a window move has failed, which means the cursor was already at the
edge of the Neovim layout.

The consequence: shell panes never see `Ctrl + h/j/k/l`. Use `Ctrl + Alt +
h/j/k/l` or the prefix there.

The same keymap serves tmux, where it delegates to
[vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator). The
branch is chosen at runtime from `$HERDR_PANE_ID`.

## Last workspace

`prefix + Shift + L` is tmux's `switch-client -l`. herdr has no `last_workspace`
action, so it goes through the small plugin in `last-workspace/`: a
`workspace.focused` event hook records the focus history, and the bound action
reads it back. Hooking the event rather than recording on keypress is what makes
the toggle correct when you switch by other means, such as the `prefix + w`
picker or `prefix + (` / `prefix + )`.

The plugin needs linking once per machine:

```bash
herdr plugin link ~/.config/herdr/last-workspace
```

State lives in `~/.local/state/herdr/plugins/dotfiles-lastworkspace`. If the
recorded workspace has since been closed, the key does nothing.

## Running tests

`<leader>tn/tf/ts/tl` (vim-test) open a runner pane below the editor and type
the command into its live shell, so history and scrollback survive repeated
runs. Under herdr this goes through
`nvim/.config/nvim/lua/config/herdr-test.lua`; under tmux it stays on vimux.

## Not carried over from tmux

| tmux setting | Status under herdr |
|---|---|
| `escape-time 0` | No knob; herdr does not add Escape latency |
| `focus-events on` | No knob; verify `FocusGained` autocmds (theme sync, gitsigns) still fire |
| `allow-passthrough on` | No knob |
| `base-index 1` | Tabs are already 1-indexed |
| `renumber-windows on` | No knob |
| `pane-border-lines heavy` | Not configurable |
| Catppuccin flavor pushed by `theme` | Herdr follows the host appearance itself via `auto_switch`; the fish `theme` function does not push to herdr |

## Caveat: `herdr config reset-keys`

That command rewrites `config.toml` in place, which replaces the stow symlink
with a real file and silently unlinks the package. If you run it, repair with
`stow -R herdr`.
