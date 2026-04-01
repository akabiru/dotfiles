-- LSP Configuration: Language server management via Mason + nvim-lspconfig
-- Mason auto-installs servers listed in ensure_installed
-- Servers: lua_ls (Lua), ruby_lsp (Ruby), ts_ls (TypeScript/JavaScript)
-- Keymaps: <leader>ca = code action (also available via gra)
-- See: https://github.com/neovim/nvim-lspconfig
return {
  {
    "mason-org/mason.nvim",
    lazy = false,
    config = function()
      require("mason").setup()
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    lazy = false,
    opts = {
      ensure_installed = { "lua_ls", "ruby_lsp", "ts_ls" },
      auto_install = true,
    },
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      local capabilities = require("blink.cmp").get_lsp_capabilities()
      vim.lsp.config("*", { capabilities = capabilities })

      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            workspace = { library = { vim.env.VIMRUNTIME } },
          },
        },
      })

      vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
    end,
  },
}
