-- Neotest: Test runner with RSpec adapter for Ruby/Rails
-- <leader>tn run nearest test, <leader>tf run current file
-- <leader>ts toggle test summary panel, <leader>to show test output
-- Requires the test extra enabled in lazy.lua
-- See: https://github.com/nvim-neotest/neotest
return {
  "nvim-neotest/neotest",
  dependencies = {
    "olimorris/neotest-rspec",
  },
  opts = {
    adapters = {
      ["neotest-rspec"] = {},
    },
  },
}
