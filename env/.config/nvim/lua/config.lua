vim.lsp.config("*", {
	root_markers = { ".git", ".hg" },
	vim.lsp.config("*", {
		capabilities = {
			textDocument = {
				semanticTokens = {
					multilineTokenSupport = true,
				},
			},
		},
	}),
})

vim.diagnostic.config({ virtual_text = true, signs = false })

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- for GBrowse
vim.api.nvim_create_user_command("Browse", function(opts)
	vim.fn.system({ "xdg-open", opts.fargs[1] })
end, { nargs = 1 })

vim.api.nvim_create_autocmd("BufReadPost", {
	pattern = "*.php",
	callback = function()
		-- vim php maintainer does some of the dumbest shit
		vim.opt_local.indentexpr = ""
		vim.opt_local.smartindent = true
		vim.opt_local.comments = "://,f:#[,:#"
		vim.opt_local.commentstring = "// %s"
	end,
})
