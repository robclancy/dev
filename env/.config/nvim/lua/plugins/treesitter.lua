require("nvim-treesitter.configs").setup({
	ensure_installed = { "lua", "luadoc", "diff", "c_sharp" },
	auto_install = true,
	highlight = {
		enable = true,
	},
	indent = {
		enable = true,
	},
})
