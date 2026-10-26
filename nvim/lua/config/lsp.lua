local severity = vim.diagnostic.severity

vim.diagnostic.config({
  severity_sort = true,
  virtual_text = true,
  float = { source = true },
  signs = {
    text = {
      [severity.ERROR] = '\u{f057}',
      [severity.WARN] = '\u{f071}',
      [severity.INFO] = '\u{f05a}',
      [severity.HINT] = '\u{f0eb}',
    },
  },
})

local identifier_chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_'

local function trigger_on_identifiers(client)
  local provider = client.server_capabilities.completionProvider
  local chars = provider.triggerCharacters or {}
  local present = {}
  for _, char in ipairs(chars) do
    present[char] = true
  end
  for char in identifier_chars:gmatch('.') do
    if not present[char] then
      table.insert(chars, char)
    end
  end
  provider.triggerCharacters = chars
end

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('config.lsp', { clear = true }),
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

    if client:supports_method('textDocument/completion') then
      trigger_on_identifiers(client)
      vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
      vim.bo[args.buf].autocomplete = false
    end

    if client:supports_method('textDocument/definition') then
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = args.buf, desc = 'Go to definition' })
    end
  end,
})

vim.lsp.enable({
  'astro',
  'basedpyright',
  'docker_language_server',
  'eslint',
  'intelephense',
  'jsonls',
  'lua_ls',
  'marksman',
  'postgres_lsp',
  'ruff',
  'vtsls',
  'yamlls',
})
