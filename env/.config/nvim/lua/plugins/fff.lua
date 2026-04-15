local fff = require("fff")

fff.setup({
	preview = { enabled = true },
})

vim.keymap.set("n", "<leader>ff", function()
	fff.find_in_git_root()
end, { desc = "Git files" })

vim.keymap.set("n", "<leader>tt", function()
	fff.find_in_git_root()
end, { desc = "Git files" })

vim.keymap.set("n", "<leader>fa", function()
	fff.find_files()
end, { desc = "All files" })

vim.keymap.set("n", "<leader>ta", function()
	fff.find_files()
end, { desc = "All files" })

vim.keymap.set("n", "<leader>fs", function()
	fff.live_grep()
end, { desc = "Grep files" })

vim.keymap.set("n", "<leader>ts", function()
	fff.live_grep()
end, { desc = "Grep files" })
