vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

require('vim._core.ui2').enable({})

require('config.options')
require('config.autocmds')
require('plugins')
require('config.lsp')
require('config.modes')
require('config.statusline')
require('config.keymaps')
