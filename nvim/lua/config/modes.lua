local M = {}

local colors = {
  Normal = 'vscBlue',
  Insert = 'vscBlueGreen',
  Visual = 'vscPink',
  Replace = 'vscRed',
  Command = 'vscYellowOrange',
  Terminal = 'vscLightGreen',
}

local modes = {
  n = { 'NORMAL', 'Normal' },
  i = { 'INSERT', 'Insert' },
  v = { 'VISUAL', 'Visual' },
  V = { 'V-LINE', 'Visual' },
  ['\22'] = { 'V-BLOCK', 'Visual' },
  s = { 'SELECT', 'Visual' },
  S = { 'S-LINE', 'Visual' },
  ['\19'] = { 'S-BLOCK', 'Visual' },
  R = { 'REPLACE', 'Replace' },
  c = { 'COMMAND', 'Command' },
  t = { 'TERMINAL', 'Terminal' },
}

function M.current()
  local mode = modes[vim.api.nvim_get_mode().mode:sub(1, 1)] or modes.n
  return mode[1], 'Mode' .. mode[2]
end

local function set_highlights()
  local palette = require('vscode.colors').get_colors()
  for kind, key in pairs(colors) do
    vim.api.nvim_set_hl(0, 'Mode' .. kind, { fg = palette.vscBack, bg = palette[key], bold = true })
    vim.api.nvim_set_hl(0, 'Mode' .. kind .. 'Cursor', { bg = palette[key] })
  end
end

set_highlights()

vim.api.nvim_create_autocmd('ColorScheme', {
  group = vim.api.nvim_create_augroup('config.modes', { clear = true }),
  callback = set_highlights,
})

vim.o.guicursor = table.concat({
  'n:block-ModeNormalCursor',
  'o:hor20-ModeNormalCursor',
  'v:block-ModeVisualCursor',
  'i-ci:ver25-ModeInsertCursor',
  'sm:block-ModeInsertCursor',
  'r-cr:hor20-ModeReplaceCursor',
  'c:block-ModeCommandCursor',
  't:block-blinkon500-blinkoff500-ModeTerminalCursor',
}, ',')

return M
