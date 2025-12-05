return {
  "neovim/nvim-lspconfig",
  opts = function(_, opts)
    local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
    local capabilities = vim.lsp.protocol.make_client_capabilities()

    if ok and cmp_nvim_lsp then
      capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
    end

    capabilities.textDocument.completion.completionItem.snippetSupport = false

    opts.servers = opts.servers or {}
    opts.servers["*"] = opts.servers["*"] or {}
    opts.servers["*"].capabilities = capabilities

    opts.setup = opts.setup or {}
    opts.setup["*"] = function()
      local icons = {
        [vim.diagnostic.severity.ERROR] = "➤",
        [vim.diagnostic.severity.WARN] = "➜",
        [vim.diagnostic.severity.INFO] = "➔",
        [vim.diagnostic.severity.HINT] = "➢",
      }

      -- Color pairs: [line_bg, line_nr_fg]
      local colors = {
        { "#3d2828", "#f38ba8" }, -- Error
        { "#3d3528", "#f9e2af" }, -- Warn
        { "#1e3d3d", "#89b4fa" }, -- Info
        { "#2d2d3d", "#a6adc8" }, -- Hint
      }

      -- Main diagnostic configuration
      vim.diagnostic.config({
        virtual_text = false,
        virtual_lines = false,
        underline = false,
        update_in_insert = true,
        severity_sort = true,
        signs = {
          text = icons,
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
        float = {
          focusable = false,
          close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
          border = "rounded",
          source = true,
          max_width = 140,
          wrap = true,
          prefix = function(diagnostic, _, _)
            local icon = icons[diagnostic.severity] or "• "
            return string.format("%s ", icon), "Diagnostic" .. vim.diagnostic.severity[diagnostic.severity]
          end,
          format = function(diagnostic)
            return diagnostic.message
          end,
        },
      })

      -- Show diagnostic float when hovering over a line with diagnostics information
      vim.api.nvim_create_autocmd("CursorHold", {
        callback = function()
          if not vim.diagnostic.is_enabled() then
            return
          end
          local diags = vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })
          if #diags > 0 then
            vim.diagnostic.open_float(nil, {
              header = #diags > 1 and { string.format("  %d diagnostics", #diags), "DiagnosticFloatHeader" } or nil,
            })
          end
        end,
      })

      -- Setup diagnostic line/number highlighting
      local function setup_highlights()
        local names = { "Error", "Warn", "Info", "Hint" }
        for i, name in ipairs(names) do
          vim.api.nvim_set_hl(0, "DiagnosticLine" .. name, { bg = colors[i][1] })
          vim.api.nvim_set_hl(0, "DiagnosticLineNr" .. name, { fg = colors[i][2], bold = true })
        end
      end
      vim.api.nvim_create_autocmd("ColorScheme", { callback = setup_highlights })
      vim.cmd("doautocmd ColorScheme")

      -- Inlay hints
      local hints_group = vim.api.nvim_create_augroup("inlay_hints", { clear = true })
      local function toggle_hints(enable)
        vim.lsp.inlay_hint.enable(enable, { bufnr = 0 })
      end
      toggle_hints(true)

      -- Hide hints in visual mode
      vim.api.nvim_create_autocmd("ModeChanged", {
        group = hints_group,
        pattern = "*:[vV\x16]*",
        callback = function()
          toggle_hints(false)
        end,
      })

      -- Show hints when leaving visual mode
      vim.api.nvim_create_autocmd("ModeChanged", {
        group = hints_group,
        pattern = "[vV\x16]*:*",
        callback = function()
          toggle_hints(true)
        end,
      })

      -- Hide hints in insert mode
      vim.api.nvim_create_autocmd("InsertEnter", {
        group = hints_group,
        callback = function()
          toggle_hints(false)
        end,
      })

      -- Show hints when leaving insert mode
      vim.api.nvim_create_autocmd("InsertLeave", {
        group = hints_group,
        callback = function()
          toggle_hints(true)
        end,
      })
      return false
    end
  end,
}
