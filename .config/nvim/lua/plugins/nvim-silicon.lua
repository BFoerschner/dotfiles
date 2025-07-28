return {
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
}