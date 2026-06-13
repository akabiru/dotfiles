-- Linting: Code linters via nvim-lint (LazyVim's default linter)
-- Diagnostics appear inline as you edit
-- rubocop for Ruby, erb_lint for ERB templates, swiftlint for Swift
-- The Ruby/ERB linters use `bundle exec` to pick up the project's gem versions
-- See: https://github.com/mfussenegger/nvim-lint
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
        cmd = "bundle",
        args = { "exec", "erblint", "--format", "compact" },
      },
    },
  },
}
