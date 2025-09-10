return {
    { "kylechui/nvim-surround",   config = true },
    { "echasnovski/mini.ai",      version = "*", event = "VeryLazy",    config = true },
    { "echasnovski/mini.comment", version = "*", event = "VeryLazy",    config = true },
    { "echasnovski/mini.pairs",   version = "*", event = "InsertEnter", config = true },
    { "mg979/vim-visual-multi" },
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        config = function() require("toggleterm").setup({ size = 15, open_mapping = [[<C-`>]] }) end,
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        config = function()
            require("which-key").setup({
                preset = "modern",
                win = { border = "rounded" },
            })
        end,
    },
    {
        "famiu/bufdelete.nvim",
        event = "VeryLazy",
        config = function()
            vim.keymap.set("n", "<C-w>", function()
                local buffers = vim.fn.getbufinfo({ buflisted = 1 })
                if #buffers == 1 then
                    vim.cmd("Bdelete")
                    require("nvim-tree.api").tree.focus()
                else
                    vim.cmd("Bdelete")
                end
            end, { desc = "Close buffer (BufDelete)" })
        end,
    },
}
