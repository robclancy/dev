local conform = require("conform")

conform.setup({
	notify_on_error = false,

	format_on_save = function(bufnr)
		local disable_filetypes = { c = true, cpp = true }
		return {
			timeout_ms = 500,
			lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
		}
	end,

	formatters = {
		biome = { require_cwd = true },
		prettierd = { require_cwd = true },
	},

	formatters_by_ft = {
		lua = { "stylua" },
		python = { "black" },
		javascript = { "prettierd", "biome" },
		javascriptreact = { "prettierd", "biome" },
		typescript = { "prettierd", "biome" },
		typescriptreact = { "prettierd", "biome" },
		php = { "pint" },
	},
})

vim.keymap.set("", "<leader>F", function()
	conform.format({ async = true, lsp_fallback = true })
end, { desc = "[F]ormat buffer" })

vim.api.nvim_create_user_command("ConformInfo", function()
	conform.info()
end, {})
