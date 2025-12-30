return {
	cmd = { "phpactor", "language-server" },
	filetypes = { "php" },
	root_markers = { ".git", "composer.json", ".phpactor.json", ".phpactor.yml" },
	workspace_required = true,
	init_options = {
		["completion.label_formatter"] = "fqn",
	},
	on_attach = function(client, bufnr)
		vim.diagnostic.enable(false, { bufnr = bufnr })
	end,
}
