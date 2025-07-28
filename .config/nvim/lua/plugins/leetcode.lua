return {
  "kawre/leetcode.nvim",
  build = ":TSUpdate html",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-treesitter/nvim-treesitter",
    "rcarriga/nvim-notify",
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    arg = "lc",
    lang = "python",
    keys = {
      toggle = { "q", "<Esc>" },
      confirm = { "<CR>" },

      reset_testcases = "r",
      use_testcase = "U",
      focus_testcases = "H",
      focus_result = "L",
    },
  },
  lazy = "lc" ~= vim.fn.argv()[1],
}