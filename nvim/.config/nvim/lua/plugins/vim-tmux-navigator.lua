-- Vim-tmux-navigator: Seamless navigation between Neovim and tmux panes
-- Use Ctrl+h/j/k/l to move between splits, works across Neovim and tmux
-- Requires matching tmux plugin: christoomey/vim-tmux-navigator
-- See: https://github.com/christoomey/vim-tmux-navigator
return {
  "christoomey/vim-tmux-navigator",
  lazy = false,
  keys = {
    { "<C-h>", "<cmd>TmuxNavigateLeft<cr>", desc = "Navigate left" },
    { "<C-j>", "<cmd>TmuxNavigateDown<cr>", desc = "Navigate down" },
    { "<C-k>", "<cmd>TmuxNavigateUp<cr>", desc = "Navigate up" },
    { "<C-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Navigate right" },
  },
}
