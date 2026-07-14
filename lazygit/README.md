# lazygit

**Config:** `lazygit/.config/lazygit/config.yml`

Like lazydocker, lazygit defaults to `~/Library/Application Support/lazygit/` on macOS and is redirected to `~/.config/lazygit/config.yml` by `XDG_CONFIG_HOME` (see [fish › Environment](../fish/README.md#environment)). Currently sets `git.mainBranches` (`main`, `master`, `dev`) so upstream/recency detection works against the right base branch.
