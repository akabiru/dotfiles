-- Runs test commands in a herdr pane, the way vimux does under tmux.
-- `pane run` types into the pane's live shell, so the runner keeps its history
-- and scrollback across repeated runs.
local M = {}

local RATIO = 0.25

local runner -- pane id, reused until the pane is closed

local function alive(pane_id)
  return pane_id ~= nil and vim.system({ "herdr", "pane", "get", pane_id }):wait().code == 0
end

local function ensure_runner()
  if alive(runner) then
    return runner
  end

  local split = vim.system({
    "herdr",
    "pane",
    "split",
    vim.env.HERDR_PANE_ID,
    "--direction",
    "down",
    "--ratio",
    tostring(RATIO),
  }):wait()

  if split.code ~= 0 then
    return nil, split.stderr
  end

  local ok, response = pcall(vim.json.decode, split.stdout)
  if not ok or not (response.result and response.result.pane) then
    return nil, split.stdout
  end

  runner = response.result.pane.pane_id
  return runner
end

function M.run(cmd)
  local pane_id, err = ensure_runner()
  if not pane_id then
    vim.notify("herdr: could not open a test pane\n" .. (err or ""), vim.log.levels.ERROR)
    return
  end

  vim.system({ "herdr", "pane", "run", pane_id, cmd })
end

return M
