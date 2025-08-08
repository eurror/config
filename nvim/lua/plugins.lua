-- plugins.lua

-- Bootstrap lazy.nvim
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

-- Plugin setup
require("lazy").setup({
    -- ============================================================================
    -- CORE PLUGINS (Essential for basic functionality)
    -- ============================================================================

    -- Theme and UI
    {
        "Mofiqul/vscode.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd("colorscheme vscode")
        end,
    },

    -- Neovim Lua development support
    {
        "folke/neodev.nvim",
        lazy = false,
        priority = 900, -- Load before LSP
    },
    -- LSP and completion (Essential)
    { "neovim/nvim-lspconfig" },
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },
    { "hrsh7th/nvim-cmp" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-buffer" },     -- Add buffer completion
    { "hrsh7th/cmp-path" },       -- Add path completion
    { "L3MON4D3/LuaSnip" },
    { "saadparwaiz1/cmp_luasnip" }, -- Add snippet completion
    { 'b0o/schemastore.nvim' },

    -- Telescope
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.8", -- Use stable version
        dependencies = {
            "nvim-lua/plenary.nvim",
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        },
        config = function()
            require("telescope").setup {
                defaults = {
                    prompt_prefix = "🔍 ",
                    selection_caret = " ",
                    file_ignore_patterns = { "venv", "node_modules" },
                    layout_strategy = 'horizontal',
                    layout_config = {
                        preview_cutoff = 120,
                        prompt_position = "top",
                    },
                    sorting_strategy = "ascending",
                    winblend = 10,
                },
                pickers = {
                    find_files = {
                        theme = "ivy",
                        previewer = false,
                    },
                    buffers = {
                        theme = "ivy",
                        previewer = false,
                    },
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

    -- Treesitter
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

    -- Git integration (Essential)
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
                current_line_blame = false, -- Toggle with :Gitsigns toggle_current_line_blame
                current_line_blame_opts = {
                    virt_text = true,
                    virt_text_pos = 'eol',
                    delay = 1000,
                },
            })
        end,
    },

    -- File explorer
    {
        "nvim-tree/nvim-tree.lua",
        config = function()
            require("nvim-tree").setup()

            vim.api.nvim_create_autocmd("QuitPre", {
                callback = function()
                    require("nvim-tree.api").tree.close()
                end,
            })
        end,
    },
    -- Lualine (Status bar)
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("lualine").setup {
                options = {
                    theme = "auto",
                    section_separators = '',
                    component_separators = '',
                },
            }
        end
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
        config = true
    },

    -- Dashboard

    -- REMOVED: lspsaga.nvim (redundant with built-in LSP + trouble.nvim)

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

    -- Which Key
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
                delay = 300,
                plugins = {
                    marks = true,
                    registers = true,
                    spelling = {
                        enabled = true,
                        suggestions = 20,
                    },
                },
                win = {
                    border = "single",
                    padding = { 1, 2 },
                },
                layout = {
                    width = { min = 20 },
                    spacing = 3,
                },
            })
        end
    },

    -- Debug Adapter Protocol (Essential for Python development)
    {
        "mfussenegger/nvim-dap",
        lazy = true,
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio", -- Required dependency for nvim-dap-ui
        },
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")

            -- Setup DAP UI
            dapui.setup()

            -- Auto open/close DAP UI
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
            -- Automatically use venv if available, else fallback to system python
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

    -- Enhanced UI and notifications (Essential)
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

    { "tpope/vim-sleuth",      event = "VeryLazy" },

    -- Enhanced navigation (Useful - keep if you use it)
    {
        "folke/flash.nvim",
        keys = {
            { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
            { "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
            { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
            { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
        },
        config = function()
            require("flash").setup()
        end,
    },

    -- Git diff viewer (Useful - only loads when needed)
    {
        "sindrets/diffview.nvim",
        cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("diffview").setup()
        end,
    },

    -- {
    --     "pwntester/octo.nvim",
    --     event = "VeryLazy",
    --     dependencies = {
    --         "nvim-lua/plenary.nvim",
    --         "nvim-telescope/telescope.nvim",
    --         "nvim-tree/nvim-web-devicons", -- optional, for icons
    --     },
    --     config = function()
    --         require("octo").setup()
    --     end,
    -- },

    -- REMOVED: conform.nvim (empty config, LSP formatting already configured)
    -- REMOVED: fidget.nvim (redundant with noice.nvim LSP progress)

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
            -- Optional: set a keymap for convenience
            vim.keymap.set("n", "<leader>gg", "<cmd>LazyGit<CR>", { desc = "Open LazyGit" })
        end,
    },

    -- "github/copilot.vim",


    -- ============================================================================
    -- EDITING ENHANCEMENTS
    -- ============================================================================

    -- Auto-close brackets and quotes
    {
        "echasnovski/mini.pairs",
        version = "*",
        event = "InsertEnter",
        config = function()
            require("mini.pairs").setup()
        end,
    },

    -- Multiple cursors support (Advanced editing)
    {
        "brenton-leighton/multiple-cursors.nvim",
        version = "*",
        opts = {},
        keys = {
            { "<C-j>",         "<Cmd>MultipleCursorsAddDown<CR>",          mode = { "n", "x" },      desc = "Add cursor and move down" },
            { "<C-k>",         "<Cmd>MultipleCursorsAddUp<CR>",            mode = { "n", "x" },      desc = "Add cursor and move up" },
            { "<C-Up>",        "<Cmd>MultipleCursorsAddUp<CR>",            mode = { "n", "i", "x" }, desc = "Add cursor and move up" },
            { "<C-Down>",      "<Cmd>MultipleCursorsAddDown<CR>",          mode = { "n", "i", "x" }, desc = "Add cursor and move down" },
            { "<C-LeftMouse>", "<Cmd>MultipleCursorsMouseAddDelete<CR>",   mode = { "n", "i" },      desc = "Add or remove cursor" },
            { "<Leader>m",     "<Cmd>MultipleCursorsAddVisualArea<CR>",    mode = { "x" },           desc = "Add cursors to the lines of the visual area" },
            { "<Leader>a",     "<Cmd>MultipleCursorsAddMatches<CR>",       mode = { "n", "x" },      desc = "Add cursors to cword" },
            { "<Leader>A",     "<Cmd>MultipleCursorsAddMatchesV<CR>",      mode = { "n", "x" },      desc = "Add cursors to cword in previous area" },
            { "<Leader>d",     "<Cmd>MultipleCursorsAddJumpNextMatch<CR>", mode = { "n", "x" },      desc = "Add cursor and jump to next cword" },
            { "<Leader>D",     "<Cmd>MultipleCursorsJumpNextMatch<CR>",    mode = { "n", "x" },      desc = "Jump to next cword" },
            { "<Leader>l",     "<Cmd>MultipleCursorsLock<CR>",             mode = { "n", "x" },      desc = "Lock virtual cursors" },
        },
    },
})
