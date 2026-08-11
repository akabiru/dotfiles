# nvim

**Config:** `nvim/.config/nvim/`
**Framework:** [LazyVim](https://www.lazyvim.org/)
**Cheatsheet:** [Navigation & motions](.config/nvim/docs/navigation.md) — line/word motions, jumplist vs. changelist, the LazyVim "root dir" gotcha, and tmux pane/window/session jumps

LazyVim-based Neovim setup for Ruby/Rails, TypeScript, Lua, and Swift/iOS.

## Plugins

| Plugin | Purpose |
|--------|---------|
| [catppuccin/nvim](https://github.com/catppuccin/nvim) | Colorscheme (Mocha/Latte) — replaces LazyVim's default tokyonight; cursor highlight overridden so it's visible on latte |
| [conform.nvim](https://github.com/stevearc/conform.nvim) | Code formatting |
| [nvim-lint](https://github.com/mfussenegger/nvim-lint) | Linting |
| [vim-test](https://github.com/vim-test/vim-test) | Test runner (runs tests in tmux pane via vimux) |
| [vimux](https://github.com/preservim/vimux) | Send commands to a tmux pane from Neovim |
| [snacks.nvim](https://github.com/folke/snacks.nvim) | File picker/explorer (configured to show hidden files); the GitHub PR pickers (`<leader>gp` list and its diff view) use a custom near-fullscreen layout with a 30/70 list-to-preview split for reviewing |
| [claudecode.nvim](https://github.com/coder/claudecode.nvim) | Claude Code integration — in-editor terminal, send buffer/selection, diff review (requires `claude` CLI on PATH) |
| [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator) | Seamless pane navigation between Neovim and tmux |
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Git change signs in the gutter + inline current-line blame (GitLens-style virtual text at EOL) |
| [git-conflict.nvim](https://github.com/akinsho/git-conflict.nvim) | VSCode-style inline merge conflict resolution — accept ours/theirs/both/none directly in the buffer |
| [diffview.nvim](https://github.com/sindrets/diffview.nvim) | 3-way merge view (base/ours/theirs), rich diffs, and file-history browser |
| [grug-far.nvim](https://github.com/MagicDuck/grug-far.nvim) | Project-wide search and replace with live preview |
| [vim-wakatime](https://github.com/wakatime/vim-wakatime) | Automatic time tracking to the WakaTime dashboard (needs an API key in `~/.wakatime.cfg`, prompted on first launch) |
| [lazydocker.nvim](https://github.com/mgierada/lazydocker.nvim) | Lazydocker TUI in a floating window — manage containers, images, logs, and volumes (requires the `lazydocker` binary) |
| [xcodebuild.nvim](https://github.com/wojciech-kulik/xcodebuild.nvim) | Build, run, test & debug iOS/macOS/watchOS/tvOS apps — manages simulators, schemes, tests, code coverage, and nvim-dap debugging (requires Xcode + the Homebrew Swift tooling; see iOS / Swift below) |
| [hardtime.nvim](https://github.com/m4xshen/hardtime.nvim) | Vim habit coach — nags on inefficient motions (repeated `hjkl`, arrow keys) and hints the idiomatic alternative; `:Hardtime report` shows your most common bad habits. Also wires up `:CoachReport` (custom, `lua/coach.lua`): opens an interactive `claude` session in a floating terminal, seeded with the aggregated hardtime log — you get top habits to fix, drills, and remap suggestions, then keep chatting/asking follow-ups in the same session. Incremental: only lines since the last report are sent (offset kept in `stdpath("data")/coach_cursor.json`); `:CoachReport!` sends the full log |
## Language Support

| Language | LSP | Formatter | Linter |
|----------|-----|-----------|--------|
| Ruby/Rails | `ruby_lsp` (via rbenv shim) | `rubocop` (via `bundle exec`) | `rubocop` (via `bundle exec`) |
| ERB | — | — | `erb_lint` (via `bundle exec`) |
| TypeScript/JavaScript | `ts_ls` | `prettierd` | — |
| Lua | `lua_ls` | `stylua` | — |
| HTML/CSS/JSON/YAML/Markdown | — | `prettierd` | — |
| Swift/iOS | `sourcekit` (Xcode toolchain) | `swiftformat` | `swiftlint` |

LSP servers are auto-installed via [Mason](https://github.com/williamboman/mason.nvim), except: `ruby_lsp`, launched via the rbenv shim (`~/.rbenv/shims/ruby-lsp`) so it picks the Ruby version pinned by each project's `.ruby-version` (install once per rbenv-managed Ruby: `rbenv shell <version> && gem install ruby-lsp ruby-lsp-rails && rbenv rehash`); and `sourcekit`, which ships with the active Xcode toolchain and can't be installed via Mason. `swiftformat`/`swiftlint`/`prettierd`/`stylua` come from Homebrew or Mason as listed.

The Ruby LSP Rails addon's "Run Migrations" prompt is disabled (`enablePendingMigrationsPrompt = false`): it interrupts constantly when a project has pending migrations, and it would run them on the host Ruby, which is wrong for dockerized projects. Run migrations manually instead (e.g. `bin/compose run backend bundle exec rails db:migrate`).

## iOS / Swift (xcodebuild.nvim)

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

## Custom Keymaps

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

## Claude Code (claudecode.nvim)

The plugin-managed Claude runs in a **floating terminal** (75% x 80%, rounded border) rather than a split, so it can sit on top of a full-width editor. Treat it as the contextual assistant: select a block, `<leader>as`, ask follow-ups in the float. A separate Claude driven in its own tmux pane stays independent - as long as you never run `/ide` in it, since sends reach every client attached to Neovim's WebSocket server.

| Keymap | Action |
|--------|--------|
| `<leader>ac` | Toggle Claude terminal (hides the float; session survives) |
| `<leader>af` | Focus Claude terminal |
| `<leader>ar` | Resume a previous Claude session (`--resume`) |
| `<leader>aC` | Continue the last Claude session (`--continue`) |
| `<leader>ab` | Add current buffer to Claude context |
| `<leader>as` | Send selection to Claude and focus the float (visual mode) / add file from tree (NvimTree, neo-tree, oil) |
| `<leader>aa` | Accept Claude's proposed diff |
| `<leader>ad` | Deny Claude's proposed diff |

## Test Runner (vim-test + vimux)

| Keymap | Action |
|--------|--------|
| `<leader>tn` | Run nearest test |
| `<leader>tf` | Run test file |
| `<leader>ts` | Run test suite |
| `<leader>tl` | Run last test |
| `<leader>tv` | Visit test file |

Tests run in a tmux pane via vimux. In dockerized OpenProject-style repos (a `bin/compose` script next to a `docker-compose.yml`), the rspec runner is auto-switched to `bin/compose rspec` so specs run inside the container; every other Ruby project keeps the default binstub.

## Autocmds

- **Theme sync** — syncs `vim.o.background` with macOS appearance on `FocusGained`, respects `~/.theme-mode` override (see the [Theme System](../README.md#theme-system))
- **Auto-reload** — reloads files changed externally (e.g., by Claude Code in another tmux pane) on cursor move
- **Gitsigns refresh** — re-runs `Gitsigns.refresh()` on `FocusGained` so commits made in another pane update the sign column automatically

## Options

- 2-space indentation with `expandtab`
- Shell set to Fish for `:terminal`
