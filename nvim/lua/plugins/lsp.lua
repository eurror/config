{
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = { "python", "lua", "json", "html", "css", "javascript" },
            highlight = { enable = true },
            indent = { enable = true },
        })
    end,
},

{
    "neovim/nvim-lspconfig",
    dependencies = {
        { "folke/neodev.nvim", lazy = false, priority = 900 },
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
        local servers = {
            "pyright", "lua_ls", "jsonls", "html",
            "cssls", "ruff", "bashls", "marksman",
        }

        require("neodev").setup({})
        local lspconfig = require("lspconfig")
        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        require("mason").setup({
            ui = {
                border = "rounded",
                icons = { package_installed = "✓", package_pending = "➜", package_uninstalled = "✗" },
            },
        })

        require("mason-lspconfig").setup({
            ensure_installed = servers,
            automatic_installation = true,
        })

        for _, server in ipairs(servers) do
            lspconfig[server].setup({ capabilities = capabilities })
        end

        lspconfig.lua_ls.setup({
            settings = { Lua = { diagnostics = { globals = { "vim" } } } },
        })
    end,
},