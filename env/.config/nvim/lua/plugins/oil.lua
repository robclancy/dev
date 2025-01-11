require("oil").setup({
	columns = {},
})

vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
