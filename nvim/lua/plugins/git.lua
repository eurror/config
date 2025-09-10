{ "tpope/vim-fugitive", event = "VeryLazy" },
{
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    config = function()
        require("gitsigns").setup({
            signs = {
                add = { text = "+" }, change = { text = "~" },
                delete = { text = "_" }, topdelete = { text = "‾" },
                changedelete = { text = "~" },
            },
            current_line_blame = false,
        })
    end,
},
{
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function() require("diffview").setup() end,
},
{
    "kdheepak/lazygit.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        vim.keymap.set("n", "<leader>gg", "<cmd>LazyGit<CR>", { desc = "Open LazyGit" })
    end,
},
