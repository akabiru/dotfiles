-- None-ls (null-ls): Linting and formatting via external tools
-- Diagnostics: rubocop (Ruby), erb_lint (ERB templates)
-- Formatting: rubocop (Ruby), prettierd (JS/TS/HTML/CSS/JSON), stylua (Lua)
-- JS/TS diagnostics handled by ts_ls (LSP) instead of eslint_d
-- <leader>cf to format current buffer
-- Prerequisites: `gem install erb_lint`, `:MasonInstall prettierd`
-- See: https://github.com/nvimtools/none-ls.nvim
return {
  "nvimtools/none-ls.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local null_ls = require("null-ls")

    null_ls.setup({
      sources = {
        null_ls.builtins.diagnostics.rubocop,
        null_ls.builtins.formatting.rubocop,
        null_ls.builtins.formatting.prettierd.with({
          filetypes = {
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
            "html",
            "css",
            "json",
            "yaml",
            "markdown",
          },
        }),
        null_ls.builtins.diagnostics.erb_lint,
        null_ls.builtins.formatting.stylua,
      },
    })

    vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format, { desc = "Format buffer" })
  end,
}
