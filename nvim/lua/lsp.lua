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

local cmp = require("cmp")
cmp.setup(
    {
        sources = {
            { name = "nvim_lsp" },
            { name = "luasnip" },
            { name = "buffer" },
            { name = "path" },
        },
        mapping = cmp.mapping.preset.insert({
            ["<CR>"] = cmp.mapping.confirm({select = false})
        }),
    }
)

local luasnip = require("luasnip")
luasnip.config.set_config({
    history = true,
    updateevents = "TextChanged,TextChangedI",
})
require("luasnip.loaders.from_vscode").lazy_load()

local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()
for _, server in ipairs(servers) do
    lspconfig[server].setup({
        capabilities = capabilities,
    })
end
lspconfig.lua_ls.setup {
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            }
        }
    }
}

require("mason").setup(
    {
        ui = {
            border = "rounded",
            icons = {
                package_installed = "✓",
                package_pending = "➜",
                package_uninstalled = "✗"
            }
        }
    }
)
require("mason-lspconfig").setup({
    ensure_installed = servers,
    automatic_installation = true,
})
