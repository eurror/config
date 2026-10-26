local group = vim.api.nvim_create_augroup('config', { clear = true })

local function autocmd(event, opts)
  vim.api.nvim_create_autocmd(event, vim.tbl_extend('force', { group = group }, opts))
end

autocmd('TextYankPost', {
  callback = function()
    vim.hl.on_yank()
  end,
})

autocmd('BufReadPost', {
  callback = function(args)
    if vim.bo[args.buf].filetype == 'gitcommit' then
      return
    end
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(args.buf) then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

autocmd('VimResized', {
  command = 'tabdo wincmd =',
})

autocmd('CmdlineChanged', {
  pattern = { ':', '/', '?' },
  callback = function()
    vim.fn.wildtrigger()
  end,
})

autocmd('FileType', {
  pattern = {
    'astro',
    'css',
    'html',
    'javascript',
    'javascriptreact',
    'json',
    'jsonc',
    'lua',
    'markdown',
    'typescript',
    'typescriptreact',
    'yaml',
  },
  callback = function(args)
    vim.bo[args.buf].shiftwidth = 2
    vim.bo[args.buf].tabstop = 2
  end,
})
