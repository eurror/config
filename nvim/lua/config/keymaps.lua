-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Replace selection with last yanked text, preserving the yank buffer
vim.keymap.set("x", "R", '"_dP', { desc = "Replace selection with yank (Helix-style)" })
