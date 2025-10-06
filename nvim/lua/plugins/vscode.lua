return {
  {
    "Mofiqul/vscode.nvim",
    lazy = false,    -- load at startup
    priority = 1000, -- make sure it loads before anything else
    config = function()
      -- optional: style options
      vim.o.background = "dark" -- or "light"

      require("vscode").setup({
        -- style = "dark",
        -- transparent = true,
        -- italic_comments = true,
      })

      -- actually set the colorscheme
      vim.cmd.colorscheme("vscode")
    end,
  },
}
