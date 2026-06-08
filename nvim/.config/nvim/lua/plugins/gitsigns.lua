-- Enable inline current-line git blame (GitLens-style virtual text at EOL)
-- See: https://github.com/lewis6991/gitsigns.nvim
local function open_pr_for_line()
  local file = vim.fn.expand("%:p")
  if file == "" then
    return
  end
  local line = vim.fn.line(".")

  local blame = vim.fn.systemlist({
    "git", "-C", vim.fn.fnamemodify(file, ":h"),
    "blame", "-L", line .. "," .. line, "--porcelain", "--", file,
  })
  if vim.v.shell_error ~= 0 or vim.tbl_isempty(blame) then
    vim.notify("git blame failed", vim.log.levels.WARN)
    return
  end
  local sha = blame[1]:match("^(%S+)")
  if not sha or sha:match("^0+$") then
    vim.notify("Line is uncommitted", vim.log.levels.INFO)
    return
  end

  local result = vim.fn.systemlist({
    "gh", "pr", "list",
    "--search", sha,
    "--state", "merged",
    "--json", "number,title,url",
    "--limit", "1",
  })
  if vim.v.shell_error ~= 0 then
    vim.notify("gh pr list failed:\n" .. table.concat(result, "\n"), vim.log.levels.ERROR)
    return
  end
  local ok, data = pcall(vim.json.decode, table.concat(result, "\n"))
  if not ok or type(data) ~= "table" or #data == 0 then
    vim.notify(("No merged PR found for %s"):format(sha:sub(1, 7)), vim.log.levels.INFO)
    return
  end
  local pr = data[1]
  vim.notify(("PR #%d • %s"):format(pr.number, pr.title))
end

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
    -- NOTE: <leader>gP is taken by LazyVim's snacks_picker extra (GitHub PRs);
    -- this line-PR lookup lives on <leader>gL ("PR for Line") to avoid the clash.
    { "<leader>gL", open_pr_for_line, desc = "Open GitHub PR for current line" },
  },
}
