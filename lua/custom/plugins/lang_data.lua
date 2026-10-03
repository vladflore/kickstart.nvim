-- JSON, YAML, TOML: language servers with schemas from SchemaStore
-- (package.json, GitHub Actions, docker-compose, pyproject.toml, ...)
local util = require 'custom.util'

util.mason_install { 'json-lsp', 'yaml-language-server', 'taplo' }
require('nvim-treesitter').install { 'json', 'yaml', 'toml' }

vim.pack.add { util.gh 'b0o/SchemaStore.nvim' }
local schemastore = require 'schemastore'

vim.lsp.config('jsonls', {
  settings = {
    json = {
      schemas = schemastore.json.schemas(),
      validate = { enable = true },
    },
  },
})
vim.lsp.config('yamlls', {
  settings = {
    yaml = {
      -- Use SchemaStore.nvim's catalog instead of yamlls's built-in download
      schemaStore = { enable = false, url = '' },
      schemas = schemastore.yaml.schemas(),
    },
  },
})
vim.lsp.enable { 'jsonls', 'yamlls', 'taplo' }
