vim.api.nvim_create_user_command("AI", function()
	local copilot_loaded = package.loaded["copilot"] ~= nil

	if not copilot_loaded then
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
	else
		vim.cmd("Copilot enable")
	end

	vim.defer_fn(function()
		vim.cmd("Copilot status")
	end, 100)
end, {})

vim.keymap.set("n", "<leader>ai", "<cmd>AI<cr>", { noremap = true, silent = true })
