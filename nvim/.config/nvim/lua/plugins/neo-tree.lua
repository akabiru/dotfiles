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
    vim.keymap.set("n", "<C-n>", ":Neotree filesystem toggle left<CR>")
  end,
}
