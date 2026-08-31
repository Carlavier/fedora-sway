vim.keymap.set({ 'n', 'v' }, 'j', 'h', { noremap = true })
vim.keymap.set({ 'n', 'v' }, 'l', 'j', { noremap = true })
vim.keymap.set({ 'n', 'v' }, ';', 'l', { noremap = true })
vim.keymap.set({ 'n', 'v' }, 'h', ';', { noremap = true })

vim.keymap.set('i', '<C-h>', '<C-w>', { noremap = true, silent = true })
vim.keymap.set('c', '<C-h>', '<C-w>', { noremap = true })

vim.keymap.set('n', '<M-j>', '<C-w>h', { noremap = true })
vim.keymap.set('n', '<M-k>', '<C-w>k', { noremap = true })
vim.keymap.set('n', '<M-l>', '<C-w>j', { noremap = true })
vim.keymap.set('n', '<M-;>', '<C-w>l', { noremap = true })

vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { noremap = true })

vim.keymap.set('n', '<Esc>', function()
  vim.cmd('nohlsearch')
end, { desc = 'Clear search highlights' })

vim.keymap.set('n', '<leader>o', function()
  local count = vim.v.count1
  local lines = {}
  for _ = 1, count do
    table.insert(lines, '')
  end
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  vim.api.nvim_buf_set_lines(0, row, row, false, lines)
  vim.api.nvim_win_set_cursor(0, { row + count, col })
end, { desc = 'Insert newline(s) below' })

vim.keymap.set('n', '<leader>O', function()
  local count = vim.v.count1
  local lines = {}
  for _ = 1, count do
    table.insert(lines, '')
  end
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  vim.api.nvim_buf_set_lines(0, row - 1, row - 1, false, lines)
  vim.api.nvim_win_set_cursor(0, { row + count, col })
end, { desc = 'Insert newline(s) above' })

vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show line diagnostics' })

vim.keymap.set('n', '[d', function()
  vim.diagnostic.jump({ count = -1, float = true })
end, { desc = 'Go to previous diagnostic' })
vim.keymap.set('n', ']d', function()
  vim.diagnostic.jump({ count = 1, float = true })
end, { desc = 'Go to next diagnostic' })

vim.keymap.set('n', 'q:', '<nop>')

vim.keymap.set('n', '<leader>bd', '<cmd>bd<cr>')

vim.keymap.set('n', '<leader>tww', function()
  vim.wo.wrap = not vim.wo.wrap
end, { silent = true })
