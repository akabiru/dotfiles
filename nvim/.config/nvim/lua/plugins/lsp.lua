-- LSP: Language server configuration
-- LazyVim manages lua_ls and ts_ls by default
-- This adds ruby_lsp for Ruby/Rails development
-- Servers are auto-installed via Mason
-- See: https://github.com/neovim/nvim-lspconfig
return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      ruby_lsp = {},
    },
  },
}
