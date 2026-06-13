-- Formatting: Code formatters via conform.nvim (LazyVim's default formatter)
-- <leader>cf to format buffer (LazyVim default keymap)
-- rubocop for Ruby, prettierd for JS/TS/web, swiftformat for Swift, stylua for Lua
-- prettierd is auto-installed via the mason.nvim spec below (ensure_installed).
-- See: https://github.com/stevearc/conform.nvim
return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters = {
        rubocop = {
          command = "bundle",
          prepend_args = { "exec", "rubocop" },
        },
      },
      formatters_by_ft = {
        ruby = { "rubocop" },
        javascript = { "prettierd" },
        javascriptreact = { "prettierd" },
        typescript = { "prettierd" },
        typescriptreact = { "prettierd" },
        html = { "prettierd" },
        css = { "prettierd" },
        json = { "prettierd" },
        yaml = { "prettierd" },
        markdown = { "prettierd" },
        swift = { "swiftformat" },
        lua = { "stylua" },
      },
    },
  },
  -- Auto-install formatters used above. LazyVim merges (not replaces) this
  -- list, so prettierd is appended to its defaults (stylua, shfmt, etc.).
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "prettierd" } },
  },
}
