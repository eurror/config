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
            vim.keymap.set("n", "<C-w>", function() vim.cmd("Bdelete") end)
        end,
    },
}
