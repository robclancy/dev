require("opencode").setup({
	preferred_picker = "mini.pick",
	keymap_prefix = "<leader>o",
	ui = {
		position = "left",
		window_width = 0.40,
	},
	context = {
		enabled = true,
		diagnostics = {
			warning = true,
			error = true,
		},
		current_file = {
			enabled = true,
		},
		selection = {
			enabled = true,
		},
	},
})
