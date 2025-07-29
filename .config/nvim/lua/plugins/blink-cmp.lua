return {
  "saghen/blink.cmp",
  dependencies = {
    { "rafamadriz/friendly-snippets" },
  },
  version = "1.*",
  build = function() end,
  lazy = false,
  opts = {
    keymap = {
      preset = "none",

      ["<CR>"] = { "accept", "fallback" },
      ["<Tab>"] = { "select_next", "fallback" },
      ["<S-Tab>"] = { "select_prev", "fallback" },
      ["<C-k>"] = { "hide", "hide_documentation", "hide_signature", "show_signature" },

      ["<Right>"] = { "snippet_forward", "fallback" },
      ["<Left>"] = { "snippet_backward", "fallback" },

      ["<Up>"] = { "select_prev", "fallback" },
      ["<Down>"] = { "select_next", "fallback" },
      ["<C-up>"] = { "scroll_documentation_up", "fallback" },
      ["<C-down>"] = { "scroll_documentation_down", "fallback" },
    },

    completion = {
      ghost_text = {
        enabled = false,
      },
      menu = {
        border = "rounded",
        auto_show = true,
        max_height = 20,
        draw = {
          components = {
            kind_icon = {
              ellipsis = false,
              text = function(ctx)
                local icon = ctx.kind_icon
                if vim.tbl_contains({ "Path" }, ctx.source_name) then
                  local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
                  if dev_icon then
                    icon = dev_icon
                  end
                else
                  icon = require("lspkind").symbolic(ctx.kind, {
                    mode = "symbol",
                  })
                end

                return icon .. ctx.icon_gap
              end,

              highlight = function(ctx)
                local hl = ctx.kind_hl
                if vim.tbl_contains({ "Path" }, ctx.source_name) then
                  local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
                  if dev_icon then
                    hl = dev_hl
                  end
                end
                return hl
              end,
            },
          },
        },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 0,
        window = {
          border = "rounded",
        },
      },
    },
    signature = {
      enabled = false,
      window = {
        border = "rounded",
        show_documentation = true,
        scrollbar = true,
      },
    },
    appearance = {
      use_nvim_cmp_as_default = false,
      nerd_font_variant = "mono",
    },
    sources = {
      default = { "lsp", "path", "cmdline", "buffer" },
      per_filetype = {
        sql = { "dadbod" },
        lua = { inherit_defaults = true, "lazydev" },
      },
      providers = {
        dadbod = { module = "vim_dadbod_completion.blink" },
        lazydev = { ... },
      },
    },
    fuzzy = { implementation = "rust" },
  },
  opts_extend = { "sources.default" },
}
