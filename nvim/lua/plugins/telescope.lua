return {
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
