require("blink.cmp").setup({
	sources = {
		default = { "lsp", "buffer" },
		providers = {
			buffer = {
				score_offset = 5,
				max_items = 3,
			},
			lsp = {
				fallbacks = {},
			},
		},
	},
	signature = { enabled = true },
	completion = {
		menu = {
			draw = {
				columns = {
					{ "kind_icon", gap = 1 },
					{ "label" },
				},
				components = {
					kind_icon = {
						text = function(ctx)
							if ctx.item.source_name == "Buffer" then
								return "-"
							end

							return ctx.kind_icon .. " "
						end,
					},
				},
			},
		},
	},
})
