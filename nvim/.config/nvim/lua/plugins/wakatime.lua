-- Automatic time tracking — logs coding activity to the WakaTime dashboard.
-- `lazy = false` so the timer starts at startup rather than on the first command.
-- Requires an API key in `~/.wakatime.cfg` (prompted for on first launch).
-- See: https://github.com/wakatime/vim-wakatime
return {
  "wakatime/vim-wakatime",
  lazy = false,
}
