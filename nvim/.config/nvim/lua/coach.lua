-- Coach: on-demand AI feedback on vim habits, fed by hardtime.nvim's log.
-- :CoachReport aggregates the log and asks the claude CLI for focused advice.
local M = {}

local function log_path()
  return vim.fn.stdpath("log") .. "/hardtime.nvim.log"
end

-- Offset into the hardtime log marking where the previous report stopped,
-- kept in a sidecar file so hardtime's own log stays untouched. The head
-- line detects log rotation/truncation, which resets the offset.
local function cursor_path()
  return vim.fn.stdpath("data") .. "/coach_cursor.json"
end

local function read_cursor()
  local ok, lines = pcall(vim.fn.readfile, cursor_path())
  if not ok or #lines == 0 then
    return nil
  end
  local ok_decode, cursor = pcall(vim.json.decode, table.concat(lines, "\n"))
  return ok_decode and cursor or nil
end

local function write_cursor(count, head)
  vim.fn.writefile({ vim.json.encode({ count = count, head = head }) }, cursor_path())
end

-- Returns only the lines added since the stored cursor.
local function new_lines(lines)
  local cursor = read_cursor()
  if not cursor or cursor.head ~= lines[1] or cursor.count > #lines then
    return lines
  end
  return vim.list_slice(lines, cursor.count + 1)
end

-- Aggregate log lines into "<count>x <hint>" entries, most frequent first.
local function aggregate(lines)
  local counts = {}
  for _, line in ipairs(lines) do
    local hint = line:gsub("%[.-%] ", "")
    if hint ~= "" then
      counts[hint] = (counts[hint] or 0) + 1
    end
  end
  local sorted = {}
  for hint, count in pairs(counts) do
    table.insert(sorted, { hint = hint, count = count })
  end
  table.sort(sorted, function(a, b)
    return a.count > b.count
  end)
  return sorted
end

local function build_prompt(entries)
  local habits = {}
  for _, e in ipairs(entries) do
    table.insert(habits, string.format("%dx %s", e.count, e.hint))
  end
  return table.concat({
    "You are a vim motions coach. Below are my aggregated hardtime.nvim hints:",
    "each line is how often I triggered an inefficient-motion warning, most frequent first.",
    "",
    table.concat(habits, "\n"),
    "",
    "Give me:",
    "1. My top 3 habits to fix, worst first, each with the idiomatic alternative and a one-line drill.",
    "2. Any keymap or plugin suggestion that would remove the temptation entirely.",
    "Be specific and terse. Markdown, no preamble.",
    "Afterwards, answer my follow-up questions as the same coach.",
  }, "\n")
end

-- Interactive claude session in a floating terminal, seeded with the prompt
-- so the conversation can continue after the initial report.
local function open_chat(prompt)
  local width = math.floor(vim.o.columns * 0.75)
  local height = math.floor(vim.o.lines * 0.8)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    col = math.floor((vim.o.columns - width) / 2),
    row = math.floor((vim.o.lines - height) / 2),
    style = "minimal",
    border = "rounded",
    title = " Coach ",
  })
  vim.fn.jobstart({ "claude", prompt }, { term = true })
  vim.cmd.startinsert()
end

-- opts.full sends the whole log instead of just lines since the last report.
function M.report(opts)
  local ok, lines = pcall(vim.fn.readfile, log_path())
  if not ok or #lines == 0 then
    vim.notify("Coach: no hardtime log yet at " .. log_path(), vim.log.levels.WARN)
    return
  end
  local batch = (opts and opts.full) and lines or new_lines(lines)
  if #batch == 0 then
    vim.notify("Coach: nothing new since last report (:CoachReport! for full log)", vim.log.levels.INFO)
    return
  end
  local entries = aggregate(batch)
  if vim.fn.executable("claude") ~= 1 then
    vim.notify("Coach: claude CLI not found on PATH", vim.log.levels.ERROR)
    return
  end
  -- The cursor advances at launch: an interactive session has no success
  -- callback, and :CoachReport! recovers the rare failed run.
  write_cursor(#lines, lines[1])
  open_chat(build_prompt(entries))
end

function M.setup()
  vim.api.nvim_create_user_command("CoachReport", function(cmd)
    M.report({ full = cmd.bang })
  end, {
    bang = true,
    desc = "AI feedback on new vim habits since last report (! for full log)",
  })
end

return M
