return {
  'NMAC427/guess-indent.nvim',
  event = { 'BufReadPost', 'BufNewFile' },
  config = function()
    require('guess-indent').setup({
      auto_cmd = true,
    })
  end,
}
