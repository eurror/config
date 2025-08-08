-- lua/core/lsp.lua

-- Safe require function to handle missing plugins
local function safe_require(module)
    local ok, result = pcall(require, module)
    if not ok then
        vim.notify("Failed to load " .. module .. ": " .. result, vim.log.levels.ERROR)
        return nil
    end
    return result
end

-- Setup neodev first for Neovim Lua development
local neodev = safe_require("neodev")
if neodev then
    neodev.setup({
        library = {
            enabled = true, -- when not enabled, neodev will not change any settings to the LSP server
            runtime = true, -- runtime path
            types = true, -- full signature, docs and completion of vim.api, vim.treesitter, vim.lsp and others
            plugins = true, -- installed opt or start plugins in packpath
        },
        setup_jsonls = true, -- configures jsonls to provide completion for project specific .luarc.json files
        lspconfig = true,
        pathStrict = true,
    })
end

-- Load required modules safely
local lspconfig = safe_require("lspconfig")
local cmp = safe_require("cmp")
local luasnip = safe_require("luasnip")
local cmp_nvim_lsp = safe_require("cmp_nvim_lsp")
local mason = safe_require("mason")
local mason_lspconfig = safe_require("mason-lspconfig")

-- Exit early if core modules aren't available
if not lspconfig or not cmp or not mason or not mason_lspconfig then
    vim.notify("LSP configuration requires missing plugins", vim.log.levels.ERROR)
    return
end

-- Configure diagnostic signs
local signs = {
    { name = "DiagnosticSignError", text = "" },
    { name = "DiagnosticSignWarn", text = "" },
    { name = "DiagnosticSignHint", text = "" },
    { name = "DiagnosticSignInfo", text = "" },
}

for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
end

-- Setup Mason for managing LSP servers
mason.setup({
    ui = {
        border = "rounded",
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
})

-- Configure which language servers to install
local servers = {
    "pyright",      -- Python type checking
    "lua_ls",       -- Lua language server
    "jsonls",       -- JSON language server
    "html",         -- HTML language server
    "cssls",        -- CSS language server
    "ruff",         -- Python linting and formatting
    "bashls",       -- Bash language server (recommended addition)
    "marksman",     -- Markdown language server (recommended addition)
}

mason_lspconfig.setup({
    ensure_installed = servers,
    automatic_installation = true,
})

-- Configure LSP key mappings
local on_attach = function(client, bufnr)
    local opts = { noremap = true, silent = true, buffer = bufnr }

    -- Navigation keybindings
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Go to declaration" }))
    vim.keymap.set("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "Find references" }))
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "Go to implementation" }))
    vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, vim.tbl_extend("force", opts, { desc = "Go to type definition" }))

    -- Documentation and help
    vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Show hover documentation" }))
    vim.keymap.set("n", "<leader>sh", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "Show signature help" }))

    -- Code actions and refactoring
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))
    vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code actions" }))

    -- Diagnostics
    vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, vim.tbl_extend("force", opts, { desc = "Show line diagnostics" }))
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, vim.tbl_extend("force", opts, { desc = "Previous diagnostic" }))
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, vim.tbl_extend("force", opts, { desc = "Next diagnostic" }))
    vim.keymap.set("n", "<leader>dl", "<cmd>Telescope diagnostics<cr>", vim.tbl_extend("force", opts, { desc = "List diagnostics" }))

    -- Formatting
    vim.keymap.set("n", "<leader>f", function()
        vim.lsp.buf.format({ async = true })
    end, vim.tbl_extend("force", opts, { desc = "Format document" }))

    -- Workspace management
    vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, vim.tbl_extend("force", opts, { desc = "Add workspace folder" }))
    vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, vim.tbl_extend("force", opts, { desc = "Remove workspace folder" }))
    vim.keymap.set("n", "<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, vim.tbl_extend("force", opts, { desc = "List workspace folders" }))
end

-- Setup capabilities for completion
local capabilities = vim.tbl_deep_extend(
    "force",
    {},
    vim.lsp.protocol.make_client_capabilities(),
    cmp_nvim_lsp and cmp_nvim_lsp.default_capabilities() or {}
)

-- Enhanced server configurations
local server_configs = {
    -- Python language server with enhanced settings
    pyright = {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
            python = {
                analysis = {
                    typeCheckingMode = "off",
                    autoImportCompletions = true,
                    autoSearchPaths = true,
                    useLibraryCodeForTypes = true,
                    diagnosticMode = "workspace",
                },
            },
        },
    },

    -- Lua language server optimized for Neovim
    lua_ls = {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
            Lua = {
                runtime = {
                    version = "LuaJIT",
                },
                diagnostics = {
                    globals = { "vim" },
                    disable = { "missing-fields" },
                },
                workspace = {
                    library = vim.api.nvim_get_runtime_file("", true),
                    checkThirdParty = false,
                    maxPreload = 100000,
                    preloadFileSize = 10000,
                },
                telemetry = {
                    enable = false,
                },
                completion = {
                    callSnippet = "Replace",
                },
                format = {
                    enable = true,
                    defaultConfig = {
                        indent_style = "space",
                        indent_size = "4",
                    },
                },
            },
        },
    },

    -- Ruff for Python linting and formatting
    ruff = {
        capabilities = capabilities,
        on_attach = function(client, bufnr)
            -- Disable hover in favor of Pyright
            client.server_capabilities.hoverProvider = false
            on_attach(client, bufnr)
        end,
        init_options = {
            settings = {
                args = {},
            }
        }
    },

    -- JSON language server with schema support
    jsonls = {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
            json = {
                schemas = require('schemastore').json.schemas(),
                validate = { enable = true },
            },
        },
    },
}

-- Setup configured servers
for server_name, config in pairs(server_configs) do
    if lspconfig[server_name] then
        lspconfig[server_name].setup(config)
    end
end

-- Setup remaining servers with default configuration
local simple_servers = { "html", "cssls", "bashls", "marksman" }
for _, server_name in ipairs(simple_servers) do
    if lspconfig[server_name] then
        lspconfig[server_name].setup({
            capabilities = capabilities,
            on_attach = on_attach,
        })
    end
end

-- Configure diagnostics appearance
vim.diagnostic.config({
    virtual_text = {
        prefix = '●',
        spacing = 4,
        source = "if_many",
        format = function(diagnostic)
            if diagnostic.severity == vim.diagnostic.severity.ERROR then
                return string.format("E: %s", diagnostic.message)
            elseif diagnostic.severity == vim.diagnostic.severity.WARN then
                return string.format("W: %s", diagnostic.message)
            elseif diagnostic.severity == vim.diagnostic.severity.INFO then
                return string.format("I: %s", diagnostic.message)
            elseif diagnostic.severity == vim.diagnostic.severity.HINT then
                return string.format("H: %s", diagnostic.message)
            end
            return diagnostic.message
        end,
    },
    float = {
        source = 'always',
        border = 'rounded',
        header = '',
        prefix = '',
        focusable = false,
    },
    signs = {
        active = signs,
    },
    underline = true,
    update_in_insert = false,
    severity_sort = true,
})

-- Configure LSP handlers for better UI
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded",
})

-- Configure nvim-cmp (completion) - only if available
if not cmp then
    return
end

local kind_icons = {
    Text = "",
    Method = "󰆧",
    Function = "󰊕",
    Constructor = "",
    Field = "󰇽",
    Variable = "󰂡",
    Class = "󰠱",
    Interface = "",
    Module = "",
    Property = "󰜢",
    Unit = "",
    Value = "󰎠",
    Enum = "",
    Keyword = "󰌋",
    Snippet = "",
    Color = "󰏘",
    File = "󰈙",
    Reference = "",
    Folder = "󰉋",
    EnumMember = "",
    Constant = "󰏿",
    Struct = "",
    Event = "",
    Operator = "󰆕",
    TypeParameter = "󰅲",
}

cmp.setup({
    snippet = {
        expand = function(args)
            if luasnip then
                luasnip.lsp_expand(args.body)
            end
        end,
    },
    window = {
        completion = cmp.config.window.bordered({
            border = "rounded",
            winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
        }),
        documentation = cmp.config.window.bordered({
            border = "rounded",
            winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
        }),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = false
        }),
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip and luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip and luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp', priority = 1000 },
        { name = 'luasnip', priority = 750 },
        { name = 'buffer', priority = 500, keyword_length = 3 },
        { name = 'path', priority = 250 },
    }),
    formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
            -- Add icons
            vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind] or "", vim_item.kind)

            -- Truncate long completion items
            if string.len(vim_item.abbr) > 40 then
                vim_item.abbr = string.sub(vim_item.abbr, 1, 40) .. "..."
            end

            -- Show source with different colors
            vim_item.menu = ({
                nvim_lsp = "[LSP]",
                luasnip = "[Snippet]",
                buffer = "[Buffer]",
                path = "[Path]",
            })[entry.source.name]

            return vim_item
        end,
    },
    experimental = {
        ghost_text = {
            hl_group = "CmpGhostText",
        },
    },
})

-- Add this to your configuration
vim.api.nvim_create_autocmd("LspProgress", {
    callback = function(args)
        vim.notify(args.data.params.value.message or "LSP Working...", vim.log.levels.INFO)
    end,
})
