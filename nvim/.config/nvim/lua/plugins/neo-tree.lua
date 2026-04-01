-- Neo-tree: File explorer sidebar
-- <C-n> or <leader>e to toggle, press `/` inside neo-tree to search
-- Shows dotfiles, auto-focuses file buffer after opening
-- See: https://github.com/nvim-neo-tree/neo-tree.nvim
return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  lazy = false,
  config = function()
    require("neo-tree").setup({
      close_if_last_window = true,
      filesystem = {
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
        },
      },
      event_handlers = {
        {
          event = "file_opened",
          handler = function()
            vim.cmd("wincmd p")
          end,
        },
      },
    })
    vim.keymap.set("n", "<C-n>", ":Neotree filesystem toggle left<CR>", { desc = "Toggle file tree" })
    vim.keymap.set("n", "<leader>e", ":Neotree filesystem toggle left<CR>", { desc = "Explorer (neo-tree)" })
  end,
}
