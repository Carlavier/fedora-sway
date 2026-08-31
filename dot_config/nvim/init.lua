vim.g.mapleader = " "
vim.g.maplocalleader = " "

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  ui = { border = "rounded" },
  rocks = {
    hererocks = false,
    enabled = true,
  },
})

require("configs")
require("autocmd")
vim.opt.termguicolors = true
vim.api.nvim_set_hl(0, "CursorLineNr", { reverse = true, bold = true })
