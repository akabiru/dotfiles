-- Linting: Code linters via nvim-lint (LazyVim's default linter)
-- Diagnostics appear inline as you edit
-- rubocop for Ruby, erb_lint for ERB templates, swiftlint for Swift
-- The Ruby/ERB linters use `bundle exec` to pick up the project's gem versions
-- See: https://github.com/mfussenegger/nvim-lint

-- Trust gate (security): the Ruby/ERB linters run the OPENED project's
-- `bundle exec <linter>`, which executes that project's pinned gems and, for
-- rubocop, any Ruby pulled in by its `.rubocop.yml` `require:`/plugins. nvim-lint
-- auto-runs these on buffer events, so merely opening a .rb/.erb file in an
-- untrusted checkout would run attacker-controlled Ruby on the host (CWE-94).
-- Only take the project-bundler path when the file lives under a root the user
-- has explicitly trusted; for anything else the linter is skipped (a host-wide
-- rubocop is not a safe fallback here, since it would still load the project's
-- .rubocop.yml `require:`). Add your own project locations to `trusted_roots`.
local trusted_roots = {
  "~/Developer",
}

local function current_file_trusted()
  local file = vim.api.nvim_buf_get_name(0)
  if file == "" then
    return false
  end
  file = vim.fs.normalize(file)
  for _, root in ipairs(trusted_roots) do
    root = vim.fs.normalize(root)
    if file == root or vim.startswith(file, root .. "/") then
      return true
    end
  end
  return false
end

return {
  "mfussenegger/nvim-lint",
  opts = {
    linters_by_ft = {
      ruby = { "rubocop" },
      eruby = { "erb_lint" },
      -- swiftlint runs standalone (from Homebrew), no bundle wrapper needed.
      -- Picks up a project's .swiftlint.yml automatically when present.
      swift = { "swiftlint" },
    },
    -- Override cmd to use `bundle` and prepend `exec <linter>` to the
    -- upstream args. We re-list the upstream args here because nvim-lint
    -- (via LazyVim) merges `linters` with vim.tbl_deep_extend, which on
    -- list-like tables overlays index-by-index — replacing `args` with a
    -- shorter list silently drops the trailing flags. For rubocop that
    -- means losing `--format json`, which makes the parser fail with
    -- "Expected value but found invalid token".
    linters = {
      rubocop = {
        -- Only run the project's `bundle exec rubocop` for files under a
        -- trusted root (see `current_file_trusted`); skip untrusted checkouts.
        condition = current_file_trusted,
        cmd = "bundle",
        args = {
          "exec",
          "rubocop",
          "--format",
          "json",
          "--force-exclusion",
          "--server",
          "--stdin",
          function()
            return vim.api.nvim_buf_get_name(0)
          end,
        },
      },
      erb_lint = {
        -- Same trust gate as rubocop: `bundle exec erblint` runs the opened
        -- project's gems, so gate it to trusted roots too.
        condition = current_file_trusted,
        cmd = "bundle",
        args = { "exec", "erblint", "--format", "compact" },
      },
    },
  },
}
