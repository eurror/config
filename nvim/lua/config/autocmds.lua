-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "dap-repl",
    "dapui_console",
    "dapui_watches",
    "dapui_stacks",
    "dapui_breakpoints",
    "dapui_scopes",
    "dapui_hover",
  },
  callback = function(event)
    vim.bo[event.buf].modifiable = true
  end,
})
