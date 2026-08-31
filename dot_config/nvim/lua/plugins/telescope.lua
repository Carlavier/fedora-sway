local function folder_icon_entry_maker(opts)
  opts = opts or {}
  local devicons = require('nvim-web-devicons')
  local displayer = require('telescope.pickers.entry_display').create({
    separator = ' ',
    items = { { width = 2 }, { remaining = true } },
  })

  return function(line)
    if line == '' then
      return nil
    end
    local abs_path = line
    if opts.cwd and not (line:sub(1, 1) == '/' or line:match('^%a+:')) then
      abs_path = vim.fs.normalize(vim.fs.joinpath(opts.cwd, line))
    end

    local entry = { value = line, ordinal = line, path = abs_path }
    entry.display = function(et)
      local icon, icon_hl
      if vim.fn.isdirectory(et.path) == 1 then
        icon, icon_hl = '', 'DevIconDefault'
      else
        local filename = vim.fs.basename(et.path)
        icon, icon_hl = devicons.get_icon(filename, vim.fn.fnamemodify(filename, ':e'), { default = true })
      end
      return displayer({ { icon, icon_hl }, et.value })
    end
    return entry
  end
end

_G.search_handlers = {
  find_files = function()
    local builtin = require('telescope.builtin')
    local cwd = vim.uv.cwd()
    builtin.find_files({
      cwd = cwd,
      entry_maker = folder_icon_entry_maker({ cwd = cwd }),
    })
  end,
  live_grep = function()
    require('telescope.builtin').live_grep()
  end,
  help_tags = function()
    require('telescope.builtin').help_tags()
  end,
  keymaps = function()
    require('telescope.builtin').keymaps()
  end,
  neovim_config = function()
    local builtin = require('telescope.builtin')
    local conf = vim.fn.stdpath('config')
    builtin.find_files({
      cwd = conf,
      find_command = { 'fdfind', '--type', 'f', '--type', 'd', '--hidden', '--strip-cwd-prefix' },
      entry_maker = folder_icon_entry_maker({ cwd = conf }),
    })
  end,
}

return {
  'nvim-telescope/telescope.nvim',
  branch = 'master',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  },
  keys = {
    { '<leader>sf', desc = 'Search Files' },
    { '<leader>[', desc = 'which_key_ignore' },
    { '<leader>sg', desc = 'Search by Grep' },
    { '<leader>sh', desc = 'Search Help' },
    { '<leader>sk', desc = 'Search Keymaps' },
    { '<leader>sn', desc = 'Search Neovim Config' },
  },
  config = function()
    local telescope = require('telescope')

    telescope.setup({
      defaults = {
        file_ignore_patterns = {
          'node_modules/',
          '%.git/',
          'venv/',
          '%.venv/',
          '__pycache__/',
          '%.o',
          '%.a',
          '%.out',
          '%.bin',
        },
        mappings = {
          i = {
            ['<C-h>'] = function()
              vim.api.nvim_input('<C-w>')
            end,
          },
        },
      },
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = 'smart_case',
        },
      },
      pickers = {
        find_files = {
          find_command = { 'fdfind', '--type', 'f', '--type', 'd', '--hidden', '--strip-cwd-prefix' },
          entry_maker = function(line)
            return folder_icon_entry_maker({ cwd = vim.uv.cwd() })(line)
          end,
        },
        live_grep = {
          additional_args = function()
            return { '--hidden' }
          end,
        },
      },
    })

    telescope.load_extension('fzf')

    local map = vim.keymap.set
    map('n', '<leader>sf', _G.search_handlers.find_files, { desc = 'Search Files' })
    map('n', '<leader>[', _G.search_handlers.find_files)
    map('n', '<leader>sg', _G.search_handlers.live_grep, { desc = 'Search by Grep' })
    map('n', '<leader>sh', _G.search_handlers.help_tags, { desc = 'Search Help' })
    map('n', '<leader>sk', _G.search_handlers.keymaps, { desc = 'Search Keymaps' })
    map('n', '<leader>sn', _G.search_handlers.neovim_config, { desc = 'Search Neovim Config' })
  end,
}
