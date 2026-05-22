-- Colorscheme: gruvbox-material (trial), with Catppuccin kept available.
-- Both respect vim.o.background, so the dark/light auto-switch keeps working.
--   dark mode  → gruvbox-material (medium bg)
--   light mode → gruvbox-material (medium bg)
-- See: https://github.com/sainnhe/gruvbox-material
return {
  {
    "sainnhe/gruvbox-material",
    lazy = false,
    priority = 1000,
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
  -- Catppuccin kept installed so `:colorscheme catppuccin` works for quick A/B.
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
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
    opts = { colorscheme = "gruvbox-material" },
  },
}
