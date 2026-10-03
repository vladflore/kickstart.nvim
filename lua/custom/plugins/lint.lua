-- Linters that don't come with a language server (bashls and ruff already report diagnostics).
-- Replaces kickstart.plugins.lint, which expects markdownlint.
local util = require 'custom.util'

vim.pack.add { util.gh 'mfussenegger/nvim-lint' }

local lint = require 'lint'
lint.linters_by_ft = {
  java = { 'checkstyle' }, -- Google style by default, matching google-java-format
}

-- checkstyle writes SARIF file URIs as `file:/path`, but nvim-lint only maps `file:///path`
-- to buffers, so every result would be dropped. Normalize the URIs before parsing.
local checkstyle = lint.linters.checkstyle
local parse_sarif = checkstyle.parser
checkstyle.parser = function(output, ...) return parse_sarif((output:gsub('"file:/([^/])', '"file:///%1')), ...) end

vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
  group = vim.api.nvim_create_augroup('lint', { clear = true }),
  callback = function()
    if vim.bo.modifiable then lint.try_lint() end
  end,
})
