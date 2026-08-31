return {
  'MagicDuck/grug-far.nvim',
  config = function()
    require('grug-far').setup({
      wrap = true,
      maxBufLines = 1000,

      helpLine = { enabled = false },
      showCompactInputs = true,
      showInputsTopPadding = false,
      showInputsBottomPadding = false,

      openTargetWindow = {
        preferredLocation = 'right',
      },

      engines = {
        ripgrep = {
          path = 'rg',
          extraArgs = '',
        },
      },

      keymaps = {
        replace = { n = '<localleader>r' },
        qflist = { n = '<localleader>q' },
        syncLocations = { n = '<localleader>s' },
        historyOpen = { n = '<localleader>t' },
        historyAdd = { n = '<localleader>a' },
        refresh = { n = '<localleader>f' },
        close = { n = '<localleader>c' },
        gotoLocation = { n = '<enter>' },
        pickHistoryEntry = { n = '<enter>' },
      },
    })
  end,
}
