-- Enable inline current-line git blame (GitLens-style virtual text at EOL)
-- See: https://github.com/lewis6991/gitsigns.nvim
return {
  "lewis6991/gitsigns.nvim",
  opts = {
    current_line_blame = true,
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = "eol",
      delay = 300,
      ignore_whitespace = false,
    },
    current_line_blame_formatter = "  <author>, <author_time:%R> • <summary>",
  },
  keys = {
    { "<leader>gb", function() require("gitsigns").blame_line({ full = true }) end, desc = "Blame line (full)" },
    { "<leader>gB", function() require("gitsigns").toggle_current_line_blame() end, desc = "Toggle inline blame" },
  },
}
