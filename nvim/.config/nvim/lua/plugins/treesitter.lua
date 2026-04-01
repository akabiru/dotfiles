-- Treesitter: Advanced syntax highlighting and code parsing
-- Auto-installs parsers for any language you open
-- Provides better highlighting and indentation than regex-based syntax
-- See: https://github.com/nvim-treesitter/nvim-treesitter
return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  opts = {
    auto_install = true,
    highlight = { enable = true },
    indent = { enable = true },
  },
}
