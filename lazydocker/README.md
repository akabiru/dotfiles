# lazydocker

**Config:** `lazydocker/.config/lazydocker/config.yml`

On macOS lazydocker reads `~/Library/Application Support/lazydocker/` by default; the `XDG_CONFIG_HOME` export (see [fish › Environment](../fish/README.md#environment)) redirects it to `~/.config/lazydocker/config.yml` so the config lives with the dotfiles.

Lazydocker custom commands are menu-driven; they cannot be bound to their own key. On the **Services** panel, press `c` ("run predefined custom command") and pick the entry (with a single command this is effectively `c` then Enter).

Lazydocker has no per-repo config, so this command appears in every project's menu. The `Op:` prefix is just a label marking it as OpenProject-specific; it only does something useful in a compose project that has those services.

The commands route through OpenProject's `bin/compose` wrapper instead of raw `docker compose`, so they inherit its `.env` loading, `docker-compose.override.yml` inclusion, `config/database.yml` guard, and `docker-compose` vs `docker compose` detection. Because `bin/compose` is a relative path, launch lazydocker from the openproject repo root (the cwd these commands already assumed).

Each command runs through [`tmux-job`](../bin/README.md#tmux-job), so it opens in a background pane at the bottom of the tmux window instead of taking over the lazydocker float. Lazydocker returns straight away; the pane's light on the tmux agent strip goes green while the command runs, yellow when it succeeds and red when it fails. Jump to it with `prefix+A` (or pick it from `prefix+a`), then press any key to close it. This needs lazydocker to run inside tmux.

| Command | Runs |
|---------|------|
| Op: recreate backend + frontend + backend-test | `bin/compose up -d backend frontend backend-test --force-recreate` |
| Op: setup backend + frontend services | `bin/compose setup` (backend setup + frontend & hocuspocus `npm install`) |
| Op: restart backend + frontend services | `bin/compose up -d backend frontend --force-recreate` |

Open the lazydocker TUI from Neovim with `<leader>D` (see [nvim › Custom Keymaps](../nvim/README.md#custom-keymaps)).
