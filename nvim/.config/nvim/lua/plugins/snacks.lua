-- Snacks: Override to show dotfiles in explorer
-- Toggle at runtime: H for hidden files, I for gitignored files

-- Review-oriented layout for the GitHub PR pickers (<leader>gp and its diff view):
-- near-fullscreen, file list 30% / preview 70% so reading the diff gets the space.
-- A full inline layout (not just tweaked fields) is required: snacks only skips
-- the preset when layout.layout[1] is set.
local gh_review_layout = {
  layout = {
    box = "horizontal",
    width = 0.95,
    min_width = 120,
    height = 0.9,
    {
      box = "vertical",
      border = true,
      title = "{title} {live} {flags}",
      { win = "input", height = 1, border = "bottom" },
      { win = "list", border = "none" },
    },
    { win = "preview", title = "{preview}", border = true, width = 0.7 },
  },
}

return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        explorer = {
          hidden = true,
          ignored = true,
        },
        files = {
          hidden = true,
        },
        grep = {
          hidden = true,
        },
        gh_pr = {
          layout = gh_review_layout,
        },
        gh_diff = {
          layout = gh_review_layout,
        },
      },
    },
  },
}
