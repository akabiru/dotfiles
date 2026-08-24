-- Ctrl+h/j/k/l navigation across Neovim windows and multiplexer panes.
--
-- herdr has no way to inspect a pane's foreground process, so it cannot decide
-- whether a keypress belongs to Neovim. The decision is made here instead:
-- ctrl+hjkl stays unbound in herdr, and Neovim hands off only once a window
-- move has failed, which means we were already at the edge of the layout.
local M = {}

local HERDR_DIRECTION = { h = "left", j = "down", k = "up", l = "right" }
local TMUX_COMMAND = { h = "TmuxNavigateLeft", j = "TmuxNavigateDown", k = "TmuxNavigateUp", l = "TmuxNavigateRight" }

function M.navigate(direction)
  if not vim.env.HERDR_PANE_ID then
    vim.cmd(TMUX_COMMAND[direction]) -- falls back to a plain wincmd outside tmux
    return
  end

  local before = vim.fn.winnr()
  vim.cmd.wincmd(direction)
  if vim.fn.winnr() == before then
    vim.system({ "herdr", "pane", "focus", "--current", "--direction", HERDR_DIRECTION[direction] })
  end
end

return M
