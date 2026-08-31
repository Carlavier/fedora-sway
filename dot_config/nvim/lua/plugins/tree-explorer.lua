return {
  'nvim-tree/nvim-tree.lua',
  version = '*',
  lazy = false,
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require('nvim-tree').setup({
      sort = {
        sorter = 'case_sensitive',
      },
      view = {
        width = 30,
      },
      renderer = {
        root_folder_label = false,
        group_empty = true,
      },
      filters = {
        dotfiles = false,
      },
    })

    vim.keymap.set('n', '<leader>tt', ':NvimTreeToggle<CR>', { silent = true, desc = 'Toggle Tree Explorer' })
  end,
}
