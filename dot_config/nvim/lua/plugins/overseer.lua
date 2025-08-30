return {
  {
    "stevearc/overseer.nvim",
    dependencies = { "akinsho/toggleterm.nvim" },
    opts = function(_, opts)
      opts.strategy = {
        "toggleterm",
        direction = "float",
        close_on_exit = false,
        hidden = false,
        on_create = function(term)
          vim.cmd("startinsert!")

          -- Set up 'q' to close the terminal in normal mode
          vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<cr>", {
            noremap = true,
            silent = true,
            desc = "Close terminal",
          })
        end,
      }
      return opts
    end,
  },
}
