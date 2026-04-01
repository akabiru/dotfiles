-- Gitsigns: Git integration in the sign column (gutter)
-- Shows added/modified/deleted lines, stage/reset hunks inline
-- ]h/[h to navigate hunks, <leader>gs stage, <leader>gr reset
-- <leader>gb blame line, <leader>gd diff, <leader>gp preview hunk
-- See: https://github.com/lewis6991/gitsigns.nvim
return {
  "lewis6991/gitsigns.nvim",
  event = "VeryLazy",
  opts = {
    on_attach = function(bufnr)
      local gs = require("gitsigns")
      local function map(mode, l, r, desc)
        vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
      end

      map("n", "]h", gs.next_hunk, "Next hunk")
      map("n", "[h", gs.prev_hunk, "Prev hunk")
      map("n", "<leader>gs", gs.stage_hunk, "Stage hunk")
      map("n", "<leader>gr", gs.reset_hunk, "Reset hunk")
      map("n", "<leader>gp", gs.preview_hunk, "Preview hunk")
      map("n", "<leader>gb", gs.blame_line, "Blame line")
      map("n", "<leader>gd", gs.diffthis, "Diff this")

      map("v", "<leader>gs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Stage hunk")
      map("v", "<leader>gr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Reset hunk")
    end,
  },
}
