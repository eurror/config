local o = vim.o

o.number = true
o.relativenumber = true
o.signcolumn = 'yes'
o.cursorline = true
o.scrolloff = 8
o.sidescrolloff = 8
o.wrap = true
o.linebreak = true
o.breakindent = true
o.smoothscroll = true

o.expandtab = true
o.shiftwidth = 4
o.tabstop = 4
o.softtabstop = -1
o.shiftround = true

o.ignorecase = true
o.smartcase = true
o.inccommand = 'split'

o.splitright = true
o.splitbelow = true

o.clipboard = 'unnamedplus'
o.undofile = true
o.confirm = true
o.updatetime = 250
o.virtualedit = 'block'

o.list = true
o.listchars = 'tab:» ,trail:·,nbsp:␣'

o.laststatus = 3
o.showmode = false
o.winborder = 'rounded'
o.pumborder = 'rounded'
o.pumheight = 15

o.foldlevelstart = 99
o.foldtext = ''

o.autocomplete = true
o.complete = '.^5,w^5,b^5,u^5'
o.completeopt = 'menuone,noselect,popup,fuzzy'

o.wildmode = 'noselect:lastused,full'
o.wildoptions = 'pum,fuzzy'

vim.cmd.packadd('nvim.undotree')
