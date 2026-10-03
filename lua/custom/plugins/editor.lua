-- Editing and navigation: oil (file explorer), flash (jumps), trouble (lists), treesitter-context
local util = require 'custom.util'

vim.pack.add {
  util.gh 'stevearc/oil.nvim',
  util.gh 'folke/flash.nvim',
  util.gh 'folke/trouble.nvim',
  util.gh 'nvim-treesitter/nvim-treesitter-context',
}

-- Edit directories like buffers: rename/move/delete files by editing text, then :w
require('oil').setup {
  view_options = { show_hidden = true },
}
vim.keymap.set('n', '-', '<Cmd>Oil<CR>', { desc = 'Open parent directory (Oil)' })

-- Jump to any visible location with a label. `s` is taken by mini.surround, so use `gs`.
require('flash').setup {}
vim.keymap.set({ 'n', 'x', 'o' }, 'gs', function() require('flash').jump() end, { desc = 'Flash jump' })
vim.keymap.set({ 'n', 'x', 'o' }, 'gS', function() require('flash').treesitter() end, { desc = 'Flash Treesitter select' })
vim.keymap.set('o', 'r', function() require('flash').remote() end, { desc = 'Remote Flash' })
vim.keymap.set({ 'o', 'x' }, 'R', function() require('flash').treesitter_search() end, { desc = 'Treesitter search' })

-- Lists for diagnostics, symbols, references and quickfix
require('trouble').setup {}
require('which-key').add { { '<leader>x', group = 'Trouble' } }
vim.keymap.set('n', '<leader>xx', '<Cmd>Trouble diagnostics toggle<CR>', { desc = 'Diagnostics (workspace)' })
vim.keymap.set('n', '<leader>xX', '<Cmd>Trouble diagnostics toggle filter.buf=0<CR>', { desc = 'Diagnostics (buffer)' })
vim.keymap.set('n', '<leader>xs', '<Cmd>Trouble symbols toggle focus=false<CR>', { desc = 'Symbols' })
vim.keymap.set('n', '<leader>xl', '<Cmd>Trouble lsp toggle focus=false win.position=right<CR>', { desc = 'LSP definitions/references' })
vim.keymap.set('n', '<leader>xq', '<Cmd>Trouble qflist toggle<CR>', { desc = 'Quickfix list' })

-- Keep the enclosing function/class signature visible at the top of the window
require('treesitter-context').setup { max_lines = 3 }
