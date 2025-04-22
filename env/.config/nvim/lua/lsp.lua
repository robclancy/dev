vim.lsp.enable({ "luals", "vtsls", "astro", "yamlls" })

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
