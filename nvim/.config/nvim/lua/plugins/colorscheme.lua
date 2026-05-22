-- Colorscheme: Catppuccin (default), with gruvbox-material available for A/B.
-- Catppuccin auto-switches via vim.o.background (set by the FocusGained autocmd
-- in lua/config/autocmds.lua, which reads ~/.theme-mode written by `theme.fish`).
--   dark mode  → catppuccin-mocha
--   light mode → catppuccin-latte
-- A/B with gruvbox-material via `:colorscheme gruvbox-material`.
return {
  {
    "sainnhe/gruvbox-material",
    lazy = true,
    config = function()
      -- Warm cream/dark background, material (slightly desaturated) syntax palette.
      -- Tuned for long sessions: high enough contrast for tired eyes without harshness.
      vim.g.gruvbox_material_background = "medium"
      vim.g.gruvbox_material_foreground = "material"
      vim.g.gruvbox_material_better_performance = 1
      vim.g.gruvbox_material_enable_italic = 1
      vim.g.gruvbox_material_ui_contrast = "high"
      vim.g.gruvbox_material_diagnostic_text_highlight = 1
      vim.g.gruvbox_material_diagnostic_line_highlight = 1
    end,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      -- `flavour = "auto"` is required for catppuccin to react to vim.o.background.
      -- Without it, catppuccin pins to its default (mocha) and ignores background.
      flavour = "auto",
      background = { light = "latte", dark = "mocha" },
      custom_highlights = function(C)
        return {
          Cursor = { fg = C.base, bg = C.text },
          lCursor = { fg = C.base, bg = C.text },
          TermCursor = { fg = C.base, bg = C.text },
        }
      end,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "catppuccin" },
  },
}
