return {
  'jiaoshijie/undotree',
  dependencies = 'nvim-lua/plenary.nvim',
  keys = {
    { '<leader>u', "<cmd>lua require('undotree').toggle()<cr>", desc = 'Toggle UndoTree' },
  },
  opts = {
    float_diff = true,
    layout = 'left_bottom',
    position = 'left',
    window = {
      width = 0.2,
    },
    ignore_filetype = {
      'Undotree',
      'UndotreeDiff',
      'qf',
      'TelescopePrompt',
      'spectre_panel',
    },
  },
}
