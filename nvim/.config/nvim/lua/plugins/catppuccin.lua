-- Catppuccin: Soothing pastel color scheme for Neovim
-- Applied globally via colorscheme, with integrations for most plugins
-- See: https://github.com/catppuccin/nvim
return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      integrations = {
        gitsigns = true,
        mason = true,
        neotree = true,
        treesitter = true,
        which_key = true,
        bufferline = true,
        mini = { enabled = true },
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
      },
    })
    vim.cmd.colorscheme("catppuccin-mocha")
  end,
}
