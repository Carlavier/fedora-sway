vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.argc() == 0 and vim.fn.line("$") == 1 and vim.fn.getline(1) == "" then
      vim.bo.modifiable = false
      vim.bo.readonly = true
    end
  end,
})
