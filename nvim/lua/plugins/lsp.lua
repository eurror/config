return {
    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        build = ":TSUpdateSync",
        event = { "BufReadPost", "BufNewFile" },
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
        },
        opts = {
            ensure_installed = {
                "python", "lua", "json",
                "html", "css",
                "yaml", "toml",
            },
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },
            fold = { enable = true },
            indent = { enable = true },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<C-space>",
                    node_incremental = "<C-space>",
                    node_decremental = "<S-space>",
                },
            },
            autotag = {
                enable = true,
            },
            auto_install = true,
            refactor = {
                highlight_definitions = { enable = true },
                highlight_current_scope = { enable = true },
            },
            disable = function(lang, buf)
                local max_filesize = 100 * 1024 -- 100 KB
                local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                if ok and stats and stats.size > max_filesize then
                    return true
                end
            end,
        },
        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)
        end,
    },

    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        dependencies = "nvim-treesitter/nvim-treesitter",
        branch = "main",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require("nvim-treesitter.configs").setup({
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true,
                        keymaps = {
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["at"] = "@class.outer",
                            ["it"] = "@class.inner",
                            ["aa"] = "@parameter.outer",
                            ["ia"] = "@parameter.inner",
                            ["ai"] = "@conditional.outer",
                            ["ii"] = "@conditional.inner",
                            ["al"] = "@loop.outer",
                            ["il"] = "@loop.inner",
                            ["ab"] = "@block.outer",
                            ["ib"] = "@block.inner",
                            ["a/"] = "@comment.outer",
                            ["aF"] = "@call.outer",
                            ["iF"] = "@call.inner",
                        },
                        selection_modes = {
                            ["@parameter.outer"] = "m",
                            ["@function.outer"] = "m",
                            ["@class.outer"] = "m",
                        },
                    },
                    swap = {
                        enable = true,
                        swap_next = {
                            ["<leader>a"] = "@parameter.inner",
                            ["<leader>fn"] = "@function.outer",
                        },
                        swap_previous = {
                            ["<leader>A"] = "@parameter.inner",
                            ["<leader>fp"] = "@function.outer",
                        },
                    },
                    move = {
                        enable = true,
                        set_jumps = true,
                        goto_next_start = {
                            ["]f"] = "@function.outer",
                            ["]c"] = "@class.outer",
                            ["]a"] = "@parameter.inner",
                            ["]i"] = "@conditional.outer",
                            ["]l"] = "@loop.outer",
                        },
                        goto_next_end = {
                            ["]F"] = "@function.outer",
                            ["]C"] = "@class.outer",
                            ["]A"] = "@parameter.inner",
                        },
                        goto_previous_start = {
                            ["[f"] = "@function.outer",
                            ["[c"] = "@class.outer",
                            ["[a"] = "@parameter.inner",
                            ["[i"] = "@conditional.outer",
                            ["[l"] = "@loop.outer",
                        },
                        goto_previous_end = {
                            ["[F"] = "@function.outer",
                            ["[C"] = "@class.outer",
                            ["[A"] = "@parameter.inner",
                        },
                    },
                    lsp_interop = {
                        enable = true,
                        border = "rounded",
                        floating_preview_opts = {},
                        peek_definition_code = {
                            ["<leader>df"] = "@function.outer",
                            ["<leader>dc"] = "@class.outer",
                        },
                    },
                },
            })

            local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
            vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
            vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)
            vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
            vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
            vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
            vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
        end,
    },

    {
        "windwp/nvim-ts-autotag",
        opts = {},
    },
    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                { path = "luvit-meta/library", words = { "vim%.uv" } },
            },
        },
    },
    { "Bilal2453/luvit-meta", lazy = true },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "folke/lazydev.nvim",
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
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
            local servers = {
                basedpyright = {
                    settings = {
                        basedpyright = {
                            analysis = {
                                autoSearchPaths = true,
                                diagnosticMode = "openFilesOnly",
                                useLibraryCodeForTypes = true,
                                typeCheckingMode = "strict",
                            }
                        },
                    },
                },
                lua_ls = {
                    settings = {
                        Lua = {
                            diagnostics = {
                                globals = { "vim" },
                                disable = { "missing-fields" },
                            },
                            workspace = {
                                checkThirdParty = false,
                            },
                            telemetry = { enable = false },
                        },
                    },
                },
            }

            require("mason-lspconfig").setup({
                ensure_installed = vim.tbl_keys(servers),
                automatic_installation = true,
                handlers = {
                    function(server_name)
                        local server = servers[server_name] or {}
                        server.capabilities = require("cmp_nvim_lsp").default_capabilities()

                        server.on_attach = function(client, bufnr)
                            local opts = { buffer = bufnr, silent = true }
                            vim.keymap.set("n", "<leader>k", vim.lsp.buf.hover, opts)
                            vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                            vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
                            vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
                            vim.keymap.set("n", "go", vim.lsp.buf.type_definition, opts)
                            vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
                            vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, opts)
                            vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, opts)
                            vim.keymap.set({ "n", "v" }, "<leader>a", vim.lsp.buf.code_action, opts)
                            vim.keymap.set("n", "gl", vim.diagnostic.open_float, opts)
                            vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
                            vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
                        end

                        require("lspconfig")[server_name].setup(server)
                    end,
                },
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
                virtual_text = {
                    spacing = 4,
                    prefix = "●",
                    severity = { min = vim.diagnostic.severity.WARN },
                },
                underline = true,
                update_in_insert = false,
                severity_sort = true,
                float = {
                    border = "rounded",
                    source = "if_many",
                    header = "",
                    prefix = "",
                },
            })

            vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
                vim.lsp.diagnostic.on_publish_diagnostics, {
                    update_in_insert = false,
                    debounce = 300,
                }
            )

            local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
            function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
                opts = opts or {}
                opts.border = opts.border or "rounded"
                return orig_util_open_floating_preview(contents, syntax, opts, ...)
            end
        end,
    },

    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        dependencies = { "williamboman/mason.nvim" },
        opts = {
            formatters_by_ft = {
                python = { "ruff_format", "ruff_organize_imports" },
                lua = { "stylua" },
                json = { "jq" },
                yaml = { "yamlfmt" },
            },
            format_on_save = {
                timeout_ms = 3000,
                lsp_fallback = true,
                async = false,
            },
            formatters = {
                ruff_format = {
                    command = "ruff",
                    args = { "format", "--force-exclude", "--stdin-filename", "$FILENAME", "-" },
                },
                ruff_organize_imports = {
                    command = "ruff",
                    args = { "check", "--select", "I", "--fix", "--force-exclude", "--stdin-filename", "$FILENAME", "-" },
                },
            },
        },
        keys = {
            {
                "<leader>=",
                function()
                    require("conform").format({ async = true, lsp_fallback = true })
                end,
                mode = { "n", "v" },
                desc = "Format buffer",
            },
        },
        init = function()
            vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
        end,
    },

    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        dependencies = { "williamboman/mason.nvim" },
        opts = {
            ensure_installed = {
                "stylua",
                "ruff",
            },
            auto_update = false,
            run_on_start = true,
        },
    },
}
