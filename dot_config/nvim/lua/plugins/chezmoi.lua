return -- Lazy.nvim
{
  "xvzc/chezmoi.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("chezmoi").setup({
      -- your configurations
    })
    -- auto run chezmoi apply
    vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
      pattern = { os.getenv("HOME") .. "/.local/share/chezmoi/*" },
      callback = function(ev)
        local bufnr = ev.buf
        local edit_watch = function()
          require("chezmoi.commands.__edit").watch(bufnr)
        end
        vim.schedule(edit_watch)
      end,
    })
    local telescope = require("telescope")

    telescope.setup({
      defaults = {
        mappings = {
          n = {
            ["q"] = require("telescope.actions").close,
          },
        },
      },
    })

    telescope.load_extension("chezmoi")
    vim.keymap.set("n", "<leader>cz", telescope.extensions.chezmoi.find_files, {})
  end,
}
