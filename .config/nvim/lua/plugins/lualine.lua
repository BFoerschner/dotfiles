return {
  "nvim-lualine/lualine.nvim",
  -- enabled = false,
  event = "UIEnter", -- Load after UI is ready but before user interaction
  priority = 1000,
  config = function()
    require("lualine").setup({
      options = {
        theme = "moonfly",
      },
      sections = {
        lualine_a = { "filename" },
        lualine_b = { "diagnostics" },
        lualine_c = { "navic" },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "" },
        lualine_z = { "location" },
      },
    })
  end,
}
