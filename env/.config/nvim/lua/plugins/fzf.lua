local fzf = require("fzf-lua")

fzf.setup({
	winopts = {
		preview = { hidden = "hidden" },
	},
})

vim.keymap.set("n", "<leader>fa", fzf.files, { desc = "all files" })
vim.keymap.set("n", "<leader>ta", fzf.files, { desc = "all files" })
vim.keymap.set("n", "<leader>ff", fzf.git_files, { desc = "git files" })
vim.keymap.set("n", "<leader>tt", fzf.git_files, { desc = "git files" })
vim.keymap.set("n", "<leader><leader>", function()
	fzf.global({ query = "$" })
end, { desc = "buffers" })
vim.keymap.set("n", "<leader>fs", fzf.live_grep, { desc = "grep files" })
vim.keymap.set("n", "<leader>ts", fzf.live_grep, { desc = "grep files" })
vim.keymap.set("n", "<leader>,", fzf.live_grep_resume, { desc = "buffers" })
vim.keymap.set("n", "<leader>fr", function()
	fzf.oldfiles({ cwd_only = true })
end, { desc = "recent files" })
vim.keymap.set("n", "<leader>tr", function()
	fzf.oldfiles({ cwd_only = true })
end, { desc = "recent files" })

vim.keymap.set("n", "gd", fzf.lsp_definitions, { desc = "goto defs" })
