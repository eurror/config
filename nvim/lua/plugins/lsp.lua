return {
    {
        "williamboman/mason.nvim",
        cmd = "Mason",
        build = ":MasonUpdate",
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
        end,
    },

    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        build = ":TSUpdateSync",
        lazy = vim.fn.argc(-1) == 0,
        event = "VeryLazy",
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
        event = "VeryLazy",
        config = function()
            require("nvim-treesitter.configs").setup({
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true, -- автоматически прыгает к следующему textobject
                        keymaps = {
                            -- Функции
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            -- Классы
                            ["at"] = "@class.outer",
                            ["it"] = "@class.inner",
                            -- Параметры/аргументы
                            ["aa"] = "@parameter.outer",
                            ["ia"] = "@parameter.inner",
                            -- Условия (if/else)
                            ["ai"] = "@conditional.outer",
                            ["ii"] = "@conditional.inner",
                            -- Циклы
                            ["al"] = "@loop.outer",
                            ["il"] = "@loop.inner",
                            -- Блоки кода
                            ["ab"] = "@block.outer",
                            ["ib"] = "@block.inner",
                            -- Комментарии
                            ["a/"] = "@comment.outer",
                            -- Вызовы функций
                            ["aF"] = "@call.outer",
                            ["iF"] = "@call.inner",
                        },
                        selection_modes = {
                            ["@parameter.outer"] = "m", -- charwise
                            ["@function.outer"] = "m",  -- linewise
                            ["@class.outer"] = "m",     -- linewise
                        },
                    },
                    swap = {
                        enable = true,
                        swap_next = {
                            ["<leader>a"] = "@parameter.inner", -- swap с следующим параметром
                            ["<leader>fn"] = "@function.outer", -- swap с следующей функцией
                        },
                        swap_previous = {
                            ["<leader>A"] = "@parameter.inner", -- swap с предыдущим параметром
                            ["<leader>fp"] = "@function.outer", -- swap с предыдущей функцией
                        },
                    },
                    move = {
                        enable = true,
                        set_jumps = true, -- добавляет в jumplist (Ctrl-o для возврата)
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
            -- Repeatable движения с помощью ; и ,
            local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
            vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
            vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)
            -- Делаем f, F, t, T тоже repeatable через ; и ,
            vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
            vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
            vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
            vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
        end,
    },

    {
        "windwp/nvim-ts-autotag",
        event = "VeryLazy",
        opts = {},
    },
    {
        "neovim/nvim-lspconfig",
        event = "VeryLazy",
        dependencies = {
            { "folke/neodev.nvim", ft = "lua" },
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            require("neodev").setup({})
            local servers = {
                pyright = {
                    settings = {
                        python = {
                            analysis = {
                                autoSearchPaths = true,
                                diagnosticMode = "openFilesOnly",
                                useLibraryCodeForTypes = true,
                            }
                        },
                    },
                },
                lua_ls = {
                    settings = {
                        Lua = {
                            diagnostics = { globals = { "vim" } },
                            workspace = { checkThirdParty = false },
                        },
                    },
                },
                ruff = {
                    settings = {
                        workspace = vim.fn.expand(".")
                    }
                },
            }
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
                severity_sort = true,
            })

            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            local lspconfig = require("lspconfig")
            capabilities.textDocument.positionEncoding = { "utf-8" }


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

    -- {
    --     "stevearc/conform.nvim",
    --     event = { "BufReadPre", "BufNewFile" },
    --     dependencies = { "williamboman/mason.nvim" },
    --     opts = {
    --         formatters_by_ft = {
    --             python = { "isort", "black", "ruff" },
    --             lua = { "stylua" },
    --         },
    --         format_on_save = {
    --             timeout_ms = 500,
    --             lsp_fallback = true,
    --         },
    --         formatters = {
    --             black = {
    --                 prepend_args = { "--fast" },
    --             },
    --             isort = {
    --                 prepend_args = { "--profile", "black" },
    --             },
    --         },
    --     },
    --     config = function(_, opts)
    --         require("conform").setup(opts)
    --     end,
    -- }
}
