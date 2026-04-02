-- Colorscheme: Catppuccin (overrides LazyVim's default tokyonight)
-- Adapts to system appearance via Ghostty's background detection:
--   dark mode  → Catppuccin Mocha
--   light mode → Catppuccin Latte
-- See: https://github.com/catppuccin/nvim
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
  },
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "catppuccin" },
  },
}
