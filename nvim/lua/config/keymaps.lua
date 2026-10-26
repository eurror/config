local map = vim.keymap.set

local function fzf(picker, opts)
  return function()
    require('fzf-lua')[picker](opts)
  end
end

local function buffer_dir()
  if vim.bo.filetype == 'oil' then
    return require('oil').get_current_dir()
  end
  return vim.fn.expand('%:p:h')
end

map('x', 'R', 'P', { desc = 'Replace selection keeping register' })
map({ 'n', 'i', 'x' }, '<A-CR>', '<Esc>o', { desc = 'Open line below' })

map('n', '<leader>f', fzf('files'), { desc = 'Files' })
map('n', '<leader>F', function()
  require('fzf-lua').files({ cwd = buffer_dir() })
end, { desc = 'Files in buffer directory' })
map('n', '<leader>b', fzf('buffers'), { desc = 'Buffers' })
map('n', '<leader>/', fzf('live_grep'), { desc = 'Grep' })
map('n', '<leader>*', fzf('grep_cword'), { desc = 'Grep word under cursor' })
map('x', '<leader>*', fzf('grep_visual'), { desc = 'Grep selection' })
map('n', '<leader>s', fzf('lsp_document_symbols'), { desc = 'Document symbols' })
map('n', '<leader>S', fzf('lsp_live_workspace_symbols'), { desc = 'Workspace symbols' })
map('n', '<leader>d', fzf('diagnostics_document'), { desc = 'Diagnostics' })
map('n', '<leader>D', fzf('diagnostics_workspace'), { desc = 'Workspace diagnostics' })
map('n', '<leader>j', fzf('jumps'), { desc = 'Jumplist' })
map('n', "<leader>'", fzf('resume'), { desc = 'Resume last picker' })
map('n', '<leader>?', fzf('keymaps'), { desc = 'Keymaps' })
map('n', '<leader>h', fzf('helptags'), { desc = 'Help' })

map('n', '<leader>e', function()
  require('oil').open()
end, { desc = 'File explorer' })
map('n', '<leader>w', '<C-w>', { remap = true, desc = 'Window' })
map('n', '<leader>u', '<Cmd>Undotree<CR>', { desc = 'Undotree' })
map({ 'n', 'x' }, '<leader>=', function()
  require('conform').format({ async = true })
end, { desc = 'Format' })

map('n', '<leader>gg', function()
  require('config.terminal').lazygit()
end, { desc = 'Lazygit' })
map('n', '<leader>gc', fzf('git_status'), { desc = 'Changed files' })
map('n', '<leader>gl', fzf('git_bcommits'), { desc = 'File history' })
map('n', '<leader>gL', fzf('git_commits'), { desc = 'Repository log' })

map('n', '<leader>th', function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }), { bufnr = 0 })
end, { desc = 'Inlay hints' })
map('n', '<leader>tw', function()
  vim.wo.wrap = not vim.wo.wrap
end, { desc = 'Wrap' })
map('n', '<leader>ts', function()
  vim.wo.spell = not vim.wo.spell
end, { desc = 'Spell' })
map('n', '<leader>td', function()
  local lines = not vim.diagnostic.config().virtual_lines
  vim.diagnostic.config({ virtual_lines = lines, virtual_text = not lines })
end, { desc = 'Diagnostic lines' })

map({ 'n', 't' }, '<C-`>', function()
  require('config.terminal').toggle()
end, { desc = 'Terminal' })
