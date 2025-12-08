return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "LazyFile", "VeryLazy" },
  lazy = false,
  opts = {
    ensure_installed = { "all" },
    sync_install = true,
  },
  config = function(_, opts)
    -- Temporarily disable vim.notify for treesitter setup, hide that damn installation message
    local original_notify = vim.notify
    vim.notify = function(msg, ...)
      if type(msg) == "string" and (msg:match("treesitter") or msg:match("languages? installed")) then
        return
      end
      original_notify(msg, ...)
    end

    require("nvim-treesitter.configs").setup(opts)

    -- Restore original notify
    vim.notify = original_notify
  end,
}
