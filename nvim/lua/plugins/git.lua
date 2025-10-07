return {
  { "tpope/vim-fugitive", cmd = { "Git", "G", "Gdiffsplit", "Gvdiffsplit", "Gblame", "GBrowse" } },
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    config = function()
      require("gitsigns").setup({
        current_line_blame = true,
      })
    end,
  },
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("diffview").setup()
      vim.keymap.set("n", "<leader>do", "<cmd>DiffviewOpen<CR>", { desc = "Diffview Open" })
      vim.keymap.set("n", "<leader>dc", "<cmd>DiffviewClose<CR>", { desc = "Diffview Close" })
      vim.keymap.set("n", "<leader>df", "<cmd>DiffviewFocusFiles<CR>", { desc = "Diffview Focus Files" })
      vim.keymap.set("n", "<leader>dt", "<cmd>DiffviewToggleFiles<CR>", { desc = "Diffview Toggle Files" })
    end,
  },
  {
    "kdheepak/lazygit.nvim",
    cmd = "LazyGit",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>gg", "<cmd>LazyGit<CR>", desc = "Open LazyGit" },
    },
  },
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
      "ibhagwan/fzf-lua",
      "echasnovski/mini.pick",
    },
  }
}
