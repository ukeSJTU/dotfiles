return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'mason-org/mason.nvim', opts = {} },
      'mason-org/mason-lspconfig.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
      'saghen/blink.cmp',
    },
    config = function()
      local function python_tool(tool, args)
        return function(dispatchers, config)
          local command = tool
          if config.root_dir then
            local project_command = vim.fs.joinpath(config.root_dir, '.venv', 'bin', tool)
            if vim.fn.executable(project_command) == 1 then
              command = project_command
            end
          end
          return vim.lsp.rpc.start(vim.list_extend({ command }, args), dispatchers)
        end
      end

      local lsp_group = vim.api.nvim_create_augroup('lsp-attach', { clear = true })
      local highlight_group = vim.api.nvim_create_augroup('lsp-highlight', { clear = true })

      vim.api.nvim_create_autocmd('LspAttach', {
        group = lsp_group,
        callback = function(event)
          local map = function(keys, func, desc, mode)
            vim.keymap.set(mode or 'n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
          map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
          map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
          map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
          map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')
          map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')
          map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if not client then
            return
          end

          if client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_group,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_group,
              callback = vim.lsp.buf.clear_references,
            })
          end

          if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map('<leader>th', function()
              local enabled = vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }
              vim.lsp.inlay_hint.enable(not enabled, { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      vim.api.nvim_create_autocmd('LspDetach', {
        group = lsp_group,
        callback = function(event)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = highlight_group, buffer = event.buf }
        end,
      })

      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {},
        virtual_text = { source = 'if_many', spacing = 2 },
      }

      local capabilities = require('blink.cmp').get_lsp_capabilities()
      local servers = {
        vtsls = {},
        biome = {},
        eslint = {},
        oxlint = {},
        ty = {
          cmd = python_tool('ty', { 'server' }),
          settings = {
            ty = {
              diagnosticMode = 'workspace',
            },
          },
        },
        ruff = {
          cmd = python_tool('ruff', { 'server' }),
          on_attach = function(client)
            client.server_capabilities.hoverProvider = false
          end,
        },
        tinymist = {},
        lua_ls = {
          settings = {
            Lua = {
              completion = { callSnippet = 'Replace' },
            },
          },
        },
      }

      for name, server in pairs(servers) do
        server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
        vim.lsp.config(name, server)
      end

      local server_names = vim.tbl_keys(servers)
      require('mason-lspconfig').setup {
        ensure_installed = server_names,
        automatic_enable = server_names,
      }
    end,
  },
}
