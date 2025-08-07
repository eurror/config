-- lua/core/options.lua
local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.guicursor = ""
opt.termguicolors = true
opt.smartindent = true
opt.mouse = "a"
opt.clipboard = "unnamedplus"

-- Suppress deprecation warnings (temporary solution)
vim.deprecate = function() end
