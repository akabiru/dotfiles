-- VSCode-style inline merge conflict resolution.
-- Highlights <<<<<<< / ======= / >>>>>>> regions and lets you accept
-- ours / theirs / both / none right in the buffer.
-- See: https://github.com/akinsho/git-conflict.nvim
return {
  "akinsho/git-conflict.nvim",
  version = "*",
  event = "BufReadPre",
  opts = {
    -- Buffer-local mappings active inside a conflicted file:
    --   co → accept ours (current)   ct → accept theirs (incoming)
    --   cb → accept both             c0 → accept none
    --   ]x / [x → next / prev conflict
    default_mappings = true,
    default_commands = true,
    disable_diagnostics = false,
    list_opener = "copen",
    highlights = {
      incoming = "DiffAdd",
      current = "DiffText",
    },
  },
  keys = {
    { "<leader>gxo", "<cmd>GitConflictChooseOurs<cr>", desc = "Conflict: accept ours (current)" },
    { "<leader>gxt", "<cmd>GitConflictChooseTheirs<cr>", desc = "Conflict: accept theirs (incoming)" },
    { "<leader>gxb", "<cmd>GitConflictChooseBoth<cr>", desc = "Conflict: accept both" },
    { "<leader>gx0", "<cmd>GitConflictChooseNone<cr>", desc = "Conflict: accept none" },
    { "<leader>gxl", "<cmd>GitConflictListQf<cr>", desc = "Conflict: list all (quickfix)" },
    { "]x", "<cmd>GitConflictNextConflict<cr>", desc = "Next conflict" },
    { "[x", "<cmd>GitConflictPrevConflict<cr>", desc = "Prev conflict" },
  },
}
