local prettier = { 'prettierd' }

require('conform').setup({
  formatters_by_ft = {
    astro = prettier,
    css = prettier,
    html = prettier,
    javascript = prettier,
    javascriptreact = prettier,
    json = prettier,
    jsonc = prettier,
    lua = { 'stylua' },
    markdown = prettier,
    php = { 'pint' },
    python = { 'ruff_format' },
    sql = { 'pg_format' },
    typescript = prettier,
    typescriptreact = prettier,
    yaml = prettier,
  },
  default_format_opts = { lsp_format = 'fallback' },
})

vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
