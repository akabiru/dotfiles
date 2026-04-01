-- Formatting: Code formatters via conform.nvim (LazyVim's default formatter)
-- <leader>cf to format buffer (LazyVim default keymap)
-- rubocop for Ruby, prettierd for JS/TS/web, stylua for Lua
-- Prerequisites: `:MasonInstall prettierd` or `npm i -g @fsouza/prettierd`
-- See: https://github.com/stevearc/conform.nvim
return {
  "stevearc/conform.nvim",
  opts = {
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
      lua = { "stylua" },
    },
  },
}
