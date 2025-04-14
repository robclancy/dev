local function get_typescript_server_path(root_dir)
	local project_root = vim.fs.dirname(vim.fs.find("node_modules", { path = root_dir, upward = true })[1])
	return project_root and (project_root .. "/node_modules/typescript/lib") or ""
end

return {
	cmd = { "astro-ls", "--stdio" },
	filetypes = { "astro" },
	root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
	init_options = {
		typescript = {
			tsdk = "./node_modules/typescript/lib",
		},
	},
}
