return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "LazyFile", "VeryLazy" },
  opts = {
    highlight = { enable = true },
    ensure_installed = { "all" },
    sync_install = true,
  },
}
