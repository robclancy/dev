require("nvim-treesitter.configs").setup({
	ensure_installed = { "lua", "luadoc", "diff" },
	auto_install = true,
	highlight = {
		enable = true,
	},
	indent = {
		enable = true,
	},
})
