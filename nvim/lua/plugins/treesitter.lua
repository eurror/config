return {
  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdateSync",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "HiPhish/nvim-ts-rainbow2",
    },
    opts = {
      ensure_installed = {
        "python",
        "lua",
        "json",
        "html",
        "css",
        "yaml",
        "toml",
        "bash",
        "dockerfile",
        "sql",
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
      rainbow = { enable = true, query = 'rainbow-parens', strategy = require('ts-rainbow.strategy.global') },
      autotag = {
        enable = true,
      },
      auto_install = true,
      refactor = {
        highlight_definitions = { enable = true },
        highlight_current_scope = { enable = true },
      },

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
            ["@parameter.outer"] = "v",
            ["@function.outer"] = "v",
            ["@class.outer"] = "V",
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
      disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
          return true
        end

        local ok2, lines = pcall(vim.api.nvim_buf_line_count, buf)
        if ok2 and lines > 3000 then
          return true
        end
      end,
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}
