-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Sync Neovim background with macOS appearance on focus.
-- When running in tmux, Ghostty's OSC 11 background signal can be lost on theme switches.
-- This queries macOS directly and updates vim.o.background accordingly.
vim.api.nvim_create_autocmd("FocusGained", {
  group = vim.api.nvim_create_augroup("sync_background", { clear = true }),
  callback = function()
    local handle = io.popen("defaults read -g AppleInterfaceStyle 2>/dev/null")
    if handle then
      local result = handle:read("*a")
      handle:close()
      local bg = result:match("Dark") and "dark" or "light"
      if vim.o.background ~= bg then
        vim.o.background = bg
      end
    end
  end,
})
