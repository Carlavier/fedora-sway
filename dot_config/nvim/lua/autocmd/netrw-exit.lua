vim.api.nvim_create_autocmd('FileType', {
  pattern = 'netrw',
  callback = function()
    vim.keymap.set('n', '<leader><Esc>', ':bd<CR>', { remap = false, buffer = true })
  end,
})
