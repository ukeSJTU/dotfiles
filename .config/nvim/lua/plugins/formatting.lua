local project = require 'config.project'

local function buffer_path(bufnr)
  local path = vim.api.nvim_buf_get_name(bufnr)
  return path ~= '' and path or vim.uv.cwd()
end

local function javascript_formatters(bufnr)
  local path = buffer_path(bufnr)
  local formatters = {}
  for _, formatter in ipairs { 'oxfmt', 'biome', 'prettier' } do
    local supports_filetype = formatter ~= 'biome' or vim.bo[bufnr].filetype ~= 'scss'
    if supports_filetype and project.has_js_tool(path, formatter) then
      table.insert(formatters, formatter)
    end
  end
  formatters.stop_after_first = true
  return formatters
end

local javascript_filetypes = {
  'css',
  'html',
  'javascript',
  'javascriptreact',
  'json',
  'jsonc',
  'scss',
  'typescript',
  'typescriptreact',
}

local formatters_by_ft = {
  lua = { 'stylua' },
  python = function(bufnr)
    return project.uses_ruff(buffer_path(bufnr)) and { 'ruff_format' } or {}
  end,
}

for _, filetype in ipairs(javascript_filetypes) do
  formatters_by_ft[filetype] = javascript_formatters
end

return {
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = function()
      return {
        notify_on_error = false,
        format_on_save = function(bufnr)
          local formatters = require('conform').list_formatters_to_run(bufnr)
          if #formatters == 0 then
            return nil
          end
          return {
            timeout_ms = 1000,
            lsp_format = 'never',
          }
        end,
        formatters_by_ft = formatters_by_ft,
        formatters = {
          ruff_format = {
            command = require('conform.util').find_executable({ '.venv/bin/ruff' }, 'ruff'),
          },
        },
      }
    end,
  },
}
