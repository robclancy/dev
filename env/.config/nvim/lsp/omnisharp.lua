return {
	cmd = {
		"OmniSharp",
		"-z",
		"--hostPID",
		tostring(vim.fn.getpid()),
		"DotNet:enablePackageRestore=false",
		"--encoding",
		"utf-8",
		"--languageserver",
	},
	filetypes = { "cs", "vb" },
	root_markers = { "*.sln", "*.csproj" },
	capabilities = {
		workspace = {
			workspaceFolders = false,
		},
	},
	handlers = {
		["event"] = function() end,
	},
}