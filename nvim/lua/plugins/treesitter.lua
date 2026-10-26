require('nvim-treesitter').install({
  'astro',
  'bash',
  'css',
  'diff',
  'dockerfile',
  'git_rebase',
  'gitcommit',
  'html',
  'javascript',
  'jsdoc',
  'json',
  'luadoc',
  'nginx',
  'php',
  'phpdoc',
  'python',
  'regex',
  'sql',
  'toml',
  'tsx',
  'typescript',
  'yaml',
})

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('config.treesitter', { clear = true }),
  callback = function(args)
    if not pcall(vim.treesitter.start, args.buf) then
      return
    end
    vim.wo[0][0].foldmethod = 'expr'
    vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
  end,
})
