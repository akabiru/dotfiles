return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  opts = {
    ensure_installed = {"lua", "javascript", "typescript", "ruby"},
    highlight = { enable = true },
    indent = { enable = true },
  },
}
