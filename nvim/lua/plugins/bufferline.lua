return {
  {
    "akinsho/bufferline.nvim",
    event = "BufAdd",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("bufferline").setup({
        options = {
          diagnostics = "nvim_lsp",
          show_duplicate_prefix = true,
          offsets = {
            {
              filetype = "Neotree",
              text = "File Explorer",
              text_align = "left",
              separator = true,
              highlight = "Directory",
            },
          },
        },
      })
    end,
  }
}
