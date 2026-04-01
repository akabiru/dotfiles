-- Linting: Code linters via nvim-lint (LazyVim's default linter)
-- Diagnostics appear inline as you edit
-- rubocop for Ruby, erb_lint for ERB templates
-- Prerequisites: `gem install erb_lint` (rubocop comes from project Gemfile)
-- See: https://github.com/mfussenegger/nvim-lint
return {
  "mfussenegger/nvim-lint",
  opts = {
    linters_by_ft = {
      ruby = { "rubocop" },
      eruby = { "erb_lint" },
    },
  },
}
