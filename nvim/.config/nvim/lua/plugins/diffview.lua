-- Full 3-way merge view (base / ours / theirs) for the gnarly conflicts,
-- plus a rich diff and file-history browser.
-- During a merge, `:DiffviewOpen` shows every conflicted file; inside the
-- merge tool use <leader>co/ct/cb/ca to take a side and ]x / [x to navigate.
-- See: https://github.com/sindrets/diffview.nvim
return {
  "sindrets/diffview.nvim",
  cmd = {
    "DiffviewOpen",
    "DiffviewClose",
    "DiffviewToggleFiles",
    "DiffviewFocusFiles",
    "DiffviewFileHistory",
  },
  opts = {
    enhanced_diff_hl = true,
    view = {
      merge_tool = {
        layout = "diff3_mixed", -- base in the middle, ours/theirs on the sides
        disable_diagnostics = true,
      },
    },
  },
  -- Note: <leader>gd is already LazyVim's "Git Diff (hunks)", so diffview
  -- lives under <leader>gv ("v" = diffVIEW) to avoid clobbering it.
  keys = {
    { "<leader>gvo", "<cmd>DiffviewOpen<cr>", desc = "Diffview: open (merge/diff)" },
    { "<leader>gvc", "<cmd>DiffviewClose<cr>", desc = "Diffview: close" },
    { "<leader>gvh", "<cmd>DiffviewFileHistory %<cr>", desc = "Diffview: current file history" },
    { "<leader>gvH", "<cmd>DiffviewFileHistory<cr>", desc = "Diffview: repo history" },
  },
}
