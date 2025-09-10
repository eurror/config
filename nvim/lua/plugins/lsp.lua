return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            ensure_installed = {
                "python", "lua", "json", "html",
                "css", "javascript", "bash", "markdown",
            },
            highlight = { enable = true },
            indent = {
                enable = true,
                disable = { "yaml", "python" },
            },
        },
        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)
        end,
    },

    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            { "folke/neodev.nvim", ft = "lua" },
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            local servers = {
                pyright = {
                    settings = {
                        python = {
                            venvPath = ".",
                            pythonPath = './venv/bin/python'
                        }
                    }
                },
                jsonls = {},
                html = {},
                cssls = {},
                ruff = {},
                bashls = {},
                marksman = {},
                lua_ls = {
                    settings = {
                        Lua = {
                            diagnostics = { globals = { "vim" } },
                            workspace = { checkThirdParty = false },
                        },
                    },
                },
            }

            require("neodev").setup({})

            local lspconfig = require("lspconfig")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            capabilities.textDocument.positionEncoding = { "utf-8" }

            require("mason").setup({
                ui = {
                    border = "rounded",
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗",
                    },
                },
            })

            require("mason-lspconfig").setup({
                ensure_installed = vim.tbl_keys(servers),
                automatic_installation = true,
            })

            vim.diagnostic.config({
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = " ",
                        [vim.diagnostic.severity.WARN]  = " ",
                        [vim.diagnostic.severity.HINT]  = " ",
                        [vim.diagnostic.severity.INFO]  = " ",
                    },
                },
                virtual_text = true,
                underline = true,
                update_in_insert = false,
            })

            local on_attach = function(_, bufnr)
                local opts = { buffer = bufnr, silent = true }
                vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
                vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
                vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
            end

            for server, config in pairs(servers) do
                lspconfig[server].setup(vim.tbl_deep_extend("force", {
                    capabilities = capabilities,
                    on_attach = on_attach,
                }, config))
            end
        end,
    },

    {
        "nvimtools/none-ls.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = { "williamboman/mason.nvim" },
        config = function()
            local null_ls = require("null-ls")
            null_ls.setup({
                sources = {
                    null_ls.builtins.formatting.black,
                    null_ls.builtins.formatting.isort,
                    null_ls.builtins.diagnostics.ruff,
                    null_ls.builtins.formatting.stylua,
                    null_ls.builtins.formatting.prettier,
                },
            })
        end,
    },
}
