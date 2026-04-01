-- Mini.surround: Add, delete, and replace surrounding characters
-- sa{motion}{char} = add surround (e.g., saiw" surrounds word with quotes)
-- sd{char} = delete surround (e.g., sd" removes surrounding quotes)
-- sr{old}{new} = replace surround (e.g., sr"' changes " to ')
-- See: https://github.com/echasnovski/mini.surround
return {
  "echasnovski/mini.surround",
  version = "*",
  event = "VeryLazy",
  opts = {},
}
