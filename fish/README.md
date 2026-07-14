# fish

**Config:** `fish/.config/fish/`

Shell configuration, aliases, functions, and completions.

## Aliases

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

## Environment

| Variable | Value |
|----------|-------|
| `EDITOR` | `nvim` |
| `XDG_CONFIG_HOME` | `~/.config` (points XDG-aware tools like lazydocker and lazygit at `~/.config` instead of the macOS default `~/Library/Application Support`) |

## PATH Additions

- `/opt/homebrew/opt/postgresql@17/bin` — PostgreSQL 17
- `/usr/local/go/bin` and `~/go/bin` — Go toolchain
- `/opt/cloud66/bin` — Cloud66 deployment tools

## Tool Initialization

- **nodenv** — Node.js version management
- **Starship** — cross-shell prompt
- **Oh My Fish** — plugin framework (via `conf.d/omf.fish`)
- **uv** — Python package manager (via `conf.d/uv.env.fish`)

## Completions

- **OpenProject CLI** (`op`) — shell completions for `op` commands

## Custom Functions

### `theme` — Unified Theme Switcher

Switch dark/light mode across Neovim, tmux, and Ghostty simultaneously.

```bash
theme              # Show current theme mode
theme dark         # Switch to dark mode
theme light        # Switch to light mode
theme auto         # Follow macOS system appearance
theme toggle       # Cycle: auto → dark → light → auto
```

See the [Theme System](../README.md#theme-system) for how the pieces fit together.

## Secrets

Copy `conf.d/secrets.fish.example` to `conf.d/secrets.fish` and add sensitive environment variables. This file is gitignored.
