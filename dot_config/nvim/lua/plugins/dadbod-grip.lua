return {
  {
    "joryeugene/dadbod-grip.nvim",
    version = "*",
    setup = function()
      require("dadbod-grip").setup({
        ai = false,
      })
    end,
  },
}
