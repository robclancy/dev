vim.api.nvim_create_user_command("Transparent", function()
	vim.api.nvim_set_hl(0, "Normal", { bg = "None" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#111111" })
end, {})

vim.api.nvim_create_autocmd({ "InsertEnter" }, {
	callback = function()
		io.stdout:write("\27]12;orange\7")
	end,
})

vim.api.nvim_create_autocmd({ "InsertLeave", "VimLeave" }, {
	callback = function()
		io.stdout:write("\27]12;white\7")
	end,
})

-- vim.api.nvim_create_user_command("Accent", function(opts)
-- 	if opts.args then
-- 		vim.g.accent_colour = opts.args
-- 	else
-- 		vim.g.accent_auto_cwd_colour = 1
-- 	end
--
-- 	vim.g.accent_no_bg = 1
--
-- 	vim.opt.termguicolors = false
-- 	vim.cmd("colorscheme accent")
--
-- 	-- vim.api.nvim_set_hl(0, "Normal", { bg = "None" })
-- 	-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#111111" })
-- 	vim.api.nvim_set_hl(0, "CursorLine", { bg = "#111111" })
-- 	vim.api.nvim_set_hl(0, "TabLineFill", { bg = "None" })
-- 	vim.api.nvim_set_hl(0, "TabLineMiniBar", { fg = "#999999" })
-- end, { nargs = 1 })
--
-- vim.cmd("Accent magenta")

require("kanso").setup({
	undercurl = true,
	transparent = true,
	commentStyle = { italic = true },
	theme = "zen",
})

require("cyberdream").setup({
	transparent = true,
	-- saturation = 0.8,
	italic_comments = true,
	extensions = {
		blinkcmp = true,
		fzflua = true,
		treesitter = true,
	},
})

-- vim.cmd("colorscheme kanso")
-- vim.api.nvim_set_hl(0, "CursorLine", { bg = "#080808" })

vim.cmd("colorscheme naysayer")
