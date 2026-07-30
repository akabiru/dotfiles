-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Sync Neovim background with theme preference on focus.
-- Reads ~/.theme-mode for manual override (dark/light), falls back to macOS appearance (auto).
vim.api.nvim_create_autocmd("FocusGained", {
  group = vim.api.nvim_create_augroup("sync_background", { clear = true }),
  callback = function()
    local mode = "auto"
    local f = io.open(os.getenv("HOME") .. "/.theme-mode", "r")
    if f then
      mode = (f:read("*l") or "auto"):match("^%s*(.-)%s*$") or "auto"
      f:close()
    end

    local bg
    if mode == "dark" or mode == "light" then
      bg = mode
    else
      local handle = io.popen("defaults read -g AppleInterfaceStyle 2>/dev/null")
      if handle then
        local result = handle:read("*a")
        handle:close()
        bg = result:match("Dark") and "dark" or "light"
      end
    end

    if bg and vim.o.background ~= bg then
      vim.o.background = bg
    end
  end,
})

-- Reload files changed outside Neovim (e.g. by Claude Code in another tmux pane).
-- LazyVim has this on FocusGained, but tmux pane switches don't always trigger it.
vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
  group = vim.api.nvim_create_augroup("auto_checktime", { clear = true }),
  callback = function()
    vim.cmd.checktime()
  end,
})

-- Point Claude Code at the account that belongs to the current directory.
-- The `claude` fish function does this per-directory, but plugins spawn the binary
-- directly with no shell in between, so the mapping has to land on Neovim's own
-- environment for child processes to inherit it. An inherited value is left alone:
-- it means the account was already chosen upstream.
if not (vim.env.CLAUDE_CONFIG_DIR and vim.env.CLAUDE_CONFIG_DIR ~= "") then
  local function resolve_claude_config_dir()
    vim.system(
      { "/opt/homebrew/bin/fish", "-c", "_claude_config_dir" },
      { cwd = vim.fn.getcwd(), text = true },
      function(out)
        local dir = vim.trim(out.stdout or "")
        vim.schedule(function()
          -- An unmapped directory selects the default account, which is what no variable means.
          vim.env.CLAUDE_CONFIG_DIR = (out.code == 0 and dir ~= "") and dir or nil
        end)
      end
    )
  end

  resolve_claude_config_dir()
  vim.api.nvim_create_autocmd("DirChanged", {
    group = vim.api.nvim_create_augroup("claude_config_dir", { clear = true }),
    pattern = "global",
    callback = resolve_claude_config_dir,
  })
end

-- Refresh gitsigns when returning to Neovim so commits made in another pane
-- (or terminal) update the sign column without a manual :Gitsigns refresh.
vim.api.nvim_create_autocmd("FocusGained", {
  group = vim.api.nvim_create_augroup("gitsigns_refresh_on_focus", { clear = true }),
  callback = function()
    if package.loaded.gitsigns then
      require("gitsigns").refresh()
    end
  end,
})
