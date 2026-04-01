-- Lualine: Status line showing mode, git branch, diagnostics, and more
-- Sections: [mode] [branch | diff] [filename] [diagnostics] [filetype] [line:col]
-- Uses catppuccin-mocha theme to match the editor colorscheme
-- See: https://github.com/nvim-lualine/lualine.nvim
return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("lualine").setup({
      options = {
        theme = "catppuccin-mocha",
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff" },
        lualine_c = { "filename" },
        lualine_x = { "diagnostics" },
        lualine_y = { "filetype" },
        lualine_z = { "location" },
      },
    })
  end,
}
