return {
	"brooth/far.vim",
	init = function()
		vim.g["far#enable_undo"] = 1
		vim.g["far#default_file_mask"] = "**/*"
	end,

	config = function()
		vim.api.nvim_del_user_command("Farr")

		vim.api.nvim_create_user_command("Farr", function(opts)
			if vim.bo.filetype == "snacks_dashboard" then
				vim.cmd("enew")
			end

			vim.fn.FarModePrompt(-1, 1, 1, 1, opts.args)
		end, { nargs = "*" })

		vim.keymap.set("n", "<leader>sr", "<cmd>Farr<cr>", {
			desc = "Search and replace",
			silent = true,
		})

		vim.api.nvim_create_autocmd("CmdlineLeave", {
			callback = function()
				vim.schedule(function()
					if vim.o.laststatus == 2 then
						vim.opt.laststatus = 3
					end
				end)
			end,
		})
	end,
}
