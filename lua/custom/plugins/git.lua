-- Git: lazygit in a floating window (uses your lazygit config), plus parsers for commit messages and git config
local util = require 'custom.util'

vim.pack.add { util.gh 'kdheepak/lazygit.nvim' }
require('nvim-treesitter').install { 'gitcommit', 'git_config', 'git_rebase', 'gitignore' }

require('which-key').add { { '<leader>g', group = '[G]it' } }
vim.keymap.set('n', '<leader>gg', '<Cmd>LazyGit<CR>', { desc = 'Lazy[g]it' })
