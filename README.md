# dotfiles

> Personal development environment for macOS, managed with [GNU Stow](https://www.gnu.org/software/stow/).

Fish shell, Neovim (LazyVim), tmux or herdr, and Ghostty — configured to work together with a unified theme system that syncs dark/light mode across all tools.

## What's Inside

Each package has its own README with the full details (aliases, plugins, keymaps, settings).

| Package | Description |
|---------|-------------|
| [`fish`](fish/README.md) | Shell configuration, aliases, functions, and completions |
| [`nvim`](nvim/README.md) | LazyVim-based Neovim setup for Ruby/Rails, TypeScript, Lua, and Swift/iOS |
| [`tmux`](tmux/README.md) | Terminal multiplexer with Catppuccin theme and vim-style navigation |
| [`herdr`](herdr/README.md) | Alternative terminal multiplexer, keybinding-compatible with the tmux setup |
| [`ghostty`](ghostty/README.md) | Ghostty terminal emulator settings |
| [`claude`](claude/README.md) | Claude Code global settings, instructions, custom agents, and slash commands |
| [`lazydocker`](lazydocker/README.md) | Lazydocker custom commands (e.g. recreate backend/frontend/test services) |
| [`lazygit`](lazygit/README.md) | Lazygit config (main branch names for upstream detection) |

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
stow fish nvim tmux herdr ghostty claude lazydocker lazygit

# Or symlink individually
stow fish
stow nvim
```

After stowing, install the tmux plugins:

```bash
# Start tmux, then press prefix + I to install plugins via TPM
tmux
```

And, if you use herdr, link its bundled plugin:

```bash
herdr plugin link ~/.config/herdr/last-workspace
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

## Theme System

A unified dark/light mode system that keeps Neovim, tmux, and Ghostty in sync, driven by the fish [`theme` function](fish/README.md#custom-functions).

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

Stow will create symlinks from `~/.config/newpkg/` pointing to your dotfiles repo. A `README.md` at the package root is safe: stow's default ignore list skips `README.*`, so it documents the package on GitHub without being symlinked into `~`.

## License

MIT
