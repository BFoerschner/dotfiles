return {
  "sindrets/diffview.nvim",
  config = function()
    local function toggle_diffview(cmd)
      if next(require("diffview.lib").views) == nil then
        vim.cmd(cmd)
      else
        vim.cmd("DiffviewClose")
      end
    end

    local wk = require("which-key")
    wk.add({
      mode = { "n" },
      {
        "<leader>gd",
        function()
          toggle_diffview("DiffviewOpen")
        end,
        desc = "Diff Index",
      },
      {
        "<leader>gD",
        function()
          toggle_diffview("DiffviewOpen master..HEAD")
        end,
        desc = "Diff Master",
      },
      {
        "<leader>gf",
        function()
          toggle_diffview("DiffviewFileHistory %")
        end,
        desc = "Open diffs for current file",
      },
    })
  end,
}