-- Colorscheme: Catppuccin Mocha (overrides LazyVim's default tokyonight)
-- Warm dark pastel theme, also used in tmux for a consistent look
-- See: https://github.com/catppuccin/nvim
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = { flavour = "mocha" },
  },
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "catppuccin" },
  },
}
