local fzf = require("fzf-lua")

fzf.setup({
	winopts = {
		preview = { hidden = "hidden" },
	},
})

vim.keymap.set("n", "<leader>ff", fzf.files, { desc = "files" })
vim.keymap.set("n", "<leader>fg", fzf.git_files, { desc = "git files" })
vim.keymap.set("n", "<leader><leader>", fzf.buffers, { desc = "buffers" })
vim.keymap.set("n", "<leader>fs", fzf.live_grep, { desc = "grep files" })
vim.keymap.set("n", "<leader>,", fzf.live_grep_resume, { desc = "buffers" })
vim.keymap.set("n", "<leader>fr", function()
	fzf.oldfiles({ cwd_only = true })
end, { desc = "recent files" })

vim.keymap.set("n", "gd", fzf.lsp_definitions, { desc = "goto defs" })
