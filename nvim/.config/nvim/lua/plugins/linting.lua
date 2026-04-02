-- Linting: Code linters via nvim-lint (LazyVim's default linter)
-- Diagnostics appear inline as you edit
-- rubocop for Ruby, erb_lint for ERB templates
-- Both use `bundle exec` to pick up the project's gem versions
-- See: https://github.com/mfussenegger/nvim-lint
return {
  "mfussenegger/nvim-lint",
  opts = {
    linters_by_ft = {
      ruby = { "rubocop" },
      eruby = { "erb_lint" },
    },
    linters = {
      rubocop = {
        cmd = "bundle",
        args = { "exec", "rubocop" },
      },
      erb_lint = {
        cmd = "bundle",
        args = { "exec", "erb_lint" },
      },
    },
  },
}
