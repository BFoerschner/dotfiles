return {
  "A7Lavinraj/fyler.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    icon_provider = "nvim-web-devicons",
    mappings = {
      confirm = {
        n = {
          ["y"] = "Confirm",
          ["n"] = "Discard",
        },
      },
      explorer = {
        n = {
          ["q"] = "CloseView",
          ["<CR>"] = "Select",
          ["<Right>"] = "Select",
          ["<Left>"] = "Select",
        },
      },
    },
  },
}