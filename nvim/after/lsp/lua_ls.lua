local config_dir = vim.fn.stdpath('config')

local function library()
  local paths = { vim.env.VIMRUNTIME }
  for _, plugin in ipairs(vim.pack.get(nil, { info = false })) do
    table.insert(paths, plugin.path)
  end
  return paths
end

return {
  root_dir = function(bufnr, on_dir)
    local file = vim.api.nvim_buf_get_name(bufnr)
    if vim.fs.relpath(config_dir, file) then
      on_dir(config_dir)
    else
      on_dir(vim.fs.root(bufnr, vim.lsp.config.lua_ls.root_markers))
    end
  end,
  on_init = function(client)
    local root = client.workspace_folders and client.workspace_folders[1].name
    if root ~= config_dir then
      return
    end
    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = { version = 'LuaJIT', path = { 'lua/?.lua', 'lua/?/init.lua' } },
      workspace = { checkThirdParty = false, library = library() },
    })
  end,
  settings = { Lua = {} },
}
