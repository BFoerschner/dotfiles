local map = vim.api.nvim_set_keymap

map("n", ",,", ":buffer #<CR>", { noremap = true, silent = true })

map("n", ",vs", ":vsplit<CR><C-W>h", { noremap = true, silent = true })
map("n", ",hs", ":split<CR><C-W>k", { noremap = true, silent = true })

map("n", "<C-F>", "<cmd>NvimTreeToggle<cr>", { noremap = true, silent = true })
map("n", "<Leader>gd", "<cmd>DiffviewOpen<cr>", { noremap = true, silent = true })

-- visual paste without yanking
vim.keymap.set("x", "p", function()
  return 'pgv"' .. vim.v.register .. "y"
end, { remap = false, expr = true })

vim.keymap.set("x", "<leader>r", function()
  vim.cmd('normal! "vy')
  local yanked_text = vim.fn.getreg("v")
  yanked_text = yanked_text:gsub("\n", "")
  yanked_text = yanked_text:match("^%s*(.-)%s*$")
  yanked_text = vim.fn.escape(yanked_text, "/\\^$.*+?()[]{}|")

  vim.api.nvim_input(":<C-u>" .. "%s/\\v(" .. yanked_text .. ")/" .. yanked_text .. "/gI<Left><Left><Left>")
end, { desc = "Replace selected text", noremap = true, silent = true })

vim.keymap.set("x", "<leader>R", function()
  vim.api.nvim_input(":s/\\%V//gI<Left><Left><Left><Left>")
end, { desc = "Search and replace in selection" })
