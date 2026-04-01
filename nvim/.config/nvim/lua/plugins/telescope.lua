-- Telescope: Fuzzy finder for files, text, and more
-- <C-p> find files (includes hidden), <leader>fg live grep
-- Uses telescope-ui-select to render code actions and other menus as dropdowns
-- See: https://github.com/nvim-telescope/telescope.nvim
return {
  "nvim-telescope/telescope.nvim",
  tag = "v0.2.1",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-ui-select.nvim" },
  },
  config = function()
    require("telescope").setup({
      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_dropdown(),
        },
      },
    })
    require("telescope").load_extension("ui-select")

    local builtin = require("telescope.builtin")
    vim.keymap.set("n", "<C-p>", function() builtin.find_files({ hidden = true }) end, { desc = "Find files" })
    vim.keymap.set("n", "<leader>fg", function() builtin.live_grep({ additional_args = { "--hidden" } }) end, { desc = "Live grep" })
  end,
}
