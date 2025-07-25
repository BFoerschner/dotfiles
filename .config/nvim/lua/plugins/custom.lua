return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "LazyFile", "VeryLazy" },
    lazy = false,
  },
  {
    "nvim-tree/nvim-tree.lua",
    opts = {},
    config = function(_, opts)
      require("nvim-tree").setup()
    end,
  },
  {
    "echasnovski/mini.pairs",
    enabled = false,
  },
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
    },
  },
  { "LunarVim/bigfile.nvim" },
  {
    "kawre/leetcode.nvim",
    build = ":TSUpdate html",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim", -- required by telescope
      "MunifTanjim/nui.nvim",

      -- optional
      "nvim-treesitter/nvim-treesitter",
      "rcarriga/nvim-notify",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      -- configuration goes here
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
  },
  {
    "stevearc/oil.nvim",
    opts = {},
    -- dependencies = { { "echasnovski/mini.icons", opts = {} } },
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
  },
  {
    "polirritmico/monokai-nightasty.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      dark_style_background = "transparent", -- default, dark, transparent, #color
      light_style_background = "default", -- default, dark, transparent, #color
      color_headers = true, -- Enable header colors for each header level (h1, h2, etc.)
      lualine_bold = true, -- Lualine a and z sections font width
      lualine_style = "dark", -- "dark", "light" or "default" (Follows dark/light style)

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
  },
  {
    "echasnovski/mini.indentscope",
    opts = {
      draw = {
        delay = 0,
        animation = require("mini.indentscope").gen_animation.none(),
      },
    },
  },
  {
    "windwp/nvim-ts-autotag",
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        ["javascript"] = { "prettierd" },
        ["javascriptreact"] = { "prettierd" },
        ["typescript"] = { "prettierd" },
        ["typescriptreact"] = { "prettierd" },
        ["svelte"] = { "prettierd" },
        ["vue"] = { "prettierd" },
        ["css"] = { "prettierd" },
        ["scss"] = { "prettierd" },
        ["less"] = { "prettierd" },
        ["html"] = { "prettierd" },
        ["json"] = { "prettier" },
        ["jsonc"] = { "prettierd" },
        ["yaml"] = { "prettierd" },
        ["markdown"] = { "prettierd" },
        ["markdown.mdx"] = { "prettierd" },
        ["graphql"] = { "prettierd" },
        ["handlebars"] = { "prettierd" },
      },
    },
  },
  {
    "sindrets/diffview.nvim",
  },
  {
    "folke/snacks.nvim",
    opts = {
      scroll = { enabled = false },
    },
  },
  {
    "mg979/vim-visual-multi",
  },
  {
    "folke/snacks.nvim",
    opts = {
      terminal = {
        win = {
          position = "float",
        },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- Safely require cmp_nvim_lsp
      local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      if not ok then
        cmp_nvim_lsp = nil
      end

      -- Start with base capabilities
      local capabilities = vim.lsp.protocol.make_client_capabilities()

      -- If cmp_nvim_lsp is available, merge its capabilities
      if cmp_nvim_lsp then
        capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
      end

      -- Disable snippet support globally since it's really annoying
      capabilities.textDocument.completion.completionItem.snippetSupport = false
      opts.capabilities = capabilities

      -- Setup diagnostic display and floating window behavior
      opts.setup = opts.setup or {}
      opts.setup["*"] = function()
        vim.diagnostic.config({
          virtual_text = false,
          virtual_lines = true,
          underline = false,
          update_in_insert = false,
          severity_sort = true,
          signs = {
            text = {
              [vim.diagnostic.severity.ERROR] = "➤",
              [vim.diagnostic.severity.WARN] = "➜",
              [vim.diagnostic.severity.INFO] = "➔",
              [vim.diagnostic.severity.HINT] = "➢",
            },
            linehl = {
              [vim.diagnostic.severity.ERROR] = "DiagnosticLineError",
              [vim.diagnostic.severity.WARN] = "DiagnosticLineWarn",
              [vim.diagnostic.severity.INFO] = "DiagnosticLineInfo",
              [vim.diagnostic.severity.HINT] = "DiagnosticLineHint",
            },
            numhl = {
              [vim.diagnostic.severity.ERROR] = "DiagnosticLineNrError",
              [vim.diagnostic.severity.WARN] = "DiagnosticLineNrWarn",
              [vim.diagnostic.severity.INFO] = "DiagnosticLineNrInfo",
              [vim.diagnostic.severity.HINT] = "DiagnosticLineNrHint",
            },
          },
        })

        vim.api.nvim_create_autocmd("ColorScheme", {
          callback = function()
            -- Line highlighting (subtle background tint)
            vim.api.nvim_set_hl(0, "DiagnosticLineError", { bg = "#3d2828", fg = "NONE" })
            vim.api.nvim_set_hl(0, "DiagnosticLineWarn", { bg = "#3d3528", fg = "NONE" })
            vim.api.nvim_set_hl(0, "DiagnosticLineInfo", { bg = "#1e3d3d", fg = "NONE" })
            vim.api.nvim_set_hl(0, "DiagnosticLineHint", { bg = "#2d2d3d", fg = "NONE" })

            -- Line number highlighting
            vim.api.nvim_set_hl(0, "DiagnosticLineNrError", { fg = "#f38ba8", bold = true })
            vim.api.nvim_set_hl(0, "DiagnosticLineNrWarn", { fg = "#f9e2af", bold = true })
            vim.api.nvim_set_hl(0, "DiagnosticLineNrInfo", { fg = "#89b4fa", bold = true })
            vim.api.nvim_set_hl(0, "DiagnosticLineNrHint", { fg = "#a6adc8", bold = true })
          end,
        })

        -- Trigger the highlight setup immediately
        vim.cmd("doautocmd ColorScheme")

        vim.o.updatetime = 0

        -- Setup inlay hints toggle based on mode
        vim.api.nvim_create_autocmd("InsertEnter", {
          callback = function()
            vim.lsp.inlay_hint.enable(false, { bufnr = 0 })
          end,
        })

        vim.api.nvim_create_autocmd("InsertLeave", {
          callback = function()
            vim.lsp.inlay_hint.enable(true, { bufnr = 0 })
          end,
        })

        -- Enable inlay hints initially (for normal mode)
        vim.lsp.inlay_hint.enable(true, { bufnr = 0 })

        return false -- allow default setup to continue
      end
    end,
    -- opts = {
    --   inlay_hints = {
    --     enabled = true,
    --   },
    --   servers = {
    --     bashls = {
    --       filetypes = { "sh", "zsh" },
    --     },
    --   },
    --   setup = {
    --     -- This runs once after LSP is set up
    --     ["*"] = function()
    --       -- Disable virtual text diagnostics
    --       vim.diagnostic.config({
    --         virtual_text = false,
    --         signs = true,
    --         underline = true,
    --         update_in_insert = true,
    --         severity_sort = true,
    --       })
    --
    --       -- Show diagnostics in floating window on CursorHold
    --       vim.o.updatetime = 250
    --       vim.api.nvim_create_autocmd("CursorHold", {
    --         callback = function()
    --           vim.diagnostic.open_float(nil, { focusable = false })
    --         end,
    --       })
    --
    --       return false -- allow default handler to continue
    --     end,
    --   },
    -- },
  },
  { "akinsho/bufferline.nvim", enabled = false },
  { "nvim-neo-tree/neo-tree.nvim", enabled = false },
  { "folke/flash.nvim", enabled = false },
  -- { "MeanderingProgrammer/render-markdown.nvim", enabled = false },
  {
    "jellydn/hurl.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      -- Optional, for markdown rendering with render-markdown.nvim
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown" },
        },
        ft = { "markdown" },
      },
    },
    ft = "hurl",
    opts = {
      -- Show debugging info
      debug = false,
      -- Show notification on run
      show_notification = false,
      -- Show response in popup or split
      auto_close = false,
      mode = "split",
      -- Default formatter
      formatters = {
        json = { "jq" }, -- Make sure you have install jq in your system, e.g: brew install jq
        html = {
          "prettier", -- Make sure you have install prettier in your system, e.g: npm install -g prettier
          "--parser",
          "html",
        },
        xml = {
          "tidy", -- Make sure you have installed tidy in your system, e.g: brew install tidy-html5
          "-xml",
          "-i",
          "-q",
        },
      },
      -- Default mappings for the response popup or split views
      mappings = {
        close = "q", -- Close the response popup or split view
        next_panel = "<C-n>", -- Move to the next response popup window
        prev_panel = "<C-p>", -- Move to the previous response popup window
      },
    },
    keys = {
      -- Run API request
      { "<leader>A", "<cmd>HurlRunner<CR>", desc = "Run All requests" },
      { "<leader>a", "<cmd>HurlRunnerAt<CR>", desc = "Run Api request" },
      { "<leader>te", "<cmd>HurlRunnerToEntry<CR>", desc = "Run Api request to entry" },
      { "<leader>tE", "<cmd>HurlRunnerToEnd<CR>", desc = "Run Api request from current entry to end" },
      { "<leader>tm", "<cmd>HurlToggleMode<CR>", desc = "Hurl Toggle Mode" },
      { "<leader>tv", "<cmd>HurlVerbose<CR>", desc = "Run Api in verbose mode" },
      { "<leader>tV", "<cmd>HurlVeryVerbose<CR>", desc = "Run Api in very verbose mode" },
      -- Run Hurl request in visual mode
      { "<leader>h", ":HurlRunner<CR>", desc = "Hurl Runner", mode = "v" },
    },
  },
  {
    "ovk/endec.nvim",
    event = "VeryLazy",
    opts = {
      keymaps = {
        -- Decode Base64 in-place
        decode_base64_inplace = "<leader>tdb", -- normal
        vdecode_base64_inplace = "<leader>tdb", -- visual
        -- Encode Base64 in-place (normal mode)
        encode_base64_inplace = "<leader>teb", -- normal
        vencode_base64_inplace = "<leader>teb", -- visual
        -- Decode Base64URL in-place
        decode_base64url_inplace = "<leader>tdB", -- normal
        vdecode_base64url_inplace = "<leader>tdB", -- visual
        -- Encode Base64URL in-place
        encode_base64url_inplace = "<leader>teB", -- normal
        vencode_base64url_inplace = "<leader>teB", -- visual
        -- Decode URL in-place
        decode_url_inplace = "<leader>tdU", -- normal
        vdecode_url_inplace = "<leader>tdU", -- visual
        -- Encode URL in-place
        encode_url_inplace = "<leader>teU", -- normal
        vencode_url_inplace = "<leader>teU", --visual
      },
    },
  },
  {
    "michaelrommel/nvim-silicon",
    lazy = true,
    cmd = "Silicon",
    opts = {
      output = function()
        local path = "./" .. os.date("!%Y-%m-%dT%H-%M-%SZ") .. "_code.png"
        if vim.fn.has("clipboard") == 1 then
          vim.fn.setreg("+", path)
        end
        return path
      end,
    },
  },
  { "nvim-tree/nvim-web-devicons", opts = {} },
  { "onsails/lspkind.nvim" },
  {
    "supermaven-inc/supermaven-nvim",
    event = "InsertEnter",
    cmd = {
      "SupermavenUsePro",
    },
    opts = {
      keymaps = {
        accept_suggestion = "<C-l>",
        accept_word = "<C-M-l>",
      },
      log_level = "off",
      disable_inline_completion = false,
      ignore_filetypes = { "bigfile", "snacks_input", "snacks_notif" },
    },
  },
  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    version = "*",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons", -- optional dependency
    },
  },
  {
    "echasnovski/mini.snippets",
    opts = {
      -- Disable default mappings
      mappings = {
        expand = "",
        jump_next = "",
        jump_prev = "",
        stop = "",
      },
    },
  },
  {
    "nvim-zh/colorful-winsep.nvim",
    config = true,
    event = { "WinLeave" },
  },
  {
    "saghen/blink.cmp",
    -- optional: provides snippets for the snippet source
    dependencies = {
      { "rafamadriz/friendly-snippets" },
    },

    -- use a release tag to download pre-built binaries
    version = "*",
    build = "cargo build --release",
    opts = {
      -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept, C-n/C-p for up/down)
      -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys for up/down)
      -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
      --
      -- All presets have the following mappings:
      -- C-space: Open menu or open docs if already open
      -- C-e: Hide menu
      -- C-k: Toggle signature help
      --
      -- See the full "keymap" documentation for information on defining your own keymap.
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
                  local lspkind = require("lspkind")
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

                -- Optionally, use the highlight groups from nvim-web-devicons
                -- You can also add the same function for `kind.highlight` if you want to
                -- keep the highlight groups in sync with the icons.
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
        -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = "mono",
      },

      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        default = { "lsp", "path", "cmdline", "buffer" },
        per_filetype = {
          sql = { "dadbod" },
          -- optionally inherit from the `default` sources
          lua = { inherit_defaults = true, "lazydev" },
        },
        providers = {
          dadbod = { module = "vim_dadbod_completion.blink" },
          lazydev = { ... },
          lsp = { ... },
        },
      },

      -- Blink.cmp uses a Rust fuzzy matcher by default for typo resistance and significantly better performance
      -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
      -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
      --
      -- See the fuzzy documentation for more information
      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
    opts_extend = { "sources.default" },
  },
  {
    "folke/noice.nvim",
    opts = {
      lsp = {
        signature = {
          enabled = true,
          auto_open = { enabled = true },
        },
      },
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        -- Language Servers
        "docker-compose-language-service",
        "tailwindcss-language-server",
        "dockerfile-language-server",
        "yaml-language-server",
        "bash-language-server",
        "vue-language-server",
        "lua-language-server",
        "terraform-ls",
        "eslint-lsp",
        "json-lsp",
        "pyright",
        "lemminx",
        "vtsls",
        "gopls",
        "ruff",
        "ansiblels",
        "svelte",
        "marksman",

        -- Debug Adapters
        "js-debug-adapter",
        "codelldb",
        "debugpy",
        "delve",

        -- Linters
        "shellcheck",
        "hadolint",
        "tflint",
        "markdownlint-cli2",

        -- Formatters
        "prettier",
        "black",
        "stylua",
        "shfmt",
        "goimports",
        "gofumpt",

        -- Utilities
        "markdown-toc",
      },
      auto_update = true,
      run_on_start = false,
      debounce_hours = 24,
    },
  },
}
