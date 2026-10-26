local gitsigns = require('gitsigns')

local function selection()
  return { vim.fn.line('.'), vim.fn.line('v') }
end

gitsigns.setup({
  on_attach = function(buf)
    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc })
    end

    map('n', ']h', function()
      gitsigns.nav_hunk('next')
    end, 'Next hunk')
    map('n', '[h', function()
      gitsigns.nav_hunk('prev')
    end, 'Previous hunk')

    map('n', '<leader>gs', gitsigns.stage_hunk, 'Stage hunk')
    map('x', '<leader>gs', function()
      gitsigns.stage_hunk(selection())
    end, 'Stage selection')
    map('n', '<leader>gr', gitsigns.reset_hunk, 'Reset hunk')
    map('x', '<leader>gr', function()
      gitsigns.reset_hunk(selection())
    end, 'Reset selection')
    map('n', '<leader>gp', gitsigns.preview_hunk, 'Preview hunk')
    map('n', '<leader>gb', function()
      gitsigns.blame_line({ full = true })
    end, 'Blame line')
    map('n', '<leader>gd', gitsigns.diffthis, 'Diff file')

    map({ 'o', 'x' }, 'ih', gitsigns.select_hunk, 'Hunk')
  end,
})
