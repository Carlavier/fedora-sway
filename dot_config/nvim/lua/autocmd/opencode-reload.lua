local checktime_group = vim.api.nvim_create_augroup("ExternalReload", { clear = true })

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  group = checktime_group,
  desc = "Reload buffers changed externally by opencode",
  nested = true,
  callback = function()
    if vim.o.buftype == "" and vim.fn.getcmdwintype() == "" then
      vim.cmd("checktime")
    end
  end,
})

vim.api.nvim_create_autocmd("FileChangedShellPost", {
  group = checktime_group,
  desc = "Force redraw when an external change is detected",
  callback = function()
    if vim.o.buftype == "" then
      vim.cmd("redraw!")
    end
  end,
})
