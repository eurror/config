return {
    {
        "rcarriga/nvim-notify",
        event = "VeryLazy",
        init = function()
            vim.notify = function(...) require("notify")(...) end
        end,
        config = function()
            require("notify").setup({
                background_colour = "#000000",
                render = "compact",
                stages = "fade_in_slide_out",
                timeout = 2000,
            })
        end,
    },
    {
        "folke/noice.nvim",
        event = { "CmdlineEnter", "LspAttach" },
        dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
        config = function()
            require("noice").setup({
                lsp = {
                    override = {
                        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                        ["vim.lsp.util.stylize_markdown"] = true,
                        ["cmp.entry.get_documentation"] = true,
                    },
                },
                presets = {
                    command_palette = true,
                    long_message_to_split = true,
                    lsp_doc_border = true,
                },
            })
        end,
    },
    {
        "folke/flash.nvim",
        keys = {
            { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash Jump" },
            { "S",     mode = { "n", "o", "x" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
            { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Flash Remote" },
            { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Flash Treesitter Search" },
            { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
        },
        config = function()
            require("flash").setup({
                modes = { search = { enabled = true }, char = { enabled = true } },
            })
        end,
    },
    {
        "folke/trouble.nvim",
        cmd = { "Trouble", "TroubleToggle", "TroubleClose", "TroubleRefresh" },
        dependencies = { "nvim-tree/nvim-web-devicons" },
        keys = {
            { "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", desc = "Trouble Diagnostics" },
            { "<leader>xq", "<cmd>Trouble qflist toggle<CR>",      desc = "Trouble Quickfix" },
            { "<leader>xl", "<cmd>Trouble loclist toggle<CR>",     desc = "Trouble Location List" },
        },
        config = function()
            require("trouble").setup({
                auto_preview = false,
                auto_jump = { "lsp_definitions" },
            })
        end,
    },
}
