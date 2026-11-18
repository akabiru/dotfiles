-- Formatting: Code formatters via conform.nvim (LazyVim's default formatter)
-- <leader>cf to format buffer (LazyVim default keymap)
-- rubocop for Ruby, prettierd (only with a project Prettier config) then eslint_d for JS/TS,
-- prettierd for other web files, swiftformat for Swift, stylua for Lua
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
        -- Without a project Prettier config, prettierd would apply Prettier defaults
        -- and fight the project's own style (e.g. ESLint stylistic rules).
        prettierd = {
          condition = function(_, ctx)
            return vim.fs.find({
              ".prettierrc",
              ".prettierrc.json",
              ".prettierrc.yml",
              ".prettierrc.yaml",
              ".prettierrc.js",
              ".prettierrc.cjs",
              ".prettierrc.mjs",
              "prettier.config.js",
              "prettier.config.cjs",
              "prettier.config.mjs",
            }, { path = ctx.filename, upward = true })[1] ~= nil
          end,
        },
      },
      formatters_by_ft = {
        ruby = { "rubocop" },
        javascript = { "prettierd", "eslint_d" },
        javascriptreact = { "prettierd", "eslint_d" },
        typescript = { "prettierd", "eslint_d" },
        typescriptreact = { "prettierd", "eslint_d" },
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
  -- list, so these are appended to its defaults (stylua, shfmt, etc.).
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "prettierd", "eslint_d" } },
  },
}
