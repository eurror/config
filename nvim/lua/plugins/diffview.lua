return {
  {
    "sindrets/diffview.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles", "DiffviewFileHistory" },
    keys = {
      { "<leader>gvd", "<cmd>DiffviewOpen<cr>", desc = "Diffview Open" },
      { "<leader>gvc", "<cmd>DiffviewClose<cr>", desc = "Diffview Close" },
      { "<leader>gvh", "<cmd>DiffviewFileHistory %<cr>", desc = "Diffview File History" },
      { "<leader>gvH", "<cmd>DiffviewFileHistory<cr>", desc = "Diffview Branch History" },
      { "<leader>gvf", "<cmd>DiffviewFocusFiles<cr>", desc = "Diffview Focus Files"},
      { "<leader>gvt", "<cmd>DiffviewToggleFiles<cr>", desc = "Diffview Toggle Files"},
      { "<leader>gvr", "<cmd>DiffviewRefresh<cr>", desc = "Diffview Refresh"},
    },
    opts = {
      enhanced_diff_hl = true,
      hooks = {
        diff_buf_read = function()
          vim.opt_local.wrap = true
          vim.opt_local.list = false
          vim.opt_local.colorcolumn = ""
        end,
      },
    },
  }
}
