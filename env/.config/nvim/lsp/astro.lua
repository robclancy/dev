return {
	cmd = { "astro-ls", "--stdio" },
	filetypes = { "astro" },
	root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
	init_options = {
		typescript = {
			tsdk = os.getenv("HOME") .. "/.local/share/pnpm/global/5/node_modules/typescript/lib",
		},
	},
}
