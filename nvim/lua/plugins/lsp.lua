local M = {}

-- Utility: Find Python interpreter
local function find_python_interpreter()
  local venv_paths = {
    vim.fn.getcwd() .. "/venv/bin/python",
    vim.fn.getcwd() .. "/.venv/bin/python",
    vim.env.VIRTUAL_ENV and (vim.env.VIRTUAL_ENV .. "/bin/python") or nil,
  }

  for _, path in ipairs(venv_paths) do
    if path and vim.fn.filereadable(path) == 1 then
      return path
    end
  end

  return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
end

-- LSP Server configurations
local function get_server_configs()
  return {
    pyright = {
      settings = {
        python = {
          pythonPath = find_python_interpreter(),
          analysis = {
            autoSearchPaths = true,
            diagnosticMode = "openFilesOnly",
            indexing = true,
            useLibraryCodeForTypes = true,
            typeCheckingMode = "off",
            autoImportCompletions = true,
          },
        },
      },
      filetypes ={"python"},
      before_init = function(_, config)
        config.settings.python.pythonPath = find_python_interpreter()
      end,
    },

    ruff = {
      init_options = {
        settings = {
          lineLength = 88,
          lint = {
            select = { "E", "F", "I" },
          },
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
          hint = {
            enable = true,
            setType = true,
            arrayIndex = "Disable",
          },
          completion = {
            callSnippet = "Replace",
            keywordSnippet = "Replace",
          },
          workspace = {
            checkThirdParty = false,
            library = {
              vim.env.VIMRUNTIME,
              "${3rd}/luv/library",
            },
          },
          telemetry = { enable = false },
        },
      },
    },
  }
end

-- Diagnostic configuration
local function setup_diagnostics()
  vim.diagnostic.config({
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = " ",
        [vim.diagnostic.severity.WARN]  = " ",
        [vim.diagnostic.severity.HINT]  = " ",
        [vim.diagnostic.severity.INFO]  = " ",
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
      source = true,
      header = "",
      prefix = function(diagnostic)
        local level = vim.diagnostic.severity[diagnostic.severity]
        local prefix_map = {
          ERROR = " ",
          WARN  = " ",
          HINT  = " ",
          INFO  = " ",
        }
        return prefix_map[level] .. " ", "Diagnostic" .. level
      end,
    },
  })

  -- Performance: Debounce diagnostics
  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.handlers["textDocument/publishDiagnostics"], {
      update_in_insert = false,
      virtual_text = { spacing = 4, prefix = "●" },
    }
  )
end

-- Floating window borders
local function setup_float_borders()
  local orig = vim.lsp.util.open_floating_preview
  function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    opts = opts or {}
    opts.border = "rounded"
    opts.max_width = opts.max_width or 80
    opts.max_height = opts.max_height or 20
    return orig(contents, syntax, opts, ...)
  end
end

-- Key mappings
local function setup_keymaps(_, bufnr)
  local map = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
  end

  map("n", "<leader>k", vim.lsp.buf.hover, "Hover Documentation")
  map("n", "gd", vim.lsp.buf.definition, "Go to Definition")
  map("n", "gD", vim.lsp.buf.declaration, "Go to Declaration")
  map("n", "gi", vim.lsp.buf.implementation, "Go to Implementation")
  map("n", "go", vim.lsp.buf.type_definition, "Go to Type Definition")
  map("n", "gr", vim.lsp.buf.references, "References")
  map("n", "gs", vim.lsp.buf.signature_help, "Signature Help")
  map("n", "<leader>r", vim.lsp.buf.rename, "Rename")
  map({ "n", "v" }, "<leader>a", vim.lsp.buf.code_action, "Code Action")
  map("n", "gl", vim.diagnostic.open_float, "Line Diagnostics")
  map("n", "[d", vim.diagnostic.goto_prev, "Previous Diagnostic")
  map("n", "]d", vim.diagnostic.goto_next, "Next Diagnostic")
  map("n", "<leader>q", vim.diagnostic.setloclist, "Quickfix Diagnostics")

  -- Performance: Refresh codelens on attach and cursor hold
  if vim.lsp.buf.code_lens then
    map("n", "<leader>cl", vim.lsp.codelens.run, "Run CodeLens")
    vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
      buffer = bufnr,
      callback = vim.lsp.codelens.refresh,
    })
  end
end

-- Performance optimizations
local function optimize_lsp_performance(client)
  -- Disable semantic tokens for better performance
  if client.server_capabilities.semanticTokensProvider then
    client.server_capabilities.semanticTokensProvider = nil
  end

  -- Disable document formatting if conform.nvim is used
  if client.name ~= "ruff" then
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end
end

-- Main setup
function M.setup()
  require("mason").setup({
    ui = {
      border = "rounded",
      width = 0.8,
      height = 0.8,
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗",
      },
    },
    max_concurrent_installers = 10,
  })

  local servers = get_server_configs()

  require("mason-lspconfig").setup({
    ensure_installed = vim.tbl_keys(servers),
    automatic_installation = true,
  })

  local capabilities = vim.tbl_deep_extend(
    "force",
    vim.lsp.protocol.make_client_capabilities(),
    require("cmp_nvim_lsp").default_capabilities()
  )

  -- Performance: Reduce workspace indexing
  capabilities.workspace = {
    didChangeWatchedFiles = { dynamicRegistration = false },
  }

  setup_diagnostics()
  setup_float_borders()

  local on_attach = function(client, bufnr)
    setup_keymaps(client, bufnr)
    optimize_lsp_performance(client)

    -- Auto-format on save (only if conform.nvim fails)
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({ async = false, timeout_ms = 2000 })
        end,
      })
    end
  end

  for server_name, server_config in pairs(servers) do
    vim.lsp.config(server_name, {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = server_config.settings or {},
    })
  end

  require("lazydev").setup({
    library = {
      { path = "luvit-meta/library", words = { "vim%.uv" } },
    },
  })
end

return {
  {
    "windwp/nvim-ts-autotag",
    lazy = true,
    opts = {},
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "folke/lazydev.nvim",
      "Bilal2453/luvit-meta",
    },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      M.setup()
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
        timeout_ms = 2000,
        lsp_fallback = true,
        async = false,
        quiet = true,
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
          require("conform").format({ async = true, lsp_fallback = true, timeout_ms = 2000 })
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
      ensure_installed = { "stylua", "ruff" },
      auto_update = false,
      run_on_start = true,
    },
  },
}
