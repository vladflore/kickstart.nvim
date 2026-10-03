-- Java: nvim-jdtls (LSP + refactorings + test runner), google-java-format, checkstyle (see lint.lua)
-- jdtls is started per project by nvim-jdtls instead of `vim.lsp.enable`, so it is not in init.lua's `servers`.
local util = require 'custom.util'

util.mason_install { 'jdtls', 'google-java-format', 'checkstyle', 'java-debug-adapter', 'java-test' }
require('nvim-treesitter').install { 'java' }

require('conform').formatters_by_ft.java = { 'google-java-format' }
util.format_on_save { 'java' }

vim.pack.add { util.gh 'mfussenegger/nvim-jdtls', util.gh 'mfussenegger/nvim-dap' }
require('which-key').add { { '<leader>j', group = '[J]ava' } }

local mason = vim.fn.stdpath 'data' .. '/mason'

-- Extra jars loaded into jdtls for debugging and running tests
local function bundles()
  local jars = vim.fn.glob(mason .. '/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar', true, true)
  for _, jar in ipairs(vim.fn.glob(mason .. '/packages/java-test/extension/server/*.jar', true, true)) do
    local name = vim.fs.basename(jar)
    -- These ship with java-test but are not jdtls plugins, and break jdtls when loaded as bundles
    if name ~= 'com.microsoft.java.test.runner-jar-with-dependencies.jar' and name ~= 'jacocoagent.jar' then table.insert(jars, jar) end
  end
  return jars
end

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('custom-jdtls', { clear = true }),
  pattern = 'java',
  callback = function(args)
    -- Build wrappers/settings files mark the top of a multi-module project, so prefer them
    local root = vim.fs.root(args.buf, {
      { 'mvnw', 'gradlew', 'settings.gradle', 'settings.gradle.kts' },
      { 'pom.xml', 'build.gradle', 'build.gradle.kts' },
      '.git',
    })
    if not root then
      if args.file == '' then return end
      root = vim.fs.dirname(vim.fs.abspath(args.file))
    end

    local jdtls = require 'jdtls'
    jdtls.start_or_attach {
      -- Each project needs its own jdtls workspace (index + caches)
      cmd = { mason .. '/bin/jdtls', '-data', vim.fn.stdpath 'cache' .. '/jdtls/' .. (root:gsub('[/\\:]', '_')) },
      root_dir = root,
      capabilities = require('blink.cmp').get_lsp_capabilities(),
      init_options = { bundles = bundles() },
      on_attach = function(_, bufnr)
        jdtls.setup_dap { hotcodereplace = 'auto' }

        local map = function(keys, func, desc, mode) vim.keymap.set(mode or 'n', keys, func, { buffer = bufnr, desc = 'Java: ' .. desc }) end
        map('<leader>jo', jdtls.organize_imports, '[O]rganize imports')
        map('<leader>jv', jdtls.extract_variable, 'Extract [v]ariable')
        map('<leader>jv', function() jdtls.extract_variable { visual = true } end, 'Extract [v]ariable', 'x')
        map('<leader>jc', jdtls.extract_constant, 'Extract [c]onstant')
        map('<leader>jc', function() jdtls.extract_constant { visual = true } end, 'Extract [c]onstant', 'x')
        map('<leader>jm', function() jdtls.extract_method { visual = true } end, 'Extract [m]ethod', 'x')
        map('<leader>jt', jdtls.test_class, '[T]est class')
        map('<leader>jn', jdtls.test_nearest_method, 'Test [n]earest method')
      end,
    }
  end,
})
