vim.opt.cursorline = true
vim.opt.inccommand = 'split'

vim.opt.cmdheight = 1
vim.opt.laststatus = 0
vim.opt.showtabline = 2
vim.opt.guicursor = ''

vim.opt.expandtab = false
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.smartindent = true

vim.opt.relativenumber = false
vim.opt.number = false

vim.opt.wrap = true

vim.opt.pumheight = 6
vim.opt.pumwidth = 18
vim.opt.pumblend = 15

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.swapfile = false
vim.opt.undofile = true

vim.diagnostic.config({ virtual_text = true })

vim.lsp.config('*', {
root_markers = { '.git', '.hg' },
	vim.lsp.config('*', {
	  capabilities = {
	    textDocument = {
	      semanticTokens = {
		multilineTokenSupport = true,
	      }
	    }
	  }
  })
})

-- System clipboard
vim.keymap.set({ 'n', 'v', 'x' }, '<leader>y', '"+y', { noremap = true, silent = true, desc = 'Yank to clipboard' })
vim.keymap.set({ 'n', 'v', 'x' }, '<leader>Y', '"+yy', { noremap = true, silent = true, desc = 'Yank line to clipboard' })
vim.keymap.set({ 'n', 'v', 'x' }, '<leader>p', '"+p', { noremap = true, silent = true, desc = 'Paste from clipboard' })

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

