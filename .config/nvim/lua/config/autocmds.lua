-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.wrap = false
  end,
})

-- automatically open the trouble diagnostics window when there are errors
-- local trouble_open = false
--
-- vim.api.nvim_create_autocmd("DiagnosticChanged", {
--   callback = function()
--     local diagnostics = vim.diagnostic.get()
--     if #diagnostics > 0 then
--       if not trouble_open then
--         vim.cmd("Trouble diagnostics open")
--         trouble_open = true
--       end
--     else
--       if trouble_open then
--         vim.cmd("Trouble diagnostics close")
--         trouble_open = false
--       end
--     end
--   end,
-- })
