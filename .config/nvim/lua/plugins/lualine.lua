return {
  "nvim-lualine/lualine.nvim",
  -- enabled = false,
  config = function()
    require("lualine").setup({
      options = {
        theme = "moonfly",
      },
      sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
      winbar = {
        lualine_a = { "navic" },
        lualine_b = { "diagnostics" },
        lualine_c = { "filename" },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "" },
        lualine_z = { "location" },
      },
    })
    vim.opt.laststatus = 0
  end,
}
