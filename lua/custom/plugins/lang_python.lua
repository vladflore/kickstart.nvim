-- Python: pyright (types, navigation), ruff (lint, format, imports), debugpy (debugging)
local util = require 'custom.util'

util.mason_install { 'pyright', 'ruff', 'debugpy' }
require('nvim-treesitter').install { 'python' }

vim.lsp.config('pyright', {
  settings = {
    -- ruff handles import sorting
    pyright = { disableOrganizeImports = true },
  },
})
vim.lsp.config('ruff', {
  on_attach = function(client)
    -- Leave hover to pyright, which has the type information
    client.server_capabilities.hoverProvider = false
  end,
})
vim.lsp.enable { 'pyright', 'ruff' }

require('conform').formatters_by_ft.python = { 'ruff_format', 'ruff_organize_imports' }
util.format_on_save { 'python' }

-- Debugging, see lua/custom/plugins/debug.lua for keymaps
vim.pack.add { util.gh 'mfussenegger/nvim-dap', util.gh 'mfussenegger/nvim-dap-python' }
require('dap-python').setup(vim.fn.stdpath 'data' .. '/mason/packages/debugpy/venv/bin/python')
