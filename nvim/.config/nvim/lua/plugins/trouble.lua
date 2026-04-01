-- Trouble: Pretty diagnostics, references, and quickfix browser
-- <leader>xx toggle all diagnostics, <leader>xd buffer diagnostics only
-- <leader>xl location list, <leader>xq quickfix list
-- gR to browse LSP references for symbol under cursor
-- See: https://github.com/folke/trouble.nvim
return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  cmd = "Trouble",
  keys = {
    { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
    { "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer diagnostics" },
    { "<leader>xl", "<cmd>Trouble loclist toggle<cr>", desc = "Location list" },
    { "<leader>xq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix list" },
    { "gR", "<cmd>Trouble lsp_references toggle<cr>", desc = "LSP references (Trouble)" },
  },
  opts = {},
}
