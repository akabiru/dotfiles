# dotfiles

> Personal development environment for macOS, managed with [GNU Stow](https://www.gnu.org/software/stow/).

Fish shell, Neovim (LazyVim), tmux, and Ghostty — configured to work together with a unified theme system that syncs dark/light mode across all tools.

## What's Inside

| Package | Description |
|---------|-------------|
| [`fish`](#fish-shell) | Shell configuration, aliases, functions, and completions |
| [`nvim`](#neovim) | LazyVim-based Neovim setup for Ruby/Rails, TypeScript, and Lua |
| [`tmux`](#tmux) | Terminal multiplexer with Catppuccin theme and vim-style navigation |
| [`ghostty`](#ghostty) | Ghostty terminal emulator settings |
| [`claude`](#claude-code) | Claude Code global settings, instructions, and custom agents |

## Prerequisites

- macOS
- [Homebrew](https://brew.sh)
- [GNU Stow](https://www.gnu.org/software/stow/) (`brew install stow`)

All other dependencies (fish, neovim, tmux, ghostty, fonts, etc.) are declared in the `Brewfile`.

## Installation

```bash
git clone https://github.com/akabiru/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Install all Homebrew dependencies (formulae, casks, VS Code extensions, etc.)
brew bundle

# Symlink all packages
stow fish nvim tmux ghostty claude

# Or symlink individually
stow fish
stow nvim
```

After stowing, install tmux plugins:

```bash
# Start tmux, then press prefix + I to install plugins via TPM
tmux
```

### Brewfile

The `Brewfile` captures the full development environment:

| Category | Examples |
|----------|----------|
| **Taps** | `anomalyco/tap`, `withgraphite/tap` |
| **Formulae** | fish, neovim, tmux, starship, ripgrep, gh, nodenv, rbenv, postgresql, redis, stow, lazygit, lazydocker, ollama, overmind, hledger |
| **Casks** | Ghostty, Arc, Firefox, Docker Desktop, OrbStack, RubyMine, Zed, VS Code, Spotify, JetBrainsMono Nerd Font |
| **VS Code Extensions** | Ruby LSP, Claude Code, GitLens, Prettier, ESLint, Docker, Terraform, Go, and more |
| **Go packages** | gopls, wails |
| **npm globals** | corepack, yarn |

To update the Brewfile after installing new packages:

```bash
brew bundle dump --force
```

## Fish Shell

**Config:** `fish/.config/fish/`

### Aliases

| Alias | Command | Description |
|-------|---------|-------------|
| `o` | `overmind` | Process manager |
| `d` | `docker` | Docker CLI |
| `dcx` | `docker-compose exec` | Execute in running container |
| `dcr` | `docker-compose run --rm` | Run with auto-cleanup |
| `dcu` | `docker-compose up` | Start services |
| `dcs` | `docker-compose stop` | Stop services |
| `dstats` | `docker stats --format ...` | Formatted container stats |
| `ggpull` | `git pull origin (branch)` | Pull current branch |
| `ggpush` | `git push origin (branch)` | Push current branch |

### Environment

| Variable | Value |
|----------|-------|
| `EDITOR` | `nvim` |

### PATH Additions

- `/opt/homebrew/opt/postgresql@17/bin` — PostgreSQL 17
- `/usr/local/go/bin` and `~/go/bin` — Go toolchain
- `/opt/cloud66/bin` — Cloud66 deployment tools

### Tool Initialization

- **nodenv** — Node.js version management
- **Starship** — cross-shell prompt
- **Oh My Fish** — plugin framework (via `conf.d/omf.fish`)
- **uv** — Python package manager (via `conf.d/uv.env.fish`)

### Completions

- **OpenProject CLI** (`op`) — shell completions for `op` commands

### Custom Functions

#### `theme` — Unified Theme Switcher

Switch dark/light mode across Neovim, tmux, and Ghostty simultaneously.

```bash
theme              # Show current theme mode
theme dark         # Switch to dark mode
theme light        # Switch to light mode
theme auto         # Follow macOS system appearance
theme toggle       # Cycle: auto → dark → light → auto
```

See [Theme System](#theme-system) for details.

### Secrets

Copy `conf.d/secrets.fish.example` to `conf.d/secrets.fish` and add sensitive environment variables. This file is gitignored.

## Neovim

**Config:** `nvim/.config/nvim/`
**Framework:** [LazyVim](https://www.lazyvim.org/)

### Plugins

| Plugin | Purpose |
|--------|---------|
| [catppuccin/nvim](https://github.com/catppuccin/nvim) | Colorscheme (Mocha/Latte) — replaces LazyVim's default tokyonight |
| [conform.nvim](https://github.com/stevearc/conform.nvim) | Code formatting |
| [nvim-lint](https://github.com/mfussenegger/nvim-lint) | Linting |
| [vim-test](https://github.com/vim-test/vim-test) | Test runner (runs tests in tmux pane via vimux) |
| [vimux](https://github.com/preservim/vimux) | Send commands to a tmux pane from Neovim |
| [snacks.nvim](https://github.com/folke/snacks.nvim) | File picker/explorer (configured to show hidden files) |
| [claudecode.nvim](https://github.com/coder/claudecode.nvim) | Claude Code integration — in-editor terminal, send buffer/selection, diff review (requires `claude` CLI on PATH) |
| [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator) | Seamless pane navigation between Neovim and tmux |

### Language Support

| Language | LSP | Formatter | Linter |
|----------|-----|-----------|--------|
| Ruby/Rails | `ruby_lsp` (via rbenv shim) | `rubocop` (via `bundle exec`) | `rubocop` (via `bundle exec`) |
| ERB | — | — | `erb_lint` (via `bundle exec`) |
| TypeScript/JavaScript | `ts_ls` | `prettierd` | — |
| Lua | `lua_ls` | `stylua` | — |
| HTML/CSS/JSON/YAML/Markdown | — | `prettierd` | — |

LSP servers are auto-installed via [Mason](https://github.com/williamboman/mason.nvim), except `ruby_lsp`, which is launched via the rbenv shim (`~/.rbenv/shims/ruby-lsp`) so it picks the Ruby version pinned by each project's `.ruby-version`. Install `ruby-lsp` once per rbenv-managed Ruby version: `rbenv shell <version> && gem install ruby-lsp ruby-lsp-rails && rbenv rehash`.

### Custom Keymaps

| Keymap | Action |
|--------|--------|
| `<leader>yp` | Copy relative file path to clipboard |
| `<leader>yP` | Copy absolute file path to clipboard |

### Claude Code (claudecode.nvim)

| Keymap | Action |
|--------|--------|
| `<leader>ac` | Toggle Claude terminal |
| `<leader>af` | Focus Claude terminal |
| `<leader>ar` | Resume a previous Claude session (`--resume`) |
| `<leader>aC` | Continue the last Claude session (`--continue`) |
| `<leader>ab` | Add current buffer to Claude context |
| `<leader>as` | Send selection to Claude (visual mode) / add file from tree (NvimTree, neo-tree, oil) |
| `<leader>aa` | Accept Claude's proposed diff |
| `<leader>ad` | Deny Claude's proposed diff |

### Test Runner (vim-test + vimux)

| Keymap | Action |
|--------|--------|
| `<leader>tn` | Run nearest test |
| `<leader>tf` | Run test file |
| `<leader>ts` | Run test suite |
| `<leader>tl` | Run last test |
| `<leader>tv` | Visit test file |

### Autocmds

- **Theme sync** — syncs `vim.o.background` with macOS appearance on `FocusGained`, respects `~/.theme-mode` override
- **Auto-reload** — reloads files changed externally (e.g., by Claude Code in another tmux pane) on cursor move

### Options

- 2-space indentation with `expandtab`
- Shell set to Fish for `:terminal`

## tmux

**Config:** `tmux/.tmux.conf`

### Keybindings

**Prefix:** `Ctrl + Space` (remapped from default `Ctrl + b`)

| Key | Action |
|-----|--------|
| `prefix + r` | Reload config |
| `prefix + \|` | Vertical split (current directory) |
| `prefix + -` | Horizontal split (current directory) |
| `prefix + c` | New window (current directory) |
| `prefix + h/j/k/l` | Vim-style pane navigation |
| `Ctrl + h/j/k/l` | Cross-pane navigation (via vim-tmux-navigator) |

### Settings

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

### Display

- Active pane border: blue, bold
- Inactive pane border: grey
- Catppuccin status modules: application, directory, session

### Plugins

| Plugin | Purpose |
|--------|---------|
| [tpm](https://github.com/tmux-plugins/tpm) | Plugin manager |
| [catppuccin/tmux](https://github.com/catppuccin/tmux) (v2.1.3) | Catppuccin theme |
| [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator) | Seamless Neovim/tmux navigation |

## Ghostty

**Config:** `ghostty/.config/ghostty/config.ghostty`

| Setting | Value |
|---------|-------|
| Shell | Fish (`/opt/homebrew/bin/fish`) |
| Font | JetBrainsMono Nerd Font Mono, 15pt |
| Theme | Catppuccin Mocha (synced via `theme` command) |
| Shell integration | Fish |
| Copy on select | Clipboard (auto-copy mouse selections) |

## Claude Code

**Config:** `claude/.claude/`

Global settings and custom agents for [Claude Code](https://docs.anthropic.com/en/docs/claude-code).

| File | Purpose |
|------|---------|
| `CLAUDE.md` | Global instructions applied to all projects |
| `settings.json` | Model, plugins, environment, and preference settings |
| `agents/rails-code-reviewer.md` | Custom Rails code review agent |
| `agents/frontend-architect.md` | Frontend architecture guidance (Stimulus, Angular, ViewComponents, Turbo) |
| `agents/local-first-architect.md` | Local-first/CRDT architecture (Yjs, BlockNote, Hocuspocus, ProseMirror) |

### Notifications

`settings.json` wires a `Notification` hook that fires `terminal-notifier` whenever Claude is idle waiting for input or needs permission — works through tmux, clicking focuses Ghostty. Requires `terminal-notifier` on `PATH`.

## Theme System

A unified dark/light mode system that keeps Neovim, tmux, and Ghostty in sync.

### How It Works

```
┌──────────────┐     writes      ┌──────────────┐
│ theme [mode] │ ───────────────▶│ ~/.theme-mode │
│ (fish func)  │                 │ (dark/light/  │
└──────┬───────┘                 │  auto)        │
       │                         └───────┬───────┘
       │ applies directly                │ read on focus/startup
       ▼                                 ▼
┌──────────────┐  ┌──────────────┐  ┌──────────────┐
│   Ghostty    │  │    tmux      │  │   Neovim     │
│ config edit  │  │ @catppuccin  │  │ vim.o.back-  │
│              │  │ _flavor      │  │ ground       │
└──────────────┘  └──────────────┘  └──────────────┘
```

### Modes

| Mode | Behavior |
|------|----------|
| `dark` | Force Catppuccin Mocha everywhere |
| `light` | Force Catppuccin Latte everywhere |
| `auto` | Follow macOS system appearance (detected via `defaults read -g AppleInterfaceStyle`) |

### Integration Points

- **Fish** — `theme` function writes `~/.theme-mode` and applies changes immediately
- **Neovim** — `FocusGained` autocmd reads `~/.theme-mode` and updates background
- **tmux** — reads `~/.theme-mode` at startup, sets catppuccin flavor before plugin loads
- **Ghostty** — config file updated directly by `theme` function

## Adding a New Stow Package

```bash
# Create the package directory mirroring the target structure
mkdir -p newpkg/.config/newpkg
# Add your config files
vim newpkg/.config/newpkg/config
# Symlink it
stow newpkg
```

Stow will create symlinks from `~/.config/newpkg/` pointing to your dotfiles repo.

## License

MIT
