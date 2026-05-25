require('nvim-treesitter').setup({
	install_dir = vim.fn.stdpath('data') .. '/site',
})

require('nvim-treesitter.install').ensure_installed({ 'lua', 'luadoc', 'diff', 'c_sharp' })

vim.api.nvim_create_autocmd('FileType', {
	pattern = { 'lua', 'cs', 'diff' },
	callback = function()
		vim.treesitter.start()
	end,
})

vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"