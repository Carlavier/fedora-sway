vim.api.nvim_create_autocmd("FileType", {
	pattern = "gotmpl",
	callback = function(args)
		vim.treesitter.start(args.buf)
	end,
})
