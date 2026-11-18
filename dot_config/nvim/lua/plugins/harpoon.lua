return {
	"theprimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local harpoon = require("harpoon")
		harpoon.setup()

		vim.keymap.set("n", "<leader>;", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end, { desc = "Open Harpoon list" })

		vim.keymap.set("n", "<leader>h", function()
			harpoon:list():select(1)
		end, { desc = "Harpoon Select H" })
		vim.keymap.set("n", "<leader>j", function()
			harpoon:list():select(2)
		end, { desc = "Harpoon Select J" })
		vim.keymap.set("n", "<leader>k", function()
			harpoon:list():select(3)
		end, { desc = "Harpoon Select K" })
		vim.keymap.set("n", "<leader>l", function()
			harpoon:list():select(4)
		end, { desc = "Harpoon Select L" })

		vim.keymap.set("n", "<leader>ah", function()
			harpoon:list():replace_at(1)
		end, { desc = "Harpoon Anchor H" })
		vim.keymap.set("n", "<leader>aj", function()
			harpoon:list():replace_at(2)
		end, { desc = "Harpoon Anchor J" })
		vim.keymap.set("n", "<leader>ak", function()
			harpoon:list():replace_at(3)
		end, { desc = "Harpoon Anchor K" })
		vim.keymap.set("n", "<leader>al", function()
			harpoon:list():replace_at(4)
		end, { desc = "Harpoon Anchor L" })
	end,
}
