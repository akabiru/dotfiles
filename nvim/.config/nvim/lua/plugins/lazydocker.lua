-- Lazydocker in a floating window — manage containers, images, logs, and
-- volumes without leaving Neovim. Requires the `lazydocker` binary on PATH.
-- See: https://github.com/mgierada/lazydocker.nvim
return {
  "mgierada/lazydocker.nvim",
  dependencies = { "akinsho/toggleterm.nvim" },
  opts = {
    border = "curved", -- "single" | "double" | "shadow" | "curved"
    width = 0.9, -- 0-1 for a percentage of the editor, >1 for absolute columns
    height = 0.9, -- 0-1 for a percentage of the editor, >1 for absolute rows
  },
  -- Note: <leader>l is LazyVim's direct ":Lazy" mapping, so a <leader>ld
  -- binding would stall it on a which-key timeout. Live on <leader>D instead.
  keys = {
    { "<leader>D", function() require("lazydocker").open() end, desc = "Open Lazydocker" },
  },
}
