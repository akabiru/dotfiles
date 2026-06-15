-- vim-test with vimux strategy: runs tests in a tmux pane
-- See: https://github.com/vim-test/vim-test
return {
  "vim-test/vim-test",
  dependencies = {
    "preservim/vimux",
  },
  config = function()
    vim.cmd("let test#strategy = 'vimux'")

    -- Dockerized OpenProject-style repos can't run rspec on the host; tests
    -- run inside the container via `bin/compose rspec`. Detect that layout
    -- (a `bin/compose` script alongside a `docker-compose.yml`) and point the
    -- rspec runner at it. Any other Ruby project keeps the default binstub.
    local function set_ruby_runner()
      local file = vim.api.nvim_buf_get_name(0)
      local from = file ~= "" and vim.fs.dirname(file) or vim.fn.getcwd()
      local compose = vim.fs.find("docker-compose.yml", { upward = true, path = from })[1]
      local root = compose and vim.fs.dirname(compose)
      if root and vim.fn.filereadable(root .. "/bin/compose") == 1 then
        vim.g["test#ruby#rspec#executable"] = "bin/compose rspec"
      else
        vim.g["test#ruby#rspec#executable"] = nil -- fall back to vim-test's default
      end
    end

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "ruby",
      callback = set_ruby_runner,
      desc = "Use `bin/compose rspec` inside dockerized OpenProject repos",
    })

    vim.keymap.set("n", "<leader>tn", ":TestNearest<CR>", { desc = "Run nearest test" })
    vim.keymap.set("n", "<leader>tf", ":TestFile<CR>", { desc = "Run test file" })
    vim.keymap.set("n", "<leader>ts", ":TestSuite<CR>", { desc = "Run test suite" })
    vim.keymap.set("n", "<leader>tl", ":TestLast<CR>", { desc = "Run last test" })
    vim.keymap.set("n", "<leader>tv", ":TestVisit<CR>", { desc = "Visit test file" })
  end,
}
