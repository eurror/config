local fzf = require('fzf-lua')

fzf.setup({
  defaults = { file_icons = 'mini' },
  grep = { hidden = true },
})

fzf.register_ui_select()
