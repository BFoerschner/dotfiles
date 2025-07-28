return {
  "neovim/nvim-lspconfig",
  opts = function(_, opts)
    -- Setup completion capabilities
    local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
    local capabilities = vim.lsp.protocol.make_client_capabilities()

    if ok and cmp_nvim_lsp then
      capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
    end

    -- Disable snippet support for completion
    capabilities.textDocument.completion.completionItem.snippetSupport = false
    opts.capabilities = capabilities

    opts.setup = opts.setup or {}
    opts.setup["*"] = function()
      local diagnostic_icons = {
        [vim.diagnostic.severity.ERROR] = "➤",
        [vim.diagnostic.severity.WARN] = "➜",
        [vim.diagnostic.severity.INFO] = "➔",
        [vim.diagnostic.severity.HINT] = "➢",
      }

      -- Color schemes for diagnostic highlights
      local severity_names = { "Error", "Warn", "Info", "Hint" }
      local line_colors = { "#3d2828", "#3d3528", "#1e3d3d", "#2d2d3d" }
      local nr_colors = { "#f38ba8", "#f9e2af", "#89b4fa", "#a6adc8" }

      -- Configure diagnostic display
      vim.diagnostic.config({
        virtual_text = false,
        virtual_lines = false,
        underline = false,
        update_in_insert = true,
        severity_sort = true,
        signs = {
          text = diagnostic_icons,
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

      -- Show diagnostic popup on cursor hold
      vim.api.nvim_create_autocmd("CursorHold", {
        callback = function()
          -- Only show diagnostic floats if diagnostics are enabled
          if not vim.diagnostic.is_enabled() then
            return
          end

          local line_diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })
          -- Show count in header if multiple diagnostics
          local header_text = #line_diagnostics > 1
              and { string.format("  %d diagnostics", #line_diagnostics), "DiagnosticFloatHeader" }
            or nil

          vim.diagnostic.open_float(nil, {
            focusable = false,
            close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
            border = "rounded",
            source = "always",
            -- Add icon prefix to each diagnostic
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
          })
        end,
      })

      -- Setup diagnostic highlighting colors
      local function setup_highlights()
        for i, name in ipairs(severity_names) do
          vim.api.nvim_set_hl(0, "DiagnosticLine" .. name, { bg = line_colors[i], fg = "NONE" })
          vim.api.nvim_set_hl(0, "DiagnosticLineNr" .. name, { fg = nr_colors[i], bold = true })
        end
      end

      -- Apply highlights on colorscheme changes
      vim.api.nvim_create_autocmd("ColorScheme", { callback = setup_highlights })
      vim.cmd("doautocmd ColorScheme")

      -- Inlay hints management
      local function toggle_inlay_hints(enable)
        vim.lsp.inlay_hint.enable(enable, { bufnr = 0 })
      end

      -- Hide inlay hints in visual mode and insert mode
      local inlay_group = vim.api.nvim_create_augroup("inlay_hints", { clear = true })

      -- Hide hints when entering visual mode
      vim.api.nvim_create_autocmd("ModeChanged", {
        group = inlay_group,
        pattern = "*:[vV\x16]*",
        callback = function()
          toggle_inlay_hints(false)
        end,
      })

      -- Show hints when leaving visual mode
      vim.api.nvim_create_autocmd("ModeChanged", {
        group = inlay_group,
        pattern = "[vV\x16]*:*",
        callback = function()
          toggle_inlay_hints(true)
        end,
      })

      -- Hide hints when entering insert mode
      vim.api.nvim_create_autocmd("InsertEnter", {
        group = inlay_group,
        callback = function()
          toggle_inlay_hints(false)
        end,
      })

      -- Show hints when leaving insert mode
      vim.api.nvim_create_autocmd("InsertLeave", {
        group = inlay_group,
        callback = function()
          toggle_inlay_hints(true)
        end,
      })

      -- Fast cursor updates for responsive diagnostics
      vim.o.updatetime = 0

      -- Enable inlay hints at first
      toggle_inlay_hints(true)

      return false
    end
  end,
}
