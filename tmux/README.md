# tmux

**Config:** `tmux/.tmux.conf`

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

## Plugins

| Plugin | Purpose |
|--------|---------|
| [tpm](https://github.com/tmux-plugins/tpm) | Plugin manager |
| [catppuccin/tmux](https://github.com/catppuccin/tmux) (v2.1.3) | Catppuccin theme |
| [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator) | Seamless Neovim/tmux navigation |

The catppuccin flavor (mocha/latte) is set at startup from `~/.theme-mode`; see the [Theme System](../README.md#theme-system).
