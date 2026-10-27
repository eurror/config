return {
  settings = {
    json = {
      validate = { enable = true },
      schemas = {
        { fileMatch = { 'package.json' }, url = 'https://json.schemastore.org/package.json' },
        { fileMatch = { 'tsconfig*.json', 'jsconfig*.json' }, url = 'https://json.schemastore.org/tsconfig.json' },
        { fileMatch = { 'composer.json' }, url = 'https://getcomposer.org/schema.json' },
        { fileMatch = { '.prettierrc', '.prettierrc.json' }, url = 'https://json.schemastore.org/prettierrc.json' },
        { fileMatch = { '.eslintrc', '.eslintrc.json' }, url = 'https://json.schemastore.org/eslintrc.json' },
      },
    },
  },
}
