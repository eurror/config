local M = {}

local function open_float(buf)
  local width = math.floor(vim.o.columns * 0.9)
  local height = math.floor(vim.o.lines * 0.85)
  return vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    col = math.floor((vim.o.columns - width) / 2),
    row = math.floor((vim.o.lines - height) / 2),
  })
end

local function spawn(cmd)
  local buf = vim.api.nvim_create_buf(false, true)
  local win = open_float(buf)
  vim.fn.jobstart(cmd, {
    term = true,
    on_exit = function()
      vim.schedule(function()
        if vim.api.nvim_buf_is_valid(buf) then
          vim.api.nvim_buf_delete(buf, { force = true })
        end
      end)
    end,
  })
  vim.cmd.startinsert()
  return buf, win
end

local shell = { buf = -1, win = -1 }

function M.toggle()
  if vim.api.nvim_win_is_valid(shell.win) then
    vim.api.nvim_win_hide(shell.win)
  elseif vim.api.nvim_buf_is_valid(shell.buf) then
    shell.win = open_float(shell.buf)
    vim.cmd.startinsert()
  else
    shell.buf, shell.win = spawn({ vim.o.shell })
  end
end

function M.lazygit()
  spawn({ 'lazygit' })
end

return M
