require("nvim-tmux-navigation").setup({
	disable_when_zoomed = true,
	keybindings = {
		left = "<C-h>",
		down = "<C-j>",
		up = "<C-k>",
		right = "<C-l>",
		-- last_active = "<C-\\>",
		-- next = "<C-Space>",
	},
})

-- Add insert mode mappings for window navigation (needed for opencode input window)
vim.keymap.set("i", "<C-h>", "<Esc><cmd>lua require'nvim-tmux-navigation'.NvimTmuxNavigateLeft()<CR>", { noremap = true, silent = true })
vim.keymap.set("i", "<C-l>", "<Esc><cmd>lua require'nvim-tmux-navigation'.NvimTmuxNavigateRight()<CR>", { noremap = true, silent = true })
vim.keymap.set("i", "<C-j>", "<Esc><cmd>lua require'nvim-tmux-navigation'.NvimTmuxNavigateDown()<CR>", { noremap = true, silent = true })
vim.keymap.set("i", "<C-k>", "<Esc><cmd>lua require'nvim-tmux-navigation'.NvimTmuxNavigateUp()<CR>", { noremap = true, silent = true })
