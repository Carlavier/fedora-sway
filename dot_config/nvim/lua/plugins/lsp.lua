local servers = {
  lua_ls = {
    root_markers = { '.luarc.json', '.luarc.jsonc', '.git', 'init.lua' },
    single_file_support = false,
    settings = {
      Lua = {
        diagnostics = { globals = { 'vim' } },
      },
    },
  },

  vtsls = {
    settings = {
      vtsls = {
        format = { enable = false },
      },
    },
    on_clear_imports = function(bufnr)
      vim.keymap.set('n', '<leader>co', function()
        vim.lsp.buf.code_action({
          apply = true,
          context = {
            only = { 'source.organizeImports' },
            diagnostics = {},
          },
        })
      end, { buffer = bufnr, desc = 'Clear unused imports' })
    end,
  },

  emmet_language_server = {
    filetypes = {
      'css',
      'html',
      'javascriptreact',
      'less',
      'sass',
      'scss',
      'typescriptreact',
      'vue',
    },
  },

  clangd = {
    cmd = {
      'clangd',
      '--background-index',
      '--clang-tidy',
      '--header-insertion=iwyu',
      '--completion-style=detailed',
      '--function-arg-placeholders',
      '--fallback-style=llvm',
    },
    init_options = {
      usePlaceholders = true,
      completeUnimported = true,
      clangdFileStatus = true,
    },
    on_clear_imports = function(bufnr)
      vim.keymap.set('n', '<leader>co', function()
        vim.lsp.buf.code_action({
          apply = true,
          filter = function(action)
            return action.title == 'Fix all include-cleaner findings'
          end,
        })
      end, { buffer = bufnr, desc = 'Clear unused includes' })
    end,
  },

  basedpyright = {
    cmd = {
      vim.fn.stdpath('data') .. '/mason/bin/basedpyright-langserver',
      '--stdio',
    },
    settings = {
      basedpyright = {
        analysis = {
          extraPaths = { 'src' },
          autoImportCompletions = true,
          indexing = true,
          diagnosticMode = 'workspace',
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
          typeCheckingMode = 'basic',
        },
      },
    },
    on_clear_imports = function(bufnr)
      vim.keymap.set('n', '<leader>co', function()
        vim.lsp.buf.code_action({
          apply = true,
          context = { only = { 'source.organizeImports' } },
        })
      end, { buffer = bufnr, desc = 'Clear unused imports' })
    end,
  },
}

return {
  {
    'mason-org/mason.nvim',
    config = function()
      require('mason').setup({
        ui = {
          icons = {
            package_installed = '✓',
            package_pending = '➜',
            package_uninstalled = '✗',
          },
        },
      })
    end,
  },

  {
    'neovim/nvim-lspconfig',
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(event)
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = event.buf, desc = 'Go to definition' })
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = event.buf, desc = 'Go to declaration' })
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { buffer = event.buf, desc = 'Go to implementation' })
          vim.keymap.set('n', 'go', vim.lsp.buf.type_definition, { buffer = event.buf, desc = 'Go to type definition' })
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, { buffer = event.buf, desc = 'List references' })
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = event.buf, desc = 'Hover documentation' })
          vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, { buffer = event.buf, desc = 'Signature help' })
          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { buffer = event.buf, desc = 'Rename symbol' })
          vim.keymap.set(
            { 'n', 'v' },
            '<leader>ca',
            vim.lsp.buf.code_action,
            { buffer = event.buf, desc = 'Code actions' }
          )

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if not client then
            return
          end

          local server_config = servers[client.name]
          if server_config and server_config.on_clear_imports then
            server_config.on_clear_imports(event.buf)
          end
        end,
      })

      vim.env.PATH = vim.fn.stdpath('data') .. '/mason/bin:' .. vim.env.PATH

      local capabilities = require('blink.cmp').get_lsp_capabilities()
      for server_name, config in pairs(servers) do
        config.capabilities = capabilities
        vim.lsp.config(server_name, config)
        vim.lsp.enable(server_name)
      end
    end,
  },
}
