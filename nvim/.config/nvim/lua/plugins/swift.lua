-- Swift / iOS: build, run, test, and debug Apple apps without leaving Neovim.
-- xcodebuild.nvim wraps the `xcodebuild` CLI + `xcrun simctl` for simulators
-- and drives nvim-dap (codelldb) for debugging.
--
-- Code intelligence is separate: sourcekit-lsp is registered in lsp.lua, and
-- formatting/linting (swiftformat/swiftlint) live in formatting.lua/linting.lua.
--
-- Prerequisites (one-time):
--   * Full Xcode installed AND selected:
--       sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
--   * CLI tools via Homebrew (in the Brewfile): xcbeautify, xcode-build-server,
--     swiftformat, swiftlint, xcodegen
--   * Per project, so sourcekit-lsp understands the Xcode project, generate a
--     buildServer.json once (and after scheme/target changes):
--       xcode-build-server config -scheme <Scheme> -project <Name>.xcodeproj
--       # or, for a workspace:
--       xcode-build-server config -scheme <Scheme> -workspace <Name>.xcworkspace
--
-- Keymaps live under <leader>X (capital) to avoid LazyVim's <leader>x Trouble
-- group. <leader>Xf opens the picker listing every available action.
-- See: https://github.com/wojciech-kulik/xcodebuild.nvim
return {
  -- Debugging stack for xcodebuild.nvim. On Xcode 16+ it uses the toolchain's
  -- native LLDB (no codelldb needed), but still needs an nvim-dap client + UI.
  -- This is LazyVim's standard dap setup (nvim-dap + dap-ui + virtual text +
  -- mason-nvim-dap) and owns nvim-dap's config correctly — hand-wiring nvim-dap
  -- raw makes lazy.nvim try to call a non-existent dap.setup(). Adds <leader>d.
  { import = "lazyvim.plugins.extras.dap.core" },

  {
    "wojciech-kulik/xcodebuild.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim", -- required: floating code-coverage UI
      "folke/snacks.nvim", -- our picker + SwiftUI/snapshot previews
      "nvim-treesitter/nvim-treesitter", -- Quick test framework support
    },
    ft = { "swift", "objc", "objcpp" },
    cmd = {
      "XcodebuildPicker",
      "XcodebuildBuild",
      "XcodebuildBuildRun",
      "XcodebuildTest",
      "XcodebuildSelectScheme",
      "XcodebuildSelectDevice",
    },
    -- stylua: ignore
    keys = {
      { "<leader>X", "", desc = "+xcode/iOS" },
      { "<leader>Xf", "<cmd>XcodebuildPicker<cr>", desc = "Show all xcodebuild actions" },
      { "<leader>Xb", "<cmd>XcodebuildBuild<cr>", desc = "Build project" },
      { "<leader>Xr", "<cmd>XcodebuildBuildRun<cr>", desc = "Build & run" },
      { "<leader>Xt", "<cmd>XcodebuildTest<cr>", desc = "Run tests" },
      { "<leader>XT", "<cmd>XcodebuildTestClass<cr>", desc = "Run current test class" },
      { "<leader>Xl", "<cmd>XcodebuildToggleLogs<cr>", desc = "Toggle build/run logs" },
      { "<leader>Xs", "<cmd>XcodebuildSelectScheme<cr>", desc = "Select scheme" },
      { "<leader>Xd", "<cmd>XcodebuildSelectDevice<cr>", desc = "Select device / simulator" },
      { "<leader>Xc", "<cmd>XcodebuildToggleCodeCoverage<cr>", desc = "Toggle code coverage" },
      { "<leader>Xn", function() require("xcodebuild.integrations.dap").build_and_debug() end, desc = "Build & debug" },
      { "<leader>XN", function() require("xcodebuild.integrations.dap").debug_without_build() end, desc = "Debug without building" },
    },
    config = function()
      require("xcodebuild").setup({})
      -- Register the nvim-dap adapter for Apple-device debugging. On Xcode 16+
      -- this uses the native LLDB debugger, so no codelldb path is required.
      require("xcodebuild.integrations.dap").setup()
    end,
  },

  -- Swift treesitter parser (syntax, indentation, Quick test detection).
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "swift" } },
  },
}
