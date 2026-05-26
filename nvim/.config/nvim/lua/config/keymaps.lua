-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

-- Copy relative path to clipboard
vim.keymap.set("n", "<leader>yp", function()
  local path = vim.fn.expand("%:.")
  vim.fn.setreg("+", path)
  vim.notify("Copied relative path: " .. path)
end, { desc = "Copy relative path" })

-- Copy absolute path to clipboard
vim.keymap.set("n", "<leader>yP", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  vim.notify("Copied absolute path: " .. path)
end, { desc = "Copy absolute path" })

-- Paste over a visual selection without clobbering the unnamed register
vim.keymap.set("x", "p", [["_dP]], { desc = "Paste without clobber" })
vim.keymap.set("x", "P", [["_dP]], { desc = "Paste without clobber" })
