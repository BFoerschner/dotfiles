return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "LazyFile", "VeryLazy" },
  lazy = false,
}