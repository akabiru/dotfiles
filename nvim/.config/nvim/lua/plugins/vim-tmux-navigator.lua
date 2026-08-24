-- Ctrl+h/j/k/l moves between Neovim splits and multiplexer panes.
-- The keys route through config.herdr-nav, which picks herdr or tmux at runtime.
-- The tmux side needs the matching christoomey/vim-tmux-navigator plugin loaded
-- in .tmux.conf; herdr needs no counterpart.
-- See: nvim/docs/navigation.md
return {
  "christoomey/vim-tmux-navigator",
  lazy = false,
  keys = {
    { "<C-h>", function() require("config.herdr-nav").navigate("h") end, desc = "Navigate left" },
    { "<C-j>", function() require("config.herdr-nav").navigate("j") end, desc = "Navigate down" },
    { "<C-k>", function() require("config.herdr-nav").navigate("k") end, desc = "Navigate up" },
    { "<C-l>", function() require("config.herdr-nav").navigate("l") end, desc = "Navigate right" },
  },
}
