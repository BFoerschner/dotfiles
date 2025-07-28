local map = vim.api.nvim_set_keymap

map("n", ",,", ":buffer #<CR>", { noremap = true, silent = true })

map("n", ",vs", ":vsplit<CR><C-W>h", { noremap = true, silent = true })
map("n", ",hs", ":split<CR><C-W>k", { noremap = true, silent = true })

-- visual paste without yanking
vim.keymap.set("x", "p", function()
  return 'pgv"' .. vim.v.register .. "y"
end, { remap = false, expr = true })
