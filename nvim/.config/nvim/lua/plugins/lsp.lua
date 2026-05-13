-- LSP: Language server configuration
-- LazyVim manages lua_ls and ts_ls by default
-- This adds ruby_lsp for Ruby/Rails development
-- See: https://github.com/neovim/nvim-lspconfig
--
-- ruby_lsp is launched via the rbenv shim (not Mason) so it picks up the
-- right Ruby per project .ruby-version. Mason's shim has a hardcoded
-- shebang pinning a single Ruby, which breaks projects on other versions.
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ruby_lsp = {
          mason = false,
          cmd = { vim.fn.expand("~/.rbenv/shims/ruby-lsp") },
        },
      },
    },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      opts.ensure_installed = vim.tbl_filter(function(s)
        return s ~= "ruby_lsp"
      end, opts.ensure_installed)
      return opts
    end,
  },
}
