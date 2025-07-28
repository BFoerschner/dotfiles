return {
  "neovim/nvim-lspconfig",
  opts = function(_, opts)
    local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
    if not ok then
      cmp_nvim_lsp = nil
    end

    local capabilities = vim.lsp.protocol.make_client_capabilities()

    if cmp_nvim_lsp then
      capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
    end

    capabilities.textDocument.completion.completionItem.snippetSupport = false
    opts.capabilities = capabilities

    opts.setup = opts.setup or {}
    opts.setup["*"] = function()
      vim.diagnostic.config({
        virtual_text = false,
        virtual_lines = false,
        underline = false,
        update_in_insert = true,
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

      local diagnostic_icons = {
        [vim.diagnostic.severity.ERROR] = "➤",
        [vim.diagnostic.severity.WARN] = "➜",
        [vim.diagnostic.severity.INFO] = "➔",
        [vim.diagnostic.severity.HINT] = "➢",
      }

      vim.api.nvim_create_autocmd("CursorHold", {
        callback = function()
          local line_diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })
          local header_text = nil
          if #line_diagnostics > 1 then
            header_text = { string.format("  %d diagnostics", #line_diagnostics), "DiagnosticFloatHeader" }
          end

          local float_opts = {
            focusable = false,
            close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
            border = "rounded",
            source = "always",
            prefix = function(diagnostic, _, _)
              local icon = diagnostic_icons[diagnostic.severity] or "• "
              return string.format("%s ", icon), "Diagnostic" .. vim.diagnostic.severity[diagnostic.severity]
            end,
            format = function(diagnostic)
              return diagnostic.message
            end,
            header = header_text,
            pad_top = 1,
            pad_bottom = 1,
            max_width = 140,
            wrap = true,
          }
          vim.diagnostic.open_float(nil, float_opts)
        end,
      })

      vim.opt.updatetime = 50

      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = function()
          vim.api.nvim_set_hl(0, "DiagnosticLineError", { bg = "#3d2828", fg = "NONE" })
          vim.api.nvim_set_hl(0, "DiagnosticLineWarn", { bg = "#3d3528", fg = "NONE" })
          vim.api.nvim_set_hl(0, "DiagnosticLineInfo", { bg = "#1e3d3d", fg = "NONE" })
          vim.api.nvim_set_hl(0, "DiagnosticLineHint", { bg = "#2d2d3d", fg = "NONE" })

          vim.api.nvim_set_hl(0, "DiagnosticLineNrError", { fg = "#f38ba8", bold = true })
          vim.api.nvim_set_hl(0, "DiagnosticLineNrWarn", { fg = "#f9e2af", bold = true })
          vim.api.nvim_set_hl(0, "DiagnosticLineNrInfo", { fg = "#89b4fa", bold = true })
          vim.api.nvim_set_hl(0, "DiagnosticLineNrHint", { fg = "#a6adc8", bold = true })
        end,
      })

      vim.cmd("doautocmd ColorScheme")

      vim.o.updatetime = 0

      local visual_event_group = vim.api.nvim_create_augroup("visual_event", { clear = true })

      vim.api.nvim_create_autocmd("ModeChanged", {
        group = visual_event_group,
        pattern = { "*:[vV\x16]*" },
        callback = function()
          vim.lsp.inlay_hint.enable(false, { bufnr = 0 })
        end,
      })

      vim.api.nvim_create_autocmd("ModeChanged", {
        group = visual_event_group,
        pattern = { "[vV\x16]*:*" },
        callback = function()
          vim.lsp.inlay_hint.enable(true, { bufnr = 0 })
        end,
      })

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

      vim.lsp.inlay_hint.enable(true, { bufnr = 0 })

      return false
    end
  end,
}

