return {
  "greggh/claude-code.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  keys = {
    { "<leader>a", "", desc = "+ai" },
    { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude Code" },
  },
  opts = {
    window = {
      position = "float",
      float = {
        width = "90%",
        height = "90%",
        row = "center",
        col = "center",
        relative = "editor",
        border = "double",
      },
    },
  },
}
