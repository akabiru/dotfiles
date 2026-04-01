-- Which-Key: Displays a popup with available keybindings as you type
-- Press <leader> (space) and wait — all available keymaps appear organized by group
-- Automatically discovers any keymap with a `desc` field
-- See: https://github.com/folke/which-key.nvim
return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    spec = {
      { "<leader>b", group = "buffer" },
      { "<leader>c", group = "code" },
      { "<leader>f", group = "find" },
      { "<leader>g", group = "git" },
      { "<leader>t", group = "test" },
      { "<leader>x", group = "diagnostics" },
    },
  },
}
