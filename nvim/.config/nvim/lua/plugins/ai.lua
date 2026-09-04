-- claudecode.nvim: Claude Code integration for Neovim.
-- Starts a WebSocket MCP server so the `claude` CLI (running in a terminal split)
-- can read the current buffer, selection, and diagnostics, and propose diffs
-- that are reviewed inline via <leader>aa / <leader>ad.
--
-- Requires the `claude` CLI on PATH (installed via the VS Code/Claude Code app).
-- Keymaps live under the <leader>a "ai" group.
return {
  "coder/claudecode.nvim",
  opts = {
    -- Claude runs under nvim's terminal emulator, not tmux. With $TMUX inherited it wraps
    -- OSC 52 clipboard writes in tmux passthrough, which libvterm renders as literal text.
    env = { TMUX = "" },
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
