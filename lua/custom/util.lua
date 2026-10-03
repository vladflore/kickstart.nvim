-- Shared helpers for the modules in `lua/custom/plugins/`.
-- Lives outside `plugins/` so the auto-loader doesn't pick it up.
local M = {}

---@param repo string
---@return string
function M.gh(repo) return 'https://github.com/' .. repo end

--- Install Mason packages that aren't installed yet.
--- Uses Mason package names (e.g. `bash-language-server`, not `bashls`).
---@param packages string[]
function M.mason_install(packages)
  local registry = require 'mason-registry'
  registry.refresh(function()
    for _, name in ipairs(packages) do
      local ok, pkg = pcall(registry.get_package, name)
      if not ok then
        vim.notify('Unknown Mason package: ' .. name, vim.log.levels.WARN)
      elseif not pkg:is_installed() and not pkg:is_installing() then
        pkg:install()
      end
    end
  end)
end

-- Filetypes formatted on save. The `format_on_save` in init.lua is left as upstream,
-- so language modules opt in here instead.
local format_on_save = {}

vim.api.nvim_create_autocmd('BufWritePre', {
  group = vim.api.nvim_create_augroup('custom-format-on-save', { clear = true }),
  callback = function(args)
    -- 500ms (kickstart's default) is too short for google-java-format's startup
    if format_on_save[vim.bo[args.buf].filetype] then require('conform').format { bufnr = args.buf, timeout_ms = 3000 } end
  end,
})

---@param filetypes string[]
function M.format_on_save(filetypes)
  for _, ft in ipairs(filetypes) do
    format_on_save[ft] = true
  end
end

return M
