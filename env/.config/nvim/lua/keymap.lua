vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- clipboard
vim.keymap.set({ "n", "v", "x" }, "<leader>y", '"+y', { noremap = true, silent = true, desc = "Yank to clipboard" })
vim.keymap.set(
	{ "n", "v", "x" },
	"<leader>Y",
	'"+yy',
	{ noremap = true, silent = true, desc = "Yank line to clipboard" }
)
vim.keymap.set({ "n", "v", "x" }, "<leader>p", '"+p', { noremap = true, silent = true, desc = "Paste from clipboard" })

vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww ~/.config/tmux/tmux-sessionizer<CR>")

vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "quickfix list" })

vim.keymap.set("n", "K", function(opts)
	opts = opts or {}
	opts.border = "single"
	vim.lsp.buf.hover(opts)
end)

vim.api.nvim_create_autocmd("FileType", {
	pattern = "qf",
	callback = function()
		vim.keymap.set("n", "<C-n>", ":cnext<CR>", { buffer = true })
		vim.keymap.set("n", "<C-p>", ":cprev<CR>", { buffer = true })
	end,
})
