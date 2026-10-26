local M = {}

local function join(parts, separator)
  return table.concat(
    vim.tbl_filter(function(part)
      return part ~= ''
    end, parts),
    separator
  )
end

local function git()
  local head = vim.b.gitsigns_head
  if not head or head == '' then
    return ''
  end
  return join({ '\u{e0a0} ' .. head, vim.b.gitsigns_status or '' }, ' ')
end

local function filetype()
  local ft = vim.bo.filetype
  if ft == '' then
    return ''
  end
  return require('mini.icons').get('filetype', ft) .. ' ' .. ft
end

local function mode()
  local name, hl = require('config.modes').current()
  return '%#' .. hl .. '# ' .. name .. ' %*'
end

local function recording()
  local register = vim.fn.reg_recording()
  return register ~= '' and '@' .. register or ''
end

function M.render()
  local left = join({ mode(), recording(), git(), '%f %h%w%m%r' }, '  ')
  local right = join({
    vim.ui.progress_status(),
    vim.diagnostic.status(),
    filetype(),
    '%l:%c %P',
  }, '  ')
  return left .. '%=' .. right .. ' '
end

vim.o.statusline = "%!v:lua.require'config.statusline'.render()"

vim.api.nvim_create_autocmd({ 'ModeChanged', 'RecordingEnter', 'RecordingLeave' }, {
  group = vim.api.nvim_create_augroup('config.statusline', { clear = true }),
  callback = function()
    vim.schedule(vim.cmd.redrawstatus)
  end,
})

return M
