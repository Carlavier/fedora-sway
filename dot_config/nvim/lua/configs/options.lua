vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.autoindent = true

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.colorcolumn = "120"
vim.opt.wrap = false
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 10

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.signcolumn = "yes"

vim.opt.fillchars = { eob = " " }

local undodir = vim.fn.expand("~/.vim/undodir")
if vim.fn.isdirectory(undodir) == 0 then
  vim.fn.mkdir(undodir, "p")
end

vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.undodir = undodir
vim.opt.updatetime = 300
vim.opt.timeoutlen = 500
vim.opt.ttimeoutlen = 0
vim.opt.autoread = true
vim.opt.autowrite = false

vim.opt.errorbells = false
vim.opt.backspace = "indent,eol,start"
vim.opt.path:append("**")
vim.opt.selection = "inclusive"

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.diffopt:append("linematch:60")
vim.opt.redrawtime = 10000

vim.opt.laststatus = 3

vim.opt.showmode = false

vim.g.netrw_bufsettings = "noma nomod nu nobl nowrap ro"

vim.opt.list = true
vim.opt.listchars = {
  nbsp = "␣",
  tab = "→ ",
  trail = "·",
  extends = "»",
  precedes = "«",
}

vim.api.nvim_set_hl(0, "Whitespace", { fg = "#ff0000", force = true })
vim.api.nvim_set_hl(0, "NonText", { fg = "#ff0000", force = true })

vim.opt.title = true
