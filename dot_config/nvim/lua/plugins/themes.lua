return {
  -- {
  --   'sirzif/tzfn.nvim',
  --   name = 'tzfn',
  --   priority = 1000,
  --   lazy = fasle,
  --   config = function()
  --     vim.cmd('colorscheme tzfn')
  --   end,
  -- },
  -- {
  --   'Abstract-IDE/Abstract-cs',
  --   name = 'abscs',
  -- priority = 1000,
  -- lazy = fasle,
  -- config = function()
  --   vim.cmd("colorscheme abscs")
  -- end,
  -- everything is nice except for the purple part and string color
  -- },
  {
    'uncleTen276/dark_flat.nvim',
    priority = 1000,
    lazy = false,
    config = function()
      vim.cmd('colorscheme dark_flat')
      vim.api.nvim_set_hl(0, 'Normal', { fg = '#ffffff', bg = '#0b0b0b' })
      vim.api.nvim_set_hl(0, 'LineNrAbove', { fg = '#777777' })
      vim.api.nvim_set_hl(0, 'LineNrBelow', { fg = '#777777' })
    end,
  },
  -- {
  --   'rockyzhang24/arctic.nvim',
  --   dependencies = { 'rktjmp/lush.nvim' },
  -- priority = 1000,
  -- lazy = fasle,
  -- config = function()
  --   vim.cmd("colorscheme arctic")
  -- end,
  -- very similar to vscode old default theme
  -- },
  -- {
  --   'zootedb0t/citruszest.nvim',
  -- priority = 1000,
  -- lazy = fasle,
  -- config = function()
  --   vim.cmd("colorscheme citruszest")
  -- end,
  -- },
}
