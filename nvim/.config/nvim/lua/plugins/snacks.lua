-- Snacks: Override to show dotfiles in explorer
-- Toggle at runtime: H for hidden files, I for gitignored files
return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        explorer = {
          hidden = true,
        },
        files = {
          hidden = true,
        },
        grep = {
          hidden = true,
        },
      },
    },
  },
}
