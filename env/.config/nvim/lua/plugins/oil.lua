require("oil").setup({
	columns = {},
	view_options = {
		show_hidden = true
	}
})

vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
