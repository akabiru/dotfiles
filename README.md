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
| [`claude`](#claude-code) | Claude Code global settings, instructions, custom agents, and slash commands |
| [`lazydocker`](#lazydocker) | Lazydocker custom commands (e.g. recreate backend/frontend/test services) |
| [`lazygit`](#lazygit) | Lazygit config (main branch names for upstream detection) |

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
stow fish nvim tmux ghostty claude lazydocker lazygit

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
| `XDG_CONFIG_HOME` | `~/.config` (points XDG-aware tools like lazydocker and lazygit at `~/.config` instead of the macOS default `~/Library/Application Support`) |

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
**Cheatsheet:** [Navigation & motions](nvim/.config/nvim/docs/navigation.md) — line/word motions, jumplist vs. changelist, the LazyVim "root dir" gotcha, and tmux pane/window/session jumps

### Plugins

| Plugin | Purpose |
|--------|---------|
| [catppuccin/nvim](https://github.com/catppuccin/nvim) | Colorscheme (Mocha/Latte) — replaces LazyVim's default tokyonight; cursor highlight overridden so it's visible on latte |
| [conform.nvim](https://github.com/stevearc/conform.nvim) | Code formatting |
| [nvim-lint](https://github.com/mfussenegger/nvim-lint) | Linting |
| [vim-test](https://github.com/vim-test/vim-test) | Test runner (runs tests in tmux pane via vimux) |
| [vimux](https://github.com/preservim/vimux) | Send commands to a tmux pane from Neovim |
| [snacks.nvim](https://github.com/folke/snacks.nvim) | File picker/explorer (configured to show hidden files) |
| [claudecode.nvim](https://github.com/coder/claudecode.nvim) | Claude Code integration — in-editor terminal, send buffer/selection, diff review (requires `claude` CLI on PATH) |
| [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator) | Seamless pane navigation between Neovim and tmux |
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Git change signs in the gutter + inline current-line blame (GitLens-style virtual text at EOL) |
| [git-conflict.nvim](https://github.com/akinsho/git-conflict.nvim) | VSCode-style inline merge conflict resolution — accept ours/theirs/both/none directly in the buffer |
| [diffview.nvim](https://github.com/sindrets/diffview.nvim) | 3-way merge view (base/ours/theirs), rich diffs, and file-history browser |
| [grug-far.nvim](https://github.com/MagicDuck/grug-far.nvim) | Project-wide search and replace with live preview |
| [vim-wakatime](https://github.com/wakatime/vim-wakatime) | Automatic time tracking to the WakaTime dashboard (needs an API key in `~/.wakatime.cfg`, prompted on first launch) |
| [lazydocker.nvim](https://github.com/mgierada/lazydocker.nvim) | Lazydocker TUI in a floating window — manage containers, images, logs, and volumes (requires the `lazydocker` binary) |
| [xcodebuild.nvim](https://github.com/wojciech-kulik/xcodebuild.nvim) | Build, run, test & debug iOS/macOS/watchOS/tvOS apps — manages simulators, schemes, tests, code coverage, and nvim-dap debugging (requires Xcode + the Homebrew Swift tooling; see iOS / Swift below) |

### Language Support

| Language | LSP | Formatter | Linter |
|----------|-----|-----------|--------|
| Ruby/Rails | `ruby_lsp` (via rbenv shim) | `rubocop` (via `bundle exec`) | `rubocop` (via `bundle exec`) |
| ERB | — | — | `erb_lint` (via `bundle exec`) |
| TypeScript/JavaScript | `ts_ls` | `prettierd` | — |
| Lua | `lua_ls` | `stylua` | — |
| HTML/CSS/JSON/YAML/Markdown | — | `prettierd` | — |
| Swift/iOS | `sourcekit` (Xcode toolchain) | `swiftformat` | `swiftlint` |

LSP servers are auto-installed via [Mason](https://github.com/williamboman/mason.nvim), except: `ruby_lsp`, launched via the rbenv shim (`~/.rbenv/shims/ruby-lsp`) so it picks the Ruby version pinned by each project's `.ruby-version` (install once per rbenv-managed Ruby: `rbenv shell <version> && gem install ruby-lsp ruby-lsp-rails && rbenv rehash`); and `sourcekit`, which ships with the active Xcode toolchain and can't be installed via Mason. `swiftformat`/`swiftlint`/`prettierd`/`stylua` come from Homebrew or Mason as listed.

### iOS / Swift (xcodebuild.nvim)

Full iOS/macOS development without leaving Neovim: code intelligence via `sourcekit-lsp`, formatting/linting via `swiftformat`/`swiftlint`, and build/run/test/debug via [xcodebuild.nvim](https://github.com/wojciech-kulik/xcodebuild.nvim) (driving the `xcodebuild` CLI, `xcrun simctl` simulators, and `nvim-dap`).

**One-time setup:**

1. Install **full Xcode** (App Store), then point the toolchain at it (not the Command Line Tools): `sudo xcode-select -s /Applications/Xcode.app/Contents/Developer`. Verify with `xcodebuild -version`.
2. Install the Homebrew tooling: `brew bundle` pulls `xcbeautify`, `xcode-build-server`, `swiftformat`, `swiftlint`, and `xcodegen`.
3. **Per project**, generate a `buildServer.json` so `sourcekit-lsp` understands the Xcode project (re-run after scheme/target changes):
   ```sh
   xcode-build-server config -scheme <Scheme> -project <Name>.xcodeproj
   # or, for a workspace:
   xcode-build-server config -scheme <Scheme> -workspace <Name>.xcworkspace
   ```

Debugging uses the toolchain's native LLDB on Xcode 16+ (no codelldb needed) via LazyVim's dap stack.

| Keymap | Action |
|--------|--------|
| `<leader>Xf` | Show all xcodebuild actions (picker) |
| `<leader>Xb` | Build project |
| `<leader>Xr` | Build & run |
| `<leader>Xt` | Run tests |
| `<leader>XT` | Run current test class |
| `<leader>Xl` | Toggle build/run logs |
| `<leader>Xs` | Select scheme |
| `<leader>Xd` | Select device / simulator |
| `<leader>Xc` | Toggle code coverage |
| `<leader>Xn` | Build & debug |
| `<leader>XN` | Debug without building |

Once a debug session is running (`<leader>Xn`), the general `<leader>d…` keymaps from LazyVim's dap stack control it (these work for any nvim-dap session, not just Swift):

| Keymap | Action |
|--------|--------|
| `<leader>dc` | Run / continue |
| `<leader>da` | Run with args |
| `<leader>db` | Toggle breakpoint |
| `<leader>dB` | Breakpoint condition |
| `<leader>di` | Step into |
| `<leader>dO` | Step over |
| `<leader>do` | Step out |
| `<leader>dC` | Run to cursor |
| `<leader>dg` | Go to line (no execute) |
| `<leader>dj` / `dk` | Move down / up the call stack |
| `<leader>dl` | Run last |
| `<leader>dP` | Pause |
| `<leader>dt` | Terminate |
| `<leader>dr` | Toggle REPL |
| `<leader>ds` | Session |
| `<leader>dw` | Widgets (hover) |
| `<leader>du` | Toggle dap-ui |
| `<leader>de` | Eval (normal / visual) |

**Caveats:** no live SwiftUI preview canvas — xcodebuild.nvim renders snapshot-style previews (via snacks.nvim), not Xcode's interactive canvas. Deploying to a **physical device** needs code signing plus `ios-deploy`/`pymobiledevice3` (not installed by default); simulator workflows need none of that.

### Custom Keymaps

| Keymap | Action |
|--------|--------|
| `<leader>yp` | Copy relative file path to clipboard |
| `<leader>yP` | Copy absolute file path to clipboard |
| `<leader>gb` | Show full git blame popup for current line (gitsigns) |
| `<leader>gB` | Toggle inline current-line blame virtual text (gitsigns) |
| `<leader>gL` | Preview the GitHub PR that introduced the current line — `PR #N • title` (requires `gh` CLI) |
| `<leader>gO` | Preview that PR and open it in the browser (requires `gh` CLI) |
| `<leader>D` | Open Lazydocker in a floating window (lazydocker.nvim) |
| `co` / `ct` / `cb` / `c0` | In a conflicted file: accept ours / theirs / both / none (git-conflict) |
| `]x` / `[x` | Jump to next / previous merge conflict (git-conflict) |
| `<leader>gxo` / `gxt` / `gxb` / `gx0` | Accept ours / theirs / both / none conflict (git-conflict) |
| `<leader>gxl` | List all conflicts in the quickfix window (git-conflict) |
| `<leader>gvo` | Open Diffview (3-way merge view during a merge, otherwise diff) |
| `<leader>gvc` | Close Diffview |
| `<leader>gvh` / `gvH` | Diffview file history (current file / whole repo) |
| `p` / `P` (visual) | Paste over selection without overwriting the unnamed register (clipboard survives) |

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

Tests run in a tmux pane via vimux. In dockerized OpenProject-style repos (a `bin/compose` script next to a `docker-compose.yml`), the rspec runner is auto-switched to `bin/compose rspec` so specs run inside the container; every other Ruby project keeps the default binstub.

### Autocmds

- **Theme sync** — syncs `vim.o.background` with macOS appearance on `FocusGained`, respects `~/.theme-mode` override
- **Auto-reload** — reloads files changed externally (e.g., by Claude Code in another tmux pane) on cursor move
- **Gitsigns refresh** — re-runs `Gitsigns.refresh()` on `FocusGained` so commits made in another pane update the sign column automatically

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
- Inactive pane border: catppuccin `overlay2` (adapts to latte/mocha)
- Pane border lines: heavy (thicker Unicode box-drawing glyphs)
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

### Custom Commands

Slash commands in `commands/` toggle the pair-programming workflow defined in `CLAUDE.md` (the **Collaboration Model**). By default you drive and Claude navigates; these switch who holds the keyboard.

| Command | Action |
|---------|--------|
| `/drive` | Hand the keyboard to Claude (Mode 2) — it plans first, then implements one reviewable chunk at a time, pausing at each checkpoint for review |
| `/navigate` | Take the keyboard back (Mode 1) — you write the code; Claude reviews your diffs, suggests alternatives, and researches or drafts tests on request |

Verbal triggers work too ("you drive" / "I'll drive"). Any `.md` file added to `commands/` becomes a slash command automatically.

### Notifications

`settings.json` wires a `Notification` hook that fires `terminal-notifier` whenever Claude is idle waiting for input or needs permission — works through tmux, clicking focuses Ghostty. Requires `terminal-notifier` on `PATH`.

## Lazydocker

**Config:** `lazydocker/.config/lazydocker/config.yml`.

On macOS lazydocker reads `~/Library/Application Support/lazydocker/` by default; the `XDG_CONFIG_HOME` export (see [Environment](#environment)) redirects it to `~/.config/lazydocker/config.yml` so the config lives with the dotfiles.

Lazydocker custom commands are menu-driven; they cannot be bound to their own key. On the **Services** panel, press `c` ("run predefined custom command") and pick the entry (with a single command this is effectively `c` then Enter).

Lazydocker has no per-repo config, so this command appears in every project's menu. The `Op:` prefix is just a label marking it as OpenProject-specific; it only does something useful in a compose project that has those services.

The commands route through OpenProject's `bin/compose` wrapper instead of raw `docker compose`, so they inherit its `.env` loading, `docker-compose.override.yml` inclusion, `config/database.yml` guard, and `docker-compose` vs `docker compose` detection. Because `bin/compose` is a relative path, launch lazydocker from the openproject repo root (the cwd these commands already assumed).

| Command | Runs |
|---------|------|
| Op: recreate backend + frontend + backend-test | `bin/compose up -d backend frontend backend-test --force-recreate` |
| Op: setup backend + frontend services | `bin/compose setup` (backend setup + frontend & hocuspocus `npm install`) |
| Op: restart backend + frontend services | `bin/compose up -d backend frontend --force-recreate` |

Open the lazydocker TUI from Neovim with `<leader>D` (see [Custom Keymaps](#custom-keymaps)).

## Lazygit

**Config:** `lazygit/.config/lazygit/config.yml`.

Like lazydocker, lazygit defaults to `~/Library/Application Support/lazygit/` on macOS and is redirected to `~/.config/lazygit/config.yml` by `XDG_CONFIG_HOME`. Currently sets `git.mainBranches` (`main`, `master`, `dev`) so upstream/recency detection works against the right base branch.

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
