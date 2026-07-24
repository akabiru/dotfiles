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

    -- OpenProject's frontend Vitest specs only resolve through the Angular
    -- esbuild builder (`ng test`): it wires up the `core-*` tsconfig path
    -- aliases and the test setup. vim-test would shell out to bare vitest and
    -- fail. So run the spec through the builder, the same way `set_ruby_runner`
    -- routes rspec. jsdom can't be forced from the CLI (the builder schema
    -- requires >=1 browser), so pin a single headless chromium.
    --
    -- Returns (repo_root, path_relative_to_frontend) for an OpenProject
    -- frontend spec, or nil to let vim-test handle the file normally.
    local function op_frontend_spec()
      local file = vim.api.nvim_buf_get_name(0)
      if not file:match("%.spec%.ts$") then
        return nil
      end

      local angular = vim.fs.find("angular.json", { upward = true, path = vim.fs.dirname(file) })[1]
      if not angular then
        return nil
      end
      local frontend = vim.fs.dirname(angular)

      -- Gate strictly to OpenProject: its frontend package names itself, so this
      -- never fires in another Angular repo that happens to share the layout.
      -- The marker is intrinsic to the checkout, so it also holds in worktrees
      -- and any clone location.
      local pkg = frontend .. "/package.json"
      if vim.fn.filereadable(pkg) ~= 1 then
        return nil
      end
      if not table.concat(vim.fn.readfile(pkg), "\n"):find('"openproject-frontend"', 1, true) then
        return nil
      end

      local repo = vim.fs.dirname(frontend) -- frontend/ sits directly under the repo root
      return repo, file:sub(#frontend + 2) -- strip "<frontend>/" prefix
    end

    local function run_test_file()
      local repo, rel = op_frontend_spec()
      if not repo then
        vim.cmd("TestFile") -- default vim-test behaviour for every other project
        return
      end

      -- The spec path comes from the opened buffer, so its components are
      -- attacker-controlled in a cloned repo. Every segment interpolated into a
      -- shell string is passed through vim.fn.shellescape() before it reaches
      -- the shell to prevent command injection.
      --
      -- `config/database.yml` is the local-setup marker (the docker setup
      -- forbids it, which is how bin/compose itself tells the two apart). Local:
      -- run on the host. Docker: exec into the running `frontend` container.
      local cmd
      if vim.fn.filereadable(repo .. "/config/database.yml") == 1 then
        cmd = string.format(
          "cd %s/frontend && npm test -- --include=%s --browsers=chromium --headless",
          vim.fn.shellescape(repo),
          vim.fn.shellescape(rel)
        )
      else
        -- The docker branch is parsed by two shells: the tmux pane shell, then
        -- the inner `bash -lc`. So `rel` is escaped for the inner bash, and the
        -- whole inner script is escaped again for the outer shell.
        -- bin/compose resolves a relative compose file, so it must run from the
        -- repo root; the container WORKDIR is already `frontend/`.
        local inner = string.format(
          "npm test -- --include=%s --browsers=chromium --headless",
          vim.fn.shellescape(rel)
        )
        cmd = string.format(
          "cd %s && bin/compose exec frontend bash -lc %s",
          vim.fn.shellescape(repo),
          vim.fn.shellescape(inner)
        )
      end
      vim.fn.VimuxRunCommand(cmd)
    end

    vim.keymap.set("n", "<leader>tn", ":TestNearest<CR>", { desc = "Run nearest test" })
    vim.keymap.set("n", "<leader>tf", run_test_file, { desc = "Run test file" })
    vim.keymap.set("n", "<leader>ts", ":TestSuite<CR>", { desc = "Run test suite" })
    vim.keymap.set("n", "<leader>tl", ":TestLast<CR>", { desc = "Run last test" })
    vim.keymap.set("n", "<leader>tv", ":TestVisit<CR>", { desc = "Visit test file" })
  end,
}
