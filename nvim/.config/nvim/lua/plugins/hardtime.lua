-- Hardtime: breaks bad habits by nagging/blocking inefficient motions
-- (repeated hjkl, arrow keys) and hinting the idiomatic alternative
-- See: https://github.com/m4xshen/hardtime.nvim
return {
  "m4xshen/hardtime.nvim",
  lazy = false,
  opts = {},
  config = function(_, opts)
    require("hardtime").setup(opts)
    require("coach").setup()
  end,
}
