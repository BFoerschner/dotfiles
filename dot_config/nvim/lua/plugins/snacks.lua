return {
  {
    "folke/snacks.nvim",
    opts = {
      quickfile = { enabled = false },
      scroll = { enabled = false },
      bigfile = {
        size = 1024 * 1024, -- 1MB
        setup = function(ctx)
          if vim.fn.exists(":NoMatchParen") ~= 0 then
            vim.cmd("NoMatchParen")
          end
          Snacks.util.wo(0, { foldmethod = "manual", statuscolumn = "", conceallevel = 0 })
          vim.b.completion = false
          vim.b.minianimate_disable = true
          vim.b.minihipatterns_disable = true
          vim.b.miniindentscope_disable = true
          vim.bo[ctx.buf].syntax = ctx.ft
          pcall(vim.cmd, "IlluminatePauseBuf")
          vim.treesitter.stop(ctx.buf)
          vim.diagnostic.enable(false, { bufnr = ctx.buf })
          vim.opt_local.swapfile = false
          vim.opt_local.undolevels = -1
          vim.opt_local.list = false
          vim.opt_local.spell = false
        end,
      },
      terminal = {
        win = {
          position = "float",
        },
      },
    },
  },
}

