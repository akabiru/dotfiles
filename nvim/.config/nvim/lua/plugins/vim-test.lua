-- vim-test with vimux strategy: runs tests in a tmux pane
-- See: https://github.com/vim-test/vim-test
return {
  "vim-test/vim-test",
  dependencies = {
    "preservim/vimux",
  },
  config = function()
    vim.cmd("let test#strategy = 'vimux'")
    vim.keymap.set("n", "<leader>tn", ":TestNearest<CR>", { desc = "Run nearest test" })
    vim.keymap.set("n", "<leader>tf", ":TestFile<CR>", { desc = "Run test file" })
    vim.keymap.set("n", "<leader>ts", ":TestSuite<CR>", { desc = "Run test suite" })
    vim.keymap.set("n", "<leader>tl", ":TestLast<CR>", { desc = "Run last test" })
    vim.keymap.set("n", "<leader>tv", ":TestVisit<CR>", { desc = "Visit test file" })
  end,
}
