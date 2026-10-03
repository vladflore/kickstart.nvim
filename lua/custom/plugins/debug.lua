-- Debugging (DAP) core: nvim-dap + UI and keymaps.
-- Language adapters are configured in the lang_*.lua files (debugpy for Python, java-debug via nvim-jdtls).
-- Replaces kickstart.plugins.debug, which is set up for Go.
local util = require 'custom.util'

vim.pack.add {
  util.gh 'mfussenegger/nvim-dap',
  util.gh 'rcarriga/nvim-dap-ui',
  util.gh 'nvim-neotest/nvim-nio',
}

local dap = require 'dap'
local dapui = require 'dapui'

vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' })
vim.keymap.set('n', '<F1>', dap.step_into, { desc = 'Debug: Step Into' })
vim.keymap.set('n', '<F2>', dap.step_over, { desc = 'Debug: Step Over' })
vim.keymap.set('n', '<F3>', dap.step_out, { desc = 'Debug: Step Out' })
vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
vim.keymap.set('n', '<leader>B', function() dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ') end, { desc = 'Debug: Set Breakpoint' })
-- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: See last session result.' })

---@diagnostic disable-next-line: missing-fields
dapui.setup {}

vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
local signs = { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '▶' }
for type, icon in pairs(signs) do
  local hl = type == 'Stopped' and 'DapStop' or 'DapBreak'
  vim.fn.sign_define('Dap' .. type, { text = icon, texthl = hl, numhl = hl })
end

dap.listeners.after.event_initialized['dapui_config'] = dapui.open
dap.listeners.before.event_terminated['dapui_config'] = dapui.close
dap.listeners.before.event_exited['dapui_config'] = dapui.close
