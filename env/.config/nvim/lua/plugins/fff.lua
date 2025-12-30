local fff = require("fff")
fff.setup({
	preview = { enabled = false },
})

vim.keymap.set("n", "<leader>ff", function()
	fff.find_in_git_root()
end, { desc = "Git files" })

vim.keymap.set("n", "<leader>fa", function()
	fff.find_files()
end, { desc = "Find files" })

vim.keymap.set("n", "<leader>fr", function()
	fff.find_recent()
end, { desc = "Find recent files" })
