return {
  "polirritmico/monokai-nightasty.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    dark_style_background = "transparent",
    light_style_background = "default",
    color_headers = true,
    lualine_bold = true,
    lualine_style = "dark",

    hl_styles = {
      keywords = { italic = true },
      comments = { italic = true },
      functions = {},
      variables = {},
    },

    dim_inactive = false,
    on_highlights = function(highlights, colors)
      highlights.TelescopeSelection = { bold = true }
      highlights.TelescopeBorder = { fg = colors.grey }
      highlights["@lsp.type.property.lua"] = { fg = colors.fg }
    end,
  },
  config = function(_, opts)
    vim.opt.cursorline = true
    vim.o.background = "dark"
    require("monokai-nightasty").load(opts)
  end,
}