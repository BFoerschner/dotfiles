return {
  "michaelrommel/nvim-silicon",
  lazy = true,
  cmd = "Silicon",
  keys = {
    {
      "<leader>sc",
      function()
        require("nvim-silicon").file()
      end,
      mode = "v",
      desc = "Save code screenshot file, copy path to clipboard",
    },
    {
      "<leader>sC",
      function()
        require("nvim-silicon").clip()
      end,
      mode = "v",
      desc = "Copy code screenshot to clipboard",
    },
  },
  config = function()
    local wk = require("which-key")
    wk.add({
      mode = { "v" },
      { "<leader>s", group = "Silicon" },
    })

    require("nvim-silicon").setup({
      command = "silicon",
      output = function()
        local path = "./" .. os.date("!%Y-%m-%dT%H-%M-%SZ") .. "_code.png"
        if vim.fn.has("clipboard") == 1 then
          vim.fn.setreg("+", path)
        end
        return path
      end,
    })
  end,
}
