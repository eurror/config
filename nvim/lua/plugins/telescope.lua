return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "BurntSushi/ripgrep",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-telescope/telescope-ui-select.nvim",
      "nvim-treesitter/nvim-treesitter",
      "sharkdp/fd",
      "nvim-tree/nvim-web-devicons",
      "neovim/nvim-lspconfig"
    },
    config = function()
      require("telescope").setup {
        defaults = {
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--hidden",
            "--glob=!.git/",
            "--no-follow",
            "--max-depth=10",
          },
          file_ignore_patterns = {
            "^.git/",
            "^node_modules/",
            "^venv/",
            "^%.venv/",
            "^__pycache__/",
            "%.pyc$",
            "^%.pytest_cache/",
            "^%.mypy_cache/",
            "^target/",
            "^build/",
            "^dist/",
            "^coverage/",
          },
          preview = {
            filesize_limit = 1,
            treesitter = false,
          },
          path_display = { "truncate" },
          dynamic_preview_title = true,
          results_title = false,
          cache_picker = {
            num_pickers = 5,
          },
          pickers = {
            find_files = {
              find_command = { "fd", "--type", "f", "--hidden", "--follow", "--exclude", ".git" },
              hidden = true,
              follow = false,
            }, },
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
