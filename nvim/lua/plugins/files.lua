return {
    { "nvim-lua/plenary.nvim" },
    { "b0o/schemastore.nvim" },

    {
        "nvim-tree/nvim-tree.lua",
        event  = "VeryLazy",
        config = function()
            require("nvim-tree").setup({
                view = {
                    side = "left",
                    width = 35,
                    adaptive_size = true,
                    relativenumber = true,
                    number = true,
                    float = {
                        enable = false
                    }
                },
                hijack_cursor = true,
                hijack_unnamed_buffer_when_opening = true,
                sync_root_with_cwd = true,
                respect_buf_cwd = true,
                diagnostics = { enable = true },
                git = {
                    enable = true,
                    ignore = true,
                    timeout = 200,
                },
                renderer = {
                    highlight_git = true,
                    highlight_opened_files = "all",
                    root_folder_label = false,
                    indent_markers = { enable = true },
                    icons = {
                        glyphs = {
                            default = "",
                            symlink = "",
                            git = {
                                unstaged = "",
                                staged = "S",
                                unmerged = "",
                                renamed = "➜",
                                untracked = "U",
                                deleted = "",
                                ignored = "◌",
                            },
                            folder = {
                                default = "",
                                open = "",
                                empty = "",
                                empty_open = "",
                                symlink = "",
                            },
                        },
                    },
                },
                actions = {
                    open_file = {
                        quit_on_open = true,
                        window_picker = { enable = false },
                    },
                    change_dir = {
                        enable = true,
                        global = true,
                    },
                },
                update_focused_file = {
                    enable = true,
                    update_cwd = true,
                    ignore_list = {},
                },
                system_open = {
                    cmd = "open",
                },
            })
            vim.api.nvim_create_autocmd("QuitPre", {
                callback = function()
                    if require("nvim-tree.api").tree.is_visible() then
                        require("nvim-tree.api").tree.close()
                    end
                end,
            })
        end,
    },

    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "BurntSushi/ripgrep",
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
            "nvim-telescope/telescope-ui-select.nvim",
        },
        config = function()
            require("telescope").setup {
                defaults = {
                    prompt_prefix = " ",
                    selection_caret = " ",
                    file_ignore_patterns = {
                        "venv", ".venv", "node_modules", ".git",
                        "__pycache__", "*.pyc", ".pytest_cache",
                        "target", "build", "dist"
                    },
                    layout_config = { prompt_position = "top" },
                    sorting_strategy = "ascending",
                    winblend = 10,
                    preview = {
                        filesize_limit = 1,
                    },
                    file_sorter = require("telescope.sorters").get_fuzzy_file,
                    generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
                    path_display = { "truncate" },
                    dynamic_preview_title = true,
                    results_title = false,
                    cache_picker = {
                        num_pickers = 5,
                    },
                },
                extensions = {
                    fzf = {
                        fuzzy = true,
                        override_generic_sorter = true,
                        override_file_sorter = true,
                        case_mode = "smart_case",
                    },
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown {}
                    }
                },
            }
            require("telescope").load_extension("fzf")
            require("telescope").load_extension("ui-select")
        end,
    },
}
