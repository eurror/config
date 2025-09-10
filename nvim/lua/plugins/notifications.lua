return {
    {
        "rcarriga/nvim-notify",
        event = "VeryLazy",
        config = function()
            require("notify").setup({ background_colour = "#000000" })
            vim.notify = require("notify")
        end,
    },
    {
        "folke/noice.nvim",
        event = "VeryLazy",
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
                }
            })
        end,
    },
    {
        "folke/flash.nvim",
        config = function() require("flash").setup() end,
    },
    {
        "folke/trouble.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function() require("trouble").setup() end,
    },
}
