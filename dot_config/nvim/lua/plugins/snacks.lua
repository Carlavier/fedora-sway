return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  opts = {
    dashboard = {
      enabled = true,
      layout = {
        show_statusline = true,
      },
      preset = {
        keys = {
          {
            icon = '󰈔 ',
            key = '<leader>sf',
            desc = 'Search Files',
            action = function()
              if _G.search_handlers then
                _G.search_handlers.find_files()
              else
                require('telescope.builtin').find_files()
              end
            end,
          },
          {
            icon = ' ',
            key = '<leader>sg',
            desc = 'Search by Grep',
            action = function()
              if _G.search_handlers then
                _G.search_handlers.live_grep()
              else
                require('telescope.builtin').live_grep()
              end
            end,
          },
          {
            icon = ' ',
            key = '<leader>pf',
            desc = 'Open Oil',
            action = function()
              if vim.bo.filetype == 'oil' then
                require('oil').parent()
              else
                local current = vim.api.nvim_buf_get_name(0)
                if current == '' or current:match('^oil://') then
                  require('oil').open(vim.fn.getcwd())
                else
                  require('oil').open()
                end
              end
            end,
          },
          {
            icon = '󰞋 ',
            key = '<leader>sh',
            desc = 'Search Help',
            action = function()
              if _G.search_handlers then
                _G.search_handlers.help_tags()
              else
                require('telescope.builtin').help_tags()
              end
            end,
          },
          {
            icon = '󰘳 ',
            key = '<leader>sk',
            desc = 'Search Keymaps',
            action = function()
              if _G.search_handlers then
                _G.search_handlers.keymaps()
              else
                require('telescope.builtin').keymaps()
              end
            end,
          },
          {
            icon = '󱎘 ',
            key = ':q',
            desc = 'Quit',
            action = function()
              vim.cmd('q')
            end,
          },
        },
      },
      sections = {
        function()
          local handle = io.popen('fortune -sa | cowsay 2>/dev/null')
          local lines = {}
          local max_len = 0
          if handle then
            local result = handle:read('*a')
            handle:close()
            for line in result:gmatch('[^\r\n]+') do
              table.insert(lines, line)
              if #line > max_len then
                max_len = #line
              end
            end
          end
          if #lines == 0 then
            return {
              { text = '  Welcome to Neovim', hl = 'SnacksDashboardHeader', align = 'center' },
            }
          end
          local formatted_lines = {}
          for _, line in ipairs(lines) do
            local padding = string.rep(' ', max_len - #line)
            table.insert(formatted_lines, {
              text = line .. padding,
              hl = 'SnacksDashboardHeader',
              align = 'center',
            })
          end
          return formatted_lines
        end,
        { type = 'padding', val = 2 },
        {
          section = 'keys',
          gap = 1,
        },
        { type = 'padding', val = 2 },
        { section = 'startup' },
      },
    },
  },
  init = function()
    vim.api.nvim_create_autocmd('User', {
      pattern = 'SnacksDashboardOpened',
      callback = function()
        vim.opt.laststatus = 3

        vim.api.nvim_set_hl(0, 'SnacksDashboardHeader', { link = 'WarningMsg' })
        vim.api.nvim_set_hl(0, 'SnacksDashboardIcon', { link = 'Directory' })
        vim.api.nvim_set_hl(0, 'SnacksDashboardDesc', { link = 'Function' })

        local error_hl = vim.api.nvim_get_hl(0, { name = 'Error', link = false })
        local todo_hl = vim.api.nvim_get_hl(0, { name = 'Todo', link = false })

        local red_fg = error_hl.fg
        local pink_fg = todo_hl.fg

        vim.api.nvim_set_hl(0, 'SnacksDashboardKey', { fg = red_fg, bold = true })
        vim.api.nvim_set_hl(0, 'SnacksDashboardSpecial', { fg = pink_fg, bold = true, italic = true })
      end,
    })
  end,
}
