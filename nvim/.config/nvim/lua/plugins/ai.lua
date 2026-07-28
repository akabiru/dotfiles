-- claudecode.nvim: Claude Code integration for Neovim.
-- Starts a WebSocket MCP server so the `claude` CLI can read the current buffer,
-- selection, and diagnostics, and propose diffs reviewed inline via <leader>aa / <leader>ad.
--
-- The terminal floats: this instance answers questions about a selection, and stays
-- separate from the long-running Claude driven in its own tmux pane. Sends go to every
-- client attached to this server, so keep that tmux session off `/ide` or it gets them too.
--
-- Requires the `claude` CLI on PATH (installed via the VS Code/Claude Code app).
-- Keymaps live under the <leader>a "ai" group.
return {
  "coder/claudecode.nvim",
  opts = {
    focus_after_send = true,
    terminal = {
      provider = "snacks",
      snacks_win_opts = {
        position = "float",
        width = 0.75,
        height = 0.8,
        border = "rounded",
        title = " Claude (context) ",
        title_pos = "center",
      },
    },
  },
  keys = {
    { "<leader>a", "", desc = "+ai", mode = { "n", "v" } },
    { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
    { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
    { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
    { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
    { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
    { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
    {
      "<leader>as",
      "<cmd>ClaudeCodeTreeAdd<cr>",
      desc = "Add file",
      ft = { "NvimTree", "neo-tree", "oil" },
    },
    -- Diff management
    { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
    { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
  },
}
