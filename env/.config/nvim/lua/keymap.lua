vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- System clipboard
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

vim.keymap.set("i", "jj", "<Esc>")
vim.keymap.set("i", "ff", "<Esc>")

vim.keymap.set("n", "K", function(opts)
	opts = opts or {}
	opts.border = "single"
	vim.lsp.buf.hover(opts)
end)
