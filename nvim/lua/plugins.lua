local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    {
        "Mofiqul/vscode.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd("colorscheme vscode")
        end,
    },
    { "nvim-lua/plenary.nvim" },
    { 'b0o/schemastore.nvim' },

    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "BurntSushi/ripgrep",
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        },
        config = function()
            require("telescope").setup {
                defaults = {
                    prompt_prefix = "🔍 ",
                    selection_caret = " ",
                    file_ignore_patterns = { "venv", "venv/", ".venv/", ".venv", "node_modules", ".git" },
                    layout_config = {
                        prompt_position = "top",
                    },
                    sorting_strategy = "ascending",
                    winblend = 10,
                },
                extensions = {
                    fzf = {
                        fuzzy = true,
                        override_generic_sorter = true,
                        override_file_sorter = true,
                        case_mode = "smart_case",
                    },
                },
            }
            require("telescope").load_extension("fzf")
        end,
    },

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
        "tpope/vim-fugitive",
        event = "VeryLazy",
    },
    {
        "lewis6991/gitsigns.nvim",
        event = "BufReadPre",
        config = function()
            require("gitsigns").setup({
                signs = {
                    add = { text = "+" },
                    change = { text = "~" },
                    delete = { text = "_" },
                    topdelete = { text = "‾" },
                    changedelete = { text = "~" },
                },
                current_line_blame = false,
            })
        end,
    },

    {
        "nvim-tree/nvim-tree.lua",
        event  = "VeryLazy",
        config = function()
            require("nvim-tree").setup()
            vim.api.nvim_create_autocmd("QuitPre", {
                callback = function()
                    require("nvim-tree.api").tree.close()
                end,
            })
        end,
    },

    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("lualine").setup()
        end
    },

    {
        "akinsho/bufferline.nvim",
        dependencies = "nvim-tree/nvim-web-devicons",
        config = function()
            require("bufferline").setup({
                options = {
                    diagnostics = "nvim_lsp",
                    show_duplicate_prefix = true,
                    offsets = {
                        {
                            filetype = "NvimTree",
                            text = "File Explorer",
                            text_align = "left",
                            separator = true,
                            highlight = "Directory",
                        }
                    },
                }
            })
        end,
    },

    {
        "kylechui/nvim-surround",
        config = function()
            require("nvim-surround").setup()
        end,
    },
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        config = function()
            require("toggleterm").setup({
                size=15,
                open_mapping = [[<C-`>]],
            })
        end,
    },

    {
        "echasnovski/mini.ai",
        version = "*",
        event = "VeryLazy",
        config = function()
            require("mini.ai").setup()
        end,
    },

    {
        "echasnovski/mini.comment",
        version = "*",
        event = "VeryLazy",
        config = function()
            require("mini.comment").setup()
        end,
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
                win = {
                    border = "rounded",
                },
            })
        end
    },

    {
        "mfussenegger/nvim-dap",
        lazy = true,
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio",
        },
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")

            dapui.setup()

            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end
        end,
    },
    {
        "rcarriga/nvim-dap-ui",
        lazy = true,
        dependencies = { "nvim-neotest/nvim-nio" },
    },
    {
        "nvim-neotest/nvim-nio",
        lazy = true,
    },
    {
        "mfussenegger/nvim-dap-python",
        ft = "python",
        dependencies = { "mfussenegger/nvim-dap" },
        config = function()
            local dap_python = require("dap-python")
            local venv_python = vim.fn.getcwd() .. "/venv/bin/python"
            if vim.fn.filereadable(venv_python) == 1 then
                dap_python.setup(venv_python)
            else
                dap_python.setup("python3")
            end
        end,
    },

    {
        "rcarriga/nvim-notify",
        event = "VeryLazy",
        config = function()
            require("notify").setup({
                background_colour = "#000000",
            })
            vim.notify = require("notify")
        end,
    },

    {
        "folke/noice.nvim",
        event = "VeryLazy",
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
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
        config = function()
            require("flash").setup()
        end,
    },

    {
        "sindrets/diffview.nvim",
        cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("diffview").setup()
        end,
    },

    {
        "folke/trouble.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("trouble").setup()
        end,
    },

    {
        "kdheepak/lazygit.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            vim.keymap.set("n", "<leader>gg", "<cmd>LazyGit<CR>", { desc = "Open LazyGit" })
        end,
    },

    {
        "echasnovski/mini.pairs",
        version = "*",
        event = "InsertEnter",
        config = function()
            require("mini.pairs").setup()
        end,
    },

    { "mg979/vim-visual-multi" },

    -- "github/copilot.vim",
    -- { "junegunn/fzf.vim" }

    {
        "neovim/nvim-lspconfig",
        dependencies = {
            {
                "folke/neodev.nvim",
                lazy = false,
                priority = 900,
            },
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            local servers = {
                "pyright",
                "lua_ls",
                "jsonls",
                "html",
                "cssls",
                "ruff",
                "bashls",
                "marksman",
            }

            require("neodev").setup({})

            local lspconfig = require("lspconfig")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

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
                ensure_installed = servers,
                automatic_installation = true,
            })

            for _, server in ipairs(servers) do
                lspconfig[server].setup({ capabilities = capabilities })
            end

            lspconfig.lua_ls.setup({
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim" },
                        },
                    },
                },
            })
        end,
    },

    -- CMP
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "rafamadriz/friendly-snippets",
            "hrsh7th/cmp-cmdline",
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")

            luasnip.config.set_config({
                history = true,
                updateevents = "TextChanged,TextChangedI",
            })
            require("luasnip.loaders.from_vscode").lazy_load()

            cmp.setup({
                sources = {
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "buffer" },
                    { name = "path" },
                },
                mapping = cmp.mapping.preset.insert({
                    ["<CR>"] = cmp.mapping.confirm({ select = false }),
                }),
            })

            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = "cmdline" },
                }
            })

            cmp.setup.cmdline({ "/", "?" }, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = "buffer" },
                }
            })
        end,
    },
})
