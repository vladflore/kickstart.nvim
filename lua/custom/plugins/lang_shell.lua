-- Shell: bashls (picks up shellcheck from Mason for diagnostics), shfmt (format with <leader>f)
local util = require 'custom.util'

util.mason_install { 'bash-language-server', 'shellcheck', 'shfmt' }
require('nvim-treesitter').install { 'bash' }

vim.lsp.enable 'bashls'

require('conform').formatters_by_ft.sh = { 'shfmt' }
require('conform').formatters_by_ft.bash = { 'shfmt' }
