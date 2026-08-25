# Navigation & Motions Cheatsheet

Quick reference for moving around in Neovim (LazyVim) and across multiplexer panes.
Most of these are vanilla Vim — LazyVim-specific entries are flagged.

## Within the current line

| Key | Moves to |
|-----|----------|
| `0` | Very start of line (column 0, incl. indent) |
| `^` | First **non-blank** character |
| `$` | End of line |
| `g_` | Last **non-blank** character |
| `g0` / `g$` | Start / end of *screen* line (when wrapped) |

## By word

| Key | Moves to |
|-----|----------|
| `w` / `b` | Start of next / previous word |
| `e` / `ge` | End of next / previous word |
| `W` `B` `E` `gE` | Same, but **WORD** (whitespace-delimited, ignores punctuation) |

Lowercase breaks on punctuation (`foo.bar` = 3 words); uppercase treats `foo.bar` as one.

## Screen & file jumps

| Key | Moves to |
|-----|----------|
| `H` `M` `L` | Top / Middle / Bottom of screen |
| `gg` / `G` | First / last line of file |
| `{` / `}` | Previous / next blank-line paragraph |
| `s` | **flash.nvim** — type 2 chars, jump anywhere on screen by label *(LazyVim)* |

## Back & forward (the two history lists)

| Key | Does | Mnemonic |
|-----|------|----------|
| `Ctrl-O` | Jump **back** in the jumplist | "where was I looking" |
| `Ctrl-I` / `Tab` | Jump **forward** in the jumplist | (`Ctrl-I` *is* `Tab` in a terminal) |
| `g;` | Back to previous **change** location | "where was I typing" |
| `g,` | Forward through change locations | |
| `` `. `` | Jump to the position of the last change | |
| `:jumps` / `:changes` | Inspect either list | |

Jumps are recorded only for **big** moves (`gg`, `G`, `/`, `n`, `}`, `gd`, file opens) —
not `j`/`k`/`w`. The jumplist is a full stack; tmux's pane toggle (below) is not.

## Insert-mode delete chords

Portable equivalents of macOS `Cmd/Option+Backspace` — work in any terminal, over SSH:

| Key | Does |
|-----|------|
| `Ctrl-U` | Delete from cursor → start of line |
| `Ctrl-W` | Delete the word before cursor |
| `Ctrl-H` | Delete one char (plain backspace) |

In normal mode, compose instead: `d0` / `d^` / `db` / `dw`, or `D` (= `d$`), `C` (= `c$`).

## LazyVim "root dir" — why pickers sometimes scope to a child folder

LazyVim recomputes a **root per buffer** (not per repo) via `vim.g.root_spec`, default:

```lua
vim.g.root_spec = { "lsp", { ".git", "lua" }, "cwd" }
```

It takes the first that resolves. `"lsp"` wins first, and a language server often roots at
the **nearest** config marker (`package.json`, `tsconfig.json`, `go.mod`…) — so editing a
file in a subfolder narrows the root to that subfolder. Inspect with `:LazyRoot` or
`:lua LazyVim.root.info()`.

The fix-free workflow: **lowercase = "where I'm working", uppercase = "the whole repo".**

| Picker | Root dir (narrowed) | cwd (repo root) |
|--------|---------------------|-----------------|
| Find files | `<leader><leader>` / `<leader>ff` | `<leader>fF` |
| Grep | `<leader>sg` | `<leader>sG` |
| Explorer (neo-tree) | `<leader>e` | `<leader>E` |

## Multiplexer - "go back to the last…" (companion to `Ctrl-O`)

Both multiplexers remember the **single** last target (a toggle, not a stack). Same
pattern at every level. Directional pane moves are `Ctrl-h/j/k/l` everywhere; see
[herdr's README](../../../herdr/README.md#neovim-navigation) for how that key reaches
the right layer under each one.

tmux - prefix is `Ctrl-Space`:

| Scope | Last (toggle) | Cycle next / prev |
|-------|---------------|-------------------|
| Pane | `prefix + ;` | `prefix + o` |
| Window | *(unbound: `prefix + l` is taken by `select-pane -R`)* | `prefix + n` / `prefix + p` |
| Session | `prefix + L` | `prefix + )` / `prefix + (` |

herdr - same prefix, and workspace/tab/pane stand in for session/window/pane:

| Scope | Last (toggle) | Cycle next / prev |
|-------|---------------|-------------------|
| Pane | `prefix + ;` | `prefix + Tab` / `prefix + Shift + Tab` |
| Tab | *(no toggle)* | `prefix + n` / `prefix + p` |
| Workspace | `prefix + L` | `prefix + )` / `prefix + (` |
