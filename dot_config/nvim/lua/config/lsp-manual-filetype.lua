-- Fix for LSP not starting when filetype is manually set on new buffers
local M = {}

-- Track buffers we've already processed to avoid duplicate work
local processed_buffers = {}

-- Common filetypes that should always try to start LSP
local important_filetypes = {
  "lua",
  "python",
  "javascript",
  "typescript",
  "xml",
  "json",
  "yaml",
  "go",
  "rust",
  "java",
  "c",
  "cpp",
  "html",
  "css",
  "scss",
}

local function should_process_buffer(buf, ft)
  -- Skip if already processed
  if processed_buffers[buf] then
    return false
  end

  -- Skip if no filetype or empty
  if not ft or ft == "" then
    return false
  end

  -- Check if buffer has no name (new buffer) or if it's an important filetype
  local bufname = vim.api.nvim_buf_get_name(buf)
  local is_new_buffer = bufname == ""
  local is_important_ft = vim.tbl_contains(important_filetypes, ft)

  return is_new_buffer or is_important_ft
end

local function ensure_lsp_loaded()
  local lazy_ok, lazy = pcall(require, "lazy")
  if not lazy_ok then
    return false
  end

  local plugins = lazy.plugins()
  for _, plugin in pairs(plugins) do
    if plugin.name == "nvim-lspconfig" and not plugin._.loaded then
      pcall(lazy.load, { plugins = "nvim-lspconfig" })
      vim.wait(100) -- Give it time to load
      break
    end
  end

  return true
end

local function get_servers_for_filetype(ft)
  local mason_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
  if not mason_ok then
    return nil
  end

  local mappings_ok, mappings = pcall(mason_lspconfig.get_mappings)
  if not mappings_ok or not mappings.filetype_to_server then
    return nil
  end

  return mappings.filetype_to_server[ft]
end

local function setup_and_attach_server(server, buf)
  local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
  if not lspconfig_ok or not lspconfig[server] then
    return false
  end

  -- Setup server if not already configured
  pcall(lspconfig[server].setup, {})

  -- Wait a bit and try to attach
  vim.defer_fn(function()
    if not vim.api.nvim_buf_is_valid(buf) then
      return
    end

    local clients = vim.lsp.get_clients({ name = server })
    if #clients > 0 then
      local client = clients[1]
      if not vim.lsp.buf_is_attached(buf, client.id) then
        pcall(vim.lsp.buf_attach_client, buf, client.id)
      end
    end
  end, 150)

  return true
end

local function handle_filetype_change(event)
  local buf = event.buf
  local ft = vim.bo[buf].filetype

  if not should_process_buffer(buf, ft) then
    return
  end

  -- Mark as processed
  processed_buffers[buf] = true

  -- Clean up when buffer is deleted
  vim.api.nvim_buf_attach(buf, false, {
    on_detach = function()
      processed_buffers[buf] = nil
    end,
  })

  vim.defer_fn(function()
    if not vim.api.nvim_buf_is_valid(buf) then
      return
    end

    -- Ensure LSP configurations are loaded
    if not ensure_lsp_loaded() then
      return
    end

    -- Get servers for this filetype
    local servers = get_servers_for_filetype(ft)
    if not servers then
      return
    end

    -- Setup and attach each server
    for _, server in ipairs(servers) do
      setup_and_attach_server(server, buf)
    end
  end, 100)
end

vim.api.nvim_create_autocmd("FileType", {
  desc = "Ensure LSP starts for manually set filetypes",
  callback = handle_filetype_change,
})

return M

