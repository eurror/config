require('mason').setup()

local packages = {
  'astro-language-server',
  'basedpyright',
  'docker-language-server',
  'eslint-lsp',
  'intelephense',
  'json-lsp',
  'lua-language-server',
  'marksman',
  'postgres-language-server',
  'ruff',
  'vtsls',
  'yaml-language-server',
  'pgformatter',
  'prettierd',
  'stylua',
}

local registry = require('mason-registry')

registry.refresh(function()
  for _, name in ipairs(packages) do
    local pkg = registry.get_package(name)
    if not pkg:is_installed() and not pkg:is_installing() then
      pkg:install()
    end
  end
end)
