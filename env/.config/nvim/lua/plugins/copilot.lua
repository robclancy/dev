vim.api.nvim_create_user_command("AI", function()
	require("copilot").setup({
		suggestion = {
			enabled = true,
			auto_trigger = true,
			keymap = {
				accept = "<C-l>",
				next = "<C-n>",
				previous = "<C-p>",
				toggle = "<C-e>",
			},
		},
		panel = { enabled = false },
		server = {
			type = "binary",
		},
		filetypes = {
			["*"] = true,
		},
	})
end, {})

vim.keymap.set("n", "<leader>ai", "<cmd>AI<cr>", { noremap = true, silent = true })
