return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "LazyFile", "VeryLazy" },
  lazy = false,
  opts = {
    ensure_installed = "all",
    sync_install = true,
  },
}

