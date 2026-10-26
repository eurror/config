vim.api.nvim_create_autocmd('PackChanged', {
  group = vim.api.nvim_create_augroup('config.pack', { clear = true }),
  callback = function(ev)
    if ev.data.spec.name == 'nvim-treesitter' and ev.data.kind == 'update' then
      if not ev.data.active then
        vim.cmd.packadd('nvim-treesitter')
      end
      vim.cmd('TSUpdate')
    end
  end,
})

local function gh(repo)
  return 'https://github.com/' .. repo
end

vim.pack.add({
  gh('Mofiqul/vscode.nvim'),
  gh('nvim-mini/mini.icons'),
  gh('nvim-mini/mini.clue'),
  { src = gh('nvim-treesitter/nvim-treesitter'), version = 'main' },
  gh('neovim/nvim-lspconfig'),
  gh('mason-org/mason.nvim'),
  gh('stevearc/conform.nvim'),
  gh('ibhagwan/fzf-lua'),
  gh('stevearc/oil.nvim'),
  gh('lewis6991/gitsigns.nvim'),
})

require('plugins.colorscheme')
require('plugins.icons')
require('plugins.clue')
require('plugins.treesitter')
require('plugins.mason')
require('plugins.conform')
require('plugins.fzf')
require('plugins.oil')
require('plugins.gitsigns')
