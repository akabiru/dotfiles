-- Blink.cmp: Fast autocompletion engine
-- Tab/S-Tab to navigate suggestions, Enter to confirm, C-space to toggle menu
-- Sources: LSP, file paths, snippets, buffer words
-- Includes friendly-snippets for common language snippets
-- See: https://github.com/saghen/blink.cmp
return {
  "saghen/blink.cmp",
  version = "1.*",
  dependencies = {
    "rafamadriz/friendly-snippets",
  },
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = { preset = "default" },
    appearance = {
      nerd_font_variant = "mono",
    },
    completion = {
      documentation = { auto_show = true },
    },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },
    signature = { enabled = true },
  },
}
