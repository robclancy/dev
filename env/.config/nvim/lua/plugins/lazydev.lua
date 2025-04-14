-- I don't actually know if this is working it has pissed me off
vim.api.nvim_create_autocmd("FileType", {
	pattern = "lua",
	callback = function()
		require("lazydev").setup({
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		})
	end,
})
